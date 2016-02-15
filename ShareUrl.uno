using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.Compiler.ExportTargetInterop;

public class ShareUrl : NativeModule
{
	public ShareUrl()
	{
		AddMember(new NativeFunction("ShareThisUrl", (NativeCallback)ShareThisUrl));
	}

	static object ShareThisUrl(Context c, object[] args)
	{
		var urlString = args[0] as string;
		DisplayShareSheet(urlString);
		return null;
	}


	[Foreign(Language.ObjC)]
    public static extern(iOS) void DisplayShareSheet(string urlString)
    @{
        NSLog(@"%@", urlString);
        NSURL *myURL = [NSURL URLWithString:urlString];

        // 以下部分是用来获取当前的 UIViewController 实例
		UIViewController *parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;

		while (parentViewController.presentedViewController != nil){
		    parentViewController = parentViewController.presentedViewController;
		}
		UIViewController *currentViewController = parentViewController;

		// 设定分享 sheet 的内容URL
        UIActivityViewController* vc = [[UIActivityViewController alloc]
                                initWithActivityItems:@[myURL] applicationActivities:nil];

        // It needs to be placed inside a different thread that allows the UI to update
        // 需要在另外一个线程中显示分享页面，否则会报错
		dispatch_async(dispatch_get_main_queue(), ^{
		    // code here
	    	[currentViewController presentViewController:vc animated:YES completion:nil];
		});
    @}
}
