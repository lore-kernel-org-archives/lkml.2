Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1EANWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44541 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1EANWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:24 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 25/86] rcu: code cleanups in TINY_RCU priority boosting.
Date: Sun,  1 May 2011 06:21:05 -0700
Message-Id: <1304256126-26015-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Extraneous semicolon, bad comment, and fold INIT_LIST_HEAD() into
list_del() to get list_del_init().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3cb8e36..0bc9f73 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -339,7 +339,7 @@ static void rcu_initiate_expedited_boost(void)
 	raw_local_irq_restore(flags);
 }
 
-#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000);
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
 
 /*
  * Do priority-boost accounting for the start of a new grace period.
@@ -418,7 +418,7 @@ static void rcu_preempt_cpu_qs(void)
 	if (!rcu_preempt_gp_in_progress())
 		return;
 	/*
-	 * Check up on boosting.  If there are no readers blocking the
+	 * Check up on boosting.  If there are readers blocking the
 	 * current grace period, leave.
 	 */
 	if (rcu_initiate_boost())
@@ -578,7 +578,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		empty = !rcu_preempt_blocked_readers_cgp();
 		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
 		np = rcu_next_node_entry(t);
-		list_del(&t->rcu_node_entry);
+		list_del_init(&t->rcu_node_entry);
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
 			rcu_preempt_ctrlblk.gp_tasks = np;
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
@@ -587,7 +587,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.boost_tasks)
 			rcu_preempt_ctrlblk.boost_tasks = np;
 #endif /* #ifdef CONFIG_RCU_BOOST */
-		INIT_LIST_HEAD(&t->rcu_node_entry);
 
 		/*
 		 * If this was the last task on the current list, and if
-- 
1.7.3.2

