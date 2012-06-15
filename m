Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2FOVs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:48:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55522 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2FOVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:48:24 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 14:48:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 03/15] rcu: Prevent excessive line length in
 RCU_STATE_INITIALIZER()
Message-ID: <20120615214813.GU31184@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:05:58PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Upcoming rcu_barrier() concurrency commits will result in line lengths
> greater than 80 characters in the RCU_STATE_INITIALIZER(), so this commit
> shortens the name of the macro's argument to prevent this.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 9098910..8ce1b1d 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -62,18 +62,18 @@
>  
>  static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
>  
> -#define RCU_STATE_INITIALIZER(structname) { \
> -	.level = { &structname##_state.node[0] }, \
> +#define RCU_STATE_INITIALIZER(sname) { \
> +	.level = { &sname##_state.node[0] }, \
>  	.fqs_state = RCU_GP_IDLE, \
>  	.gpnum = -300, \
>  	.completed = -300, \
> -	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
> -	.orphan_nxttail = &structname##_state.orphan_nxtlist, \
> -	.orphan_donetail = &structname##_state.orphan_donelist, \
> -	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.fqslock), \
> +	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
> +	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
> +	.orphan_donetail = &sname##_state.orphan_donelist, \
> +	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
>  	.n_force_qs = 0, \
>  	.n_force_qs_ngp = 0, \
> -	.name = #structname, \
> +	.name = #sname, \
>  }
>  
>  struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched);
> -- 
> 1.7.8
> 
