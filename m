Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402Ab0HEUkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:40:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:48069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630Ab0HEUiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:46 -0400
Date: Thu, 5 Aug 2010 20:38:01 GMT
Message-Id: <201008052038.o75Kc1eo022023@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/cpu for 2.6.26
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Dan Carpenter <error27@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

Borislav Petkov (2):
      x86, cacheinfo: Carve out L3 cache slot accessors
      x86, AMD: Extend support to future families

Dan Carpenter (1):
      x86, xsave: Cleanup return codes in check_for_xstate()

Fenghua Yu (1):
      x86, cpu: Package Level Thermal Control, Power Limit Notification definitions

H. Peter Anvin (6):
      x86, cpu: Add CPU flags for F16C and RDRND
      x86, cpu: Support the features flags in new CPUID leaf 7
      x86, cpu: Clean up formatting in cpufeature.h, remove override
      x86, cpu: Split addon_cpuid_features.c
      Merge remote branch 'linus/master' into x86/cpu
      x86, cpu: Export AMD errata definitions

Hans Rosenfeld (3):
      x86, cpu: AMD errata checking framework
      x86, cpu: Clean up AMD erratum 400 workaround
      x86, cpu: Use AMD errata checking framework for erratum 383

Michal Schmidt (1):
      x86: Fix keeping track of AMD C1E

Suresh Siddha (3):
      x86, cpu: Make init_scattered_cpuid_features() consider cpuid subleaves
      x86, cpu: Add xsaveopt cpufeature
      x86, cpu: Enumerate xsaveopt

Venkatesh Pallipadi (1):
      x86: Look for IA32_ENERGY_PERF_BIAS support

 arch/x86/include/asm/acpi.h                        |    2 +-
 arch/x86/include/asm/cpufeature.h                  |   29 ++++--
 arch/x86/include/asm/msr-index.h                   |   19 +++-
 arch/x86/include/asm/processor.h                   |   21 ++++
 arch/x86/include/asm/required-features.h           |    2 +
 arch/x86/kernel/cpu/Makefile                       |    2 +-
 arch/x86/kernel/cpu/amd.c                          |   77 +++++++++++++-
 arch/x86/kernel/cpu/common.c                       |   10 ++
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  108 +++++++++++++++-----
 arch/x86/kernel/cpu/scattered.c                    |   63 ++++++++++++
 .../cpu/{addon_cpuid_features.c => topology.c}     |   58 +----------
 arch/x86/kernel/process.c                          |   45 +-------
 arch/x86/kernel/xsave.c                            |   13 ++-
 arch/x86/kvm/svm.c                                 |    3 +-
 drivers/acpi/processor_idle.c                      |    2 +-
 15 files changed, 311 insertions(+), 143 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/scattered.c
 rename arch/x86/kernel/cpu/{addon_cpuid_features.c => topology.c} (66%)

Auto-merging arch/x86/include/asm/msr-index.h
Auto-merging arch/x86/kernel/process.c
Auto-merging arch/x86/kvm/svm.c
Merge made by recursive.
 arch/x86/include/asm/acpi.h                        |    2 +-
 arch/x86/include/asm/cpufeature.h                  |   29 ++++--
 arch/x86/include/asm/msr-index.h                   |   19 +++-
 arch/x86/include/asm/processor.h                   |   21 ++++
 arch/x86/include/asm/required-features.h           |    2 +
 arch/x86/kernel/cpu/Makefile                       |    2 +-
 arch/x86/kernel/cpu/amd.c                          |   77 +++++++++++++-
 arch/x86/kernel/cpu/common.c                       |   10 ++
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  108 +++++++++++++++-----
 arch/x86/kernel/cpu/scattered.c                    |   63 ++++++++++++
 .../cpu/{addon_cpuid_features.c => topology.c}     |   58 +----------
 arch/x86/kernel/process.c                          |   45 +-------
 arch/x86/kernel/xsave.c                            |   13 ++-
 arch/x86/kvm/svm.c                                 |    3 +-
 drivers/acpi/processor_idle.c                      |    2 +-
 15 files changed, 311 insertions(+), 143 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/scattered.c
 rename arch/x86/kernel/cpu/{addon_cpuid_features.c => topology.c} (66%)
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index aa2c39d..92091de 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -134,7 +134,7 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
-	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	else if (c1e_detected)
 		return 1;
 	else
 		return max_cstate;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..0b205b8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+					  /* 21 available, was AMD_C1E */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
