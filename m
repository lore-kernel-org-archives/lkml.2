Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0EQWzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:55:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0EQWzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:55:00 -0400
Date: Tue, 18 May 2010 00:54:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86/cpu changes for v2.6.35
Message-ID: <20100517225426.GA1720@elte.hu>
References: <20100517225225.GA32562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517225225.GA32562@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-cleanups-for-linus git tree from:

Correction, the above URI is still the previous pull 
request - the one for x86-cleanups-for-linus is:

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus


out-of-topic modifications in x86-cpu-for-linus:
------------------------------------------------
drivers/cpufreq/cpufreq.c          # 6dad2a2: cpufreq: Unify sysfs attribute de
drivers/cpufreq/cpufreq_conservative.c# 6dad2a2: cpufreq: Unify sysfs attribute de
drivers/cpufreq/cpufreq_ondemand.c # 6dad2a2: cpufreq: Unify sysfs attribute de
drivers/misc/vmware_balloon.c      # a10a569: Modify the VMware balloon driver 
include/linux/cpufreq.h            # 6dad2a2: cpufreq: Unify sysfs attribute de

 Thanks,

	Ingo

------------------>
Borislav Petkov (9):
      x86, cpu: Add AMD core boosting feature flag to /proc/cpuinfo
      powernow-k8: Add core performance boost support
      x86: Unify APERF/MPERF support
      cpufreq: Unify sysfs attribute definition macros
      x86, cacheinfo: Unify AMD L3 cache index disable checking
      x86, cacheinfo: Reorganize AMD L3 cache structure
      x86, cacheinfo: Make L3 cache info per node
      x86, cacheinfo: Disable index in all four subcaches
      x86, k8: Fix build error when K8_NB is disabled

Frank Arnold (1):
      x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

Greg Kroah-Hartman (1):
      x86, HyperV: fix up the license to mshyperv.c

H. Peter Anvin (5):
      x86, cpu: Make APERF/MPERF a normal table-driven flag
      x86: Clean up the hypervisor layer
      x86, hypervisor: Export the x86_hyper* symbols
      Modify the VMware balloon driver for the new x86_hyper API
      x86, hypervisor: add missing <linux/module.h>

Ky Srinivasan (1):
      x86: Detect running on a Microsoft HyperV system

Mark Langsdorf (2):
      x86, cpufreq: Add APERF/MPERF support for AMD processors
      powernow-k8: Fix frequency reporting


 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/hyperv.h              |   11 ++-
 arch/x86/include/asm/hypervisor.h          |   27 ++++-
 arch/x86/include/asm/k8.h                  |    5 +
 arch/x86/include/asm/mshyperv.h            |   14 ++
 arch/x86/include/asm/processor.h           |    4 -
 arch/x86/include/asm/vmware.h              |   27 ----
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |   14 ++-
 arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-------
 arch/x86/kernel/cpu/cpufreq/mperf.c        |   51 ++++++++
 arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 ++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |  172 +++++++++++++++++++++++++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h  |    2 -
 arch/x86/kernel/cpu/hypervisor.c           |   52 ++++++---
 arch/x86/kernel/cpu/intel.c                |    6 -
 arch/x86/kernel/cpu/intel_cacheinfo.c      |  181 ++++++++++++++++++++--------
 arch/x86/kernel/cpu/mshyperv.c             |   55 +++++++++
 arch/x86/kernel/cpu/vmware.c               |   38 ++++---
 drivers/cpufreq/cpufreq.c                  |   40 ++----
 drivers/cpufreq/cpufreq_conservative.c     |   48 +++-----
 drivers/cpufreq/cpufreq_ondemand.c         |   40 ++-----
 drivers/misc/vmware_balloon.c              |    4 +-
 include/linux/cpufreq.h                    |   30 +++++
 25 files changed, 601 insertions(+), 280 deletions(-)
 create mode 100644 arch/x86/include/asm/mshyperv.h
 delete mode 100644 arch/x86/include/asm/vmware.h
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h
 create mode 100644 arch/x86/kernel/cpu/mshyperv.c

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..630e623 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -161,6 +161,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/hyperv.h b/arch/x86/include/asm/hyperv.h
index e153a2b..5df477a 100644
--- a/arch/x86/include/asm/hyperv.h
+++ b/arch/x86/include/asm/hyperv.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_KVM_HYPERV_H
-#define _ASM_X86_KVM_HYPERV_H
+#ifndef _ASM_X86_HYPERV_H
+#define _ASM_X86_HYPERV_H
 
 #include <linux/types.h>
 
