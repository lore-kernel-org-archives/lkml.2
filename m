Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2JLIUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:20:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33161 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2JLITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:19:54 -0400
Date: Fri, 12 Oct 2012 10:19:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates/fixes
Message-ID: <20121012081947.GA20570@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 95cf59ea72331d0093010543b8951bb43f262cac perf: Fix perf_cgroup_switch for sw-events

This tree includes some late late perf items that missed the 
first round:

tools:

     * Bash auto completion improvements, now we can auto complete the tools long
       options, tracepoint event names, etc, from Namhyung Kim.

     * Look up thread using tid instead of pid in 'perf sched'.
    
     * Move global variables into a perf_kvm struct, from David Ahern.
    
     * Hists refactorings, preparatory for improved 'diff' command, from Jiri Olsa.
    
     * Hists refactorings, preparatory for event group viewieng work, from Namhyung Kim.
    
     * Remove double negation on optional feature macro definitions, from Namhyung Kim.
    
     * Remove several cases of needless global variables, on most builtins.
    
     * misc fixes

kernel:

     * sysfs support for IBS on AMD CPUs, from Robert Richter.

     * Support for an upcoming Intel CPU, the Xeon-Phi / Knights 
       Corner HPC blade PMU, from Vince Weaver.

     * misc fixes

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (19):
      perf trace: Use evsel->handler.func
      perf inject: Remove unused 'input_name' static var
      perf inject: Remove static variables
      perf sched: Look up thread using tid instead of pid
      perf stat: Don't use globals where not needed to
      perf script: Don't use globals where not needed to
      perf help: Don't use globals where not needed to
      perf kmem: Don't use globals where not needed to
      perf lock: Don't use globals where not needed to
      perf timechart: Don't use globals where not needed to
      perf buildid-cache: Don't use globals where not needed to
      perf buildid-list: Don't use globals where not needed to
      perf probe: Don't use globals where not needed to
      perf top: Don't use globals where not needed to
      perf evlist: Don't use globals where not needed to
      perf record: Don't use globals where not needed to
      perf inject: Don't use globals where not needed to
      perf evlist: Introduce add_newtp method
      perf evlist: Remove some unused methods

David Ahern (1):
      perf kvm: Move global variables into a perf_kvm struct

Jiri Olsa (6):
      perf hists: Add struct hists pointer to struct hist_entry
      perf diff: Refactor diff displacement possition info
      perf hists: Separate overhead and baseline columns
      perf tools: Removing hists pair argument from output path
      perf tool: Add hpp interface to enable/disable hpp column
      perf diff: Removing the total_period argument from output code

Namhyung Kim (16):
      perf tools: Move libdw availability check before arch Makefile
      perf tools: Remove unused PYRF_OBJS variable on Makefile
      perf tools: Convert to LIBELF_SUPPORT
      perf tools: Convert to LIBUNWIND_SUPPORT
      perf tools: Convert to LIBAUDIT_SUPPORT
      perf tools: Convert to NEWT_SUPPORT
      perf tools: Convert to GTK2_SUPPORT
      perf tools: Convert to HAVE_STRLCPY
      perf tools: Check existence of _get_comp_words_by_ref when bash completing
      perf tools: Complete long option names of perf command
      perf tools: Long option completion support for each subcommands
      perf tools: Convert to BACKTRACE_SUPPORT
      perf tools: Complete tracepoint event names
      perf hists: Introduce struct he_stat
      perf hists: Move he->stat.nr_events initialization to a template
      perf hists: Add more helpers for hist entry stat

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::unique_pmu
      perf: Fix perf_cgroup_switch for sw-events

Robert Richter (1):
      perf/AMD/IBS: Add sysfs support

Vince Weaver (1):
      perf/x86: Add support for Intel Xeon-Phi Knights Corner PMU


 arch/x86/include/asm/msr-index.h         |   5 +
 arch/x86/kernel/cpu/Makefile             |   2 +-
 arch/x86/kernel/cpu/perf_event.h         |   2 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  61 +++-
 arch/x86/kernel/cpu/perf_event_intel.c   |   2 +
 arch/x86/kernel/cpu/perf_event_knc.c     | 248 +++++++++++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c   |   4 +
 include/linux/perf_event.h               |   2 +-
 kernel/events/core.c                     |  21 +-
 tools/perf/Makefile                      |  83 ++----
 tools/perf/bash_completion               |  50 +++-
 tools/perf/builtin-buildid-cache.c       |  58 ++--
 tools/perf/builtin-buildid-list.c        |  55 ++--
 tools/perf/builtin-diff.c                |  68 +++--
 tools/perf/builtin-evlist.c              |  21 +-
 tools/perf/builtin-help.c                |  40 +--
 tools/perf/builtin-inject.c              |  88 +++---
 tools/perf/builtin-kmem.c                |  66 ++---
 tools/perf/builtin-kvm.c                 | 460 +++++++++++++++++--------------
 tools/perf/builtin-lock.c                |  90 +++---
 tools/perf/builtin-probe.c               |  26 +-
 tools/perf/builtin-record.c              |  27 +-
 tools/perf/builtin-report.c              |   4 +-
 tools/perf/builtin-sched.c               |   2 +-
 tools/perf/builtin-script.c              |  90 +++---
 tools/perf/builtin-stat.c                | 328 +++++++++++-----------
 tools/perf/builtin-timechart.c           | 100 +++----
 tools/perf/builtin-top.c                 |  11 +-
 tools/perf/builtin-trace.c               | 134 +++++----
 tools/perf/perf.c                        |   4 +-
 tools/perf/ui/browsers/hists.c           |  12 +-
 tools/perf/ui/gtk/browser.c              |   6 +-
 tools/perf/ui/gtk/util.c                 |   2 +-
 tools/perf/ui/helpline.h                 |  18 +-
 tools/perf/ui/hist.c                     | 145 ++++++----
 tools/perf/ui/setup.c                    |   2 +-
 tools/perf/ui/stdio/hist.c               |  45 ++-
 tools/perf/util/annotate.h               |   8 +-
 tools/perf/util/cache.h                  |  38 +--
 tools/perf/util/debug.c                  |   2 +-
 tools/perf/util/debug.h                  |  17 +-
 tools/perf/util/evlist.c                 |  88 +-----
 tools/perf/util/evlist.h                 |  18 +-
 tools/perf/util/generate-cmdlist.sh      |   4 +-
 tools/perf/util/hist.c                   |  66 +++--
 tools/perf/util/hist.h                   |  38 ++-
 tools/perf/util/map.c                    |   2 +-
 tools/perf/util/parse-options.c          |   8 +
 tools/perf/util/parse-options.h          |   1 +
 tools/perf/util/path.c                   |   2 +-
 tools/perf/util/perf_regs.h              |   4 +-
 tools/perf/util/sort.h                   |  19 +-
 tools/perf/util/symbol.h                 |  10 +-
 tools/perf/util/unwind.h                 |   4 +-
 tools/perf/util/util.c                   |   4 +-
 55 files changed, 1517 insertions(+), 1198 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_knc.c

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 957ec87..07f96cb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,6 +121,11 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
+#define MSR_KNC_PERFCTR0               0x00000020
+#define MSR_KNC_PERFCTR1               0x00000021
+#define MSR_KNC_EVNTSEL0               0x00000028
+#define MSR_KNC_EVNTSEL1               0x00000029
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index d30a6a9..a0e067d 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
 endif
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8b6defe..271d257 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -626,6 +626,8 @@ int p4_pmu_init(void);
 
 int p6_pmu_init(void);
 
