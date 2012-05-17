Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967749Ab2EQWNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:13:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52434 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab2EQWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:13:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's source code.
Date: Thu, 17 May 2012 15:12:45 -0700
Message-Id: <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051722-6148-0000-0000-000005F0C49C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although the C language allows you to break strings across lines, doing
this makes it hard for people to find the Linux kernel code corresponding
to a given console message.  This commit therefore fixes broken strings
throughout RCU's source code.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    3 +--
 kernel/rcutorture.c      |   33 ++++++++++++++-------------------
 kernel/rcutree_trace.c   |   25 ++++++++++++-------------
 lib/list_debug.c         |    6 ++----
 4 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 26d1a47..9fae8db 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -432,8 +432,7 @@ extern int rcu_my_thread_group_empty(void);
 static inline void rcu_preempt_sleep_check(void)
 {
 	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
-			   "Illegal context switch in RCU read-side "
-			   "critical section");
+			   "Illegal context switch in RCU read-side critical section");
 }
 #else /* #ifdef CONFIG_PROVE_RCU */
 static inline void rcu_preempt_sleep_check(void)
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index d7c3cb1..ac6612c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -49,8 +49,7 @@
 #include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
-	      "Josh Triplett <josh@freedesktop.org>");
+MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
@@ -1184,27 +1183,27 @@ rcu_torture_printk(char *page)
 	}
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
-		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d rtbke: %ld rtbre: %ld "
-		       "rtbf: %ld rtb: %ld nt: %ld "
-		       "onoff: %ld/%ld:%ld/%ld "
-		       "barrier: %ld/%ld:%ld",
+		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
-		       atomic_read(&n_rcu_torture_free),
+		       atomic_read(&n_rcu_torture_free));
+	cnt += sprintf(&page[cnt], "rtmbe: %d rtbke: %ld rtbre: %ld ",
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
-		       n_rcu_torture_boost_rterror,
+		       n_rcu_torture_boost_rterror);
+	cnt += sprintf(&page[cnt], "rtbf: %ld rtb: %ld nt: %ld ",
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
-		       n_rcu_torture_timers,
+		       n_rcu_torture_timers);
+	cnt += sprintf(&page[cnt], "onoff: %ld/%ld:%ld/%ld ",
 		       n_online_successes,
 		       n_online_attempts,
 		       n_offline_successes,
-		       n_offline_attempts,
+		       n_offline_attempts);
+	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
 		       n_rcu_torture_barrier_error);
@@ -1446,8 +1445,7 @@ rcu_torture_shutdown(void *arg)
 		delta = shutdown_time - jiffies_snap;
 		if (verbose)
 			printk(KERN_ALERT "%s" TORTURE_FLAG
-			       "rcu_torture_shutdown task: %lu "
-			       "jiffies remaining\n",
+			       "rcu_torture_shutdown task: %lu jiffies remaining\n",
 			       torture_type, delta);
 		schedule_timeout_interruptible(delta);
 		jiffies_snap = ACCESS_ONCE(jiffies);
@@ -1499,8 +1497,7 @@ rcu_torture_onoff(void *arg)
 			if (cpu_down(cpu) == 0) {
 				if (verbose)
 					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: "
-					       "offlined %d\n",
+					       "rcu_torture_onoff task: offlined %d\n",
 					       torture_type, cpu);
 				n_offline_successes++;
 			}
@@ -1513,8 +1510,7 @@ rcu_torture_onoff(void *arg)
 			if (cpu_up(cpu) == 0) {
 				if (verbose)
 					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: "
-					       "onlined %d\n",
+					       "rcu_torture_onoff task: onlined %d\n",
 					       torture_type, cpu);
 				n_online_successes++;
 			}
@@ -1932,8 +1928,7 @@ rcu_torture_init(void)
 		return -EINVAL;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
-		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero "
-				  "fqs_duration, fqs disabled.\n");
+		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero fqs_duration, fqs disabled.\n");
 		fqs_duration = 0;
 	}
 	if (cur_ops->init)
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d4bc16d..ffcfd6d 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -201,8 +201,7 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
 {
-	seq_printf(m,  "%d:%d tasks=%c%c%c%c kt=%c ntb=%lu neb=%lu nnb=%lu "
-		   "j=%04x bt=%04x\n",
+	seq_printf(m, "%d:%d tasks=%c%c%c%c kt=%c ntb=%lu neb=%lu nnb=%lu ",
 		   rnp->grplo, rnp->grphi,
 		   "T."[list_empty(&rnp->blkd_tasks)],
 		   "N."[!rnp->gp_tasks],
@@ -210,11 +209,11 @@ static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
 		   "B."[!rnp->boost_tasks],
 		   convert_kthread_status(rnp->boost_kthread_status),
 		   rnp->n_tasks_boosted, rnp->n_exp_boosts,
-		   rnp->n_normal_boosts,
+		   rnp->n_normal_boosts);
+	seq_printf(m, "j=%04x bt=%04x\n",
 		   (int)(jiffies & 0xffff),
 		   (int)(rnp->boost_time & 0xffff));
-	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu nb=%lu ny=%lu nos=%lu\n",
-		   "     balk",
+	seq_printf(m, "    balk: nt=%lu egt=%lu bt=%lu nb=%lu ny=%lu nos=%lu\n",
 		   rnp->n_balk_blkd_tasks,
 		   rnp->n_balk_exp_gp_tasks,
 		   rnp->n_balk_boost_tasks,
@@ -270,11 +269,11 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
-		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
+	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x ",
 		   rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
-		   (int)(jiffies & 0xffff),
+		   (int)(jiffies & 0xffff));
+	seq_printf(m, "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
 		   rsp->n_force_qs_lh, rsp->qlen_lazy, rsp->qlen);
@@ -366,16 +365,16 @@ static const struct file_operations rcugp_fops = {
 
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
-	seq_printf(m, "%3d%cnp=%ld "
-		   "qsp=%ld rpq=%ld cbr=%ld cng=%ld "
-		   "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+	seq_printf(m, "%3d%cnp=%ld ",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
-		   rdp->n_rcu_pending,
+		   rdp->n_rcu_pending);
+	seq_printf(m, "qsp=%ld rpq=%ld cbr=%ld cng=%ld ",
 		   rdp->n_rp_qs_pending,
 		   rdp->n_rp_report_qs,
 		   rdp->n_rp_cb_ready,
-		   rdp->n_rp_cpu_needs_gp,
+		   rdp->n_rp_cpu_needs_gp);
+	seq_printf(m, "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
 		   rdp->n_rp_gp_completed,
 		   rdp->n_rp_gp_started,
 		   rdp->n_rp_need_fqs,
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 3810b48..542d408 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -84,12 +84,10 @@ void __list_add_rcu(struct list_head *new,
 		    struct list_head *prev, struct list_head *next)
 {
 	WARN(next->prev != prev,
-		"list_add_rcu corruption. next->prev should be "
-		"prev (%p), but was %p. (next=%p).\n",
+		"list_add_rcu corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
 		prev, next->prev, next);
 	WARN(prev->next != next,
-		"list_add_rcu corruption. prev->next should be "
-		"next (%p), but was %p. (prev=%p).\n",
+		"list_add_rcu corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
 		next, prev->next, prev);
 	new->next = next;
 	new->prev = prev;
-- 
1.7.8

