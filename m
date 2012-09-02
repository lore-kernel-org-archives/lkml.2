Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2IBFXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:23:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55205 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2IBFXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:23:10 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 22:23:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 10/23] rcu: Allow RCU quiescent-state
 forcing to be preempted
Message-ID: <20120902052301.GB7767@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-10-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-10-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:25AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> RCU quiescent-state forcing is currently carried out without preemption
> points, which can result in excessive latency spikes on large systems
> (many hundreds or thousands of CPUs).  This patch therefore inserts
> a voluntary preemption point into force_qs_rnp(), which should greatly
> reduce the magnitude of these spikes.
> 
> Reported-by: Mike Galbraith <mgalbraith@suse.de>
> Reported-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 79c2c28..cce73ff 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1784,6 +1784,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  	struct rcu_node *rnp;
>  
>  	rcu_for_each_leaf_node(rsp, rnp) {
> +		cond_resched();
>  		mask = 0;
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		if (!rcu_gp_in_progress(rsp)) {
> -- 
> 1.7.8
> 
