Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2BGHjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:39:16 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:52939 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2BGHjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:39:14 -0500
Date: Tue, 7 Feb 2012 15:38:40 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH] sched: move CONFIG_IRQ_TIME_ACCOUNTING to common code
Message-ID: <20120207073840.GA32736@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328080789-18277-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1328080789-18277-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:19:49AM +0400, Dmitry Antipov wrote:
> Since CONFIG_IRQ_TIME_ACCOUNTING is architecture-agnostic,
> move it from x86 area to common code.

IIRC, it's x86 dependent now.

Thanks,
Yong

> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  arch/x86/Kconfig  |   11 -----------
>  lib/Kconfig.debug |   11 +++++++++++
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bed94e..4759676 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -805,17 +805,6 @@ config SCHED_MC
>  	  making when dealing with multi-core CPU chips at a cost of slightly
>  	  increased overhead in some places. If unsure say N here.
>  
> -config IRQ_TIME_ACCOUNTING
> -	bool "Fine granularity task level IRQ time accounting"
> -	default n
> -	---help---
> -	  Select this option to enable fine granularity task irq time
> -	  accounting. This is done by reading a timestamp on each
> -	  transitions between softirq and hardirq state, so there can be a
> -	  small performance impact.
> -
> -	  If in doubt, say N here.
> -
>  source "kernel/Kconfig.preempt"
>  
>  config X86_UP_APIC
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8745ac7..d6d7afc 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -299,6 +299,17 @@ config SCHEDSTATS
>  	  application, you can say N to avoid the very slight overhead
>  	  this adds.
>  
> +config IRQ_TIME_ACCOUNTING
> +	bool "Fine granularity task level IRQ time accounting"
> +	default n
> +	---help---
> +	  Select this option to enable fine granularity task irq time
> +	  accounting. This is done by reading a timestamp on each
> +	  transitions between softirq and hardirq state, so there can be a
> +	  small performance impact.
> +
> +	  If in doubt, say N here.
> +
>  config TIMER_STATS
>  	bool "Collect kernel timers statistics"
>  	depends on DEBUG_KERNEL && PROC_FS
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
