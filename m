Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2B0Os2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:48:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:32965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2B0Os1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:48:27 -0500
Message-ID: <1330354093.11248.71.camel@twins>
Subject: Re: [PATCH v3 1/6] sched: Introduce the
 finish_arch_post_lock_switch() scheduler hook
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Date: Mon, 27 Feb 2012 15:48:13 +0100
In-Reply-To: <1327081352-13178-2-git-send-email-catalin.marinas@arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
	 <1327081352-13178-2-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 17:42 +0000, Catalin Marinas wrote:
> This hook is called by the scheduler after rq->lock has been released
> and interrupts enabled. It will be used in subsequent patches on the ARM
> architecture.
> 
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  kernel/sched/core.c  |    1 +
>  kernel/sched/sched.h |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index df00cb0..f1db6d8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1937,6 +1937,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	local_irq_enable();
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  	finish_lock_switch(rq, prev);
> +	finish_arch_post_lock_switch();
>  	trace_sched_stat_sleeptime(current, rq->clock);
>  
>  	fire_sched_in_preempt_notifiers(current);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 98c0c26..d72483d 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -692,6 +692,9 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
>  #ifndef finish_arch_switch
>  # define finish_arch_switch(prev)	do { } while (0)
>  #endif
> +#ifndef finish_arch_post_lock_switch
> +# define finish_arch_post_lock_switch()	do { } while (0)
> +#endif
>  
>  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
>  static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
> 

