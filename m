Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1FHTkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:40:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50796 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1FHTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:40:44 -0400
Date: Wed, 8 Jun 2011 12:40:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/4] sched: Make sleeping inside spinlock detection
 working in !CONFIG_PREEMPT
Message-ID: <20110608194040.GF2324@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
 <1307555315-30989-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307555315-30989-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:48:34PM +0200, Frederic Weisbecker wrote:
> Select CONFIG_PREEMPT_COUNT when we enable the sleeping inside
> spinlock detection, so that the preempt offset gets correctly
> incremented/decremented from preempt_disable()/preempt_enable().
> 
> This makes the preempt count eventually working in !CONFIG_PREEMPT
> when that debug option is set and thus fixes the detection of explicit
> preemption disabled sections under such config. Code that sleeps
> in explicitly preempt disabled section can be finally spotted
> in non-preemptible kernels.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  lib/Kconfig.debug |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 28afa4c..a7dd7b5 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -650,6 +650,7 @@ config TRACE_IRQFLAGS
> 
>  config DEBUG_SPINLOCK_SLEEP
>  	bool "Spinlock debugging: sleep-inside-spinlock checking"
> +	select PREEMPT_COUNT
>  	depends on DEBUG_KERNEL
>  	help
>  	  If you say Y here, various routines which may sleep will become very
> -- 
> 1.7.5.4
> 
