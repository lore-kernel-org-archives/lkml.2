Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2HaSNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:13:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52739 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2HaSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:13:47 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:13:38 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 07/15] rcu: Fix obsolete
 rcu_initiate_boost() header comment
Message-ID: <20120831181338.GE4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-7-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:20AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Commit 1217ed1b (rcu: permit rcu_read_unlock() to be called while holding
> runqueue locks) made rcu_initiate_boost() restore irq state when releasing
> the rcu_node structure's ->lock, but failed to update the header comment
> accordingly.  This commit therefore brings the header comment up to date.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutree_plugin.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index c930a47..3ea60c9 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1193,9 +1193,9 @@ static int rcu_boost_kthread(void *arg)
>   * kthread to start boosting them.  If there is an expedited grace
>   * period in progress, it is always time to boost.
>   *
> - * The caller must hold rnp->lock, which this function releases,
> - * but irqs remain disabled.  The ->boost_kthread_task is immortal,
> - * so we don't need to worry about it going away.
> + * The caller must hold rnp->lock, which this function releases.
> + * The ->boost_kthread_task is immortal, so we don't need to worry
> + * about it going away.
>   */
>  static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
>  {
> -- 
> 1.7.8
> 