@@ -14,6 +14,10 @@
 #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
 #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
 
+#define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
+#define HYPERV_CPUID_MIN			0x40000005
+#define HYPERV_CPUID_MAX			0x4000ffff
+
 /*
  * Feature identification. EAX indicates which features are available
  * to the partition based upon the current partition privileges.
@@ -129,6 +133,9 @@
 /* MSR used to provide vcpu index */
 #define HV_X64_MSR_VP_INDEX			0x40000002
 
+/* MSR used to read the per-partition time reference counter */
+#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
+
 /* Define the virtual APIC registers */
 #define HV_X64_MSR_EOI				0x40000070
 #define HV_X64_MSR_ICR				0x40000071
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b78c094..70abda7 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -17,10 +17,33 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#ifndef ASM_X86__HYPERVISOR_H
-#define ASM_X86__HYPERVISOR_H
+#ifndef _ASM_X86_HYPERVISOR_H
+#define _ASM_X86_HYPERVISOR_H
 
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
 
+/*
+ * x86 hypervisor information
+ */
+struct hypervisor_x86 {
+	/* Hypervisor name */
+	const char	*name;
+
+	/* Detection routine */
+	bool		(*detect)(void);
+
+	/* Adjust CPU feature bits (run once per CPU) */
+	void		(*set_cpu_features)(struct cpuinfo_x86 *);
+
+	/* Platform setup (run once per boot) */
+	void		(*init_platform)(void);
+};
+
+extern const struct hypervisor_x86 *x86_hyper;
+
+/* Recognized hypervisors */
+extern const struct hypervisor_x86 x86_hyper_vmware;
+extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
+
 #endif
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index f70e600..af00bd1 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -16,11 +16,16 @@ extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_K8_NB
+extern int num_k8_northbridges;
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
 }
+
 #else
+#define num_k8_northbridges 0
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return NULL;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
new file mode 100644
index 0000000..79ce568
--- /dev/null
+++ b/arch/x86/include/asm/mshyperv.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_MSHYPER_H
+#define _ASM_X86_MSHYPER_H
+
+#include <linux/types.h>
+#include <asm/hyperv.h>
+
+struct ms_hyperv_info {
+	u32 features;
+	u32 hints;
+};
+
+extern struct ms_hyperv_info ms_hyperv;
+
+#endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b753ea5..e4f1dfb 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -113,7 +113,6 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
-	unsigned int		x86_hyper_vendor;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -127,9 +126,6 @@ struct cpuinfo_x86 {
 
 #define X86_VENDOR_UNKNOWN	0xff
 
-#define X86_HYPER_VENDOR_NONE  0
-#define X86_HYPER_VENDOR_VMWARE 1
-
 /*
  * capabilities of CPUs
  */
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
deleted file mode 100644
index e49ed6d..0000000
--- a/arch/x86/include/asm/vmware.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2008, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#ifndef ASM_X86__VMWARE_H
-#define ASM_X86__VMWARE_H
-
-extern void vmware_platform_setup(void);
-extern int vmware_platform(void);
-extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
-
-#endif
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c202b62..3a785da 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o sched.o
+obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 97ad79c..10fa568 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -30,12 +30,14 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
+		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
+		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
+		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
+		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
+		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
+		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
+		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
 		{ 0, 0, 0, 0 }
 	};
 
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 1840c0a..bd54bf6 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,8 +2,8 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4591680..1d3cdda 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -46,6 +46,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include "mperf.h"
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, \
 		"acpi-cpufreq", msg)
