Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab2J2UjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2J2Uiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:55 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=crIB0WVTXPQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6ydWPwhbZXAA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=nqsjTMDmTqpPfUWWfFYA:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=HewdWnzw2Qd1LvCR:21 a=Uyt6dmaO5mNGi6V5:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203849.558559463@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Hakan Akkan <hakanakkan@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 20/32] nohz/cpuset: enable addition&removal of cpus while in adaptive nohz
 mode
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0020-nohz-cpuset-enable-addition-removal-of-cpus-while-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Akkan <hakanakkan@gmail.com>

Currently modifying cpuset.cpus mask of a cgroup does not
update the reference counters for adaptive nohz mode if the
cpuset already had cpuset.adaptive_nohz == 1. Fix it so that
cpus can be added or removed from a adaptive_nohz cpuset.

Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
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
 kernel/cpuset.c |  111 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 38 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 84f9f2b..218abc8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -868,6 +868,8 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 	cgroup_scan_tasks(&scan);
 }
 
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs);
+
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -908,6 +910,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
+	/*
+	 * Update adaptive nohz bits.
+	 */
+	update_nohz_cpus(cs, trialcs);
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
@@ -1226,50 +1233,75 @@ static void cpu_exit_nohz(int cpu)
 	preempt_enable();
 }
 
-static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+static void update_cpu_nohz_flag(int cpu, int adjust)
 {
-	int cpu;
+	atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
 	int val;
 
+	val = atomic_add_return(adjust, ref);
+
+	if (val == 1 && adjust > 0) {
+		cpumask_set_cpu(cpu, &nohz_cpuset_mask);
+		/*
+		 * The mask update needs to be visible right away
+		 * so that this CPU is part of the cputime IPI
+		 * update right now.
+		 */
+		 smp_mb();
+	} else if (!val) {
+		/*
+		 * The update to cpu_adaptive_nohz_ref must be
+		 * visible right away. So that once we restart the tick
+		 * from the IPI, it won't be stopped again due to cache
+		 * update lag.
+		 * FIXME: We probably need more to ensure this value is really
+		 * visible right away.
+		 */
+		smp_mb();
+		cpu_exit_nohz(cpu);
+		/*
+		 * Now that the tick has been restarted and cputimes
+		 * flushed, we don't need anymore to be part of the
+		 * cputime flush IPI.
+		 */
+		cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
+	}
+}
+
+static void update_nohz_flag(struct cpuset *old_cs, struct cpuset *cs)
+{
+	int cpu;
+	int adjust;
+
 	if (is_adaptive_nohz(old_cs) == is_adaptive_nohz(cs))
 		return;
 
-	for_each_cpu(cpu, cs->cpus_allowed) {
-		atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
-		if (is_adaptive_nohz(cs))
-			val = atomic_inc_return(ref);
-		else
-			val = atomic_dec_return(ref);
-
-		if (val == 1) {
-			cpumask_set_cpu(cpu, &nohz_cpuset_mask);
-			/*
-			 * The mask update needs to be visible right away
-			 * so that this CPU is part of the cputime IPI
-			 * update right now.
-			 */
-			 smp_mb();
-		} else if (!val) {
-			/*
-			 * The update to cpu_adaptive_nohz_ref must be
-			 * visible right away. So that once we restart the tick
-			 * from the IPI, it won't be stopped again due to cache
-			 * update lag.
-			 * FIXME: We probably need more to ensure this value is really
-			 * visible right away.
-			 */
-			smp_mb();
-			cpu_exit_nohz(cpu);
-			/*
-			 * Now that the tick has been restarted and cputimes
-			 * flushed, we don't need anymore to be part of the
-			 * cputime flush IPI.
-			 */
-			cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
-		}
-	}
+	adjust = is_adaptive_nohz(cs) ? 1 : -1;
+	for_each_cpu(cpu, cs->cpus_allowed)
+		update_cpu_nohz_flag(cpu, adjust);
+}
+
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+	int cpu;
+	cpumask_t cpus;
+
+	/*
+	 * Only bother if the cpuset has adaptive nohz
+	 */
+	if (!is_adaptive_nohz(cs))
+		return;
+
+	cpumask_xor(&cpus, old_cs->cpus_allowed, cs->cpus_allowed);
+
+	for_each_cpu(cpu, &cpus)
+		update_cpu_nohz_flag(cpu,
+			cpumask_test_cpu(cpu, cs->cpus_allowed) ? 1 : -1);
 }
 #else
+static inline void update_nohz_flag(struct cpuset *old_cs, struct cpuset *cs)
+{
+}
 static inline void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 {
 }
@@ -1340,7 +1372,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-	update_nohz_cpus(cs, trialcs);
+	update_nohz_flag(cs, trialcs);
 
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
@@ -1965,7 +1997,8 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call async_rebuild_sched_domains().
+ * will call async_rebuild_sched_domains(). Also update adaptive
+ * nohz flag.
  */
 
 static void cpuset_destroy(struct cgroup *cont)
@@ -1975,6 +2008,8 @@ static void cpuset_destroy(struct cgroup *cont)
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
+	update_flag(CS_ADAPTIVE_NOHZ, cs, 0);
+
 	number_of_cpusets--;
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
-- 
1.7.10.4


