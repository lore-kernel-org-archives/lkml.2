Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab2C2REZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:04:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46319 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab2C2REU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:04:20 -0400
Date: Thu, 29 Mar 2012 19:03:23 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
To: Borislav Petkov <bp@amd64.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
In-Reply-To: <1333039463-24268-1-git-send-email-bp@amd64.org>
Message-ID: <alpine.LFD.2.02.1203291902280.10113@tycho>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2012, Borislav Petkov wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> register_ftrace_function() checks ftrace_disabled and calls
> __register_ftrace_function which does it again.
> 
> Drop the first check and add the unlikely hint to the second one.
> 
> No functional change.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  kernel/trace/ftrace.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 867bd1dd2dd0..f9212017406d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -311,7 +311,7 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
>  
>  static int __register_ftrace_function(struct ftrace_ops *ops)
>  {
> -	if (ftrace_disabled)
> +	if (unlikely(ftrace_disabled))
>  		return -ENODEV;
>  
>  	if (FTRACE_WARN_ON(ops == &global_ops))
> @@ -4304,14 +4304,10 @@ int register_ftrace_function(struct ftrace_ops *ops)
>  
>  	mutex_lock(&ftrace_lock);
>  
> -	if (unlikely(ftrace_disabled))
> -		goto out_unlock;
> -
>  	ret = __register_ftrace_function(ops);
>  	if (!ret)
>  		ret = ftrace_startup(ops, 0);
>  
> -
>   out_unlock:
>  	mutex_unlock(&ftrace_lock);
>  	return ret;
> -- 

If you're going to do this, then you can drop the label too.

Thanks
John Kacur
