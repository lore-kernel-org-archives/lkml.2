Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2JEQtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:49:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2JEQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:49:06 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Ld--4Lr3LMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=t9ydKhIB5vYA:10 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=PCNd3yhPhSTbvLZLRK4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349455743.6755.57.camel@gandalf.local.home>
Subject: Re: [PATCHv2.5] trace: reuse kbasename() functionality
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 05 Oct 2012 12:49:03 -0400
In-Reply-To: <1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 11:53 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_uprobe.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 03003cd..c7ba4f6 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -22,6 +22,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/uprobes.h>
>  #include <linux/namei.h>
> +#include <linux/string.h>
>  
>  #include "trace_probe.h"
>  
> @@ -263,16 +264,15 @@ static int create_trace_uprobe(int argc, char **argv)
>  
>  	/* setup a probe */
>  	if (!event) {
> -		char *tail = strrchr(filename, '/');
> +		char *tail;
>  		char *ptr;
>  
> -		ptr = kstrdup((tail ? tail + 1 : filename), GFP_KERNEL);
> -		if (!ptr) {
> +		tail = kstrdup(kbasename(filename), GFP_KERNEL);

I don't see kbasename() anywhere. Is this based off of other patches?

-- Steve

> +		if (!tail) {
>  			ret = -ENOMEM;
>  			goto fail_address_parse;
>  		}
>  
> -		tail = ptr;
>  		ptr = strpbrk(tail, ".-_");
>  		if (ptr)
>  			*ptr = '\0';


