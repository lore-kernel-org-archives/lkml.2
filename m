Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab1EANc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54890 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab1EANWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 29/86] rcu: fix spelling
Date: Sun,  1 May 2011 06:21:09 -0700
Message-Id: <1304256126-26015-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "preemptible" spelling is preferable.  May as well fix it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   10 ++++----
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |   62 +++++++++++++++++++++++-----------------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 03f7148..d0346da 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -290,8 +290,8 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* If preemptable RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptable)
+	/* If preemptible RCU, no point in sending reschedule IPI. */
+	if (rdp->preemptible)
 		return 0;
 
 	/* The CPU is online, so send it a reschedule IPI. */
@@ -1982,7 +1982,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		 * or RCU-bh, force a local reschedule.
 		 */
 		rdp->n_rp_qs_pending++;
-		if (!rdp->preemptable &&
+		if (!rdp->preemptible &&
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
 				 jiffies))
 			set_need_resched();
@@ -2159,7 +2159,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void __cpuinit
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -2171,7 +2171,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
-	rdp->preemptable = preemptable;
+	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 37502a2..a6a9717 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -239,7 +239,7 @@ struct rcu_data {
 	bool		passed_quiesc;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
-	bool		preemptable;	/* Preemptable RCU? */
+	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 11b27f3..f629479 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1,7 +1,7 @@
 /*
  * Read-Copy Update mechanism for mutual exclusion (tree-based version)
  * Internal non-public definitions that provide either classic
- * or preemptable semantics.
+ * or preemptible semantics.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,7 +75,7 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Preemptable hierarchical RCU implementation.\n");
+	printk(KERN_INFO "Preemptible hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -108,7 +108,7 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Record a preemptable-RCU quiescent state for the specified CPU.  Note
+ * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
@@ -207,7 +207,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Tree-preemptable RCU implementation for rcu_read_lock().
+ * Tree-preemptible RCU implementation for rcu_read_lock().
  * Just increment ->rcu_read_lock_nesting, shared state will be updated
  * if we block.
  */
@@ -376,7 +376,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 }
 
 /*
- * Tree-preemptable RCU implementation for rcu_read_unlock().
+ * Tree-preemptible RCU implementation for rcu_read_unlock().
  * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
@@ -565,7 +565,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 }
 
 /*
- * Do CPU-offline processing for preemptable RCU.
+ * Do CPU-offline processing for preemptible RCU.
  */
 static void rcu_preempt_offline_cpu(int cpu)
 {
@@ -594,7 +594,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Process callbacks for preemptable RCU.
+ * Process callbacks for preemptible RCU.
  */
 static void rcu_preempt_process_callbacks(void)
 {
@@ -603,7 +603,7 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
- * Queue a preemptable-RCU callback for invocation after a grace period.
+ * Queue a preemptible-RCU callback for invocation after a grace period.
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
@@ -795,7 +795,7 @@ mb_ret:
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /*
- * Check to see if there is any immediate preemptable-RCU-related work
+ * Check to see if there is any immediate preemptible-RCU-related work
  * to be done.
  */
 static int rcu_preempt_pending(int cpu)
@@ -805,7 +805,7 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Does preemptable RCU need the CPU to stay out of dynticks mode?
+ * Does preemptible RCU need the CPU to stay out of dynticks mode?
  */
 static int rcu_preempt_needs_cpu(int cpu)
 {
@@ -822,7 +822,7 @@ void rcu_barrier(void)
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
 /*
- * Initialize preemptable RCU's per-CPU data.
+ * Initialize preemptible RCU's per-CPU data.
  */
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 {
@@ -830,7 +830,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable RCU's callbacks from dying CPU to other online CPU.
+ * Move preemptible RCU's callbacks from dying CPU to other online CPU.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
@@ -838,7 +838,7 @@ static void rcu_preempt_send_cbs_to_online(void)
 }
 
 /*
- * Initialize preemptable RCU's state structures.
+ * Initialize preemptible RCU's state structures.
  */
 static void __init __rcu_init_preempt(void)
 {
@@ -846,7 +846,7 @@ static void __init __rcu_init_preempt(void)
 }
 
 /*
- * Check for a task exiting while in a preemptable-RCU read-side
+ * Check for a task exiting while in a preemptible-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
  * is enabled.
@@ -894,7 +894,7 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
 static void rcu_preempt_note_context_switch(int cpu)
@@ -902,7 +902,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, there are never any preempted
+ * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
@@ -921,7 +921,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp)
@@ -929,7 +929,7 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 }
 
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
@@ -945,7 +945,7 @@ static void rcu_preempt_stall_reset(void)
 }
 
 /*
- * Because there is no preemptable RCU, there can be no readers blocked,
+ * Because there is no preemptible RCU, there can be no readers blocked,
  * so there is no need to check for blocked tasks.  So check only for
  * bogus qsmask values.
  */
@@ -957,7 +957,7 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Because preemptable RCU does not exist, it never needs to migrate
+ * Because preemptible RCU does not exist, it never needs to migrate
  * tasks that were blocked within RCU read-side critical sections, and
  * such non-existent tasks cannot possibly have been blocking the current
  * grace period.
@@ -970,7 +970,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 }
 
 /*
- * Because preemptable RCU does not exist, it never needs CPU-offline
+ * Because preemptible RCU does not exist, it never needs CPU-offline
  * processing.
  */
 static void rcu_preempt_offline_cpu(int cpu)
@@ -980,7 +980,7 @@ static void rcu_preempt_offline_cpu(int cpu)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
- * Because preemptable RCU does not exist, it never has any callbacks
+ * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
 static void rcu_preempt_check_callbacks(int cpu)
@@ -988,7 +988,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, it never has any callbacks
+ * Because preemptible RCU does not exist, it never has any callbacks
  * to process.
  */
 static void rcu_preempt_process_callbacks(void)
@@ -997,7 +997,7 @@ static void rcu_preempt_process_callbacks(void)
 
 /*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
- * But because preemptable RCU does not exist, map to rcu-sched.
+ * But because preemptible RCU does not exist, map to rcu-sched.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -1008,7 +1008,7 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Because preemptable RCU does not exist, there is never any need to
+ * Because preemptible RCU does not exist, there is never any need to
  * report on tasks preempted in RCU read-side critical sections during
  * expedited RCU grace periods.
  */
@@ -1020,7 +1020,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
- * Because preemptable RCU does not exist, it never has any work to do.
+ * Because preemptible RCU does not exist, it never has any work to do.
  */
 static int rcu_preempt_pending(int cpu)
 {
@@ -1028,7 +1028,7 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, it never needs any CPU.
+ * Because preemptible RCU does not exist, it never needs any CPU.
  */
 static int rcu_preempt_needs_cpu(int cpu)
 {
@@ -1036,7 +1036,7 @@ static int rcu_preempt_needs_cpu(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, rcu_barrier() is just
+ * Because preemptible RCU does not exist, rcu_barrier() is just
  * another name for rcu_barrier_sched().
  */
 void rcu_barrier(void)
@@ -1046,7 +1046,7 @@ void rcu_barrier(void)
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
 /*
- * Because preemptable RCU does not exist, there is no per-CPU
+ * Because preemptible RCU does not exist, there is no per-CPU
  * data to initialize.
  */
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
@@ -1054,14 +1054,14 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Because there is no preemptable RCU, there are no callbacks to move.
+ * Because there is no preemptible RCU, there are no callbacks to move.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
 }
 
 /*
- * Because preemptable RCU does not exist, it need not be initialized.
+ * Because preemptible RCU does not exist, it need not be initialized.
  */
 static void __init __rcu_init_preempt(void)
 {
-- 
1.7.3.2

