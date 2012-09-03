Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2ICJch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:32:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50853 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2ICJcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:32:36 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:32:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 15/23] rcu: Make rcutree module parameters
 visible in sysfs
Message-ID: <20120903093228.GD5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:30AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The module parameters blimit, qhimark, and qlomark (and more
> recently, rcu_fanout_leaf) have permission masks of zero, so
> that their values are not visible from sysfs.  This is unnecessary
> and inconvenient to administrators who might like an easy way to
> see what these values are on a running system.  This commit therefore
> sets their permission masks to 0444, allowing them to be read but
> not written.
> 
> Reported-by: Rusty Russell <rusty@ozlabs.org>
> Reported-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1d33240..55f20fd 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -88,7 +88,7 @@ LIST_HEAD(rcu_struct_flavors);
>  
>  /* Increase (but not decrease) the CONFIG_RCU_FANOUT_LEAF at boot time. */
>  static int rcu_fanout_leaf = CONFIG_RCU_FANOUT_LEAF;
> -module_param(rcu_fanout_leaf, int, 0);
> +module_param(rcu_fanout_leaf, int, 0444);
>  int rcu_num_lvls __read_mostly = RCU_NUM_LVLS;
>  static int num_rcu_lvl[] = {  /* Number of rcu_nodes at specified level. */
>  	NUM_RCU_LVL_0,
> @@ -216,9 +216,9 @@ static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
>  static int qhimark = 10000;	/* If this many pending, ignore blimit. */
>  static int qlowmark = 100;	/* Once only this many pending, use blimit. */
>  
> -module_param(blimit, int, 0);
> -module_param(qhimark, int, 0);
> -module_param(qlowmark, int, 0);
> +module_param(blimit, int, 0444);
> +module_param(qhimark, int, 0444);
> +module_param(qlowmark, int, 0444);
>  
>  int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
>  int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
> -- 
> 1.7.8
> 
