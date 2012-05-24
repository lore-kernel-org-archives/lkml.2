Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab2EXQcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:32:17 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36655 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2EXQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:32:16 -0400
Date: Thu, 24 May 2012 18:32:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
Message-ID: <20120524163246.GL27063@aftab.osrc.amd.com>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
 <alpine.LFD.2.02.1203291902280.10113@tycho>
 <20120329171140.GE6409@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329171140.GE6409@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo Steve,

want to pick this one up? It still applies cleanly to current linus.

Thanks.

On Thu, Mar 29, 2012 at 07:11:40PM +0200, Borislav Petkov wrote:
> On Thu, Mar 29, 2012 at 07:03:23PM +0200, John Kacur wrote:
> > If you're going to do this, then you can drop the label too.
> 
> Jahaa... thanks.
> 
> Here's an updated patch:
> 
> --
> From 135c25a609739bbdf1c33e62119517b47f0e1d07 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 29 Mar 2012 18:41:15 +0200
> Subject: [PATCH] ftrace: Remove a superfluous check
> 
> register_ftrace_function() checks ftrace_disabled and calls
> __register_ftrace_function which does it again.
> 
> Drop the first check and add the unlikely hint to the second one. Also,
> drop the label as John correctly notices.
> 
> No functional change.
> 
> Cc: John Kacur <jkacur@redhat.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  kernel/trace/ftrace.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 867bd1dd2dd0..0df8f8088ffe 100644
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
> @@ -4304,16 +4304,12 @@ int register_ftrace_function(struct ftrace_ops *ops)
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
> - out_unlock:
>  	mutex_unlock(&ftrace_lock);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(register_ftrace_function);
> -- 
> 1.7.9.3.362.g71319

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