@@ -71,8 +72,6 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -240,45 +239,6 @@ static u32 get_cur_val(const struct cpumask *mask)
 	return cmd.val;
 }
 
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-static unsigned int get_measured_perf(struct cpufreq_policy *policy,
-				      unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
@@ -702,7 +662,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* Check for APERF/MPERF support in hardware */
 	if (cpu_has(c, X86_FEATURE_APERFMPERF))
-		acpi_cpufreq_driver.getavg = get_measured_perf;
+		acpi_cpufreq_driver.getavg = cpufreq_get_measured_perf;
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.c b/arch/x86/kernel/cpu/cpufreq/mperf.c
new file mode 100644
index 0000000..911e193
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.c
@@ -0,0 +1,51 @@
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/slab.h>
+
+#include "mperf.h"
+
+static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
+
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
+{
+	struct aperfmperf *am = _cur;
+
+	get_aperfmperf(am);
+}
+
+/*
+ * Return the measured active (C0) frequency on this CPU since last call
+ * to this function.
+ * Input: cpu number
+ * Return: Average CPU frequency in terms of max frequency (zero on error)
+ *
+ * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
+ * over a period of time, while CPU is in C0 state.
+ * IA32_MPERF counts at the rate of max advertised frequency
+ * IA32_APERF counts at the rate of actual CPU frequency
+ * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
+ * no meaning should be associated with absolute values of these MSRs.
+ */
+unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu)
+{
+	struct aperfmperf perf;
+	unsigned long ratio;
+	unsigned int retval;
+
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
+		return 0;
+
+	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
+	per_cpu(acfreq_old_perf, cpu) = perf;
+
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cpufreq_get_measured_perf);
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.h b/arch/x86/kernel/cpu/cpufreq/mperf.h
new file mode 100644
index 0000000..5dbf295
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.h
@@ -0,0 +1,9 @@
+/*
+ *  (c) 2010 Advanced Micro Devices, Inc.
+ *  Your use of this code is subject to the terms and conditions of the
+ *  GNU general public license version 2. See "COPYING" or
+ *  http://www.gnu.org/licenses/gpl.html
+ */
+
+unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index d360b56..6f3dc8f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,6 +1,5 @@
-
 /*
- *   (c) 2003-2006 Advanced Micro Devices, Inc.
+ *   (c) 2003-2010 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
@@ -46,6 +45,7 @@
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
+#include "mperf.h"
 
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
@@ -54,6 +54,12 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
+/* core performance boost */
+static bool cpb_capable, cpb_enabled;
+static struct msr __percpu *msrs;
+
+static struct cpufreq_driver cpufreq_amd64_driver;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -929,7 +935,8 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
@@ -1248,6 +1255,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
+	struct cpuinfo_x86 *c = &cpu_data(pol->cpu);
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1322,6 +1330,10 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		return -EINVAL;
 	}
 
+	/* Check for APERF/MPERF support in hardware */
+	if (cpu_has(c, X86_FEATURE_APERFMPERF))
+		cpufreq_amd64_driver.getavg = cpufreq_get_measured_perf;
+
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
 	if (cpu_family == CPU_HW_PSTATE)
@@ -1393,8 +1405,77 @@ out:
 	return khz;
 }
 
+static void _cpb_toggle_msrs(bool t)
+{
+	int cpu;
+
+	get_online_cpus();
+
+	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+		if (t)
+			reg->l &= ~BIT(25);
+		else
+			reg->l |= BIT(25);
+	}
+	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+	put_online_cpus();
+}
+
+/*
+ * Switch on/off core performance boosting.
+ *
+ * 0=disable
+ * 1=enable.
+ */
+static void cpb_toggle(bool t)
+{
+	if (!cpb_capable)
+		return;
+
+	if (t && !cpb_enabled) {
+		cpb_enabled = true;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting enabled.\n");
+	} else if (!t && cpb_enabled) {
+		cpb_enabled = false;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting disabled.\n");
+	}
+}
+
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+				 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1) && cpb_capable)
+		cpb_toggle(val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", cpb_enabled);
+}
+
+#define define_one_rw(_name) \
+static struct freq_attr _name = \
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+define_one_rw(cpb);
+
 static struct freq_attr *powernow_k8_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpb,
 	NULL,
 };
 
@@ -1410,10 +1491,51 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.attr		= powernow_k8_attr,
 };
 