+int knc_pmu_init(void);
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index eebd5ff..6336bcb 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -41,17 +41,22 @@ struct cpu_perf_ibs {
 };
 
 struct perf_ibs {
-	struct pmu	pmu;
-	unsigned int	msr;
-	u64		config_mask;
-	u64		cnt_mask;
-	u64		enable_mask;
-	u64		valid_mask;
-	u64		max_period;
-	unsigned long	offset_mask[1];
-	int		offset_max;
-	struct cpu_perf_ibs __percpu *pcpu;
-	u64		(*get_count)(u64 config);
+	struct pmu			pmu;
+	unsigned int			msr;
+	u64				config_mask;
+	u64				cnt_mask;
+	u64				enable_mask;
+	u64				valid_mask;
+	u64				max_period;
+	unsigned long			offset_mask[1];
+	int				offset_max;
+	struct cpu_perf_ibs __percpu	*pcpu;
+
+	struct attribute		**format_attrs;
+	struct attribute_group		format_group;
+	const struct attribute_group	*attr_groups[2];
+
+	u64				(*get_count)(u64 config);
 };
 
 struct perf_ibs_data {
@@ -446,6 +451,19 @@ static void perf_ibs_del(struct perf_event *event, int flags)
 
 static void perf_ibs_read(struct perf_event *event) { }
 
+PMU_FORMAT_ATTR(rand_en,	"config:57");
+PMU_FORMAT_ATTR(cnt_ctl,	"config:19");
+
+static struct attribute *ibs_fetch_format_attrs[] = {
+	&format_attr_rand_en.attr,
+	NULL,
+};
+
+static struct attribute *ibs_op_format_attrs[] = {
+	NULL,	/* &format_attr_cnt_ctl.attr if IBS_CAPS_OPCNT */
+	NULL,
+};
+
 static struct perf_ibs perf_ibs_fetch = {
 	.pmu = {
 		.task_ctx_nr	= perf_invalid_context,
@@ -465,6 +483,7 @@ static struct perf_ibs perf_ibs_fetch = {
 	.max_period		= IBS_FETCH_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSFETCH_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSFETCH_REG_COUNT,
+	.format_attrs		= ibs_fetch_format_attrs,
 
 	.get_count		= get_ibs_fetch_count,
 };
@@ -488,6 +507,7 @@ static struct perf_ibs perf_ibs_op = {
 	.max_period		= IBS_OP_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSOP_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSOP_REG_COUNT,
+	.format_attrs		= ibs_op_format_attrs,
 
 	.get_count		= get_ibs_op_count,
 };
@@ -597,6 +617,17 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
 	perf_ibs->pcpu = pcpu;
 
+	/* register attributes */
+	if (perf_ibs->format_attrs[0]) {
+		memset(&perf_ibs->format_group, 0, sizeof(perf_ibs->format_group));
+		perf_ibs->format_group.name	= "format";
+		perf_ibs->format_group.attrs	= perf_ibs->format_attrs;
+
+		memset(&perf_ibs->attr_groups, 0, sizeof(perf_ibs->attr_groups));
+		perf_ibs->attr_groups[0]	= &perf_ibs->format_group;
+		perf_ibs->pmu.attr_groups	= perf_ibs->attr_groups;
+	}
+
 	ret = perf_pmu_register(&perf_ibs->pmu, name, -1);
 	if (ret) {
 		perf_ibs->pcpu = NULL;
@@ -608,13 +639,19 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
 static __init int perf_event_ibs_init(void)
 {
+	struct attribute **attr = ibs_op_format_attrs;
+
 	if (!ibs_caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
-	if (ibs_caps & IBS_CAPS_OPCNT)
+
+	if (ibs_caps & IBS_CAPS_OPCNT) {
 		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
+		*attr++ = &format_attr_cnt_ctl.attr;
+	}
 	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
+
 	register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6bca492..324bb52 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1906,6 +1906,8 @@ __init int intel_pmu_init(void)
 		switch (boot_cpu_data.x86) {
 		case 0x6:
 			return p6_pmu_init();
+		case 0xb:
+			return knc_pmu_init();
 		case 0xf:
 			return p4_pmu_init();
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
new file mode 100644
index 0000000..7c46bfd
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -0,0 +1,248 @@
+/* Driver for Intel Xeon Phi "Knights Corner" PMU */
+
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "perf_event.h"
+
+static const u64 knc_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x002a,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x0016,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0028,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0029,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x0012,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
+};
+
+static __initconst u64 knc_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		/* On Xeon Phi event "0" is a valid DATA_READ          */
+		/*   (L1 Data Cache Reads) Instruction.                */
+		/* We code this as ARCH_PERFMON_EVENTSEL_INT as this   */
+		/* bit will always be set in x86_pmu_hw_config().      */
+		[ C(RESULT_ACCESS) ] = ARCH_PERFMON_EVENTSEL_INT,
+						/* DATA_READ           */
+		[ C(RESULT_MISS)   ] = 0x0003,	/* DATA_READ_MISS      */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0001,	/* DATA_WRITE          */
+		[ C(RESULT_MISS)   ] = 0x0004,	/* DATA_WRITE_MISS     */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0011,	/* L1_DATA_PF1         */
+		[ C(RESULT_MISS)   ] = 0x001c,	/* L1_DATA_PF1_MISS    */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x000c,	/* CODE_READ          */
+		[ C(RESULT_MISS)   ] = 0x000e,	/* CODE_CACHE_MISS    */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x10cb,	/* L2_READ_MISS */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x10cc,	/* L2_WRITE_HIT */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x10fc,	/* L2_DATA_PF2      */
+		[ C(RESULT_MISS)   ] = 0x10fe,	/* L2_DATA_PF2_MISS */
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = ARCH_PERFMON_EVENTSEL_INT,
+						/* DATA_READ */
+						/* see note on L1 OP_READ */
+		[ C(RESULT_MISS)   ] = 0x0002,	/* DATA_PAGE_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0001,	/* DATA_WRITE */
+		[ C(RESULT_MISS)   ] = 0x0002,	/* DATA_PAGE_WALK */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x000c,	/* CODE_READ */
+		[ C(RESULT_MISS)   ] = 0x000d,	/* CODE_PAGE_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0012,	/* BRANCHES */
+		[ C(RESULT_MISS)   ] = 0x002b,	/* BRANCHES_MISPREDICTED */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
+
+static u64 knc_pmu_event_map(int hw_event)
+{
+	return knc_perfmon_event_map[hw_event];
+}
+
+static struct event_constraint knc_event_constraints[] =
+{
+	INTEL_EVENT_CONSTRAINT(0xc3, 0x1),	/* HWP_L2HIT */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0x1),	/* HWP_L2MISS */
+	INTEL_EVENT_CONSTRAINT(0xc8, 0x1),	/* L2_READ_HIT_E */
+	INTEL_EVENT_CONSTRAINT(0xc9, 0x1),	/* L2_READ_HIT_M */
+	INTEL_EVENT_CONSTRAINT(0xca, 0x1),	/* L2_READ_HIT_S */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),	/* L2_READ_MISS */
+	INTEL_EVENT_CONSTRAINT(0xcc, 0x1),	/* L2_WRITE_HIT */
+	INTEL_EVENT_CONSTRAINT(0xce, 0x1),	/* L2_STRONGLY_ORDERED_STREAMING_VSTORES_MISS */
+	INTEL_EVENT_CONSTRAINT(0xcf, 0x1),	/* L2_WEAKLY_ORDERED_STREAMING_VSTORE_MISS */
+	INTEL_EVENT_CONSTRAINT(0xd7, 0x1),	/* L2_VICTIM_REQ_WITH_DATA */
+	INTEL_EVENT_CONSTRAINT(0xe3, 0x1),	/* SNP_HITM_BUNIT */
+	INTEL_EVENT_CONSTRAINT(0xe6, 0x1),	/* SNP_HIT_L2 */
+	INTEL_EVENT_CONSTRAINT(0xe7, 0x1),	/* SNP_HITM_L2 */
+	INTEL_EVENT_CONSTRAINT(0xf1, 0x1),	/* L2_DATA_READ_MISS_CACHE_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf2, 0x1),	/* L2_DATA_WRITE_MISS_CACHE_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf6, 0x1),	/* L2_DATA_READ_MISS_MEM_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0x1),	/* L2_DATA_WRITE_MISS_MEM_FILL */
+	INTEL_EVENT_CONSTRAINT(0xfc, 0x1),	/* L2_DATA_PF2 */
+	INTEL_EVENT_CONSTRAINT(0xfd, 0x1),	/* L2_DATA_PF2_DROP */
+	INTEL_EVENT_CONSTRAINT(0xfe, 0x1),	/* L2_DATA_PF2_MISS */
+	INTEL_EVENT_CONSTRAINT(0xff, 0x1),	/* L2_DATA_HIT_INFLIGHT_PF2 */
+	EVENT_CONSTRAINT_END
+};
+
+#define MSR_KNC_IA32_PERF_GLOBAL_STATUS		0x0000002d
+#define MSR_KNC_IA32_PERF_GLOBAL_OVF_CONTROL	0x0000002e
+#define MSR_KNC_IA32_PERF_GLOBAL_CTRL		0x0000002f
+
+#define KNC_ENABLE_COUNTER0			0x00000001
+#define KNC_ENABLE_COUNTER1			0x00000002
+
+static void knc_pmu_disable_all(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val &= ~(KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static void knc_pmu_enable_all(int added)
+{
+	u64 val;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val |= (KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static inline void
+knc_pmu_disable_event(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	u64 val;
+
+	val = hwc->config;
+	if (cpuc->enabled)
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
+}
+
+static void knc_pmu_enable_event(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	u64 val;
+
+	val = hwc->config;
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
+}
+
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_knc_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
+static __initconst struct x86_pmu knc_pmu = {
+	.name			= "knc",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= knc_pmu_disable_all,
+	.enable_all		= knc_pmu_enable_all,
+	.enable			= knc_pmu_enable_event,
+	.disable		= knc_pmu_disable_event,
+	.hw_config		= x86_pmu_hw_config,
+	.schedule_events	= x86_schedule_events,
+	.eventsel		= MSR_KNC_EVNTSEL0,
+	.perfctr		= MSR_KNC_PERFCTR0,
+	.event_map		= knc_pmu_event_map,
+	.max_events             = ARRAY_SIZE(knc_perfmon_event_map),
+	.apic			= 1,
+	.max_period		= (1ULL << 31) - 1,
+	.version		= 0,
+	.num_counters		= 2,
+	/* in theory 40 bits, early silicon is buggy though */
+	.cntval_bits		= 32,
+	.cntval_mask		= (1ULL << 32) - 1,
+	.get_event_constraints	= x86_get_event_constraints,
+	.event_constraints	= knc_event_constraints,
+	.format_attrs		= intel_knc_formats_attr,
+};
+
+__init int knc_pmu_init(void)
+{
+	x86_pmu = knc_pmu;
+
+	memcpy(hw_cache_event_ids, knc_hw_cache_event_ids, 
+		sizeof(hw_cache_event_ids));
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 966512b..2e8caf0 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -56,6 +56,8 @@ static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_PERFCTR0;
+		case 11:
+			return msr - MSR_KNC_PERFCTR0;
 		case 15:
 			return msr - MSR_P4_BPU_PERFCTR0;
 		}
@@ -82,6 +84,8 @@ static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_EVNTSEL0;
+		case 11:
+			return msr - MSR_KNC_EVNTSEL0;
 		case 15:
 			return msr - MSR_P4_BSU_ESCR0;
 		}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 599afc4..b4166cd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1110,7 +1110,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
-	struct pmu			*active_pmu;
+	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b9df35..fd15593 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -372,6 +372,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			continue; /* ensure we process each cpuctx once */
 
 		/*
 		 * perf_cgroup_events says at least one
@@ -395,9 +397,10 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 			if (mode & PERF_CGROUP_SWIN) {
 				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
+				/*
+				 * set cgrp before ctxsw in to allow
+				 * event_filter_match() to not have to pass
+				 * task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
@@ -4419,7 +4422,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
@@ -4565,7 +4568,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
@@ -4761,7 +4764,7 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
@@ -5862,8 +5865,8 @@ static void update_pmu_context(struct pmu *pmu, struct pmu *old_pmu)
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 
-		if (cpuctx->active_pmu == old_pmu)
-			cpuctx->active_pmu = pmu;
+		if (cpuctx->unique_pmu == old_pmu)
+			cpuctx->unique_pmu = pmu;
 	}
 }
 
@@ -5998,7 +6001,7 @@ skip_type:
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
-		cpuctx->active_pmu = pmu;
+		cpuctx->unique_pmu = pmu;
 	}
 
 got_cpu_context:
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e5e71e7..f9126f8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -45,6 +45,8 @@ include config/utilities.mak
 #
 # Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
 # backtrace post unwind.
+#
+# Define NO_BACKTRACE if you do not want stack backtrace debug feature
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -185,7 +187,7 @@ strip-libs = $(filter-out -l%,$(1))
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
-$(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
+$(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
 	mkdir -p $(OUTPUT)python && \
@@ -446,20 +448,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
-# Files needed for the python binding, perf.so
-# pyrf is just an internal name needed for all those wrappers.
-# This has to be in sync with what is in the 'sources' variable in
-# tools/perf/util/setup.py
-
-PYRF_OBJS += $(OUTPUT)util/cpumap.o
-PYRF_OBJS += $(OUTPUT)util/ctype.o
-PYRF_OBJS += $(OUTPUT)util/evlist.o
-PYRF_OBJS += $(OUTPUT)util/evsel.o
-PYRF_OBJS += $(OUTPUT)util/python.o
-PYRF_OBJS += $(OUTPUT)util/thread_map.o
-PYRF_OBJS += $(OUTPUT)util/util.o
-PYRF_OBJS += $(OUTPUT)util/xyarray.o
-
 #
 # Platform specific tweaks
 #
@@ -486,7 +474,13 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 		NO_DWARF := 1
 		NO_DEMANGLE := 1
 	endif
-endif
+else
+	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+		NO_DWARF := 1
+	endif # Dwarf support
+endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
@@ -511,8 +505,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-BASIC_CFLAGS += -DNO_LIBELF_SUPPORT
-
 EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
 
 # Remove ELF/DWARF dependent codes
@@ -527,17 +519,12 @@ BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
+BASIC_CFLAGS += -DLIBELF_SUPPORT
 
-ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
-	BASIC_CFLAGS += -DLIBELF_NO_MMAP
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
+	BASIC_CFLAGS += -DLIBELF_MMAP
 endif
 
-FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
-	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-	NO_DWARF := 1
-endif # Dwarf support
-
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
@@ -550,38 +537,33 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 endif # NO_LIBELF
 
-ifdef NO_LIBUNWIND
-	BASIC_CFLAGS += -DNO_LIBUNWIND_SUPPORT
-else
+ifndef NO_LIBUNWIND
+	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
 	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
-ifdef NO_LIBAUDIT
-	BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
-else
+ifndef NO_LIBAUDIT
 	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
 	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT)),y)
 		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-		BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
 	else
+		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
 		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
 		EXTLIBS += -laudit
 	endif
 endif
 
-ifdef NO_NEWT
-	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-else
+ifndef NO_NEWT
 	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
 	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
 		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
-		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 	else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
+		BASIC_CFLAGS += -DNEWT_SUPPORT
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)ui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/browser.o
@@ -603,17 +585,15 @@ else
 	endif
 endif
 
-ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
-else
+ifndef NO_GTK2
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 	else
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
 			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
 		endif
+		BASIC_CFLAGS += -DGTK2_SUPPORT
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
@@ -621,7 +601,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		# Make sure that it'd be included only once.
-		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
 			LIB_OBJS += $(OUTPUT)ui/setup.o
 			LIB_OBJS += $(OUTPUT)ui/util.o
 		endif
@@ -762,23 +742,18 @@ ifeq ($(NO_PERF_REGS),0)
 	ifeq ($(ARCH),x86)
 		LIB_H += arch/x86/include/perf_regs.h
 	endif
-else
-	BASIC_CFLAGS += -DNO_PERF_REGS
+	BASIC_CFLAGS += -DHAVE_PERF_REGS
 endif
 
-ifdef NO_STRLCPY
-	BASIC_CFLAGS += -DNO_STRLCPY
-else
-	ifneq ($(call try-cc,$(SOURCE_STRLCPY),),y)
-		BASIC_CFLAGS += -DNO_STRLCPY
+ifndef NO_STRLCPY
+	ifeq ($(call try-cc,$(SOURCE_STRLCPY),),y)
+		BASIC_CFLAGS += -DHAVE_STRLCPY
 	endif
 endif
 
-ifdef NO_BACKTRACE
-       BASIC_CFLAGS += -DNO_BACKTRACE
-else
-       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
-               BASIC_CFLAGS += -DNO_BACKTRACE
+ifndef NO_BACKTRACE
+       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
+               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
        endif
 endif
 
diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 1958fa5..56e6a12 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,23 +1,59 @@
 # perf completion
 
+function_exists()
+{
+	declare -F $1 > /dev/null
+	return $?
+}
+
+function_exists __ltrim_colon_completions ||
+__ltrim_colon_completions()
+{
+	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
+		# Remove colon-word prefix from COMPREPLY items
+		local colon_word=${1%${1##*:}}
+		local i=${#COMPREPLY[*]}
+		while [[ $((--i)) -ge 0 ]]; do
+			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
+		done
+	fi
+}
+
 have perf &&
 _perf()
 {
-	local cur cmd
+	local cur prev cmd
 
 	COMPREPLY=()
-	_get_comp_words_by_ref cur prev
+	if function_exists _get_comp_words_by_ref; then
+		_get_comp_words_by_ref -n : cur prev
+	else
+		cur=$(_get_cword :)
+		prev=${COMP_WORDS[COMP_CWORD-1]}
+	fi
 
 	cmd=${COMP_WORDS[0]}
 
-	# List perf subcommands
+	# List perf subcommands or long options
 	if [ $COMP_CWORD -eq 1 ]; then
-		cmds=$($cmd --list-cmds)
-		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		if [[ $cur == --* ]]; then
+			COMPREPLY=( $( compgen -W '--help --version \
+			--exec-path --html-path --paginate --no-pager \
+			--perf-dir --work-tree --debugfs-dir' -- "$cur" ) )
+		else
+			cmds=$($cmd --list-cmds)
+			COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
-		cmds=$($cmd list --raw-dump)
-		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		evts=$($cmd list --raw-dump)
+		COMPREPLY=( $( compgen -W '$evts' -- "$cur" ) )
+		__ltrim_colon_completions $cur
+	# List long option names
+	elif [[ $cur == --* ]];  then
+		subcmd=${COMP_WORDS[1]}
+		opts=$($cmd $subcmd --list-opts)
+		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
 	# Fall down to list regular files
 	else
 		_filedir
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 8365455..d37e077 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -15,22 +15,6 @@
 #include "util/strlist.h"
 #include "util/symbol.h"
 
-static char const *add_name_list_str, *remove_name_list_str;
-
-static const char * const buildid_cache_usage[] = {
-	"perf buildid-cache [<options>]",
-	NULL
-};
-
-static const struct option buildid_cache_options[] = {
-	OPT_STRING('a', "add", &add_name_list_str,
-		   "file list", "file(s) to add"),
-	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
-		    "file(s) to remove"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
-	OPT_END()
-};
-
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -51,8 +35,8 @@ static int build_id_cache__add_file(const char *filename, const char *debugdir)
 	return err;
 }
 
-static int build_id_cache__remove_file(const char *filename __maybe_unused,
-				       const char *debugdir __maybe_unused)
+static int build_id_cache__remove_file(const char *filename,
+				       const char *debugdir)
 {
 	u8 build_id[BUILD_ID_SIZE];
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -73,11 +57,34 @@ static int build_id_cache__remove_file(const char *filename __maybe_unused,
 	return err;
 }
 
-static int __cmd_buildid_cache(void)
+int cmd_buildid_cache(int argc, const char **argv,
+		      const char *prefix __maybe_unused)
 {
 	struct strlist *list;
 	struct str_node *pos;
 	char debugdir[PATH_MAX];
+	char const *add_name_list_str = NULL,
+		   *remove_name_list_str = NULL;
+	const struct option buildid_cache_options[] = {
+	OPT_STRING('a', "add", &add_name_list_str,
+		   "file list", "file(s) to add"),
+	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
+		    "file(s) to remove"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_cache_usage[] = {
+		"perf buildid-cache [<options>]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, buildid_cache_options,
+			     buildid_cache_usage, 0);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_pager();
 
 	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
@@ -119,16 +126,3 @@ static int __cmd_buildid_cache(void)
 
 	return 0;
 }
-
-int cmd_buildid_cache(int argc, const char **argv,
-		      const char *prefix __maybe_unused)
-{
-	argc = parse_options(argc, argv, buildid_cache_options,
-			     buildid_cache_usage, 0);
-
-	if (symbol__init() < 0)
-		return -1;
-
-	setup_pager();
-	return __cmd_buildid_cache();
-}
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 1159fee..a0e94ff 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,27 +16,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
-static const char *input_name;
-static bool force;
-static bool show_kernel;
-static bool with_hits;
-
-static const char * const buildid_list_usage[] = {
-	"perf buildid-list [<options>]",
-	NULL
-};
-
-static const struct option options[] = {
-	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose"),
-	OPT_END()
-};
-
 static int sysfs__fprintf_build_id(FILE *fp)
 {
 	u8 kallsyms_build_id[BUILD_ID_SIZE];
@@ -65,7 +44,8 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
-static int perf_session__list_build_ids(void)
+static int perf_session__list_build_ids(const char *input_name,
+					bool force, bool with_hits)
 {
 	struct perf_session *session;
 
@@ -95,18 +75,31 @@ out:
 	return 0;
 }
 
-static int __cmd_buildid_list(void)
-{
-	if (show_kernel)
-		return sysfs__fprintf_build_id(stdout);
-
-	return perf_session__list_build_ids();
-}
-
 int cmd_buildid_list(int argc, const char **argv,
 		     const char *prefix __maybe_unused)
 {
+	bool show_kernel = false;
+	bool with_hits = false;
+	bool force = false;
+	const char *input_name = NULL;
+	const struct option options[] = {
+	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_list_usage[] = {
+		"perf buildid-list [<options>]",
+		NULL
+	};
+
 	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
 	setup_pager();
-	return __cmd_buildid_list();
+
+	if (show_kernel)
+		return sysfs__fprintf_build_id(stdout);
+
+	return perf_session__list_build_ids(input_name, force, with_hits);
 }
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 761f419..a0b531c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -70,8 +70,8 @@ static struct perf_tool tool = {
 	.ordering_requires_timestamps = true,
 };
 
-static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
-						    struct hist_entry *he)
+static void insert_hist_entry_by_name(struct rb_root *root,
+				      struct hist_entry *he)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -90,7 +90,7 @@ static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void hists__resort_entries(struct hists *self)
+static void hists__name_resort(struct hists *self, bool sort)
 {
 	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
@@ -100,12 +100,16 @@ static void hists__resort_entries(struct hists *self)
 		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&n->rb_node);
-		rb_erase(&n->rb_node, &self->entries);
 		n->position = position++;
-		perf_session__insert_hist_entry_by_name(&tmp, n);
+
+		if (sort) {
+			rb_erase(&n->rb_node, &self->entries);
+			insert_hist_entry_by_name(&tmp, n);
+		}
 	}
 
-	self->entries = tmp;
+	if (sort)
+		self->entries = tmp;
 }
 
 static struct hist_entry *hists__find_entry(struct hists *self,
@@ -121,7 +125,7 @@ static struct hist_entry *hists__find_entry(struct hists *self,
 			n = n->rb_left;
 		else if (cmp > 0)
 			n = n->rb_right;
-		else 
+		else
 			return iter;
 	}
 
@@ -150,6 +154,24 @@ static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 	return NULL;
 }
 
+static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct hists *hists = &evsel->hists;
+
+		hists__output_resort(hists);
+
+		/*
+		 * The hists__name_resort only sets possition
+		 * if name is false.
+		 */
+		if (name || ((!name) && show_displacement))
+			hists__name_resort(hists, name);
+	}
+}
+
 static int __cmd_diff(void)
 {
 	int ret, i;
@@ -176,15 +198,8 @@ static int __cmd_diff(void)
 	evlist_old = older->evlist;
 	evlist_new = newer->evlist;
 
-	list_for_each_entry(evsel, &evlist_new->entries, node)
-		hists__output_resort(&evsel->hists);
-
-	list_for_each_entry(evsel, &evlist_old->entries, node) {
-		hists__output_resort(&evsel->hists);
-
-		if (show_displacement)
-			hists__resort_entries(&evsel->hists);
-	}
+	perf_evlist__resort_hists(evlist_old, true);
+	perf_evlist__resort_hists(evlist_new, false);
 
 	list_for_each_entry(evsel, &evlist_new->entries, node) {
 		struct perf_evsel *evsel_old;
@@ -199,8 +214,7 @@ static int __cmd_diff(void)
 		first = false;
 
 		hists__match(&evsel_old->hists, &evsel->hists);
-		hists__fprintf(&evsel->hists, &evsel_old->hists,
-			       show_displacement, true, 0, 0, stdout);
+		hists__fprintf(&evsel->hists, true, 0, 0, stdout);
 	}
 
 out_delete:
@@ -242,6 +256,21 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static void ui_init(void)
+{
+	perf_hpp__init();
+
+	/* No overhead column. */
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
+
+	/* Display baseline/delta/displacement columns. */
+	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
+	perf_hpp__column_enable(PERF_HPP__DELTA, true);
+
+	if (show_displacement)
+		perf_hpp__column_enable(PERF_HPP__DISPL, true);
+}
+
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	sort_order = diff__default_sort_order;
@@ -264,7 +293,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	perf_hpp__init(true, show_displacement);
+	ui_init();
+
 	setup_sorting(diff_usage, options);
 	setup_pager();
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 1fb1641..997afb8 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -108,23 +108,20 @@ static int __cmd_evlist(const char *input_name, struct perf_attr_details *detail
 	return 0;
 }
 
-static const char * const evlist_usage[] = {
-	"perf evlist [<options>]",
-	NULL
-};
-
 int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_attr_details details = { .verbose = false, };
 	const char *input_name = NULL;
 	const struct option options[] = {
-		OPT_STRING('i', "input", &input_name, "file",
-			    "Input file name"),
-		OPT_BOOLEAN('F', "freq", &details.freq,
-			    "Show the sample frequency"),
-		OPT_BOOLEAN('v', "verbose", &details.verbose,
-			    "Show all event attr details"),
-		OPT_END()
+	OPT_STRING('i', "input", &input_name, "file", "Input file name"),
+	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
+	OPT_BOOLEAN('v', "verbose", &details.verbose,
+		    "Show all event attr details"),
+	OPT_END()
+	};
+	const char * const evlist_usage[] = {
+		"perf evlist [<options>]",
+		NULL
 	};
 
 	argc = parse_options(argc, argv, options, evlist_usage, 0);
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 25c8b94..411ee56 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -30,23 +30,6 @@ enum help_format {
 	HELP_FORMAT_WEB,
 };
 
-static bool show_all = false;
-static enum help_format help_format = HELP_FORMAT_NONE;
-static struct option builtin_help_options[] = {
-	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
-	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
-	OPT_SET_UINT('w', "web", &help_format, "show manual in web browser",
-			HELP_FORMAT_WEB),
-	OPT_SET_UINT('i', "info", &help_format, "show info page",
-			HELP_FORMAT_INFO),
-	OPT_END(),
-};
-
-static const char * const builtin_help_usage[] = {
-	"perf help [--all] [--man|--web|--info] [command]",
-	NULL
-};
-
 static enum help_format parse_help_format(const char *format)
 {
 	if (!strcmp(format, "man"))
@@ -258,11 +241,13 @@ static int add_man_viewer_info(const char *var, const char *value)
 
 static int perf_help_config(const char *var, const char *value, void *cb)
 {
+	enum help_format *help_formatp = cb;
+
 	if (!strcmp(var, "help.format")) {
 		if (!value)
 			return config_error_nonbool(var);
-		help_format = parse_help_format(value);
-		if (help_format == HELP_FORMAT_NONE)
+		*help_formatp = parse_help_format(value);
+		if (*help_formatp == HELP_FORMAT_NONE)
 			return -1;
 		return 0;
 	}
@@ -428,12 +413,27 @@ static int show_html_page(const char *perf_cmd)
 
 int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	bool show_all = false;
+	enum help_format help_format = HELP_FORMAT_NONE;
+	struct option builtin_help_options[] = {
+	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
+	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
+	OPT_SET_UINT('w', "web", &help_format, "show manual in web browser",
+			HELP_FORMAT_WEB),
+	OPT_SET_UINT('i', "info", &help_format, "show info page",
+			HELP_FORMAT_INFO),
+	OPT_END(),
+	};
+	const char * const builtin_help_usage[] = {
+		"perf help [--all] [--man|--web|--info] [command]",
+		NULL
+	};
 	const char *alias;
 	int rc = 0;
 
 	load_command_list("perf-", &main_cmds, &other_cmds);
 
-	perf_config(perf_help_config, NULL);
+	perf_config(perf_help_config, &help_format);
 
 	argc = parse_options(argc, argv, builtin_help_options,
 			builtin_help_usage, 0);
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1eaa661..4688bea 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -14,8 +14,10 @@
 
 #include "util/parse-options.h"
 
-static char		const *input_name = "-";
-static bool		inject_build_ids;
+struct perf_inject {
+	struct perf_tool tool;
+	bool		 build_ids;
+};
 
 static int perf_event__repipe_synth(struct perf_tool *tool __maybe_unused,
 				    union perf_event *event,
@@ -194,7 +196,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
@@ -208,22 +210,6 @@ repipe:
 	return 0;
 }
 
-struct perf_tool perf_inject = {
-	.sample		= perf_event__repipe_sample,
-	.mmap		= perf_event__repipe,
-	.comm		= perf_event__repipe,
-	.fork		= perf_event__repipe,
-	.exit		= perf_event__repipe,
-	.lost		= perf_event__repipe,
-	.read		= perf_event__repipe_sample,
-	.throttle	= perf_event__repipe,
-	.unthrottle	= perf_event__repipe,
-	.attr		= perf_event__repipe_attr,
-	.event_type	= perf_event__repipe_event_type_synth,
-	.tracing_data	= perf_event__repipe_tracing_data_synth,
-	.build_id	= perf_event__repipe_op2_synth,
-};
-
 extern volatile int session_done;
 
 static void sig_handler(int sig __maybe_unused)
@@ -231,56 +217,72 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static int __cmd_inject(void)
+static int __cmd_inject(struct perf_inject *inject)
 {
 	struct perf_session *session;
 	int ret = -EINVAL;
 
 	signal(SIGINT, sig_handler);
 
-	if (inject_build_ids) {
-		perf_inject.sample	 = perf_event__inject_buildid;
-		perf_inject.mmap	 = perf_event__repipe_mmap;
-		perf_inject.fork	 = perf_event__repipe_task;
-		perf_inject.tracing_data = perf_event__repipe_tracing_data;
+	if (inject->build_ids) {
+		inject->tool.sample	  = perf_event__inject_buildid;
+		inject->tool.mmap	  = perf_event__repipe_mmap;
+		inject->tool.fork	  = perf_event__repipe_task;
+		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
+	session = perf_session__new("-", O_RDONLY, false, true, &inject->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
-	ret = perf_session__process_events(session, &perf_inject);
+	ret = perf_session__process_events(session, &inject->tool);
 
 	perf_session__delete(session);
 
 	return ret;
 }
 
-static const char * const report_usage[] = {
-	"perf inject [<options>]",
-	NULL
-};
-
-static const struct option options[] = {
-	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
-		    "Inject build-ids into the output stream"),
-	OPT_INCR('v', "verbose", &verbose,
-		 "be more verbose (show build ids, etc)"),
-	OPT_END()
-};
-
 int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	argc = parse_options(argc, argv, options, report_usage, 0);
+	struct perf_inject inject = {
+		.tool = {
+			.sample		= perf_event__repipe_sample,
+			.mmap		= perf_event__repipe,
+			.comm		= perf_event__repipe,
+			.fork		= perf_event__repipe,
+			.exit		= perf_event__repipe,
+			.lost		= perf_event__repipe,
+			.read		= perf_event__repipe_sample,
+			.throttle	= perf_event__repipe,
+			.unthrottle	= perf_event__repipe,
+			.attr		= perf_event__repipe_attr,
+			.event_type	= perf_event__repipe_event_type_synth,
+			.tracing_data	= perf_event__repipe_tracing_data_synth,
+			.build_id	= perf_event__repipe_op2_synth,
+		},
+	};
+	const struct option options[] = {
+		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
+			    "Inject build-ids into the output stream"),
+		OPT_INCR('v', "verbose", &verbose,
+			 "be more verbose (show build ids, etc)"),
+		OPT_END()
+	};
+	const char * const inject_usage[] = {
+		"perf inject [<options>]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, options, inject_usage, 0);
 
 	/*
 	 * Any (unrecognized) arguments left?
 	 */
 	if (argc)
-		usage_with_options(report_usage, options);
+		usage_with_options(inject_usage, options);
 
 	if (symbol__init() < 0)
 		return -1;
 
-	return __cmd_inject();
+	return __cmd_inject(&inject);
 }
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bc912c6..14bf82f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -21,8 +21,6 @@
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
-static const char		*input_name;
-
 static int			alloc_flag;
 static int			caller_flag;
 
@@ -31,8 +29,6 @@ static int			caller_lines = -1;
 
 static bool			raw_ip;
 
-static char			default_sort_order[] = "frag,hit,bytes";
-
 static int			*cpunode_map;
 static int			max_cpu_num;
 
@@ -481,7 +477,7 @@ static void sort_result(void)
 	__sort_result(&root_caller_stat, &root_caller_sorted, &caller_sort);
 }
 
-static int __cmd_kmem(void)
+static int __cmd_kmem(const char *input_name)
 {
 	int err = -EINVAL;
 	struct perf_session *session;
@@ -520,11 +516,6 @@ out_delete:
 	return err;
 }
 
-static const char * const kmem_usage[] = {
-	"perf kmem [<options>] {record|stat}",
-	NULL
-};
-
 static int ptr_cmp(struct alloc_stat *l, struct alloc_stat *r)
 {
 	if (l->ptr < r->ptr)
@@ -720,41 +711,17 @@ static int parse_line_opt(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static const struct option kmem_options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		   "input file name"),
-	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
-			   "show per-callsite statistics",
-			   parse_caller_opt),
-	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
-			   "show per-allocation statistics",
-			   parse_alloc_opt),
-	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
-		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
-		     parse_sort_opt),
-	OPT_CALLBACK('l', "line", NULL, "num",
-		     "show n lines",
-		     parse_line_opt),
-	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
-	OPT_END()
-};
-
-static const char *record_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
+static int __cmd_record(int argc, const char **argv)
+{
+	const char * const record_args[] = {
+	"record", "-a", "-R", "-f", "-c", "1",
 	"-e", "kmem:kmalloc",
 	"-e", "kmem:kmalloc_node",
 	"-e", "kmem:kfree",
 	"-e", "kmem:kmem_cache_alloc",
 	"-e", "kmem:kmem_cache_alloc_node",
 	"-e", "kmem:kmem_cache_free",
-};
-
-static int __cmd_record(int argc, const char **argv)
-{
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 
@@ -775,6 +742,25 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const char * const default_sort_order = "frag,hit,bytes";
+	const char *input_name = NULL;
+	const struct option kmem_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
+			   "show per-callsite statistics", parse_caller_opt),
+	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
+			   "show per-allocation statistics", parse_alloc_opt),
+	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
+		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
+		     parse_sort_opt),
+	OPT_CALLBACK('l', "line", NULL, "num", "show n lines", parse_line_opt),
+	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
+	OPT_END()
+	};
+	const char * const kmem_usage[] = {
+		"perf kmem [<options>] {record|stat}",
+		NULL
+	};
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
 	if (!argc)
@@ -793,7 +779,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (list_empty(&alloc_sort))
 			setup_sorting(&alloc_sort, default_sort_order);
 
-		return __cmd_kmem();
+		return __cmd_kmem(input_name);
 	} else
 		usage_with_options(kmem_usage, kmem_options);
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a28c9ca..260abc5 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -32,16 +32,76 @@ struct event_key {
 	int info;
 };
 
+struct kvm_event_stats {
+	u64 time;
+	struct stats stats;
+};
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	struct event_key key;
+
+	struct kvm_event_stats total;
+
+	#define DEFAULT_VCPU_NUM 8
+	int max_vcpu;
+	struct kvm_event_stats *vcpu;
+};
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+
+struct perf_kvm;
+
 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct event_key *key, char decode[20]);
