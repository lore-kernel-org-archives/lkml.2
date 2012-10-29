Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845Ab2J2Uq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2J2Uiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:52 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ao97ML-lnxUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=C9r2xFJohYMA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=-cVt75R8PzuP9JnB230A:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203848.814892534@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 15/32] nohz/cpuset: New API to flush cputimes on nohz cpusets
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0015-nohz-cpuset-New-API-to-flush-cputimes-on-nohz-cpuset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Provide a new API that sends an IPI to every CPUs included
in nohz cpusets in order to flush their cputimes. It's going
to be useful for those that want to see accurate cputimes
on a nohz cpuset.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuset.h   |    2 ++
 include/linux/tick.h     |    1 +
 kernel/cpuset.c          |   34 +++++++++++++++++++++++++++++++++-
 kernel/time/tick-sched.c |   21 ++++++++++++++++-----
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 631968b..b6c2460 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -262,9 +262,11 @@ static inline bool cpuset_adaptive_nohz(void)
 }
 
 extern void cpuset_exit_nohz_interrupt(void *unused);
+extern void cpuset_nohz_flush_cputimes(void);
 #else
 static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
 static inline bool cpuset_adaptive_nohz(void) { return false; }
+static inline void cpuset_nohz_flush_cputimes(void) { }
 
 #endif /* CONFIG_CPUSETS_NO_HZ */
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 598b492..3c31d6e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -161,6 +161,7 @@ extern void tick_nohz_check_adaptive(void);
 extern void tick_nohz_pre_schedule(void);
 extern void tick_nohz_post_schedule(void);
 extern bool tick_nohz_account_tick(void);
+extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
 static inline void tick_nohz_enter_kernel(void) { }
 static inline void tick_nohz_exit_kernel(void) { }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1b67e5b..84f9f2b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/tick.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1200,6 +1201,23 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
 DEFINE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
 
+static cpumask_t nohz_cpuset_mask;
+
+static void flush_cputime_interrupt(void *unused)
+{
+	tick_nohz_flush_current_times(false);
+}
+
+void cpuset_nohz_flush_cputimes(void)
+{
+	preempt_disable();
+	smp_call_function_many(&nohz_cpuset_mask, flush_cputime_interrupt,
+			       NULL, true);
+	preempt_enable();
+	/* Make the utime/stime updates visible */
+	smp_mb();
+}
+
 static void cpu_exit_nohz(int cpu)
 {
 	preempt_disable();
@@ -1223,7 +1241,15 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 		else
 			val = atomic_dec_return(ref);
 
-		if (!val) {
+		if (val == 1) {
+			cpumask_set_cpu(cpu, &nohz_cpuset_mask);
+			/*
+			 * The mask update needs to be visible right away
+			 * so that this CPU is part of the cputime IPI
+			 * update right now.
+			 */
+			 smp_mb();
+		} else if (!val) {
 			/*
 			 * The update to cpu_adaptive_nohz_ref must be
 			 * visible right away. So that once we restart the tick
@@ -1234,6 +1260,12 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 			 */
 			smp_mb();
 			cpu_exit_nohz(cpu);
+			/*
+			 * Now that the tick has been restarted and cputimes
+			 * flushed, we don't need anymore to be part of the
+			 * cputime flush IPI.
+			 */
+			cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
 		}
 	}
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index de8ba59..2627663 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -712,7 +712,6 @@ static void tick_nohz_account_ticks(struct tick_sched *ts)
 			WARN_ON_ONCE(1);
 		}
 	}
-	ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 }
 
 /**
@@ -746,6 +745,7 @@ void tick_nohz_idle_exit(void)
 		__tick_nohz_restart_sched_tick(ts, now);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 		tick_nohz_account_ticks(ts);
+		ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 #endif
 	}
 
@@ -988,9 +988,7 @@ static void tick_do_timer_check_handler(int cpu)
 
 static void tick_nohz_restart_adaptive(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-
-	tick_nohz_account_ticks(ts);
+	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
 }
@@ -1030,7 +1028,7 @@ void tick_nohz_pre_schedule(void)
 	 * on the prev task.
 	 */
 	if (test_thread_flag(TIF_NOHZ)) {
-		tick_nohz_account_ticks(ts);
+		tick_nohz_flush_current_times(true);
 		clear_thread_flag(TIF_NOHZ);
 	}
 }
@@ -1047,6 +1045,19 @@ void tick_nohz_post_schedule(void)
 	if (ts->tick_stopped)
 		tick_nohz_restart_sched_tick();
 }
+
+void tick_nohz_flush_current_times(bool restart_tick)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (ts->tick_stopped) {
+		tick_nohz_account_ticks(ts);
+		if (restart_tick)
+			ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
+		else
+			ts->saved_jiffies = jiffies;
+	}
+}
 #else
 
 static void tick_do_timer_check_handler(int cpu)
-- 
1.7.10.4