@@ -124,6 +124,8 @@
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
+#define X86_FEATURE_RDRND	(4*32+30) /* The RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
@@ -157,22 +159,29 @@
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
- * CPUID levels like 0x6, 0xA etc
+ * CPUID levels like 0x6, 0xA etc, word 7
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
+#define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
+#define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
 
-/* Virtualization flags: Linux defined */
+/* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
 #define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
-#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
-#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
-#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
-#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_NPT		(8*32+ 5) /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
+
+/* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
+#define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
@@ -194,7 +203,9 @@ extern const char * const x86_power_flags[32];
 	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
 	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
-	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
+	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
 	  ? 1 :								\
 	 test_cpu_cap(c, bit))
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 509a421..2eeb2e6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -226,12 +226,14 @@
 #define MSR_IA32_THERM_CONTROL		0x0000019a
 #define MSR_IA32_THERM_INTERRUPT	0x0000019b
 
-#define THERM_INT_LOW_ENABLE		(1 << 0)
-#define THERM_INT_HIGH_ENABLE		(1 << 1)
+#define THERM_INT_HIGH_ENABLE		(1 << 0)
+#define THERM_INT_LOW_ENABLE		(1 << 1)
+#define THERM_INT_PLN_ENABLE		(1 << 24)
 
 #define MSR_IA32_THERM_STATUS		0x0000019c
 
 #define THERM_STATUS_PROCHOT		(1 << 0)
+#define THERM_STATUS_POWER_LIMIT	(1 << 10)
 
 #define MSR_THERM2_CTL			0x0000019d
 
@@ -241,6 +243,19 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+
+#define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
+
+#define PACKAGE_THERM_STATUS_PROCHOT		(1 << 0)
+#define PACKAGE_THERM_STATUS_POWER_LIMIT	(1 << 10)
+
+#define MSR_IA32_PACKAGE_THERM_INTERRUPT	0x000001b2
+
+#define PACKAGE_THERM_INT_HIGH_ENABLE		(1 << 0)
+#define PACKAGE_THERM_INT_LOW_ENABLE		(1 << 1)
+#define PACKAGE_THERM_INT_PLN_ENABLE		(1 << 24)
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..325b7bd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -762,6 +762,7 @@ extern void init_c1e_mask(void);
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
+extern bool			c1e_detected;
 
 /*
  * on systems with caches, caches must be flashed as the absolute
@@ -1025,4 +1026,24 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+/*
+ * AMD errata checking
+ */
+#ifdef CONFIG_CPU_SUP_AMD
+extern const int amd_erratum_383[];
+extern const int amd_erratum_400[];
+extern bool cpu_has_amd_erratum(const int *);
+
+#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+#else
+#define cpu_has_amd_erratum(x)	(false)
+#endif /* CONFIG_CPU_SUP_AMD */
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 64cf2d2..6c7fc25 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -84,5 +84,7 @@
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
+#define REQUIRED_MASK8	0
+#define REQUIRED_MASK9	0
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3a785da..5e3a351 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -12,7 +12,7 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
 
-obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
+obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
deleted file mode 100644
index 10fa568..0000000
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- *	Routines to indentify additional cpu features that are scattered in
- *	cpuid space.
- */
-#include <linux/cpu.h>
-
-#include <asm/pat.h>
-#include <asm/processor.h>
-
-#include <asm/apic.h>
-
-struct cpuid_bit {
-	u16 feature;
-	u8 reg;
-	u8 bit;
-	u32 level;
-};
-
-enum cpuid_regs {
-	CR_EAX = 0,
-	CR_ECX,
-	CR_EDX,
-	CR_EBX
-};
-
-void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
-{
-	u32 max_level;
-	u32 regs[4];
-	const struct cpuid_bit *cb;
-
-	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
-		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
-		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
-		{ 0, 0, 0, 0 }
-	};
-
-	for (cb = cpuid_bits; cb->feature; cb++) {
-
-		/* Verify that the level is valid */
-		max_level = cpuid_eax(cb->level & 0xffff0000);
-		if (max_level < cb->level ||
-		    max_level > (cb->level | 0xffff))
-			continue;
-
-		cpuid(cb->level, &regs[CR_EAX], &regs[CR_EBX],
-			&regs[CR_ECX], &regs[CR_EDX]);
-
-		if (regs[cb->reg] & (1 << cb->bit))
-			set_cpu_cap(c, cb->feature);
-	}
-}
-
-/* leaf 0xb SMT level */
-#define SMT_LEVEL	0
-
-/* leaf 0xb sub-leaf types */
-#define INVALID_TYPE	0
-#define SMT_TYPE	1
-#define CORE_TYPE	2
-
-#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
-#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
-#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
-
-/*
- * Check for extended topology enumeration cpuid leaf 0xb and if it
- * exists, use it for populating initial_apicid and cpu topology
- * detection.
- */
-void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned int eax, ebx, ecx, edx, sub_index;
-	unsigned int ht_mask_width, core_plus_mask_width;
-	unsigned int core_select_mask, core_level_siblings;
-	static bool printed;
-
-	if (c->cpuid_level < 0xb)
-		return;
-
-	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
-
-	/*
-	 * check if the cpuid leaf 0xb is actually implemented.
-	 */
-	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
-		return;
-
-	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
-
-	/*
-	 * initial apic id, which also represents 32-bit extended x2apic id.
-	 */
-	c->initial_apicid = edx;
-
-	/*
-	 * Populate HT related information from sub-leaf level 0.
-	 */
-	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
-	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
-
-	sub_index = 1;
-	do {
-		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
-
-		/*
-		 * Check for the Core type in the implemented sub leaves.
-		 */
-		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
-			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
-			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
-			break;
-		}
-
-		sub_index++;
-	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
-
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
-
-	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
-						 & core_select_mask;
-	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
-	/*
-	 * Reinit the apicid, now that we have extended initial_apicid.
-	 */
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
-
-	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
-
-	if (!printed) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-		printed = 1;
-	}
-	return;
-#endif
-}
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..60a57b1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -466,7 +466,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 
 	}
-	if (c->x86 == 0x10 || c->x86 == 0x11)
+	if (c->x86 >= 0x10)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 	/* get apicid instead of initial apic id from cpuid */
@@ -529,7 +529,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			num_cache_leaves = 3;
 	}
 