+/*
+ * Clear the boost-disable flag on the CPU_DOWN path so that this cpu
+ * cannot block the remaining ones from boosting. On the CPU_UP path we
+ * simply keep the boost-disable flag in sync with the current global
+ * state.
+ */
+static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
+				void *hcpu)
+{
+	unsigned cpu = (long)hcpu;
+	u32 lo, hi;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+
+		if (!cpb_enabled) {
+			rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
+			lo |= BIT(25);
+			wrmsr_on_cpu(cpu, MSR_K7_HWCR, lo, hi);
+		}
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
+		lo &= ~BIT(25);
+		wrmsr_on_cpu(cpu, MSR_K7_HWCR, lo, hi);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata cpb_nb = {
+	.notifier_call		= cpb_notify,
+};
+
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
-	unsigned int i, supported_cpus = 0;
+	unsigned int i, supported_cpus = 0, cpu;
 
 	for_each_online_cpu(i) {
 		int rc;
@@ -1422,15 +1544,36 @@ static int __cpuinit powernowk8_init(void)
 			supported_cpus++;
 	}
 
-	if (supported_cpus == num_online_cpus()) {
-		printk(KERN_INFO PFX "Found %d %s "
-			"processors (%d cpu cores) (" VERSION ")\n",
-			num_online_nodes(),
-			boot_cpu_data.x86_model_id, supported_cpus);
-		return cpufreq_register_driver(&cpufreq_amd64_driver);
+	if (supported_cpus != num_online_cpus())
+		return -ENODEV;
+
+	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
+
+	if (boot_cpu_has(X86_FEATURE_CPB)) {
+
+		cpb_capable = true;
+
+		register_cpu_notifier(&cpb_nb);
+
+		msrs = msrs_alloc();
+		if (!msrs) {
+			printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
+			return -ENOMEM;
+		}
+
+		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			cpb_enabled |= !(!!(reg->l & BIT(25)));
+		}
+
+		printk(KERN_INFO PFX "Core Performance Boosting: %s.\n",
+			(cpb_enabled ? "on" : "off"));
 	}
 
-	return -ENODEV;
+	return cpufreq_register_driver(&cpufreq_amd64_driver);
 }
 
 /* driver entry point for term */
@@ -1438,6 +1581,13 @@ static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
 
+	if (boot_cpu_has(X86_FEATURE_CPB)) {
+		msrs_free(msrs);
+		msrs = NULL;
+
+		unregister_cpu_notifier(&cpb_nb);
+	}
+
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 02ce824..df3529b 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -5,7 +5,6 @@
  *  http://www.gnu.org/licenses/gpl.html
  */
 
-
 enum pstate {
 	HW_PSTATE_INVALID = 0xff,
 	HW_PSTATE_0 = 0,
@@ -55,7 +54,6 @@ struct powernow_k8_data {
 	struct cpumask *available_cores;
 };
 
-
 /* processor's cpuid instruction support */
 #define CPUID_PROCESSOR_SIGNATURE	1	/* function 1 */
 #define CPUID_XFAM			0x0ff00000	/* extended family */
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 08be922..dd531cc 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -21,37 +21,55 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/processor.h>
-#include <asm/vmware.h>
 #include <asm/hypervisor.h>
 
-static inline void __cpuinit
-detect_hypervisor_vendor(struct cpuinfo_x86 *c)
+/*
+ * Hypervisor detect order.  This is specified explicitly here because
+ * some hypervisors might implement compatibility modes for other
+ * hypervisors and therefore need to be detected in specific sequence.
+ */
+static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
-	if (vmware_platform())
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
-	else
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
-}
+	&x86_hyper_vmware,
+	&x86_hyper_ms_hyperv,
+};
 
