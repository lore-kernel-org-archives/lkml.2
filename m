Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0DEStg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:49:36 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41488 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0DESta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:49:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPbJuUtGHnq6/2dsb2JhbACbSnK2RYUHBA
Date: Mon, 5 Apr 2010 14:49:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 02/10] rcu: make dead code really dead
Message-ID: <20100405184928.GA4505@Krystal>
References: <20100405183403.GA23075@linux.vnet.ibm.com> <1270492472-23222-2-git-send-email-paulmck@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1270492472-23222-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:48:40 up 11 days,  4:51,  4 users,  load average: 0.02, 0.12,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> cleanup: make dead code really dead

Is it just me or this spinlock change is more than just a cleanup ? Or
maybe it just needs a much more descriptive changelog.

Thanks,

Mathieu

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e54c123..6042fb8 100644
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
> -- 
> 1.7.0
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