-	if (c->x86 >= 0xf && c->x86 <= 0x11)
+	if (c->x86 >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
 	if (cpu_has_xmm2) {
@@ -546,7 +546,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		fam10h_check_enable_mmcfg();
 	}
 
-	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+	if (c == &boot_cpu_data && c->x86 >= 0xf) {
 		unsigned long long tseg;
 
 		/*
@@ -609,3 +609,74 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 };
 
 cpu_dev_register(amd_cpu_dev);
+
+/*
+ * AMD errata checking
+ *
+ * Errata are defined as arrays of ints using the AMD_LEGACY_ERRATUM() or
+ * AMD_OSVW_ERRATUM() macros. The latter is intended for newer errata that
+ * have an OSVW id assigned, which it takes as first argument. Both take a
+ * variable number of family-specific model-stepping ranges created by
+ * AMD_MODEL_RANGE(). Each erratum also has to be declared as extern const
+ * int[] in arch/x86/include/asm/processor.h.
+ *
+ * Example:
+ *
+ * const int amd_erratum_319[] =
+ *	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0x4, 0x2),
+ *			   AMD_MODEL_RANGE(0x10, 0x8, 0x0, 0x8, 0x0),
+ *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
+ */
+
+const int amd_erratum_400[] =
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
+EXPORT_SYMBOL_GPL(amd_erratum_400);
+
+const int amd_erratum_383[] =
+	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
+EXPORT_SYMBOL_GPL(amd_erratum_383);
+
+bool cpu_has_amd_erratum(const int *erratum)
+{
+	struct cpuinfo_x86 *cpu = &current_cpu_data;
+	int osvw_id = *erratum++;
+	u32 range;
+	u32 ms;
+
+	/*
+	 * If called early enough that current_cpu_data hasn't been initialized
+	 * yet, fall back to boot_cpu_data.
+	 */
+	if (cpu->x86 == 0)
+		cpu = &boot_cpu_data;
+
+	if (cpu->x86_vendor != X86_VENDOR_AMD)
+		return false;
+
+	if (osvw_id >= 0 && osvw_id < 65536 &&
+	    cpu_has(cpu, X86_FEATURE_OSVW)) {
+		u64 osvw_len;
+
+		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, osvw_len);
+		if (osvw_id < osvw_len) {
+			u64 osvw_bits;
+
+			rdmsrl(MSR_AMD64_OSVW_STATUS + (osvw_id >> 6),
+			    osvw_bits);
+			return osvw_bits & (1ULL << (osvw_id & 0x3f));
+		}
+	}
+
+	/* OSVW unavailable or ID unknown, match family-model-stepping range */
+	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	while ((range = *erratum++))
+		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
+		    (ms >= AMD_MODEL_RANGE_START(range)) &&
+		    (ms <= AMD_MODEL_RANGE_END(range)))
+			return true;
+
+	return false;
+}
+
+EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 68e4a6f..c735830 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -551,6 +551,16 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[4] = excap;
 	}
 
+	/* Additional Intel-defined flags: level 0x00000007 */
+	if (c->cpuid_level >= 0x00000007) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
+
+		if (eax > 0)
+			c->x86_capability[9] = ebx;
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 33eae20..898c2f4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -347,8 +347,8 @@ static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
 	return l3;
 }
 
-static void __cpuinit
-amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
+					   int index)
 {
 	int node;
 
@@ -396,20 +396,39 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	this_leaf->l3 = l3_caches[node];
 }
 
+/*
+ * check whether a slot used for disabling an L3 index is occupied.
+ * @l3: L3 cache descriptor
+ * @slot: slot number (0..1)
+ *
+ * @returns: the disabled index if used or negative value if slot free.
+ */
+int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
+{
+	unsigned int reg = 0;
+
+	pci_read_config_dword(l3->dev, 0x1BC + slot * 4, &reg);
+
+	/* check whether this slot is activated already */
+	if (reg & (3UL << 30))
+		return reg & 0xfff;
+
+	return -1;
+}
+
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
-	unsigned int reg = 0;
+	int index;
 
 	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
-	if (!dev)
-		return -EINVAL;
+	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
+	if (index >= 0)
+		return sprintf(buf, "%d\n", index);
 
-	pci_read_config_dword(dev, 0x1BC + slot * 4, &reg);
-	return sprintf(buf, "0x%08x\n", reg);
+	return sprintf(buf, "FREE\n");
 }
 
 #define SHOW_CACHE_DISABLE(slot)					\
@@ -451,37 +470,74 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 	}
 }
 
-
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-				   const char *buf, size_t count,
-				   unsigned int slot)
+/*
+ * disable a L3 cache index by using a disable-slot
+ *
+ * @l3:    L3 cache descriptor
+ * @cpu:   A CPU on the node containing the L3 cache
+ * @slot:  slot number (0..1)
+ * @index: index to disable
+ *
+ * @return: 0 on success, error status on failure
+ */
+int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
+			    unsigned long index)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	unsigned long val = 0;
+	int ret = 0;
 
 #define SUBCACHE_MASK	(3UL << 20)
 #define SUBCACHE_INDEX	0xfff
 