+	void (*decode_key)(struct perf_kvm *kvm, struct event_key *key,
+			   char decode[20]);
 	const char *name;
 };
 
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+#define EVENTS_BITS		12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+struct perf_kvm {
+	struct perf_tool    tool;
+	struct perf_session *session;
+
+	const char *file_name;
+	const char *report_event;
+	const char *sort_key;
+	int trace_vcpu;
+
+	struct exit_reasons_table *exit_reasons;
+	int exit_reasons_size;
+	const char *exit_reasons_isa;
+
+	struct kvm_events_ops *events_ops;
+	key_cmp_fun compare;
+	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+	u64 total_time;
+	u64 total_count;
+
+	struct rb_root result;
+};
+
+
 static void exit_event_get_key(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key)
@@ -78,45 +138,35 @@ static bool exit_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-struct exit_reasons_table {
-	unsigned long exit_code;
-	const char *reason;
-};
-
-struct exit_reasons_table vmx_exit_reasons[] = {
+static struct exit_reasons_table vmx_exit_reasons[] = {
 	VMX_EXIT_REASONS
 };
 
-struct exit_reasons_table svm_exit_reasons[] = {
+static struct exit_reasons_table svm_exit_reasons[] = {
 	SVM_EXIT_REASONS
 };
 
-static int cpu_isa;
-
-static const char *get_exit_reason(u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
 {
-	int table_size = ARRAY_SIZE(svm_exit_reasons);
-	struct exit_reasons_table *table = svm_exit_reasons;
-
-	if (cpu_isa == 1) {
-		table = vmx_exit_reasons;
-		table_size = ARRAY_SIZE(vmx_exit_reasons);
-	}
+	int i = kvm->exit_reasons_size;
+	struct exit_reasons_table *tbl = kvm->exit_reasons;
 
-	while (table_size--) {
-		if (table->exit_code == exit_code)
-			return table->reason;
-		table++;
+	while (i--) {
+		if (tbl->exit_code == exit_code)
+			return tbl->reason;
+		tbl++;
 	}
 
 	pr_err("unknown kvm exit code:%lld on %s\n",
-		(unsigned long long)exit_code, cpu_isa ? "VMX" : "SVM");
+		(unsigned long long)exit_code, kvm->exit_reasons_isa);
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct event_key *key, char decode[20])
+static void exit_event_decode_key(struct perf_kvm *kvm,
+				  struct event_key *key,
+				  char decode[20])
 {
-	const char *exit_reason = get_exit_reason(key->key);
+	const char *exit_reason = get_exit_reason(kvm, key->key);
 
 	scnprintf(decode, 20, "%s", exit_reason);
 }
@@ -128,11 +178,11 @@ static struct kvm_events_ops exit_events = {
 	.name = "VM-EXIT"
 };
 
-    /*
-     * For the mmio events, we treat:
-     * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
-     * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
-     */
+/*
+ * For the mmio events, we treat:
+ * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
+ * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
+ */
 static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
 			       struct event_key *key)
 {
@@ -178,7 +228,9 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 	return false;
 }
 
-static void mmio_event_decode_key(struct event_key *key, char decode[20])
+static void mmio_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+				  struct event_key *key,
+				  char decode[20])
 {
 	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
 				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
@@ -219,7 +271,9 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-static void ioport_event_decode_key(struct event_key *key, char decode[20])
+static void ioport_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+				    struct event_key *key,
+				    char decode[20])
 {
 	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
 				key->info ? "POUT" : "PIN");
@@ -232,64 +286,37 @@ static struct kvm_events_ops ioport_events = {
 	.name = "IO Port Access"
 };
 
-static const char *report_event = "vmexit";
-struct kvm_events_ops *events_ops;
-
-static bool register_kvm_events_ops(void)
+static bool register_kvm_events_ops(struct perf_kvm *kvm)
 {
 	bool ret = true;
 
-	if (!strcmp(report_event, "vmexit"))
-		events_ops = &exit_events;
-	else if (!strcmp(report_event, "mmio"))
-		events_ops = &mmio_events;
-	else if (!strcmp(report_event, "ioport"))
-		events_ops = &ioport_events;
+	if (!strcmp(kvm->report_event, "vmexit"))
+		kvm->events_ops = &exit_events;
+	else if (!strcmp(kvm->report_event, "mmio"))
+		kvm->events_ops = &mmio_events;
+	else if (!strcmp(kvm->report_event, "ioport"))
+		kvm->events_ops = &ioport_events;
 	else {
-		pr_err("Unknown report event:%s\n", report_event);
+		pr_err("Unknown report event:%s\n", kvm->report_event);
 		ret = false;
 	}
 
 	return ret;
 }
 
-struct kvm_event_stats {
-	u64 time;
-	struct stats stats;
-};
-
-struct kvm_event {
-	struct list_head hash_entry;
-	struct rb_node rb;
-
-	struct event_key key;
-
-	struct kvm_event_stats total;
-
-	#define DEFAULT_VCPU_NUM 8
-	int max_vcpu;
-	struct kvm_event_stats *vcpu;
-};
-
 struct vcpu_event_record {
 	int vcpu_id;
 	u64 start_time;
 	struct kvm_event *last_event;
 };
 
-#define EVENTS_BITS			12
-#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
-
-static u64 total_time;
-static u64 total_count;
-static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
 
-static void init_kvm_event_record(void)
+static void init_kvm_event_record(struct perf_kvm *kvm)
 {
 	int i;
 
 	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
-		INIT_LIST_HEAD(&kvm_events_cache[i]);
+		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
 static int kvm_events_hash_fn(u64 key)
@@ -333,14 +360,15 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	return event;
 }
 
-static struct kvm_event *find_create_kvm_event(struct event_key *key)
+static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
+					       struct event_key *key)
 {
 	struct kvm_event *event;
 	struct list_head *head;
 
 	BUG_ON(key->key == INVALID_KEY);
 
-	head = &kvm_events_cache[kvm_events_hash_fn(key->key)];
+	head = &kvm->kvm_events_cache[kvm_events_hash_fn(key->key)];
 	list_for_each_entry(event, head, hash_entry)
 		if (event->key.key == key->key && event->key.info == key->info)
 			return event;
@@ -353,13 +381,14 @@ static struct kvm_event *find_create_kvm_event(struct event_key *key)
 	return event;
 }
 