-static inline void __cpuinit
-hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
+const struct hypervisor_x86 *x86_hyper;
+EXPORT_SYMBOL(x86_hyper);
+
+static inline void __init
+detect_hypervisor_vendor(void)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE) {
-		vmware_set_feature_bits(c);
-		return;
+	const struct hypervisor_x86 *h, * const *p;
+
+	for (p = hypervisors; p < hypervisors + ARRAY_SIZE(hypervisors); p++) {
+		h = *p;
+		if (h->detect()) {
+			x86_hyper = h;
+			printk(KERN_INFO "Hypervisor detected: %s\n", h->name);
+			break;
+		}
 	}
 }
 
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
 {
-	detect_hypervisor_vendor(c);
-	hypervisor_set_feature_bits(c);
+	if (x86_hyper && x86_hyper->set_cpu_features)
+		x86_hyper->set_cpu_features(c);
 }
 
 void __init init_hypervisor_platform(void)
 {
+
+	detect_hypervisor_vendor();
+
+	if (!x86_hyper)
+		return;
+
 	init_hypervisor(&boot_cpu_data);
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
-		vmware_platform_setup();
+
+	if (x86_hyper->init_platform)
+		x86_hyper->init_platform();
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1366c7c..afeaa3e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -373,12 +373,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	if (c->cpuid_level > 6) {
-		unsigned ecx = cpuid_ecx(6);
-		if (ecx & 0x01)
-			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
-	}
-
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 	if (cpu_has_ds) {
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b3eeb66..33eae20 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -148,13 +148,19 @@ union _cpuid4_leaf_ecx {
 	u32 full;
 };
 
+struct amd_l3_cache {
+	struct	 pci_dev *dev;
+	bool	 can_disable;
+	unsigned indices;
+	u8	 subcaches[4];
+};
+
 struct _cpuid4_info {
 	union _cpuid4_leaf_eax eax;
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	bool can_disable;
-	unsigned int l3_indices;
+	struct amd_l3_cache *l3;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -164,8 +170,7 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	bool can_disable;
-	unsigned int l3_indices;
+	struct amd_l3_cache *l3;
 };
 
 unsigned short			num_cache_leaves;
@@ -302,87 +307,163 @@ struct _cache_attr {
 };
 
 #ifdef CONFIG_CPU_SUP_AMD
-static unsigned int __cpuinit amd_calc_l3_indices(void)
+
+/*
+ * L3 cache descriptors
+ */
+static struct amd_l3_cache **__cpuinitdata l3_caches;
+
+static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 {
-	/*
-	 * We're called over smp_call_function_single() and therefore
-	 * are on the correct cpu.
-	 */
-	int cpu = smp_processor_id();
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
-	pci_read_config_dword(dev, 0x1C4, &val);
+	pci_read_config_dword(l3->dev, 0x1C4, &val);
 
 	/* calculate subcache sizes */
-	sc0 = !(val & BIT(0));
-	sc1 = !(val & BIT(4));
-	sc2 = !(val & BIT(8))  + !(val & BIT(9));
-	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+	l3->subcaches[0] = sc0 = !(val & BIT(0));
+	l3->subcaches[1] = sc1 = !(val & BIT(4));
+	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
-	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
+static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
+{
+	struct amd_l3_cache *l3;
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+
+	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
+	if (!l3) {
+		printk(KERN_WARNING "Error allocating L3 struct\n");
+		return NULL;
+	}
+
+	l3->dev = dev;
+
+	amd_calc_l3_indices(l3);
+
+	return l3;
 }
 
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
-	if (index < 3)
+	int node;
+
+	if (boot_cpu_data.x86 != 0x10)
 		return;
 
-	if (boot_cpu_data.x86 == 0x11)
+	if (index < 3)
 		return;
 
 	/* see errata #382 and #388 */
-	if ((boot_cpu_data.x86 == 0x10) &&
-	    ((boot_cpu_data.x86_model < 0x8) ||
-	     (boot_cpu_data.x86_mask  < 0x1)))
+	if (boot_cpu_data.x86_model < 0x8)
+		return;
+
+	if ((boot_cpu_data.x86_model == 0x8 ||
+	     boot_cpu_data.x86_model == 0x9)
+		&&
+	     boot_cpu_data.x86_mask < 0x1)
+			return;
+
+	/* not in virtualized environments */
+	if (num_k8_northbridges == 0)
 		return;
 
-	this_leaf->can_disable = true;
-	this_leaf->l3_indices  = amd_calc_l3_indices();
+	/*
+	 * Strictly speaking, the amount in @size below is leaked since it is
+	 * never freed but this is done only on shutdown so it doesn't matter.
+	 */
+	if (!l3_caches) {
+		int size = num_k8_northbridges * sizeof(struct amd_l3_cache *);
+
+		l3_caches = kzalloc(size, GFP_ATOMIC);
+		if (!l3_caches)
+			return;
+	}
+
+	node = amd_get_nb_id(smp_processor_id());
+
+	if (!l3_caches[node]) {
+		l3_caches[node] = amd_init_l3_cache(node);
+		l3_caches[node]->can_disable = true;
+	}
+
+	WARN_ON(!l3_caches[node]);
+
+	this_leaf->l3 = l3_caches[node];
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
+				  unsigned int slot)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	struct pci_dev *dev = this_leaf->l3->dev;
 	unsigned int reg = 0;
 
-	if (!this_leaf->can_disable)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
 	if (!dev)
 		return -EINVAL;
 
-	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	pci_read_config_dword(dev, 0x1BC + slot * 4, &reg);
 	return sprintf(buf, "0x%08x\n", reg);
 }
 
-#define SHOW_CACHE_DISABLE(index)					\
+#define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
+show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf)	\
 {									\
-	return show_cache_disable(this_leaf, buf, index);		\
+	return show_cache_disable(this_leaf, buf, slot);		\
 }
 SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
