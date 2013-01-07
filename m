Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3AGRjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:39:36 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47161 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3AGRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:39:35 -0500
Date: Mon, 7 Jan 2013 09:39:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Subject: Re: [PATCH rcu] Remove unused code originally used for context
 tracking
Message-ID: <20130107173906.GL2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
 <1354179992.2499.35.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hysBreTXE-rXVQ5no+3B8hZ-3XMgap20PAP9u76-j-Tgg@mail.gmail.com>
 <20121129113627.GS2474@linux.vnet.ibm.com>
 <1354256362.2552.6.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354256362.2552.6.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010717-5406-0000-0000-000003F64888
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 02:19:22PM +0800, Li Zhong wrote:
> As new context tracking subsystem added, it seems ignore_user_qs and
> in_user defined in struct rcu_dynticks are no longer needed, so remove
> them. 
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Hearing no objections from  Frederic, I have queued this patch for 3.9

							Thanx, Paul

> ---
>  kernel/rcutree.c | 3 ---
>  kernel/rcutree.h | 4 ----
>  2 files changed, 7 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e441b77..b8fae5d 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2719,9 +2719,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
>  	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
>  	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
>  	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
> -#ifdef CONFIG_RCU_USER_QS
> -	WARN_ON_ONCE(rdp->dynticks->in_user);
> -#endif
>  	rdp->cpu = cpu;
>  	rdp->rsp = rsp;
>  	rcu_boot_init_nocb_percpu_data(rdp);
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4b69291..6f21f2e 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -102,10 +102,6 @@ struct rcu_dynticks {
>  				    /* idle-period nonlazy_posted snapshot. */
>  	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
>  #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
> -#ifdef CONFIG_RCU_USER_QS
> -	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
> -	bool in_user;		    /* Is the CPU in userland from RCU POV? */
> -#endif
>  };
> 
>  /* RCU's kthread states for tracing. */
> -- 
> 1.7.11.4
> 
> 