-static bool handle_begin_event(struct vcpu_event_record *vcpu_record,
+static bool handle_begin_event(struct perf_kvm *kvm,
+			       struct vcpu_event_record *vcpu_record,
 			       struct event_key *key, u64 timestamp)
 {
 	struct kvm_event *event = NULL;
 
 	if (key->key != INVALID_KEY)
-		event = find_create_kvm_event(key);
+		event = find_create_kvm_event(kvm, key);
 
 	vcpu_record->last_event = event;
 	vcpu_record->start_time = timestamp;
@@ -396,8 +425,10 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
-static bool handle_end_event(struct vcpu_event_record *vcpu_record,
-			     struct event_key *key, u64 timestamp)
+static bool handle_end_event(struct perf_kvm *kvm,
+			     struct vcpu_event_record *vcpu_record,
+			     struct event_key *key,
+			     u64 timestamp)
 {
 	struct kvm_event *event;
 	u64 time_begin, time_diff;
@@ -419,7 +450,7 @@ static bool handle_end_event(struct vcpu_event_record *vcpu_record,
 		return true;
 
 	if (!event)
-		event = find_create_kvm_event(key);
+		event = find_create_kvm_event(kvm, key);
 
 	if (!event)
 		return false;
@@ -455,7 +486,9 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 	return thread->priv;
 }
 
-static bool handle_kvm_event(struct thread *thread, struct perf_evsel *evsel,
+static bool handle_kvm_event(struct perf_kvm *kvm,
+			     struct thread *thread,
+			     struct perf_evsel *evsel,
 			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
@@ -465,22 +498,15 @@ static bool handle_kvm_event(struct thread *thread, struct perf_evsel *evsel,
 	if (!vcpu_record)
 		return true;
 
-	if (events_ops->is_begin_event(evsel, sample, &key))
-		return handle_begin_event(vcpu_record, &key, sample->time);
+	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
+		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
-	if (events_ops->is_end_event(evsel, sample, &key))
-		return handle_end_event(vcpu_record, &key, sample->time);
+	if (kvm->events_ops->is_end_event(evsel, sample, &key))
+		return handle_end_event(kvm, vcpu_record, &key, sample->time);
 
 	return true;
 }
 
-typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
-struct kvm_event_key {
-	const char *name;
-	key_cmp_fun key;
-};
-
-static int trace_vcpu = -1;
 #define GET_EVENT_KEY(func, field)					\
 static u64 get_event_ ##func(struct kvm_event *event, int vcpu)		\
 {									\
@@ -515,29 +541,25 @@ static struct kvm_event_key keys[] = {
 	{ NULL, NULL }
 };
 
-static const char *sort_key = "sample";
-static key_cmp_fun compare;
-
-static bool select_key(void)
+static bool select_key(struct perf_kvm *kvm)
 {
 	int i;
 
 	for (i = 0; keys[i].name; i++) {
-		if (!strcmp(keys[i].name, sort_key)) {
-			compare = keys[i].key;
+		if (!strcmp(keys[i].name, kvm->sort_key)) {
+			kvm->compare = keys[i].key;
 			return true;
 		}
 	}
 
-	pr_err("Unknown compare key:%s\n", sort_key);
+	pr_err("Unknown compare key:%s\n", kvm->sort_key);
 	return false;
 }
 
-static struct rb_root result;
-static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
-			     int vcpu)
+static void insert_to_result(struct rb_root *result, struct kvm_event *event,
+			     key_cmp_fun bigger, int vcpu)
 {
-	struct rb_node **rb = &result.rb_node;
+	struct rb_node **rb = &result->rb_node;
 	struct rb_node *parent = NULL;
 	struct kvm_event *p;
 
@@ -552,13 +574,15 @@ static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
 	}
 
 	rb_link_node(&event->rb, parent, rb);
-	rb_insert_color(&event->rb, &result);
+	rb_insert_color(&event->rb, result);
 }
 
-static void update_total_count(struct kvm_event *event, int vcpu)
+static void update_total_count(struct perf_kvm *kvm, struct kvm_event *event)
 {
-	total_count += get_event_count(event, vcpu);
-	total_time += get_event_time(event, vcpu);
+	int vcpu = kvm->trace_vcpu;
+
+	kvm->total_count += get_event_count(event, vcpu);
+	kvm->total_time += get_event_time(event, vcpu);
 }
 
 static bool event_is_valid(struct kvm_event *event, int vcpu)
@@ -566,28 +590,30 @@ static bool event_is_valid(struct kvm_event *event, int vcpu)
 	return !!get_event_count(event, vcpu);
 }
 
-static void sort_result(int vcpu)
+static void sort_result(struct perf_kvm *kvm)
 {
 	unsigned int i;
+	int vcpu = kvm->trace_vcpu;
 	struct kvm_event *event;
 
 	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
-		list_for_each_entry(event, &kvm_events_cache[i], hash_entry)
+		list_for_each_entry(event, &kvm->kvm_events_cache[i], hash_entry)
 			if (event_is_valid(event, vcpu)) {
-				update_total_count(event, vcpu);
-				insert_to_result(event, compare, vcpu);
+				update_total_count(kvm, event);
+				insert_to_result(&kvm->result, event,
+						 kvm->compare, vcpu);
 			}
 }
 
 /* returns left most element of result, and erase it */
-static struct kvm_event *pop_from_result(void)
+static struct kvm_event *pop_from_result(struct rb_root *result)
 {
-	struct rb_node *node = rb_first(&result);
+	struct rb_node *node = rb_first(result);
 
 	if (!node)
 		return NULL;
 
-	rb_erase(node, &result);
+	rb_erase(node, result);
 	return container_of(node, struct kvm_event, rb);
 }
 
@@ -601,14 +627,15 @@ static void print_vcpu_info(int vcpu)
 		pr_info("VCPU %d:\n\n", vcpu);
 }
 
-static void print_result(int vcpu)
+static void print_result(struct perf_kvm *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
+	int vcpu = kvm->trace_vcpu;
 
 	pr_info("\n\n");
 	print_vcpu_info(vcpu);
-	pr_info("%20s ", events_ops->name);
+	pr_info("%20s ", kvm->events_ops->name);
 	pr_info("%10s ", "Samples");
 	pr_info("%9s ", "Samples%");
 
@@ -616,33 +643,34 @@ static void print_result(int vcpu)
 	pr_info("%16s ", "Avg time");
 	pr_info("\n\n");
 
-	while ((event = pop_from_result())) {
+	while ((event = pop_from_result(&kvm->result))) {
 		u64 ecount, etime;
 
 		ecount = get_event_count(event, vcpu);
 		etime = get_event_time(event, vcpu);
 
-		events_ops->decode_key(&event->key, decode);
+		kvm->events_ops->decode_key(kvm, &event->key, decode);
 		pr_info("%20s ", decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
-		pr_info("%8.2f%% ", (double)ecount / total_count * 100);
-		pr_info("%8.2f%% ", (double)etime / total_time * 100);
+		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
+		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
 		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
 			kvm_event_rel_stddev(vcpu, event));
 		pr_info("\n");
 	}
 
 	pr_info("\nTotal Samples:%lld, Total events handled time:%.2fus.\n\n",
-		(unsigned long long)total_count, total_time / 1e3);
+		(unsigned long long)kvm->total_count, kvm->total_time / 1e3);
 }
 
-static int process_sample_event(struct perf_tool *tool __maybe_unused,
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -650,18 +678,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (!handle_kvm_event(thread, evsel, sample))
+	if (!handle_kvm_event(kvm, thread, evsel, sample))
 		return -1;
 
 	return 0;
 }
 
-static struct perf_tool eops = {
-	.sample			= process_sample_event,
-	.comm			= perf_event__process_comm,
-	.ordered_samples	= true,
-};
-
 static int get_cpu_isa(struct perf_session *session)
 {
 	char *cpuid = session->header.env.cpuid;
@@ -679,34 +701,43 @@ static int get_cpu_isa(struct perf_session *session)
 	return isa;
 }
 
-static const char *file_name;
-
-static int read_events(void)
+static int read_events(struct perf_kvm *kvm)
 {
-	struct perf_session *kvm_session;
 	int ret;
 
-	kvm_session = perf_session__new(file_name, O_RDONLY, 0, false, &eops);
-	if (!kvm_session) {
+	struct perf_tool eops = {
+		.sample			= process_sample_event,
+		.comm			= perf_event__process_comm,
+		.ordered_samples	= true,
+	};
+
+	kvm->tool = eops;
+	kvm->session = perf_session__new(kvm->file_name, O_RDONLY, 0, false,
+					 &kvm->tool);
+	if (!kvm->session) {
 		pr_err("Initializing perf session failed\n");
 		return -EINVAL;
 	}
 
-	if (!perf_session__has_traces(kvm_session, "kvm record"))
+	if (!perf_session__has_traces(kvm->session, "kvm record"))
 		return -EINVAL;
 
 	/*
 	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
 	 * traced in the old kernel.
 	 */
-	ret = get_cpu_isa(kvm_session);
+	ret = get_cpu_isa(kvm->session);
 
 	if (ret < 0)
 		return ret;
 
-	cpu_isa = ret;
+	if (ret == 1) {
+		kvm->exit_reasons = vmx_exit_reasons;
+		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
+		kvm->exit_reasons_isa = "VMX";
+	}
 
-	return perf_session__process_events(kvm_session, &eops);
+	return perf_session__process_events(kvm->session, &kvm->tool);
 }
 
 static bool verify_vcpu(int vcpu)
@@ -719,28 +750,30 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-static int kvm_events_report_vcpu(int vcpu)
+static int kvm_events_report_vcpu(struct perf_kvm *kvm)
 {
 	int ret = -EINVAL;
+	int vcpu = kvm->trace_vcpu;
 
 	if (!verify_vcpu(vcpu))
 		goto exit;
 
-	if (!select_key())
+	if (!select_key(kvm))
 		goto exit;
 
-	if (!register_kvm_events_ops())
+	if (!register_kvm_events_ops(kvm))
 		goto exit;
 
-	init_kvm_event_record();
+	init_kvm_event_record(kvm);
 	setup_pager();
 
-	ret = read_events();
+	ret = read_events(kvm);
 	if (ret)
 		goto exit;
 
-	sort_result(vcpu);
-	print_result(vcpu);
+	sort_result(kvm);
+	print_result(kvm);
+
 exit:
 	return ret;
 }
@@ -765,7 +798,7 @@ static const char * const record_args[] = {
 		_p;			\
 	})
 
-static int kvm_events_record(int argc, const char **argv)
+static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -780,7 +813,7 @@ static int kvm_events_record(int argc, const char **argv)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
 	rec_argv[i++] = STRDUP_FAIL_EXIT("-o");
-	rec_argv[i++] = STRDUP_FAIL_EXIT(file_name);
+	rec_argv[i++] = STRDUP_FAIL_EXIT(kvm->file_name);
 
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
@@ -788,24 +821,24 @@ static int kvm_events_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static const char * const kvm_events_report_usage[] = {
-	"perf kvm stat report [<options>]",
-	NULL
-};
+static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
+{
+	const struct option kvm_events_report_options[] = {
+		OPT_STRING(0, "event", &kvm->report_event, "report event",
+			    "event for reporting: vmexit, mmio, ioport"),
+		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
+			    "vcpu id to report"),
+		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
+			    "key for sorting: sample(sort by samples number)"
+			    " time (sort by avg time)"),
+		OPT_END()
+	};
 
-static const struct option kvm_events_report_options[] = {
-	OPT_STRING(0, "event", &report_event, "report event",
-		    "event for reporting: vmexit, mmio, ioport"),
-	OPT_INTEGER(0, "vcpu", &trace_vcpu,
-		    "vcpu id to report"),
-	OPT_STRING('k', "key", &sort_key, "sort-key",
-		    "key for sorting: sample(sort by samples number)"
-		    " time (sort by avg time)"),
-	OPT_END()
-};
+	const char * const kvm_events_report_usage[] = {
+		"perf kvm stat report [<options>]",
+		NULL
+	};
 
-static int kvm_events_report(int argc, const char **argv)
-{
 	symbol__init();
 
 	if (argc) {
@@ -817,7 +850,7 @@ static int kvm_events_report(int argc, const char **argv)
 					   kvm_events_report_options);
 	}
 
-	return kvm_events_report_vcpu(trace_vcpu);
+	return kvm_events_report_vcpu(kvm);
 }
 
 static void print_kvm_stat_usage(void)
@@ -831,7 +864,7 @@ static void print_kvm_stat_usage(void)
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
 
-static int kvm_cmd_stat(int argc, const char **argv)
+static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	if (argc == 1) {
 		print_kvm_stat_usage();
@@ -839,44 +872,16 @@ static int kvm_cmd_stat(int argc, const char **argv)
 	}
 
 	if (!strncmp(argv[1], "rec", 3))
-		return kvm_events_record(argc - 1, argv + 1);
+		return kvm_events_record(kvm, argc - 1, argv + 1);
 
 	if (!strncmp(argv[1], "rep", 3))
-		return kvm_events_report(argc - 1 , argv + 1);
+		return kvm_events_report(kvm, argc - 1 , argv + 1);
 
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
 
-static char			name_buffer[256];
-
-static const char * const kvm_usage[] = {
-	"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
-	NULL
-};
-
-static const struct option kvm_options[] = {
-	OPT_STRING('i', "input", &file_name, "file",
-		   "Input file name"),
-	OPT_STRING('o', "output", &file_name, "file",
-		   "Output file name"),
-	OPT_BOOLEAN(0, "guest", &perf_guest,
-		    "Collect guest os data"),
-	OPT_BOOLEAN(0, "host", &perf_host,
-		    "Collect host os data"),
-	OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
-		   "guest mount directory under which every guest os"
-		   " instance has a subdir"),
-	OPT_STRING(0, "guestvmlinux", &symbol_conf.default_guest_vmlinux_name,
-		   "file", "file saving guest os vmlinux"),
-	OPT_STRING(0, "guestkallsyms", &symbol_conf.default_guest_kallsyms,
-		   "file", "file saving guest os /proc/kallsyms"),
-	OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
-		   "file", "file saving guest os /proc/modules"),
-	OPT_END()
-};
-
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -885,7 +890,7 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
 	rec_argv[i++] = strdup("-o");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -894,7 +899,7 @@ static int __cmd_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int __cmd_report(int argc, const char **argv)