+static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
+				 unsigned slot, unsigned long idx)
+{
+	int i;
+
+	idx |= BIT(30);
+
+	/*
+	 *  disable index in all 4 subcaches
+	 */
+	for (i = 0; i < 4; i++) {
+		u32 reg = idx | (i << 20);
+
+		if (!l3->subcaches[i])
+			continue;
+
+		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+
+		/*
+		 * We need to WBINVD on a core on the node containing the L3
+		 * cache which indices we disable therefore a simple wbinvd()
+		 * is not sufficient.
+		 */
+		wbinvd_on_cpu(cpu);
+
+		reg |= BIT(31);
+		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+	}
+}
+
+
 static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-	const char *buf, size_t count, unsigned int index)
+				   const char *buf, size_t count,
+				   unsigned int slot)
 {
+	struct pci_dev *dev = this_leaf->l3->dev;
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
 
 #define SUBCACHE_MASK	(3UL << 20)
 #define SUBCACHE_INDEX	0xfff
 
-	if (!this_leaf->can_disable)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -396,26 +477,20 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	/* do not allow writes outside of allowed bits */
 	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3->indices))
 		return -EINVAL;
 
-	val |= BIT(30);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-	/*
-	 * We need to WBINVD on a core on the node containing the L3 cache which
-	 * indices we disable therefore a simple wbinvd() is not sufficient.
-	 */
-	wbinvd_on_cpu(cpu);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
+	amd_l3_disable_index(this_leaf->l3, cpu, slot, val);
+
 	return count;
 }
 
-#define STORE_CACHE_DISABLE(index)					\
+#define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
+store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
 			    const char *buf, size_t count)		\
 {									\
-	return store_cache_disable(this_leaf, buf, count, index);	\
+	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
 STORE_CACHE_DISABLE(0)
 STORE_CACHE_DISABLE(1)
@@ -443,8 +518,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-		if (boot_cpu_data.x86 >= 0x10)
-			amd_check_l3_disable(index, this_leaf);
+		amd_check_l3_disable(index, this_leaf);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
@@ -701,6 +775,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
+	kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
 	kfree(per_cpu(ici_cpuid4_info, cpu));
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
@@ -985,7 +1060,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 		this_leaf = CPUID4_INFO_IDX(cpu, i);
 
-		if (this_leaf->can_disable)
+		if (this_leaf->l3 && this_leaf->l3->can_disable)
 			ktype_cache.default_attrs = default_l3_attrs;
 		else
 			ktype_cache.default_attrs = default_attrs;
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
new file mode 100644
index 0000000..16f41bb
--- /dev/null
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -0,0 +1,55 @@
+/*
+ * HyperV  Detection code.
+ *
+ * Copyright (C) 2010, Novell, Inc.
+ * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <asm/processor.h>
+#include <asm/hypervisor.h>
+#include <asm/hyperv.h>
+#include <asm/mshyperv.h>
+
+struct ms_hyperv_info ms_hyperv;
+
+static bool __init ms_hyperv_platform(void)
+{
+	u32 eax;
+	u32 hyp_signature[3];
+
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
+	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
+
+	return eax >= HYPERV_CPUID_MIN &&
+		eax <= HYPERV_CPUID_MAX &&
+		!memcmp("Microsoft Hv", hyp_signature, 12);
+}
+
+static void __init ms_hyperv_init_platform(void)
+{
+	/*
+	 * Extract the features and hints
+	 */
+	ms_hyperv.features = cpuid_eax(HYPERV_CPUID_FEATURES);
+	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
+
+	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
+	       ms_hyperv.features, ms_hyperv.hints);
+}
+
+const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
+	.name			= "Microsoft HyperV",
+	.detect			= ms_hyperv_platform,
+	.init_platform		= ms_hyperv_init_platform,
+};
+EXPORT_SYMBOL(x86_hyper_ms_hyperv);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index dfdb4db..b9d1ff5 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -24,8 +24,8 @@
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <asm/div64.h>
-#include <asm/vmware.h>
 #include <asm/x86_init.h>
