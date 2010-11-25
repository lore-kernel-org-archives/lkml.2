Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab0KYHXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:23:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60294 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0KYHXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:23:03 -0500
Subject: Re: [PATCH 1/5] MIPS/Perf-events: Work with irq_work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, fweisbec@gmail.com, will.deacon@arm.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290063401-25440-2-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-2-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 07:58:08 +0100
Message-ID: <1290668288.2072.547.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 14:56 +0800, Deng-Cheng Zhu wrote:
> This is the MIPS part of the following commit by Peter Zijlstra:
> 
> e360adbe29241a0194e10e20595360dd7b98a2b3
> 	irq_work: Add generic hardirq context callbacks

Looks ok,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---
>  arch/mips/Kconfig                    |    1 +
>  arch/mips/include/asm/perf_event.h   |   12 +-----------
>  arch/mips/kernel/perf_event_mipsxx.c |    2 +-
>  3 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 67a2fa2..c44c38d 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -4,6 +4,7 @@ config MIPS
>  	select HAVE_GENERIC_DMA_COHERENT
>  	select HAVE_IDE
>  	select HAVE_OPROFILE
> +	select HAVE_IRQ_WORK
>  	select HAVE_PERF_EVENTS
>  	select PERF_USE_VMALLOC
>  	select HAVE_ARCH_KGDB
> diff --git a/arch/mips/include/asm/perf_event.h b/arch/mips/include/asm/perf_event.h
> index e00007c..d0c7749 100644
> --- a/arch/mips/include/asm/perf_event.h
> +++ b/arch/mips/include/asm/perf_event.h
> @@ -11,15 +11,5 @@
>  
>  #ifndef __MIPS_PERF_EVENT_H__
>  #define __MIPS_PERF_EVENT_H__
> -
> -/*
> - * MIPS performance counters do not raise NMI upon overflow, a regular
> - * interrupt will be signaled. Hence we can do the pending perf event
> - * work at the tail of the irq handler.
> - */
> -static inline void
> -set_perf_event_pending(void)
> -{
> -}
> -
> +/* Leave it empty here. The file is required by linux/perf_event.h */
>  #endif /* __MIPS_PERF_EVENT_H__ */
> diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
> index 5c7c6fc..fa00edc 100644
> --- a/arch/mips/kernel/perf_event_mipsxx.c
> +++ b/arch/mips/kernel/perf_event_mipsxx.c
> @@ -696,7 +696,7 @@ static int mipsxx_pmu_handle_shared_irq(void)
>  	 * interrupt, not NMI.
>  	 */
>  	if (handled == IRQ_HANDLED)
> -		perf_event_do_pending();
> +		irq_work_run();
>  
>  #ifdef CONFIG_MIPS_MT_SMP
>  	read_unlock(&pmuint_rwlock);