+static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -903,7 +908,7 @@ static int __cmd_report(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("report");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -912,7 +917,7 @@ static int __cmd_report(int argc, const char **argv)
 	return cmd_report(i, rec_argv, NULL);
 }
 
-static int __cmd_buildid_list(int argc, const char **argv)
+static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -921,7 +926,7 @@ static int __cmd_buildid_list(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("buildid-list");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -932,6 +937,43 @@ static int __cmd_buildid_list(int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	struct perf_kvm kvm = {
+		.trace_vcpu	= -1,
+		.report_event	= "vmexit",
+		.sort_key	= "sample",
+
+		.exit_reasons = svm_exit_reasons,
+		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
+		.exit_reasons_isa = "SVM",
+	};
+
+	const struct option kvm_options[] = {
+		OPT_STRING('i', "input", &kvm.file_name, "file",
+			   "Input file name"),
+		OPT_STRING('o', "output", &kvm.file_name, "file",
+			   "Output file name"),
+		OPT_BOOLEAN(0, "guest", &perf_guest,
+			    "Collect guest os data"),
+		OPT_BOOLEAN(0, "host", &perf_host,
+			    "Collect host os data"),
+		OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
+			   "guest mount directory under which every guest os"
+			   " instance has a subdir"),
+		OPT_STRING(0, "guestvmlinux", &symbol_conf.default_guest_vmlinux_name,
+			   "file", "file saving guest os vmlinux"),
+		OPT_STRING(0, "guestkallsyms", &symbol_conf.default_guest_kallsyms,
+			   "file", "file saving guest os /proc/kallsyms"),
+		OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
+			   "file", "file saving guest os /proc/modules"),
+		OPT_END()
+	};
+
+
+	const char * const kvm_usage[] = {
+		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
+		NULL
+	};
+
 	perf_host  = 0;
 	perf_guest = 1;
 
@@ -943,28 +985,32 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;
 