-	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
+	/*
+	 * check whether this slot is already used or
+	 * the index is already disabled
+	 */
+	ret = amd_get_l3_disable_slot(l3, slot);
+	if (ret >= 0)
 		return -EINVAL;
 
+	/*
+	 * check whether the other slot has disabled the
+	 * same index already
+	 */
+	if (index == amd_get_l3_disable_slot(l3, !slot))
+		return -EINVAL;
+
+	/* do not allow writes outside of allowed bits */
+	if ((index & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((index & SUBCACHE_INDEX) > l3->indices))
+		return -EINVAL;
+
+	amd_l3_disable_index(l3, cpu, slot, index);
+
+	return 0;
+}
+
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+				  const char *buf, size_t count,
+				  unsigned int slot)
+{
+	unsigned long val = 0;
+	int cpu, err = 0;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!dev)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	/* do not allow writes outside of allowed bits */
-	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3->indices))
+	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	amd_l3_disable_index(this_leaf->l3, cpu, slot, val);
-
+	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
+	if (err) {
+		if (err == -EEXIST)
+			printk(KERN_WARNING "L3 disable slot %d in use!\n",
+					    slot);
+		return err;
+	}
 	return count;
 }
 
@@ -502,7 +558,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 
 #else	/* CONFIG_CPU_SUP_AMD */
 static void __cpuinit
-amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
 #endif /* CONFIG_CPU_SUP_AMD */
@@ -518,7 +574,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-		amd_check_l3_disable(index, this_leaf);
+		amd_check_l3_disable(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
new file mode 100644
index 0000000..34b4dad
--- /dev/null
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -0,0 +1,63 @@
+/*
+ *	Routines to indentify additional cpu features that are scattered in
+ *	cpuid space.
+ */
+#include <linux/cpu.h>
+
+#include <asm/pat.h>
+#include <asm/processor.h>
+
+#include <asm/apic.h>
+
+struct cpuid_bit {
+	u16 feature;
+	u8 reg;
+	u8 bit;
+	u32 level;
+	u32 sub_leaf;
+};
+
+enum cpuid_regs {
+	CR_EAX = 0,
+	CR_ECX,
+	CR_EDX,
+	CR_EBX
+};
+
+void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
+{
+	u32 max_level;
+	u32 regs[4];
+	const struct cpuid_bit *cb;
+
+	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
+		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
+		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
+		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
+		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
+		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
+		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
+		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ 0, 0, 0, 0, 0 }
+	};
+
+	for (cb = cpuid_bits; cb->feature; cb++) {
+
+		/* Verify that the level is valid */
+		max_level = cpuid_eax(cb->level & 0xffff0000);
+		if (max_level < cb->level ||
+		    max_level > (cb->level | 0xffff))
+			continue;
+
+		cpuid_count(cb->level, cb->sub_leaf, &regs[CR_EAX],
+			    &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
+
+		if (regs[cb->reg] & (1 << cb->bit))
+			set_cpu_cap(c, cb->feature);
+	}
+}
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
new file mode 100644
index 0000000..4397e98
--- /dev/null
+++ b/arch/x86/kernel/cpu/topology.c
@@ -0,0 +1,99 @@
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+
+#include <linux/cpu.h>
+#include <asm/apic.h>
+#include <asm/pat.h>
+#include <asm/processor.h>
+
+/* leaf 0xb SMT level */
+#define SMT_LEVEL	0
+
+/* leaf 0xb sub-leaf types */
+#define INVALID_TYPE	0
+#define SMT_TYPE	1
+#define CORE_TYPE	2
+
+#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
+#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
+#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
+
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned int eax, ebx, ecx, edx, sub_index;
+	unsigned int ht_mask_width, core_plus_mask_width;
+	unsigned int core_select_mask, core_level_siblings;
+	static bool printed;
+
+	if (c->cpuid_level < 0xb)
+		return;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	c->initial_apicid = edx;
+
+	/*
+	 * Populate HT related information from sub-leaf level 0.
+	 */
+	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+
+	sub_index = 1;
+	do {
+		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * Check for the Core type in the implemented sub leaves.
+		 */
+		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
+			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
+			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+			break;
+		}
+
+		sub_index++;
+	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+
+	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+
+	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
+						 & core_select_mask;
+	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+	/*
+	 * Reinit the apicid, now that we have extended initial_apicid.
+	 */
+	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+
+	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
+
+	if (!printed) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		if (c->x86_max_cores > 1)
+			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+			       c->cpu_core_id);
+		printed = 1;
+	}
+	return;
+#endif
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cbcf013..d401f1d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -526,44 +526,10 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 	return (edx & MWAIT_EDX_C1);
 }
 
