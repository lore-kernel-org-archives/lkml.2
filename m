Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2H3SqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:46:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58172 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2H3Spy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/5] rcu: Switch rcutorture to pr_alert() and friends
Date: Thu, 30 Aug 2012 11:45:11 -0700
Message-Id: <1346352312-31987-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-5518-0000-0000-00000739EE2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Drop a few characters by switching kernel/rcutorture.c from
"printk(KERN_ALERT" to "pr_alert(".

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |  100 +++++++++++++++++++++++++-------------------------
 1 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index c6cf6ff..8ea2726 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -119,11 +119,11 @@ MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
 #define TORTURE_FLAG "-torture:"
 #define PRINTK_STRING(s) \
-	do { printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
 #define VERBOSE_PRINTK_STRING(s) \
-	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
 #define VERBOSE_PRINTK_ERRSTRING(s) \
-	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
 static char printk_buf[4096];
 
@@ -241,7 +241,7 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 	if (fullstop == FULLSTOP_DONTSTOP)
 		fullstop = FULLSTOP_SHUTDOWN;
 	else
-		printk(KERN_WARNING /* but going down anyway, so... */
+		pr_warning(/* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
@@ -254,7 +254,7 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 static void rcutorture_shutdown_absorb(char *title)
 {
 	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
-		printk(KERN_NOTICE
+		pr_notice(
 		       "rcutorture thread %s parking due to system shutdown\n",
 		       title);
 		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
@@ -1275,7 +1275,7 @@ rcu_torture_stats_print(void)
 	int cnt;
 
 	cnt = rcu_torture_printk(printk_buf);
-	printk(KERN_ALERT "%s", printk_buf);
+	pr_alert("%s", printk_buf);
 }
 
 /*
@@ -1388,20 +1388,20 @@ rcu_torture_stutter(void *arg)
 static inline void
 rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 {
-	printk(KERN_ALERT "%s" TORTURE_FLAG
-		"--- %s: nreaders=%d nfakewriters=%d "
-		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval=%d stutter=%d irqreader=%d "
-		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
-		"test_boost=%d/%d test_boost_interval=%d "
-		"test_boost_duration=%d shutdown_secs=%d "
-		"onoff_interval=%d onoff_holdoff=%d\n",
-		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
-		test_boost, cur_ops->can_boost,
-		test_boost_interval, test_boost_duration, shutdown_secs,
-		onoff_interval, onoff_holdoff);
+	pr_alert("%s" TORTURE_FLAG
+		 "--- %s: nreaders=%d nfakewriters=%d "
+		 "stat_interval=%d verbose=%d test_no_idle_hz=%d "
+		 "shuffle_interval=%d stutter=%d irqreader=%d "
+		 "fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
+		 "test_boost=%d/%d test_boost_interval=%d "
+		 "test_boost_duration=%d shutdown_secs=%d "
+		 "onoff_interval=%d onoff_holdoff=%d\n",
+		 torture_type, tag, nrealreaders, nfakewriters,
+		 stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		 stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
+		 test_boost, cur_ops->can_boost,
+		 test_boost_interval, test_boost_duration, shutdown_secs,
+		 onoff_interval, onoff_holdoff);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1468,9 +1468,9 @@ rcu_torture_shutdown(void *arg)
 	       !kthread_should_stop()) {
 		delta = shutdown_time - jiffies_snap;
 		if (verbose)
-			printk(KERN_ALERT "%s" TORTURE_FLAG
-			       "rcu_torture_shutdown task: %lu jiffies remaining\n",
-			       torture_type, delta);
+			pr_alert("%s" TORTURE_FLAG
+				 "rcu_torture_shutdown task: %lu jiffies remaining\n",
+				 torture_type, delta);
 		schedule_timeout_interruptible(delta);
 		jiffies_snap = ACCESS_ONCE(jiffies);
 	}
@@ -1516,16 +1516,16 @@ rcu_torture_onoff(void *arg)
 		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
 		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
 			if (verbose)
-				printk(KERN_ALERT "%s" TORTURE_FLAG
-				       "rcu_torture_onoff task: offlining %d\n",
-				       torture_type, cpu);
+				pr_alert("%s" TORTURE_FLAG
+					 "rcu_torture_onoff task: offlining %d\n",
+					 torture_type, cpu);
 			starttime = jiffies;
 			n_offline_attempts++;
 			if (cpu_down(cpu) == 0) {
 				if (verbose)
-					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: offlined %d\n",
-					       torture_type, cpu);
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: offlined %d\n",
+						 torture_type, cpu);
 				n_offline_successes++;
 				delta = jiffies - starttime;
 				sum_offline += delta;
@@ -1540,16 +1540,16 @@ rcu_torture_onoff(void *arg)
 			}
 		} else if (cpu_is_hotpluggable(cpu)) {
 			if (verbose)
-				printk(KERN_ALERT "%s" TORTURE_FLAG
-				       "rcu_torture_onoff task: onlining %d\n",
-				       torture_type, cpu);
+				pr_alert("%s" TORTURE_FLAG
+					 "rcu_torture_onoff task: onlining %d\n",
+					 torture_type, cpu);
 			starttime = jiffies;
 			n_online_attempts++;
 			if (cpu_up(cpu) == 0) {
 				if (verbose)
-					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: onlined %d\n",
-					       torture_type, cpu);
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: onlined %d\n",
+						 torture_type, cpu);
 				n_online_successes++;
 				delta = jiffies - starttime;
 				sum_online += delta;
@@ -1625,14 +1625,14 @@ static int __cpuinit rcu_torture_stall(void *args)
 	if (!kthread_should_stop()) {
 		stop_at = get_seconds() + stall_cpu;
 		/* RCU CPU stall is expected behavior in following code. */
-		printk(KERN_ALERT "rcu_torture_stall start.\n");
+		pr_alert("rcu_torture_stall start.\n");
 		rcu_read_lock();
 		preempt_disable();
 		while (ULONG_CMP_LT(get_seconds(), stop_at))
 			continue;  /* Induce RCU CPU stall warning. */
 		preempt_enable();
 		rcu_read_unlock();
-		printk(KERN_ALERT "rcu_torture_stall end.\n");
+		pr_alert("rcu_torture_stall end.\n");
 	}
 	rcutorture_shutdown_absorb("rcu_torture_stall");
 	while (!kthread_should_stop())
@@ -1748,12 +1748,12 @@ static int rcu_torture_barrier_init(void)
 	if (n_barrier_cbs == 0)
 		return 0;
 	if (cur_ops->call == NULL || cur_ops->cb_barrier == NULL) {
-		printk(KERN_ALERT "%s" TORTURE_FLAG
-		       " Call or barrier ops missing for %s,\n",
-		       torture_type, cur_ops->name);
-		printk(KERN_ALERT "%s" TORTURE_FLAG
-		       " RCU barrier testing omitted from run.\n",
-		       torture_type);
+		pr_alert("%s" TORTURE_FLAG
+			 " Call or barrier ops missing for %s,\n",
+			 torture_type, cur_ops->name);
+		pr_alert("%s" TORTURE_FLAG
+			 " RCU barrier testing omitted from run.\n",
+			 torture_type);
 		return 0;
 	}
 	atomic_set(&barrier_cbs_count, 0);
@@ -1846,7 +1846,7 @@ rcu_torture_cleanup(void)
 	mutex_lock(&fullstop_mutex);
 	rcutorture_record_test_transition();
 	if (fullstop == FULLSTOP_SHUTDOWN) {
-		printk(KERN_WARNING /* but going down anyway, so... */
+		pr_warning(/* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 		mutex_unlock(&fullstop_mutex);
 		schedule_timeout_uninterruptible(10);
@@ -1970,17 +1970,17 @@ rcu_torture_init(void)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
-		printk(KERN_ALERT "rcu-torture: invalid torture type: \"%s\"\n",
-		       torture_type);
-		printk(KERN_ALERT "rcu-torture types:");
+		pr_alert("rcu-torture: invalid torture type: \"%s\"\n",
+			 torture_type);
+		pr_alert("rcu-torture types:");
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
-			printk(KERN_ALERT " %s", torture_ops[i]->name);
-		printk(KERN_ALERT "\n");
+			pr_alert(" %s", torture_ops[i]->name);
+		pr_alert("\n");
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
-		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero fqs_duration, fqs disabled.\n");
+		pr_alert("rcu-torture: ->fqs NULL and non-zero fqs_duration, fqs disabled.\n");
 		fqs_duration = 0;
 	}
 	if (cur_ops->init)
-- 
1.7.8