-	if (!file_name) {
+	if (!kvm.file_name) {
 		if (perf_host && !perf_guest)
-			sprintf(name_buffer, "perf.data.host");
+			kvm.file_name = strdup("perf.data.host");
 		else if (!perf_host && perf_guest)
-			sprintf(name_buffer, "perf.data.guest");
+			kvm.file_name = strdup("perf.data.guest");
 		else
-			sprintf(name_buffer, "perf.data.kvm");
-		file_name = name_buffer;
+			kvm.file_name = strdup("perf.data.kvm");
+
+		if (!kvm.file_name) {
+			pr_err("Failed to allocate memory for filename\n");
+			return -ENOMEM;
+		}
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
-		return __cmd_report(argc, argv);
+		return __cmd_report(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
 	else if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
-		return __cmd_buildid_list(argc, argv);
+		return __cmd_buildid_list(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "stat", 4))
-		return kvm_cmd_stat(argc, argv);
+		return kvm_cmd_stat(&kvm, argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 7d6e099..6f5f328 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -823,12 +823,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static struct perf_tool eops = {
-	.sample			= process_sample_event,
-	.comm			= perf_event__process_comm,
-	.ordered_samples	= true,
-};
-
 static const struct perf_evsel_str_handler lock_tracepoints[] = {
 	{ "lock:lock_acquire",	 perf_evsel__process_lock_acquire,   }, /* CONFIG_LOCKDEP */
 	{ "lock:lock_acquired",	 perf_evsel__process_lock_acquired,  }, /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
@@ -838,6 +832,11 @@ static const struct perf_evsel_str_handler lock_tracepoints[] = {
 
 static int read_events(void)
 {
+	struct perf_tool eops = {
+		.sample		 = process_sample_event,
+		.comm		 = perf_event__process_comm,
+		.ordered_samples = true,
+	};
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
 	if (!session) {
 		pr_err("Initializing perf session failed\n");
@@ -878,53 +877,11 @@ static int __cmd_report(void)
 	return 0;
 }
 
-static const char * const report_usage[] = {
-	"perf lock report [<options>]",
-	NULL
-};
-
-static const struct option report_options[] = {
-	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
-	/* TODO: type */
-	OPT_END()
-};
-
-static const char * const info_usage[] = {
-	"perf lock info [<options>]",
-	NULL
-};
-
-static const struct option info_options[] = {
-	OPT_BOOLEAN('t', "threads", &info_threads,
-		    "dump thread list in perf.data"),
-	OPT_BOOLEAN('m', "map", &info_map,
-		    "map of lock instances (address:name table)"),
-	OPT_END()
-};
-
-static const char * const lock_usage[] = {
-	"perf lock [<options>] {record|report|script|info}",
-	NULL
-};
-
-static const struct option lock_options[] = {
-	OPT_STRING('i', "input", &input_name, "file", "input file name"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
-	OPT_END()
-};
-
-static const char *record_args[] = {
-	"record",
-	"-R",
-	"-f",
-	"-m", "1024",
-	"-c", "1",
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
+	const char *record_args[] = {
+		"record", "-R", "-f", "-m", "1024", "-c", "1",
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 
@@ -963,6 +920,37 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const struct option info_options[] = {
+	OPT_BOOLEAN('t', "threads", &info_threads,
+		    "dump thread list in perf.data"),
+	OPT_BOOLEAN('m', "map", &info_map,
+		    "map of lock instances (address:name table)"),
+	OPT_END()
+	};
+	const struct option lock_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
+	OPT_END()
+	};
+	const struct option report_options[] = {
+	OPT_STRING('k', "key", &sort_key, "acquired",
+		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
+	/* TODO: type */
+	OPT_END()
+	};
+	const char * const info_usage[] = {
+		"perf lock info [<options>]",
+		NULL
+	};
+	const char * const lock_usage[] = {
+		"perf lock [<options>] {record|report|script|info}",
+		NULL
+	};
+	const char * const report_usage[] = {
+		"perf lock report [<options>]",
+		NULL
+	};
 	unsigned int i;
 	int rc = 0;
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 118aa89..de38a03 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -250,19 +250,20 @@ static int opt_set_filter(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static const char * const probe_usage[] = {
-	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
-	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
-	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
-	"perf probe --list",
+int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	const char * const probe_usage[] = {
+		"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
+		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
+		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
+		"perf probe --list",
 #ifdef DWARF_SUPPORT
-	"perf probe [<options>] --line 'LINEDESC'",
-	"perf probe [<options>] --vars 'PROBEPOINT'",
+		"perf probe [<options>] --line 'LINEDESC'",
+		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
-	NULL
+		NULL
 };
-
-static const struct option options[] = {
+	const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
 	OPT_BOOLEAN('l', "list", &params.list_events,
@@ -325,10 +326,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
 	OPT_END()
-};
-
-int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
-{
+	};
 	int ret;
 
 	argc = parse_options(argc, argv, options, probe_usage,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f14cb5f..e9231659 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,15 +31,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
-
-#ifdef NO_LIBUNWIND_SUPPORT
-static char callchain_help[] = CALLCHAIN_HELP "[fp]";
-#else
-static unsigned long default_stack_dump_size = 8192;
-static char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
-#endif
-
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -800,7 +791,7 @@ error:
 	return ret;
 }
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -826,7 +817,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 
 static int
 parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
@@ -865,9 +856,11 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 				       "needed for -g fp\n");
 			break;
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
+			const unsigned long default_stack_dump_size = 8192;
+
 			ret = 0;
 			rec->opts.call_graph = CALLCHAIN_DWARF;
 			rec->opts.stack_dump_size = default_stack_dump_size;
@@ -883,7 +876,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 rec->opts.stack_dump_size);
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
@@ -930,6 +923,14 @@ static struct perf_record record = {
 	.file_new   = true,
 };
 
+#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+
+#ifdef LIBUNWIND_SUPPORT
+static const char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+#else
+static const char callchain_help[] = CALLCHAIN_HELP "[fp]";
+#endif
+
 /*
  * XXX Will stay a global variable till we fix builtin-script.c to stop messing
  * with it and switch to use the library functions in perf_evlist that came
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1da243d..a61725d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -320,7 +320,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		const char *evname = perf_evsel__name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
-		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
+		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
@@ -691,7 +691,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		setup_browser(true);
 	else {
 		use_browser = 0;
-		perf_hpp__init(false, false);
+		perf_hpp__init();
 	}
 
 	setup_sorting(report_usage, options);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9b9e32e..3488ead 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1426,7 +1426,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->pid);
+	struct thread *thread = machine__findnew_thread(machine, sample->tid);
 	int err = 0;
 
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1be843a..fb96250 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,7 +24,6 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
-static bool			show_full_info;
 static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
@@ -473,8 +472,6 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-static const char *input_name;
-
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -1156,20 +1153,40 @@ out:
 	return n_args;
 }
 
-static const char * const script_usage[] = {
-	"perf script [<options>]",
-	"perf script [<options>] record <script> [<record-options>] <command>",
-	"perf script [<options>] report <script> [script-args]",
-	"perf script [<options>] <script> [<record-options>] <command>",
-	"perf script [<options>] <top-script> [script-args]",
-	NULL
-};
+static int have_cmd(int argc, const char **argv)
+{
+	char **__argv = malloc(sizeof(const char *) * argc);
+
+	if (!__argv) {
+		pr_err("malloc failed\n");
+		return -1;
+	}
+
+	memcpy(__argv, argv, sizeof(const char *) * argc);
+	argc = parse_options(argc, (const char **)__argv, record_options,
+			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
+	free(__argv);
 
-static const struct option options[] = {
+	system_wide = (argc == 0);
+
+	return 0;
+}
+
+int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	bool show_full_info = false;
+	const char *input_name = NULL;
+	char *rec_script_path = NULL;
+	char *rep_script_path = NULL;
+	struct perf_session *session;
+	char *script_path = NULL;
+	const char **__argv;
+	int i, j, err;
+	const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
+		 "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('L', "Latency", &latency_format,
 		    "show latency attributes (irqs/preemption disabled, etc)"),
 	OPT_CALLBACK_NOOPT('l', "list", NULL, NULL, "list available scripts",
@@ -1179,8 +1196,7 @@ static const struct option options[] = {
 		     parse_scriptname),
 	OPT_STRING('g', "gen-script", &generate_script_lang, "lang",
 		   "generate perf-script.xx script in specified language"),
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
@@ -1195,10 +1211,9 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. "
 		     "Valid types: hw,sw,trace,raw. "
 		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
-		     "addr,symoff",
-		     parse_output_fields),
+		     "addr,symoff", parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-		     "system-wide collection from all CPUs"),
+		    "system-wide collection from all CPUs"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
@@ -1208,37 +1223,16 @@ static const struct option options[] = {
 		    "display extended information from perf.data file"),
 	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
 		    "Show the path of [kernel.kallsyms]"),
-
 	OPT_END()
-};
-
-static int have_cmd(int argc, const char **argv)
-{
-	char **__argv = malloc(sizeof(const char *) * argc);
-
-	if (!__argv) {
-		pr_err("malloc failed\n");
-		return -1;
-	}
-
-	memcpy(__argv, argv, sizeof(const char *) * argc);
-	argc = parse_options(argc, (const char **)__argv, record_options,
-			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
-	free(__argv);
-
-	system_wide = (argc == 0);
-
-	return 0;
-}
-
-int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
-{
-	char *rec_script_path = NULL;
-	char *rep_script_path = NULL;
-	struct perf_session *session;
-	char *script_path = NULL;
-	const char **__argv;
-	int i, j, err;
+	};
+	const char * const script_usage[] = {
+		"perf script [<options>]",
+		"perf script [<options>] record <script> [<record-options>] <command>",
+		"perf script [<options>] report <script> [script-args]",
+		"perf script [<options>] <script> [<record-options>] <command>",
+		"perf script [<options>] <top-script> [script-args]",
+		NULL
+	};
 
 	setup_scripting();
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e8cd4d8..93b9011 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,122 +64,12 @@
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
 
-static struct perf_event_attr default_attrs[] = {
-
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
-
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
-
-};
-
-/*
- * Detailed stats (-d), covering the L1 and last level data caches:
- */
-static struct perf_event_attr detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_LL			<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_LL			<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-};
-
-/*
- * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
- */
-static struct perf_event_attr very_detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-
-};
-
-/*
- * Very, very detailed stats (-d -d -d), adding prefetch events:
- */
-static struct perf_event_attr very_very_detailed_attrs[] = {
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
-
-  { .type = PERF_TYPE_HW_CACHE,
-    .config =
-	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
-	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
-	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
-};
-
-
-
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
 
-static int			run_idx				=  0;
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
@@ -187,15 +77,12 @@ static bool			no_aggr				= false;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
-static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 static bool			group				= false;
-static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
-static int			output_fd;
 
 static volatile int done = 0;
 
@@ -1028,11 +915,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static const char * const stat_usage[] = {
-	"perf stat [<options>] [<command>]",
-	NULL
-};
-
 static int stat__set_big_num(const struct option *opt __maybe_unused,
 			     const char *s __maybe_unused, int unset)
 {
@@ -1040,62 +922,119 @@ static int stat__set_big_num(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static bool append_file;
-
-static const struct option options[] = {
-	OPT_CALLBACK('e', "event", &evsel_list, "event",
-		     "event selector. use 'perf list' to list available events",
-		     parse_events_option),
-	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
-		     "event filter", parse_filter),
-	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
-		    "child tasks do not inherit counters"),
-	OPT_STRING('p', "pid", &target.pid, "pid",
-		   "stat events on existing process id"),
-	OPT_STRING('t', "tid", &target.tid, "tid",
-		   "stat events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
-		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('g', "group", &group,
-		    "put the counters into a counter group"),
-	OPT_BOOLEAN('c', "scale", &scale,
-		    "scale/normalize counters"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show counter open errors, etc)"),
-	OPT_INTEGER('r', "repeat", &run_count,
-		    "repeat command and print average + stddev (max: 100)"),
-	OPT_BOOLEAN('n', "null", &null_run,
-		    "null run - dont start any counters"),
-	OPT_INCR('d', "detailed", &detailed_run,
-		    "detailed run - start a lot of events"),
-	OPT_BOOLEAN('S', "sync", &sync_run,
-		    "call sync() before starting a run"),
-	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
-			   "print large numbers with thousands\' separators",
-			   stat__set_big_num),
-	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
-		    "list of cpus to monitor in system-wide"),
-	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
-		    "disable CPU count aggregation"),
-	OPT_STRING('x', "field-separator", &csv_sep, "separator",
-		   "print counts with custom separator"),
-	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
-		     "monitor event in cgroup name only",
-		     parse_cgroups),
-	OPT_STRING('o', "output", &output_name, "file",
-		    "output file name"),
-	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
-	OPT_INTEGER(0, "log-fd", &output_fd,
-		    "log output to fd, instead of stderr"),
-	OPT_END()
-};
-
 /*
  * Add default attributes, if there were no attributes specified or
  * if -d/--detailed, -d -d or -d -d -d is used:
  */
 static int add_default_attributes(void)
 {
+	struct perf_event_attr default_attrs[] = {
+
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
+
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
+
+};
+
+/*
+ * Detailed stats (-d), covering the L1 and last level data caches:
+ */
+	struct perf_event_attr detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
+/*
+ * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
+ */
+	struct perf_event_attr very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+};
+
+/*
+ * Very, very detailed stats (-d -d -d), adding prefetch events:
+ */
+	struct perf_event_attr very_very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
 	/* Set attrs if no event is selected and !null_run: */
 	if (null_run)
 		return 0;
@@ -1130,8 +1069,59 @@ static int add_default_attributes(void)
 
 int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	bool append_file = false,
+	     sync_run = false;
+	int output_fd = 0;
+	const char *output_name	= NULL;
+	const struct option options[] = {
+	OPT_CALLBACK('e', "event", &evsel_list, "event",
+		     "event selector. use 'perf list' to list available events",
+		     parse_events_option),
+	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
+		     "event filter", parse_filter),
+	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+		    "child tasks do not inherit counters"),
+	OPT_STRING('p', "pid", &target.pid, "pid",
+		   "stat events on existing process id"),
+	OPT_STRING('t', "tid", &target.tid, "tid",
+		   "stat events on existing thread id"),
+	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
+		    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('g', "group", &group,
+		    "put the counters into a counter group"),
+	OPT_BOOLEAN('c', "scale", &scale, "scale/normalize counters"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
+	OPT_INTEGER('r', "repeat", &run_count,
+		    "repeat command and print average + stddev (max: 100)"),
+	OPT_BOOLEAN('n', "null", &null_run,
+		    "null run - dont start any counters"),
+	OPT_INCR('d', "detailed", &detailed_run,
+		    "detailed run - start a lot of events"),
+	OPT_BOOLEAN('S', "sync", &sync_run,
+		    "call sync() before starting a run"),
+	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
+			   "print large numbers with thousands\' separators",
+			   stat__set_big_num),
+	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
+		    "list of cpus to monitor in system-wide"),
+	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
+	OPT_STRING('x', "field-separator", &csv_sep, "separator",
+		   "print counts with custom separator"),
+	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
+		     "monitor event in cgroup name only", parse_cgroups),
+	OPT_STRING('o', "output", &output_name, "file", "output file name"),
+	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
+	OPT_INTEGER(0, "log-fd", &output_fd,
+		    "log output to fd, instead of stderr"),
+	OPT_END()
+	};
+	const char * const stat_usage[] = {
+		"perf stat [<options>] [<command>]",
+		NULL
+	};
 	struct perf_evsel *pos;
-	int status = -ENOMEM;
+	int status = -ENOMEM, run_idx;
 	const char *mode;
 
 	setlocale(LC_ALL, "");
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index b1a8a3b..f251b61 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -38,9 +38,6 @@
 #define PWR_EVENT_EXIT -1
 
 
-static const char	*input_name;
-static const char	*output_name = "output.svg";
-
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
 static u64		max_freq;	/* Highest CPU frequency seen */
@@ -968,16 +965,15 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static struct perf_tool perf_timechart = {
-	.comm			= process_comm_event,
-	.fork			= process_fork_event,
-	.exit			= process_exit_event,
-	.sample			= process_sample_event,
-	.ordered_samples	= true,
-};
-
-static int __cmd_timechart(void)
+static int __cmd_timechart(const char *input_name, const char *output_name)
 {
+	struct perf_tool perf_timechart = {
+		.comm		 = process_comm_event,
+		.fork		 = process_fork_event,
+		.exit		 = process_exit_event,
+		.sample		 = process_sample_event,
+		.ordered_samples = true,
+	};
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &perf_timechart);
 	int ret = -EINVAL;
@@ -1005,40 +1001,25 @@ out_delete:
 	return ret;
 }
 
-static const char * const timechart_usage[] = {
-	"perf timechart [<options>] {record}",
-	NULL
-};
-
-#ifdef SUPPORT_OLD_POWER_EVENTS
-static const char * const record_old_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
-	"-e", "power:power_start",
-	"-e", "power:power_end",
-	"-e", "power:power_frequency",
-	"-e", "sched:sched_wakeup",
-	"-e", "sched:sched_switch",
-};
-#endif
-
-static const char * const record_new_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
-	"-e", "power:cpu_frequency",
-	"-e", "power:cpu_idle",
-	"-e", "sched:sched_wakeup",
-	"-e", "sched:sched_switch",
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
+#ifdef SUPPORT_OLD_POWER_EVENTS
+	const char * const record_old_args[] = {
+		"record", "-a", "-R", "-f", "-c", "1",
+		"-e", "power:power_start",
+		"-e", "power:power_end",
+		"-e", "power:power_frequency",
+		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_switch",
+	};
+#endif
+	const char * const record_new_args[] = {
+		"record", "-a", "-R", "-f", "-c", "1",
+		"-e", "power:cpu_frequency",
+		"-e", "power:cpu_idle",
+		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_switch",
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 	const char * const *record_args = record_new_args;
@@ -1077,27 +1058,28 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
 	return 0;
 }
 
-static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_STRING('o', "output", &output_name, "file",
-		    "output file name"),
-	OPT_INTEGER('w', "width", &svg_page_width,
-		    "page width"),
-	OPT_BOOLEAN('P', "power-only", &power_only,
-		    "output power data only"),
+int cmd_timechart(int argc, const char **argv,
+		  const char *prefix __maybe_unused)
+{
+	const char *input_name;
+	const char *output_name = "output.svg";
+	const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_STRING('o', "output", &output_name, "file", "output file name"),
+	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
+	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_END()
-};
-
+	};
+	const char * const timechart_usage[] = {
+		"perf timechart [<options>] {record}",
+		NULL
+	};
 
-int cmd_timechart(int argc, const char **argv,
-		  const char *prefix __maybe_unused)
-{
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
@@ -1110,5 +1092,5 @@ int cmd_timechart(int argc, const char **argv,
 
 	setup_pager();
 
-	return __cmd_timechart();
+	return __cmd_timechart(input_name, output_name);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e434a16..ff6db80 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -316,7 +316,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->winsize.ws_row - 3);
 	putchar('\n');
-	hists__fprintf(&top->sym_evsel->hists, NULL, false, false,
+	hists__fprintf(&top->sym_evsel->hists, false,
 		       top->winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
@@ -1159,11 +1159,6 @@ setup:
 	return 0;
 }
 
-static const char * const top_usage[] = {
-	"perf top [<options>]",
-	NULL
-};
-
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_evsel *pos;
@@ -1250,6 +1245,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &top.target.uid_str, "user", "user to profile"),
 	OPT_END()
 	};
+	const char * const top_usage[] = {
+		"perf top [<options>]",
+		NULL
+	};
 
 	top.evlist = perf_evlist__new(NULL, NULL);
 	if (top.evlist == NULL)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8f113da..dec8ced 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -114,10 +114,85 @@ static size_t syscall__fprintf_args(struct syscall *sc, unsigned long *args, FIL
 	return printed;
 }
 
+typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+				  struct perf_sample *sample);
+
+static struct syscall *trace__syscall_info(struct trace *trace,
+					   struct perf_evsel *evsel,
+					   struct perf_sample *sample)
+{
+	int id = perf_evsel__intval(evsel, sample, "id");
+
+	if (id < 0) {
+		printf("Invalid syscall %d id, skipping...\n", id);
+		return NULL;
+	}
+
+	if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL) &&
+	    trace__read_syscall_info(trace, id))
+		goto out_cant_read;
+
+	if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL))
+		goto out_cant_read;
+
+	return &trace->syscalls.table[id];
+
+out_cant_read:
+	printf("Problems reading syscall %d information\n", id);
+	return NULL;
+}
+
+static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+			    struct perf_sample *sample)
+{
+	void *args;
+	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+
+	if (sc == NULL)
+		return -1;
+
+	args = perf_evsel__rawptr(evsel, sample, "args");
+	if (args == NULL) {
+		printf("Problems reading syscall arguments\n");
+		return -1;
+	}
+
+	printf("%s(", sc->name);
+	syscall__fprintf_args(sc, args, stdout);
+
+	return 0;
+}
+
+static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
+			   struct perf_sample *sample)
+{
+	int ret;
+	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+
+	if (sc == NULL)
+		return -1;
+
+	ret = perf_evsel__intval(evsel, sample, "ret");
+
+	if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
+		char bf[256];
+		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
+			   *e = audit_errno_to_name(-ret);
+
+		printf(") = -1 %s %s", e, emsg);
+	} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
+		printf(") = 0 Timeout");
+	else
+		printf(") = %d", ret);
+
+	putchar('\n');
+	return 0;
+}
+
 static int trace__run(struct trace *trace)
 {
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel, *evsel_enter, *evsel_exit;
+	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, before;
 
 	if (evlist == NULL) {
@@ -125,22 +200,12 @@ static int trace__run(struct trace *trace)
 		goto out;
 	}
 
-	evsel_enter = perf_evsel__newtp("raw_syscalls", "sys_enter", 0);
-	if (evsel_enter == NULL) {
-		printf("Couldn't read the raw_syscalls:sys_enter tracepoint information!\n");
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__add(evlist, evsel_enter);
-
-	evsel_exit = perf_evsel__newtp("raw_syscalls", "sys_exit", 1);
-	if (evsel_exit == NULL) {
-		printf("Couldn't read the raw_syscalls:sys_exit tracepoint information!\n");
+	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
+	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
+		printf("Couldn't read the raw_syscalls tracepoints information!\n");
 		goto out_delete_evlist;
 	}
 
-	perf_evlist__add(evlist, evsel_exit);
-
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
 		printf("Problems parsing the target to trace, check your options!\n");
@@ -170,9 +235,8 @@ again:
 
 		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
 			const u32 type = event->header.type;
-			struct syscall *sc;
+			tracepoint_handler handler;
 			struct perf_sample sample;
-			int id;
 
 			++nr_events;
 
@@ -200,45 +264,11 @@ again:
 				continue;
 			}
 
-			id = perf_evsel__intval(evsel, &sample, "id");
-			if (id < 0) {
-				printf("Invalid syscall %d id, skipping...\n", id);
-				continue;
-			}
-
-			if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL) &&
-			    trace__read_syscall_info(trace, id))
-				continue;
-
-			if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL))
-				continue;
-
-			sc = &trace->syscalls.table[id];
-
 			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
 				printf("%d ", sample.tid);
 
-			if (evsel == evsel_enter) {
-				void *args = perf_evsel__rawptr(evsel, &sample, "args");
-
-				printf("%s(", sc->name);
-				syscall__fprintf_args(sc, args, stdout);
-			} else if (evsel == evsel_exit) {
-				int ret = perf_evsel__intval(evsel, &sample, "ret");
-
-				if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
-					char bf[256];
-					const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
-						   *e = audit_errno_to_name(-ret);
-
-					printf(") = -1 %s %s", e, emsg);
-				} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
-					printf(") = 0 Timeout");
-				else
-					printf(") = %d", ret);
-
-				putchar('\n');
-			}
+			handler = evsel->handler.func;
+			handler(trace, evsel, &sample);
 		}
 	}
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fc2f770..6d50eb0 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -48,14 +48,14 @@ static struct cmd_struct commands[] = {
 	{ "version",	cmd_version,	0 },
 	{ "script",	cmd_script,	0 },
 	{ "sched",	cmd_sched,	0 },
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 	{ "probe",	cmd_probe,	0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
-#ifndef NO_LIBAUDIT_SUPPORT
+#ifdef LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a21f40b..0568536 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -569,7 +569,8 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 					     struct hist_entry *he)	\
 {									\
-	double percent = 100.0 * he->_field / hpp->total_period;	\
+	struct hists *hists = he->hists;				\
+	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
 	*(double *)hpp->ptr = percent;					\
 	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
@@ -584,7 +585,7 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init(false, false);
+	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
@@ -624,7 +625,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		struct perf_hpp hpp = {
 			.buf		= s,
 			.size		= sizeof(s),
-			.total_period	= browser->hists->stats.total_period,
 		};
 
 		ui_browser__gotorc(&browser->b, row, 0);
@@ -982,7 +982,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 		folded_sign = hist_entry__folded(he);
 
 	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
-	percent = (he->period * 100.0) / browser->hists->stats.total_period;
+	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
 		printed += fprintf(fp, "%c ", folded_sign);
@@ -990,10 +990,10 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	printed += fprintf(fp, " %5.2f%%", percent);
 
 	if (symbol_conf.show_nr_samples)
-		printed += fprintf(fp, " %11u", he->nr_events);
+		printed += fprintf(fp, " %11u", he->stat.nr_events);
 
 	if (symbol_conf.show_total_period)
-		printed += fprintf(fp, " %12" PRIu64, he->period);
+		printed += fprintf(fp, " %12" PRIu64, he->stat.period);
 
 	printed += fprintf(fp, "%s\n", rtrim(s));
 
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 7ff99ec..4125c62 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -49,7 +49,8 @@ static const char *perf_gtk__get_percent_color(double percent)
 static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 					 struct hist_entry *he)			\
 {										\
-	double percent = 100.0 * he->_field / hpp->total_period;		\
+	struct hists *hists = he->hists;					\
+	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
 	const char *markup;							\
 	int ret = 0;								\
 										\
@@ -73,7 +74,7 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init(false, false);
+	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
@@ -102,7 +103,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
-		.total_period	= hists->stats.total_period,
 	};
 
 	nr_cols = 0;
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 8aada5b..ccb046a 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -116,7 +116,7 @@ struct perf_error_ops perf_gtk_eops = {
  * FIXME: Functions below should be implemented properly.
  *        For now, just add stubs for NO_NEWT=1 build.
  */
-#ifdef NO_NEWT_SUPPORT
+#ifndef NEWT_SUPPORT
 void ui_progress__update(u64 curr __maybe_unused, u64 total __maybe_unused,
 			 const char *title __maybe_unused)
 {
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index 2b667ee..baa28a4 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -23,25 +23,25 @@ void ui_helpline__puts(const char *msg);
 
 extern char ui_helpline__current[512];
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
+#else
 static inline int ui_helpline__show_help(const char *format __maybe_unused,
 					 va_list ap __maybe_unused)
 {
 	return 0;
 }
-#else
-extern char ui_helpline__last_msg[];
-int ui_helpline__show_help(const char *format, va_list ap);
-#endif /* NO_NEWT_SUPPORT */
+#endif /* NEWT_SUPPORT */
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef GTK2_SUPPORT
+int perf_gtk__show_helpline(const char *format, va_list ap);
+#else
 static inline int perf_gtk__show_helpline(const char *format __maybe_unused,
 					  va_list ap __maybe_unused)
 {
 	return 0;
 }
-#else
-int perf_gtk__show_helpline(const char *format, va_list ap);
-#endif /* NO_GTK2_SUPPORT */
+#endif /* GTK2_SUPPORT */
 
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e3f8cd4..f5a1e4f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,9 +8,7 @@
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
-	const char *fmt = hpp->ptr ? "Baseline" : "Overhead";
-
-	return scnprintf(hpp->buf, hpp->size, fmt);
+	return scnprintf(hpp->buf, hpp->size, "Overhead");
 }
 
 static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
@@ -20,38 +18,18 @@ static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period / hpp->total_period;
-
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
-
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -69,13 +47,16 @@ static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -95,13 +76,16 @@ static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -120,14 +104,17 @@ static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -146,19 +133,63 @@ static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
+static int hpp__header_baseline(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "Baseline");
+}
+
+static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
+{
+	return 8;
+}
+
+static double baseline_percent(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	struct hists *pair_hists = pair ? pair->hists : NULL;
+	double percent = 0.0;
+
+	if (pair) {
+		u64 total_period = pair_hists->stats.total_period;
+		u64 base_period  = pair->stat.period;
+
+		percent = 100.0 * base_period / total_period;
+	}
+
+	return percent;
+}
+
+static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+}
+
+static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+}
+
 static int hpp__header_samples(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
@@ -175,7 +206,7 @@ static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->nr_events);
+	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
 }
 
 static int hpp__header_period(struct perf_hpp *hpp)
@@ -194,7 +225,7 @@ static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->period);
+	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
 }
 
 static int hpp__header_delta(struct perf_hpp *hpp)
@@ -211,20 +242,22 @@ static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	struct hists *pair_hists = hpp->ptr;
+	struct hist_entry *pair = he->pair;
+	struct hists *pair_hists = pair ? pair->hists : NULL;
+	struct hists *hists = he->hists;
 	u64 old_total, new_total;
 	double old_percent = 0, new_percent = 0;
 	double diff;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
 
-	old_total = pair_hists->stats.total_period;
-	if (old_total > 0 && he->pair)
-		old_percent = 100.0 * he->pair->period / old_total;
+	old_total = pair_hists ? pair_hists->stats.total_period : 0;
+	if (old_total > 0 && pair)
+		old_percent = 100.0 * pair->stat.period / old_total;
 
-	new_total = hpp->total_period;
+	new_total = hists->stats.total_period;
 	if (new_total > 0)
-		new_percent = 100.0 * he->period / new_total;
+		new_percent = 100.0 * he->stat.period / new_total;
 
 	diff = new_percent - old_percent;
 	if (fabs(diff) >= 0.01)
@@ -244,13 +277,15 @@ static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
 }
 
 static int hpp__entry_displ(struct perf_hpp *hpp,
-			    struct hist_entry *he __maybe_unused)
+			    struct hist_entry *he)
 {
+	struct hist_entry *pair = he->pair;
+	long displacement = pair ? pair->position - he->position : 0;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
 	char buf[32] = " ";
 
-	if (hpp->displacement)
-		scnprintf(buf, sizeof(buf), "%+4ld", hpp->displacement);
+	if (displacement)
+		scnprintf(buf, sizeof(buf), "%+4ld", displacement);
 
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
@@ -267,6 +302,7 @@ static int hpp__entry_displ(struct perf_hpp *hpp,
 	.entry	= hpp__entry_ ## _name
 
 struct perf_hpp_fmt perf_hpp__format[] = {
+	{ .cond = false, HPP__COLOR_PRINT_FNS(baseline) },
 	{ .cond = true,  HPP__COLOR_PRINT_FNS(overhead) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_sys) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_us) },
@@ -281,7 +317,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 #undef HPP__COLOR_PRINT_FNS
 #undef HPP__PRINT_FNS
 
-void perf_hpp__init(bool need_pair, bool show_displacement)
+void perf_hpp__init(void)
 {
 	if (symbol_conf.show_cpu_utilization) {
 		perf_hpp__format[PERF_HPP__OVERHEAD_SYS].cond = true;
@@ -298,13 +334,12 @@ void perf_hpp__init(bool need_pair, bool show_displacement)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
+}
 
-	if (need_pair) {
-		perf_hpp__format[PERF_HPP__DELTA].cond = true;
-
-		if (show_displacement)
-			perf_hpp__format[PERF_HPP__DISPL].cond = true;
-	}
+void perf_hpp__column_enable(unsigned col, bool enable)
+{
+	BUG_ON(col >= PERF_HPP__MAX_INDEX);
+	perf_hpp__format[col].cond = enable;
 }
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
@@ -319,6 +354,7 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 	const char *sep = symbol_conf.field_sep;
 	char *start = hpp->buf;
 	int i, ret;
+	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
@@ -327,9 +363,10 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 		if (!perf_hpp__format[i].cond)
 			continue;
 
-		if (!sep || i > 0) {
+		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
+			first = false;
 		}
 
 		if (color && perf_hpp__format[i].color)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index bd7d460..ebb4cc1 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -30,7 +30,7 @@ void setup_browser(bool fallback_to_pager)
 		if (fallback_to_pager)
 			setup_pager();
 
-		perf_hpp__init(false, false);
+		perf_hpp__init();
 		break;
 	}
 }
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 882461a..fbd4e32 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -271,7 +271,7 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 {
 	switch (callchain_param.mode) {
 	case CHAIN_GRAPH_REL:
-		return callchain__fprintf_graph(fp, &he->sorted_chain, he->period,
+		return callchain__fprintf_graph(fp, &he->sorted_chain, he->stat.period,
 						left_margin);
 		break;
 	case CHAIN_GRAPH_ABS:
@@ -292,9 +292,10 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 
 static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 					    struct hists *hists,
-					    u64 total_period, FILE *fp)
+					    FILE *fp)
 {
 	int left_margin = 0;
+	u64 total_period = hists->stats.total_period;
 
 	if (sort__first_dimension == SORT_COMM) {
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
@@ -307,17 +308,13 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 }
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, struct hists *pair_hists,
-			       long displacement, u64 total_period, FILE *fp)
+			       struct hists *hists, FILE *fp)
 {
 	char bf[512];
 	int ret;
 	struct perf_hpp hpp = {
 		.buf		= bf,
 		.size		= size,
-		.total_period	= total_period,
-		.displacement	= displacement,
-		.ptr		= pair_hists,
 	};
 	bool color = !symbol_conf.field_sep;
 
@@ -330,22 +327,17 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	ret = fprintf(fp, "%s\n", bf);
 
 	if (symbol_conf.use_callchain)
-		ret += hist_entry__callchain_fprintf(he, hists,
-						     total_period, fp);
+		ret += hist_entry__callchain_fprintf(he, hists, fp);
 
 	return ret;
 }
 
-size_t hists__fprintf(struct hists *hists, struct hists *pair,
-		      bool show_displacement, bool show_header, int max_rows,
+size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, FILE *fp)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
-	u64 total_period;
-	unsigned long position = 1;
-	long displacement = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
@@ -354,8 +346,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
-		.ptr	= pair,
 	};
+	bool first = true;
 
 	init_rem_hits();
 
@@ -367,8 +359,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		perf_hpp__format[idx].header(&dummy_hpp);
 		fprintf(fp, "%s", bf);
@@ -403,6 +397,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	if (sep)
 		goto print_entries;
 
+	first = true;
+
 	fprintf(fp, "# ");
 	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
 		unsigned int i;
@@ -410,8 +406,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		width = perf_hpp__format[idx].width(&dummy_hpp);
 		for (i = 0; i < width; i++)
@@ -441,24 +439,13 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		goto out;
 
 print_entries:
-	total_period = hists->stats.total_period;
-
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
 			continue;
 
-		if (show_displacement) {
-			if (h->pair != NULL)
-				displacement = ((long)h->pair->position -
-					        (long)position);
-			else
-				displacement = 0;
-			++position;
-		}
-		ret += hist_entry__fprintf(h, max_cols, hists, pair, displacement,
-					   total_period, fp);
+		ret += hist_entry__fprintf(h, max_cols, hists, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
 			goto out;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 9b5b21e..39242dc 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -138,7 +138,10 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+			 void(*timer)(void *arg), void *arg, int delay_secs);