-/*
- * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
- * For more information see
- * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
- * - Erratum #365 for family 0x11 (not affected because C1e not in use)
- */
-static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
-{
-	u64 val;
-	if (c->x86_vendor != X86_VENDOR_AMD)
-		goto no_c1e_idle;
-
-	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0F && c->x86_model >= 0x40)
-		return 1;
-
-	if (c->x86 == 0x10) {
-		/*
-		 * check OSVW bit for CPUs that are not affected
-		 * by erratum #400
-		 */
-		if (cpu_has(c, X86_FEATURE_OSVW)) {
-			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-			if (val >= 2) {
-				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-				if (!(val & BIT(1)))
-					goto no_c1e_idle;
-			}
-		}
-		return 1;
-	}
-
-no_c1e_idle:
-	return 0;
-}
+bool c1e_detected;
+EXPORT_SYMBOL(c1e_detected);
 
 static cpumask_var_t c1e_mask;
-static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
@@ -585,12 +551,12 @@ static void c1e_idle(void)
 		u32 lo, hi;
 
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-			c1e_detected = 1;
+			c1e_detected = true;
 			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 				mark_tsc_unstable("TSC halt in AMD C1E");
 			printk(KERN_INFO "System has AMD C1E enabled\n");
-			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
 		}
 	}
 
@@ -639,7 +605,8 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (check_c1e_idle(c)) {
+	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 37e68fc..9801498 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -36,15 +36,14 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 
 	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
 			       sizeof(struct _fpx_sw_bytes));
-
 	if (err)
-		return err;
+		return -EFAULT;
 
 	/*
 	 * First Magic check failed.
 	 */
 	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
-		return -1;
+		return -EINVAL;
 
 	/*
 	 * Check for error scenarios.
@@ -52,19 +51,21 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	if (fx_sw_user->xstate_size < min_xstate_size ||
 	    fx_sw_user->xstate_size > xstate_size ||
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
-		return -1;
+		return -EINVAL;
 
 	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
 					    fx_sw_user->extended_size -
 					    FP_XSTATE_MAGIC2_SIZE));
+	if (err)
+		return err;
 	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
 	 * fpstate layout with out copying the extended state information
 	 * in the memory layout.
 	 */
-	if (err || magic2 != FP_XSTATE_MAGIC2)
-		return -1;
+	if (magic2 != FP_XSTATE_MAGIC2)
+		return -EFAULT;
 
 	return 0;
 }
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..5c81daf 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -384,8 +384,7 @@ static void svm_init_erratum_383(void)
 	int err;
 	u64 val;
 
-	/* Only Fam10h is affected */
-	if (boot_cpu_data.x86 != 0x10)
+	if (!cpu_has_amd_erratum(amd_erratum_383))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e9a8026..eead3f5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -164,7 +164,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	if (c1e_detected)
 		type = ACPI_STATE_C1;
 
 	/*
