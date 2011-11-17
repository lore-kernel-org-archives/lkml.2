Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1KQF7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:59:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63185 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1KQF7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:59:15 -0500
Date: Thu, 17 Nov 2011 13:59:04 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: tom.leiming@gmail.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] init/main.c: execute lockdep_init as early as
 possible
Message-ID: <20111117055904.GA15644@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 01:34:31PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch removes the lockdep warning[1] on ARM platform.
> The warning is caused by printk inside smp_setup_processor_id.
> 
> It is safe to do this because lockdep_init doesn't depend on
> smp_setup_processor_id, so make printk can be called as early
> as possible without lockdep complainment.
> 
> [1], lockdep warning
> [    0.000000] WARNING: lockdep init error! Arch code didn't call
> lockdep_init() early enough?
> [    0.000000] Call stack leading to lockdep invocation was:
> [    0.000000]  [<c00164bc>] save_stack_trace_tsk+0x0/0x90
> [    0.000000]  [<ffffffff>] 0xffffffff
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Seems start_kernel() is the first C function called in arm.
IOW, this may be the simplest way for your issue.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> ---
>  init/main.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 217ed23..2c76efb 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -469,13 +469,12 @@ asmlinkage void __init start_kernel(void)
>  	char * command_line;
>  	extern const struct kernel_param __start___param[], __stop___param[];
>  
> -	smp_setup_processor_id();
> -
>  	/*
>  	 * Need to run as early as possible, to initialize the
>  	 * lockdep hash:
>  	 */
>  	lockdep_init();
> +	smp_setup_processor_id();
>  	debug_objects_early_init();
>  
>  	/*
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