+#else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 				       struct map *map __maybe_unused,
 				       int evidx __maybe_unused,
@@ -148,9 +151,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 {
 	return 0;
 }
-#else
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg, int delay_secs);
 #endif
 
 extern const char	*disassembler_style;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index ab17694..2bd5137 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -33,39 +33,41 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
-static inline void setup_browser(bool fallback_to_pager)
-{
-	if (fallback_to_pager)
-		setup_pager();
-}
-static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
-#else
+#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+int ui__init(void);
+void ui__exit(bool wait_for_ok);
+#else
 static inline int ui__init(void)
 {
 	return -1;
 }
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
-#else
-int ui__init(void);
-void ui__exit(bool wait_for_ok);
 #endif
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef GTK2_SUPPORT
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+#else
 static inline int perf_gtk__init(void)
 {
 	return -1;
 }
 static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#else
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
 #endif
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+
+#else /* NEWT_SUPPORT || GTK2_SUPPORT */
+
+static inline void setup_browser(bool fallback_to_pager)
+{
+	if (fallback_to_pager)
+		setup_pager();
+}
+static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
+#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
@@ -105,7 +107,7 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifdef NO_STRLCPY
+#ifndef HAVE_STRLCPY
 extern size_t strlcpy(char *dest, const char *src, size_t size);
 #endif
 
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 66eb382..03f830b 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,7 +49,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if !defined(NEWT_SUPPORT) && !defined(GTK2_SUPPORT)
 int ui__warning(const char *format, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index bb2e7d1..dec9875 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -15,7 +15,14 @@ void trace_event(union perf_event *event);
 struct ui_progress;
 struct perf_error_ops;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
+
+#include "../ui/progress.h"
+int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
+#include "../ui/util.h"
+
+#else
+
 static inline void ui_progress__update(u64 curr __maybe_unused,
 				       u64 total __maybe_unused,
 				       const char *title __maybe_unused) {}
@@ -34,13 +41,7 @@ perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
 	return 0;
 }
 
-#else /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
-
-#include "../ui/progress.h"
-int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
-#include "../ui/util.h"
-
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
 
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ae89686..186b877 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -154,8 +154,8 @@ error:
 	return -ENOMEM;
 }
 
-int perf_evlist__add_attrs(struct perf_evlist *evlist,
-			   struct perf_event_attr *attrs, size_t nr_attrs)
+static int perf_evlist__add_attrs(struct perf_evlist *evlist,
+				  struct perf_event_attr *attrs, size_t nr_attrs)
 {
 	struct perf_evsel *evsel, *n;
 	LIST_HEAD(head);
@@ -189,60 +189,6 @@ int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
-static int trace_event__id(const char *evname)
-{
-	char *filename, *colon;
-	int err = -1, fd;
-
-	if (asprintf(&filename, "%s/%s/id", tracing_events_path, evname) < 0)
-		return -1;
-
-	colon = strrchr(filename, ':');
-	if (colon != NULL)
-		*colon = '/';
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
-
-int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
-				 const char *tracepoints[],
-				 size_t nr_tracepoints)
-{
-	int err;
-	size_t i;
-	struct perf_event_attr *attrs = zalloc(nr_tracepoints * sizeof(*attrs));
-
-	if (attrs == NULL)
-		return -1;
-
-	for (i = 0; i < nr_tracepoints; i++) {
-		err = trace_event__id(tracepoints[i]);
-
-		if (err < 0)
-			goto out_free_attrs;
-
-		attrs[i].type	       = PERF_TYPE_TRACEPOINT;
-		attrs[i].config	       = err;
-	        attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
-					  PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD);
-		attrs[i].sample_period = 1;
-	}
-
-	err = perf_evlist__add_attrs(evlist, attrs, nr_tracepoints);
-out_free_attrs:
-	free(attrs);
-	return err;
-}
-
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 {
@@ -257,32 +203,18 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 	return NULL;
 }
 
-int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
-					  const struct perf_evsel_str_handler *assocs,
-					  size_t nr_assocs)
+int perf_evlist__add_newtp(struct perf_evlist *evlist,
+			   const char *sys, const char *name, void *handler)
 {
 	struct perf_evsel *evsel;
-	int err;
-	size_t i;
-
-	for (i = 0; i < nr_assocs; i++) {
-		err = trace_event__id(assocs[i].name);
-		if (err < 0)
-			goto out;
-
-		evsel = perf_evlist__find_tracepoint_by_id(evlist, err);
-		if (evsel == NULL)
-			continue;
 
-		err = -EEXIST;
-		if (evsel->handler.func != NULL)
-			goto out;
-		evsel->handler.func = assocs[i].handler;
-	}
+	evsel = perf_evsel__newtp(sys, name, evlist->nr_entries);
+	if (evsel == NULL)
+		return -1;
 
-	err = 0;
-out:
-	return err;
+	evsel->handler.func = handler;
+	perf_evlist__add(evlist, evsel);
+	return 0;
 }
 
 void perf_evlist__disable(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 3f1fb66..56003f7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -51,26 +51,14 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
-int perf_evlist__add_attrs(struct perf_evlist *evlist,
-			   struct perf_event_attr *attrs, size_t nr_attrs);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
-int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
-				 const char *tracepoints[], size_t nr_tracepoints);
-int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
-					  const struct perf_evsel_str_handler *assocs,
-					  size_t nr_assocs);
-
-#define perf_evlist__add_attrs_array(evlist, array) \
-	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
+
 #define perf_evlist__add_default_attrs(evlist, array) \
 	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
-#define perf_evlist__add_tracepoints_array(evlist, array) \
-	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
-
-#define perf_evlist__set_tracepoints_handlers_array(evlist, array) \
-	perf_evlist__set_tracepoints_handlers(evlist, array, ARRAY_SIZE(array))
+int perf_evlist__add_newtp(struct perf_evlist *evlist,
+			   const char *sys, const char *name, void *handler);
 
 int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
 
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 389590c..3ac3803 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -22,7 +22,7 @@ do
      }' "Documentation/perf-$cmd.txt"
 done
 
-echo "#ifndef NO_LIBELF_SUPPORT"
+echo "#ifdef LIBELF_SUPPORT"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
@@ -35,5 +35,5 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
-echo "#endif /* NO_LIBELF_SUPPORT */"
+echo "#endif /* LIBELF_SUPPORT */"
 echo "};"
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 236bc9d..277947a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -135,31 +135,47 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->period_sys += period;
+		he->stat.period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->period_us += period;
+		he->stat.period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->period_guest_sys += period;
+		he->stat.period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->period_guest_us += period;
+		he->stat.period_guest_us += period;
 		break;
 	default:
 		break;
 	}
 }
 
+static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+{
+	he_stat->period		+= period;
+	he_stat->nr_events	+= 1;
+}
+
+static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
+{
+	dest->period		+= src->period;
+	dest->period_sys	+= src->period_sys;
+	dest->period_us		+= src->period_us;
+	dest->period_guest_sys	+= src->period_guest_sys;
+	dest->period_guest_us	+= src->period_guest_us;
+	dest->nr_events		+= src->nr_events;
+}
+
 static void hist_entry__decay(struct hist_entry *he)
 {
-	he->period = (he->period * 7) / 8;
-	he->nr_events = (he->nr_events * 7) / 8;
+	he->stat.period = (he->stat.period * 7) / 8;
+	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
-	u64 prev_period = he->period;
+	u64 prev_period = he->stat.period;
 
 	if (prev_period == 0)
 		return true;
@@ -167,9 +183,9 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	hist_entry__decay(he);
 
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->period;
+		hists->stats.total_period -= prev_period - he->stat.period;
 
-	return he->period == 0;
+	return he->stat.period == 0;
 }
 
 static void __hists__decay_entries(struct hists *hists, bool zap_user,
@@ -223,7 +239,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (he != NULL) {
 		*he = *template;
-		he->nr_events = 1;
+
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
@@ -238,7 +254,7 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->period;
+		hists->stats.total_period += h->stat.period;
 	}
 }
 
@@ -270,8 +286,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he->period += period;
-			++he->nr_events;
+			he_stat__add_period(&he->stat, period);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -321,10 +336,14 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.cpu	= al->cpu,
 		.ip	= bi->to.addr,
 		.level	= al->level,
-		.period	= period,
+		.stat = {
+			.period	= period,
+			.nr_events = 1,
+		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
+		.hists	= self,
 	};
 
 	return add_hist_entry(self, &entry, al, period);
@@ -343,9 +362,13 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.cpu	= al->cpu,
 		.ip	= al->addr,
 		.level	= al->level,
-		.period	= period,
+		.stat = {
+			.period	= period,
+			.nr_events = 1,
+		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
+		.hists	= self,
 	};
 
 	return add_hist_entry(self, &entry, al, period);
@@ -410,12 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->period		+= he->period;
-			iter->period_sys	+= he->period_sys;
-			iter->period_us		+= he->period_us;
-			iter->period_guest_sys	+= he->period_guest_sys;
-			iter->period_guest_us	+= he->period_guest_us;
-			iter->nr_events		+= he->nr_events;
+			he_stat__add_stat(&iter->stat, &he->stat);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
@@ -518,7 +536,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->period > iter->period)
+		if (he->stat.period > iter->stat.period)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -579,8 +597,8 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->ms.unfolded)
 		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_period += h->period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+	hists->stats.total_period += h->stat.period;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f011ad4..66cb31f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,9 +98,8 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
-size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, bool show_header,
-		      int max_rows, int max_cols, FILE *fp);
+size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
+		      int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
@@ -118,9 +117,7 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 struct perf_hpp {
 	char *buf;
 	size_t size;
-	u64 total_period;
 	const char *sep;
-	long displacement;
 	void *ptr;
 };
 
@@ -135,6 +132,7 @@ struct perf_hpp_fmt {
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
+	PERF_HPP__BASELINE,
 	PERF_HPP__OVERHEAD,
 	PERF_HPP__OVERHEAD_SYS,
 	PERF_HPP__OVERHEAD_US,
@@ -148,13 +146,22 @@ enum {
 	PERF_HPP__MAX_INDEX
 };
 
-void perf_hpp__init(bool need_pair, bool show_displacement);
+void perf_hpp__init(void);
+void perf_hpp__column_enable(unsigned col, bool enable);
 int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 				bool color);
 
 struct perf_evlist;
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+#include "../ui/keysyms.h"
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+			     void(*timer)(void *arg), void *arg, int delay_secs);
+
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
@@ -177,17 +184,13 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 }
 #define K_LEFT -1
 #define K_RIGHT -2
-#else
-#include "../ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
-			     void(*timer)(void *arg), void *arg, int delay_secs);
+#endif
 
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+#ifdef GTK2_SUPPORT
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int refresh);
-#endif
-
-#ifdef NO_GTK2_SUPPORT
+#else
 static inline
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
@@ -197,11 +200,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 {
 	return 0;
 }
-
-#else
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int refresh);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ead5316..6109fa4 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -162,7 +162,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 443fc11..2bc9e70 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -384,6 +384,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			return usage_with_options_internal(usagestr, options, 1);
 		if (internal_help && !strcmp(arg + 2, "help"))
 			return parse_options_usage(usagestr, options);
+		if (!strcmp(arg + 2, "list-opts"))
+			return PARSE_OPT_LIST;
 		switch (parse_long_opt(ctx, arg + 2, options)) {
 		case -1:
 			return parse_options_usage(usagestr, options);
@@ -422,6 +424,12 @@ int parse_options(int argc, const char **argv, const struct option *options,
 		exit(129);
 	case PARSE_OPT_DONE:
 		break;
+	case PARSE_OPT_LIST:
+		while (options->type != OPTION_END) {
+			printf("--%s ", options->long_name);
+			options++;
+		}
+		exit(130);
 	default: /* PARSE_OPT_UNKNOWN */
 		if (ctx.argv[0][1] == '-') {
 			error("unknown option `%s'", ctx.argv[0] + 2);
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index abc31a1..7bb5999 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -140,6 +140,7 @@ extern NORETURN void usage_with_options(const char * const *usagestr,
 enum {
 	PARSE_OPT_HELP = -1,
 	PARSE_OPT_DONE,
+	PARSE_OPT_LIST,
 	PARSE_OPT_UNKNOWN,
 };
 
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index bd74977..a8c4954 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,7 +22,7 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
-#ifdef NO_STRLCPY
+#ifndef HAVE_STRLCPY
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 316dbe7..5a4f2b6f 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#ifndef NO_PERF_REGS
+#ifdef HAVE_PERF_REGS
 #include <perf_regs.h>
 #else
 #define PERF_REGS_MASK	0
@@ -10,5 +10,5 @@ static inline const char *perf_reg_name(int id __maybe_unused)
 {
 	return NULL;
 }
-#endif /* NO_PERF_REGS */
+#endif /* HAVE_PERF_REGS */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 12d6347..5786f32 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -43,6 +43,15 @@ extern struct sort_entry sort_sym_from;
 extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
+struct he_stat {
+	u64			period;
+	u64			period_sys;
+	u64			period_us;
+	u64			period_guest_sys;
+	u64			period_guest_us;
+	u32			nr_events;
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -52,16 +61,11 @@ extern enum sort_type sort__first_dimension;
 struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
-	u64			period;
-	u64			period_sys;
-	u64			period_us;
-	u64			period_guest_sys;
-	u64			period_guest_us;
+	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
 	s32			cpu;
-	u32			nr_events;
 
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
@@ -73,12 +77,13 @@ struct hist_entry {
 	u8			filtered;
 	char			*srcline;
 	struct symbol		*parent;
+	unsigned long		position;
 	union {
-		unsigned long	  position;
 		struct hist_entry *pair;
 		struct rb_root	  sorted_chain;
 	};
 	struct branch_info	*branch_info;
+	struct hists		*hists;
 	struct callchain_root	callchain[0];
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b441b07..8b6ef7f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,7 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
@@ -46,10 +46,10 @@ char *strxfrchar(char *s, char from, char to);
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef LIBELF_NO_MMAP
-# define PERF_ELF_C_READ_MMAP ELF_C_READ
-#else
+#ifdef LIBELF_MMAP
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
+#else
+# define PERF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
 #ifndef DMGL_PARAMS
@@ -233,7 +233,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index a78c8b3..cb6bc50 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -13,7 +13,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -31,5 +31,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 #endif /* __UNWIND_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2055cf3..9966459 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,7 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
-#ifndef NO_BACKTRACE
+#ifdef BACKTRACE_SUPPORT
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -165,7 +165,7 @@ size_t hex_width(u64 v)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifndef NO_BACKTRACE
+#ifdef BACKTRACE_SUPPORT
 void dump_stack(void)
 {
 	void *array[16];
