Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2J2Uiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:38:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2J2Uit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:49 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sqfun6WpByoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LEY0zfysBkYA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=vu6QRlfLTalFuAVWf1UA:9 a=h_HRMOJ35JwA:10 a=AYKSEw0n6-0A:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203846.951402615@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:13 -0400
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
Subject: [PATCH 02/32] cpuset: Set up interface for nohz flag
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0002-cpuset-Set-up-interface-for-nohz-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Prepare the interface to implement the nohz cpuset flag.
This flag, once set, will tell the system to try to
shutdown the periodic timer tick when possible.

We use here a per cpu refcounter. As long as a CPU
is contained into at least one cpuset that has the
nohz flag set, it is part of the set of CPUs that
run into adaptive nohz mode.

[ include build fix from Zen Lin ]

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
 arch/Kconfig           |    3 +++
 include/linux/cpuset.h |   31 ++++++++++++++++++++++++++++
 init/Kconfig           |    8 ++++++++
 kernel/cpuset.c        |   53 +++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..8e2162f6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -239,6 +239,9 @@ config HAVE_ARCH_JUMP_LABEL
 	bool
 
 config HAVE_ARCH_MUTEX_CPU_RELAX
+       bool
+
+config HAVE_CPUSETS_NO_HZ
 	bool
 
 config HAVE_RCU_TABLE_FREE
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 838320f..7e7eb41 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -13,6 +13,7 @@
 #include <linux/nodemask.h>
 #include <linux/cgroup.h>
 #include <linux/mm.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_CPUSETS
 
@@ -235,4 +236,34 @@ static inline bool put_mems_allowed(unsigned int seq)
 
 #endif /* !CONFIG_CPUSETS */
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+DECLARE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
+
+static inline bool cpuset_cpu_adaptive_nohz(int cpu)
+{
+	atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
+
+	if (atomic_add_return(0, ref) > 0)
+		return true;
+
+	return false;
+}
+
+static inline bool cpuset_adaptive_nohz(void)
+{
+	/*
+	 * We probably want to do atomic_read() when we read
+	 * locally to avoid the overhead of an ordered add.
+	 * For that we have to do the dec of the ref locally as
+	 * well.
+	 */
+	return cpuset_cpu_adaptive_nohz(smp_processor_id());
+}
+#else
+static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
+static inline bool cpuset_adaptive_nohz(void) { return false; }
+
+#endif /* CONFIG_CPUSETS_NO_HZ */
+
 #endif /* _LINUX_CPUSET_H */
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..ffdeeab 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -749,6 +749,14 @@ config PROC_PID_CPUSET
 	depends on CPUSETS
 	default y
 
+config CPUSETS_NO_HZ
+       bool "Tickless cpusets"
+       depends on CPUSETS && HAVE_CPUSETS_NO_HZ
+       help
+         This options let you apply a nohz property to a cpuset such
+	 that the periodic timer tick tries to be avoided when possible on
+	 the concerned CPUs.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	help
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f33c715..6319d8e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -145,6 +145,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_ADAPTIVE_NOHZ,
 } cpuset_flagbits_t;
 
 /* the type of hotplug event */
@@ -189,6 +190,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_adaptive_nohz(const struct cpuset *cs)
+{
+	return test_bit(CS_ADAPTIVE_NOHZ, &cs->flags);
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 };
@@ -1190,6 +1196,32 @@ static void cpuset_change_flag(struct task_struct *tsk,
 	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+DEFINE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
+
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+	int cpu;
+	int val;
+
+	if (is_adaptive_nohz(old_cs) == is_adaptive_nohz(cs))
+		return;
+
+	for_each_cpu(cpu, cs->cpus_allowed) {
+		atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
+		if (is_adaptive_nohz(cs))
+			atomic_inc(ref);
+		else
+			atomic_dec(ref);
+	}
+}
+#else
+static inline void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+}
+#endif
+
 /*
  * update_tasks_flags - update the spread flags of tasks in the cpuset.
  * @cs: the cpuset in which each task's spread flags needs to be changed
@@ -1255,6 +1287,8 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	update_nohz_cpus(cs, trialcs);
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1465,6 +1499,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_ADAPTIVE_NOHZ,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1504,6 +1539,11 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+#ifdef CONFIG_CPUSETS_NO_HZ
+	case FILE_ADAPTIVE_NOHZ:
+		retval = update_flag(CS_ADAPTIVE_NOHZ, cs, val);
+		break;
+#endif
 	default:
 		retval = -EINVAL;
 		break;
@@ -1663,6 +1703,10 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+#ifdef CONFIG_CPUSETS_NO_HZ
+	case FILE_ADAPTIVE_NOHZ:
+		return is_adaptive_nohz(cs);
+#endif
 	default:
 		BUG();
 	}
@@ -1771,7 +1815,14 @@ static struct cftype files[] = {
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_SPREAD_SLAB,
 	},
-
+#ifdef CONFIG_CPUSETS_NO_HZ
+	{
+		.name = "adaptive_nohz",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_ADAPTIVE_NOHZ,
+	},
+#endif
 	{
 		.name = "memory_pressure_enabled",
 		.flags = CFTYPE_ONLY_ON_ROOT,
-- 
1.7.10.4