+#include <asm/hypervisor.h>
 
 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
@@ -65,7 +65,7 @@ static unsigned long vmware_get_tsc_khz(void)
 	return tsc_hz;
 }
 
-void __init vmware_platform_setup(void)
+static void __init vmware_platform_setup(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
@@ -83,26 +83,22 @@ void __init vmware_platform_setup(void)
  * serial key should be enough, as this will always have a VMware
  * specific string when running under VMware hypervisor.
  */
-int vmware_platform(void)
+static bool __init vmware_platform(void)
 {
 	if (cpu_has_hypervisor) {
-		unsigned int eax, ebx, ecx, edx;
-		char hyper_vendor_id[13];
-
-		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &ebx, &ecx, &edx);
-		memcpy(hyper_vendor_id + 0, &ebx, 4);
-		memcpy(hyper_vendor_id + 4, &ecx, 4);
-		memcpy(hyper_vendor_id + 8, &edx, 4);
-		hyper_vendor_id[12] = '\0';
-		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
-			return 1;
+		unsigned int eax;
+		unsigned int hyper_vendor_id[3];
+
+		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &hyper_vendor_id[0],
+		      &hyper_vendor_id[1], &hyper_vendor_id[2]);
+		if (!memcmp(hyper_vendor_id, "VMwareVMware", 12))
+			return true;
 	} else if (dmi_available && dmi_name_in_serial("VMware") &&
 		   __vmware_platform())
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
-EXPORT_SYMBOL(vmware_platform);
 
 /*
  * VMware hypervisor takes care of exporting a reliable TSC to the guest.
@@ -116,8 +112,16 @@ EXPORT_SYMBOL(vmware_platform);
  * so that the kernel could just trust the hypervisor with providing a
  * reliable virtual TSC that is suitable for timekeeping.
  */
-void __cpuinit vmware_set_feature_bits(struct cpuinfo_x86 *c)
+static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 }
+
+const __refconst struct hypervisor_x86 x86_hyper_vmware = {
+	.name			= "VMware",
+	.detect			= vmware_platform,
+	.set_cpu_features	= vmware_set_cpu_features,
+	.init_platform		= vmware_platform_setup,
+};
+EXPORT_SYMBOL(x86_hyper_vmware);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 75d293e..063b218 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -662,32 +662,20 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
-#define define_one_ro(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0444, show_##_name, NULL)
-
-#define define_one_ro0400(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0400, show_##_name, NULL)
-
-#define define_one_rw(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_ro0400(cpuinfo_cur_freq);
-define_one_ro(cpuinfo_min_freq);
-define_one_ro(cpuinfo_max_freq);
-define_one_ro(cpuinfo_transition_latency);
-define_one_ro(scaling_available_governors);
-define_one_ro(scaling_driver);
-define_one_ro(scaling_cur_freq);
-define_one_ro(bios_limit);
-define_one_ro(related_cpus);
-define_one_ro(affected_cpus);
-define_one_rw(scaling_min_freq);
-define_one_rw(scaling_max_freq);
-define_one_rw(scaling_governor);
-define_one_rw(scaling_setspeed);
+cpufreq_freq_attr_ro_perm(cpuinfo_cur_freq, 0400);
+cpufreq_freq_attr_ro(cpuinfo_min_freq);
+cpufreq_freq_attr_ro(cpuinfo_max_freq);
+cpufreq_freq_attr_ro(cpuinfo_transition_latency);
+cpufreq_freq_attr_ro(scaling_available_governors);
+cpufreq_freq_attr_ro(scaling_driver);
+cpufreq_freq_attr_ro(scaling_cur_freq);
+cpufreq_freq_attr_ro(bios_limit);
+cpufreq_freq_attr_ro(related_cpus);
+cpufreq_freq_attr_ro(affected_cpus);
+cpufreq_freq_attr_rw(scaling_min_freq);
+cpufreq_freq_attr_rw(scaling_max_freq);
+cpufreq_freq_attr_rw(scaling_governor);
+cpufreq_freq_attr_rw(scaling_setspeed);
 
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 3a14787..526bfbf 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -178,12 +178,8 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_conservative Governor Tunables */
 #define show_one(file_name, object)					\
