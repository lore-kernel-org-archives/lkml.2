Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0C1ERa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:17:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58896 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab0C1ER2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:17:28 -0400
Date: Sat, 27 Mar 2010 21:17:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove lock acquirement when very eary boot
Message-ID: <20100328041724.GR2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BAEC985.6020302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAEC985.6020302@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 11:14:13AM +0800, Lai Jiangshan wrote:
> 
> cleanup: remove lock acquirement when very eary boot

This is indeed a safe change, however, I am keeping this lock acquisition
and release for documentation purposes.  Call me paranoid, but...

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 112edb5..e6014e1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1646,13 +1646,10 @@ EXPORT_SYMBOL_GPL(rcu_barrier_sched);
>  static void __init
>  rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
>  {
> -	unsigned long flags;
>  	int i;
>  	struct rcu_data *rdp = rsp->rda[cpu];
> -	struct rcu_node *rnp = rcu_get_root(rsp);
> 
>  	/* Set up local state, ensuring consistent view of global state. */
> -	raw_spin_lock_irqsave(&rnp->lock, flags);
>  	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
>  	rdp->nxtlist = NULL;
>  	for (i = 0; i < RCU_NEXT_SIZE; i++)
> @@ -1662,7 +1659,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
>  	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
>  #endif /* #ifdef CONFIG_NO_HZ */
>  	rdp->cpu = cpu;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  }
> 
>  /*
> 
