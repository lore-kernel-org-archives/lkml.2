Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0HIWPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49296 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/10] rcu: refer RCU CPU stall-warning victims to stallwarn.txt
Date: Mon,  9 Aug 2010 15:15:11 -0700
Message-Id: <1281392111-25060-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some documentation on RCU CPU stall warnings contained in
Documentation/RCU/stallwarn.txt, but it will not be apparent to someone
who runs into such a warning while under time pressure.  This commit
therefore adds comments preceding the printk()s pointing out the
location of this documentation.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5aab7da..ff21411 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -487,8 +487,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	/* OK, time to rat on our buddy... */
-
+	/*
+	 * OK, time to rat on our buddy...
+	 * See Documentation/RCU/stallwarn.txt for info on how to debug
+	 * RCU CPU stall warnings.
+	 */
 	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
 	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
@@ -517,6 +520,11 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	/*
+	 * OK, time to rat on ourselves...
+	 * See Documentation/RCU/stallwarn.txt for info on how to debug
+	 * RCU CPU stall warnings.
+	 */
 	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
 	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
-- 
1.7.0.6