@@ -221,12 +217,8 @@ show_one_old(freq_step);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+cpufreq_freq_attr_ro_old(sampling_rate_min);
+cpufreq_freq_attr_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -364,16 +356,12 @@ static ssize_t store_freq_step(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(sampling_down_factor);
-define_one_rw(up_threshold);
-define_one_rw(down_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(freq_step);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(sampling_down_factor);
+define_one_global_rw(up_threshold);
+define_one_global_rw(down_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(freq_step);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -409,16 +397,12 @@ write_one_old(down_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(freq_step);
 
-#define define_one_rw_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(sampling_down_factor_old, sampling_down_factor);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(down_threshold_old, down_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(freq_step_old, freq_step);
+cpufreq_freq_attr_rw_old(sampling_rate);
+cpufreq_freq_attr_rw_old(sampling_down_factor);
+cpufreq_freq_attr_rw_old(up_threshold);
+cpufreq_freq_attr_rw_old(down_threshold);
+cpufreq_freq_attr_rw_old(ignore_nice_load);
+cpufreq_freq_attr_rw_old(freq_step);
 
 static struct attribute *dbs_attributes_old[] = {
 	&sampling_rate_max_old.attr,
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index bd444dc..c00b25f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -234,12 +234,8 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_ondemand Governor Tunables */
 #define show_one(file_name, object)					\
@@ -274,12 +270,8 @@ show_one_old(powersave_bias);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+cpufreq_freq_attr_ro_old(sampling_rate_min);
+cpufreq_freq_attr_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -376,14 +368,10 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(up_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(powersave_bias);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(up_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -415,14 +403,10 @@ write_one_old(up_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(powersave_bias);
 
-#define define_one_rw_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(powersave_bias_old, powersave_bias);
+cpufreq_freq_attr_rw_old(sampling_rate);
+cpufreq_freq_attr_rw_old(up_threshold);
+cpufreq_freq_attr_rw_old(ignore_nice_load);
+cpufreq_freq_attr_rw_old(powersave_bias);
 
 static struct attribute *dbs_attributes_old[] = {
        &sampling_rate_max_old.attr,
diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index e7161c4..db9cd02 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -41,7 +41,7 @@
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <asm/vmware.h>
+#include <asm/hypervisor.h>
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
@@ -767,7 +767,7 @@ static int __init vmballoon_init(void)
 	 * Check if we are running on VMware's hypervisor and bail out
 	 * if we are not.
 	 */
-	if (!vmware_platform())
+	if (x86_hyper != &x86_hyper_vmware)
 		return -ENODEV;
 
 	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4de02b1..9f15150 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -278,6 +278,27 @@ struct freq_attr {
 	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
 };
 
+#define cpufreq_freq_attr_ro(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define cpufreq_freq_attr_ro_perm(_name, _perm)	\
+static struct freq_attr _name =			\
+__ATTR(_name, _perm, show_##_name, NULL)
+
+#define cpufreq_freq_attr_ro_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0444, show_##_name##_old, NULL)
+
+#define cpufreq_freq_attr_rw(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+#define cpufreq_freq_attr_rw_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
+
+
 struct global_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobj,
@@ -286,6 +307,15 @@ struct global_attr {
 			 const char *c, size_t count);
 };
 
+#define define_one_global_ro(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define define_one_global_rw(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+
 /*********************************************************************
  *                        CPUFREQ 2.6. INTERFACE                     *
  *********************************************************************/
