Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0C1DtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:49:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58734 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab0C1DtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:49:07 -0400
Date: Sat, 27 Mar 2010 20:48:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: make dead code really dead
Message-ID: <20100328034859.GP2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BAEC9C8.8080704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAEC9C8.8080704@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 11:15:20AM +0800, Lai Jiangshan wrote:
> 
> cleanup: make dead code really dead

Good catch!  I have queued this one up for RCU for 2.6.35.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e6014e1..1947c4e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
>  		break; /* grace period idle or initializing, ignore. */
> 
>  	case RCU_SAVE_DYNTICK:
> -
> -		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
>  		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
>  			break; /* So gcc recognizes the dead code. */
> 
> +		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> +
>  		/* Record dyntick-idle state. */
>  		force_qs_rnp(rsp, dyntick_save_progress_counter);
>  		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
> 
