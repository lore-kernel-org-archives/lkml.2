Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2B1OQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:16:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2B1OQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:16:33 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=zcWVZ8tiDacA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=wyBM1Eyl92ZqjS6myxYA:9 a=yNO3Nz3EXjvmLSGYXnMA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330438591.25686.214.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Trace: initialize variable to clear warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Tue, 28 Feb 2012 09:16:31 -0500
In-Reply-To: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 17:09 +0800, Zhengwang Ruan wrote:
> GCC warns that 'page2' is used without being initialized previously before
> being used, this is to clear it.
> 

This is a bug in gcc that's fixed in 4.6 and beyond. I don't want to
remove this warning because it will hide a real bug if page2 really does
become uninitialized. If 4.6 gives a warning here, then I'll fix it.

Note, we can't just initialize it here either, because it is initialized
in the code, and if it gets used later without that initialization then
it will break. No default will work.

Thanks,

-- Steve

> Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a3f1bc5..47376ba 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3694,7 +3694,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  	int nr_pages = 1;
>  	ssize_t written;
>  	void *page1;
> -	void *page2;
> +	void *uninitialized_var(page2);
>  	int offset;
>  	int size;
>  	int len;


