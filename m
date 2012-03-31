Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2CaIie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 04:38:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57460 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2CaIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 04:38:22 -0400
Date: Sat, 31 Mar 2012 10:38:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates and fixes
Message-ID: <20120331083814.GA12415@gmail.com>
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

   HEAD: 8ebfdf2babcda5a3b06cc67523bca1f9aed46009 Merge branch 'perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

It's mostly fixes, but there's also two late items:

 - preliminary GTK GUI support for perf report
 - PMU raw event format descriptors in sysfs, to be parsed by tooling

The raw event format in sysfs is a new ABI. For example for the 
'CPU' PMU we have:

aldebaran:~> ll /sys/bus/event_source/devices/cpu/format/*
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/any
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/cmask
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/edge
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/event
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/inv
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/offcore_rsp
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/pc
-r--r--r--. 1 root root 4096 Mar 31 10:29 /sys/bus/event_source/devices/cpu/format/umask

those lists of fields contain a specific format:

aldebaran:~> cat /sys/bus/event_source/devices/cpu/format/offcore_rsp
config1:0-63

So, those who wish to specify raw events can now use the 
following event format:

   -e cpu/cmask=1,event=2,umask=3

Most people will not want to specify any events (let alone raw 
events), they'll just use whatever default event the tools use. 

But for more obscure PMU events that have no cross-architecture 
generic events the above syntax is more usable and a bit more 
structured than specifying hex numbers.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf annotate: Fix off by one symbol hist size allocation and hit accounting

Borislav Petkov (1):
      perf tools: Simplify event_read_id exit path

David Miller (3):
      perf symbols: Do not include libgen.h
      perf symbols: Handle NULL dso in dso__name_len
      perf annotate: addr2line wants addresses in same format as objdump

Frederic Weisbecker (1):
      perf tools: Fix display of first level of callchains

Gerlando Falauto (1):
      tracing: Do not select FRAME_POINTER on PPC

Ingo Molnar (1):
      perf tools: Remove auto-generated bison/flex files

Jan Beulich (1):
      perf tools: Adjust make rules

Jiri Olsa (11):
      perf: Add ifdef to remove unused enum switch warnings
      perf: Adding sysfs group format attribute for pmu device
      perf tools: Add parser generator for events parsing
      perf tools: Add config options support for event parsing
      perf tools: Add perf pmu object to access pmu format definition
      perf tools: Add support to specify pmu style event
      perf tools: Fix various casting issues for 32 bits
      perf tools: Fix modifier to be applied on correct events
      perf diff: Fix to work with new hists design
      perf: Move mmap page data_head offset assertion out of header
      perf tools: Switch module.h into export.h

Mark Brown (1):
      tracing: Fix build breakage without CONFIG_PERF_EVENTS

Namhyung Kim (10):
      perf stat: Fix event grouping on forked task
      perf tools: Do not disable members of group event
      perf hists: Add hists__filter_by_symbol
      perf ui browser: Introduce ui_browser__input_window
      perf ui browser: Add 's' key to filter by symbol name
      perf report: Add --symbol-filter option
      perf report: Treat an argument as a symbol filter
      perf ui browser: Clean lines inside of the input window
      perf report: Document --symbol-filter option
      perf tools: Add missing ref-cycles event back to event parser

Pekka Enberg (1):
      perf report: Add a simple GTK2-based 'perf report' browser

Peter Zijlstra (1):
      perf: Fix mmap_page capabilities and docs

Prashanth Nageshappa (1):
      perf probe: Finder fails to resolve function name to address

Rajesh Bhagat (1):
      ftrace: Fix function_graph for archs that test ftrace_trace_function

Stephane Eranian (1):
      perf tools: Fix bug in raw sample parsing

Steven Rostedt (4):
      tracing/ring-buffer: Only have tracing_on disable tracing buffers
      tracing: Keep NMI watchdog from triggering when dumping trace
      tracing: Move the tracing_on/off() declarations into CONFIG_TRACING
      tracing: Fix ent_size in trace output

Wolfgang Mauerer (1):
      tracing: Fix ftrace stack trace entries


 .../testing/sysfs-bus-event_source-devices-format  |   14 +
 arch/x86/kernel/cpu/perf_event.c                   |   17 +-
 arch/x86/kernel/cpu/perf_event.h                   |    1 +
 arch/x86/kernel/cpu/perf_event_amd.c               |   18 +
 arch/x86/kernel/cpu/perf_event_intel.c             |   36 ++
 arch/x86/kernel/cpu/perf_event_p6.c                |   19 +
 include/linux/ftrace_event.h                       |    2 +
 include/linux/kernel.h                             |   15 +-
 include/linux/perf_event.h                         |   90 +++-
 include/linux/ring_buffer.h                        |    3 +
 kernel/events/core.c                               |   11 +-
 kernel/trace/Kconfig                               |    2 +-
 kernel/trace/ftrace.c                              |    3 +-
 kernel/trace/ring_buffer.c                         |  157 ++----
 kernel/trace/trace.c                               |  113 ++++
 kernel/trace/trace.h                               |    3 +-
 kernel/trace/trace_entries.h                       |   16 +-
 kernel/trace/trace_export.c                        |    2 +-
 tools/perf/Documentation/perf-report.txt           |    5 +
 tools/perf/Makefile                                |   66 ++-
 tools/perf/builtin-diff.c                          |   60 ++-
 tools/perf/builtin-report.c                        |   40 +-
 tools/perf/builtin-stat.c                          |    2 +-
 tools/perf/builtin-test.c                          |  174 ++++++-
 tools/perf/config/feature-tests.mak                |   15 +
 tools/perf/util/annotate.c                         |    8 +-
 tools/perf/util/cache.h                            |   12 +
 tools/perf/util/evlist.c                           |    6 +-
 tools/perf/util/evsel.c                            |   10 +-
 tools/perf/util/evsel.h                            |    5 +-
 tools/perf/util/gtk/browser.c                      |  189 ++++++
 tools/perf/util/gtk/gtk.h                          |    8 +
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/hist.c                             |  200 +++++---
 tools/perf/util/hist.h                             |   19 +
 .../perf/util/include/linux/{module.h => export.h} |    0
 tools/perf/util/parse-events.c                     |  603 +++++++++-----------
 tools/perf/util/parse-events.h                     |   49 ++
 tools/perf/util/parse-events.l                     |  127 ++++
 tools/perf/util/parse-events.y                     |  229 ++++++++
 tools/perf/util/pmu.c                              |  469 +++++++++++++++
 tools/perf/util/pmu.h                              |   41 ++
 tools/perf/util/pmu.l                              |   43 ++
 tools/perf/util/pmu.y                              |   93 +++
 tools/perf/util/probe-finder.c                     |    4 +-
 tools/perf/util/session.c                          |    1 +
 tools/perf/util/symbol.c                           |    3 +-
 tools/perf/util/trace-event-parse.c                |   10 +-
 tools/perf/util/ui/browser.h                       |    2 +
 tools/perf/util/ui/browsers/hists.c                |   14 +-
 tools/perf/util/ui/keysyms.h                       |    2 +
 tools/perf/util/ui/util.c                          |   82 +++
 52 files changed, 2531 insertions(+), 584 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-format
 create mode 100644 tools/perf/util/gtk/browser.c
 create mode 100644 tools/perf/util/gtk/gtk.h
 rename tools/perf/util/include/linux/{module.h => export.h} (100%)
 create mode 100644 tools/perf/util/parse-events.l
 create mode 100644 tools/perf/util/parse-events.y
 create mode 100644 tools/perf/util/pmu.c
 create mode 100644 tools/perf/util/pmu.h
 create mode 100644 tools/perf/util/pmu.l
 create mode 100644 tools/perf/util/pmu.y

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
new file mode 100644
index 0000000..079afc7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -0,0 +1,14 @@
+Where:		/sys/bus/event_source/devices/<dev>/format
+Date:		January 2012
+Kernel Version: 3.3
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Attribute group to describe the magic bits that go into
+		perf_event_attr::config[012] for a particular pmu.
+		Each attribute of this group defines the 'hardware' bitmask
+		we want to export, so that userspace can deal with sane
+		name/value pairs.
+
+		Example: 'config1:1,6-10,44'
+		Defines contents of attribute that occupies bits 1,6-10,44 of
+		perf_event_attr::config1.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fa2900c..f02672a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1314,6 +1314,11 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
+static struct attribute_group x86_pmu_format_group = {
+	.name = "format",
+	.attrs = NULL,
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1388,6 +1393,7 @@ static int __init init_hw_perf_events(void)
 	}
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
@@ -1616,6 +1622,9 @@ static int x86_pmu_event_idx(struct perf_event *event)
 {
 	int idx = event->hw.idx;
 
+	if (!x86_pmu.attr_rdpmc)
+		return 0;
+
 	if (x86_pmu.num_counters_fixed && idx >= X86_PMC_IDX_FIXED) {
 		idx -= X86_PMC_IDX_FIXED;
 		idx |= 1 << 30;
@@ -1668,6 +1677,7 @@ static struct attribute_group x86_pmu_attr_group = {
 
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
+	&x86_pmu_format_group,
 	NULL,
 };
 
@@ -1699,14 +1709,19 @@ static struct pmu pmu = {
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
-void perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
+	userpg->cap_usr_time = 0;
+	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->pmc_width = x86_pmu.cntval_bits;
+
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return;
 
 	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 		return;
 
+	userpg->cap_usr_time = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8484e77..6638aaf 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -339,6 +339,7 @@ struct x86_pmu {
 	 * sysfs attrs
 	 */
 	int		attr_rdpmc;
+	struct attribute **format_attrs;
 
 	/*
 	 * CPU Hotplug hooks
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index dd002fa..95e7fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -404,6 +404,21 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *amd_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -426,6 +441,8 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
+	.format_attrs		= amd_format_attr,
+
 	.cpu_prepare		= amd_pmu_cpu_prepare,
 	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
@@ -596,6 +613,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 #endif
 	.cpu_starting		= amd_pmu_cpu_starting,
+	.format_attrs		= amd_format_attr,
 };
 
 __init int amd_pmu_init(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6a84e7f..26b3e2f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1431,6 +1431,24 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_arch_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -1455,6 +1473,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 	.guest_get_msrs		= core_guest_get_msrs,
+	.format_attrs		= intel_arch_formats_attr,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1553,6 +1572,21 @@ static void intel_pmu_flush_branch_stack(void)
 		intel_pmu_lbr_reset();
 }
 
+PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
+
+static struct attribute *intel_arch3_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_any.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+
+	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	NULL,
+};
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1576,6 +1610,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 
+	.format_attrs		= intel_arch3_formats_attr,
+
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index c7181be..32bcfc7 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -87,6 +87,23 @@ static void p6_pmu_enable_event(struct perf_event *event)
 	(void)checking_wrmsrl(hwc->config_base, val);
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_p6_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -115,6 +132,8 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= p6_event_constraints,
+
+	.format_attrs		= intel_p6_formats_attr,
 };
 
 __init int p6_pmu_init(void)
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dd478fc..5f3f3be 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,12 +144,14 @@ struct event_filter;
 enum trace_reg {
 	TRACE_REG_REGISTER,
 	TRACE_REG_UNREGISTER,
+#ifdef CONFIG_PERF_EVENTS
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
 	TRACE_REG_PERF_ADD,
 	TRACE_REG_PERF_DEL,
+#endif
 };
 
 struct ftrace_event_call;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5db52d0..92c1026 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -428,16 +428,10 @@ extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
  * Most likely, you want to use tracing_on/tracing_off.
  */
 #ifdef CONFIG_RING_BUFFER
-void tracing_on(void);
-void tracing_off(void);
 /* trace_off_permanent stops recording with no way to bring it back */
 void tracing_off_permanent(void);
-int tracing_is_on(void);
 #else
-static inline void tracing_on(void) { }
-static inline void tracing_off(void) { }
 static inline void tracing_off_permanent(void) { }
-static inline int tracing_is_on(void) { return 0; }
 #endif
 
 enum ftrace_dump_mode {
@@ -447,6 +441,10 @@ enum ftrace_dump_mode {
 };
 
 #ifdef CONFIG_TRACING
+void tracing_on(void);
+void tracing_off(void);
+int tracing_is_on(void);
+
 extern void tracing_start(void);
 extern void tracing_stop(void);
 extern void ftrace_off_permanent(void);
@@ -531,6 +529,11 @@ static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
 static inline void trace_dump_stack(void) { }
+
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline int tracing_is_on(void) { return 0; }
+
 static inline int
 trace_printk(const char *fmt, ...)
 {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bd9f55a..ddbb6a9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -299,18 +299,31 @@ struct perf_event_mmap_page {
 	/*
 	 * Bits needed to read the hw events in user-space.
 	 *
-	 *   u32 seq;
-	 *   s64 count;
+	 *   u32 seq, time_mult, time_shift, idx, width;
+	 *   u64 count, enabled, running;
+	 *   u64 cyc, time_offset;
+	 *   s64 pmc = 0;
 	 *
 	 *   do {
 	 *     seq = pc->lock;
-	 *
 	 *     barrier()
-	 *     if (pc->index) {
-	 *       count = pmc_read(pc->index - 1);
-	 *       count += pc->offset;
-	 *     } else
-	 *       goto regular_read;
+	 *
+	 *     enabled = pc->time_enabled;
+	 *     running = pc->time_running;
+	 *
+	 *     if (pc->cap_usr_time && enabled != running) {
+	 *       cyc = rdtsc();
+	 *       time_offset = pc->time_offset;
+	 *       time_mult   = pc->time_mult;
+	 *       time_shift  = pc->time_shift;
+	 *     }
+	 *
+	 *     idx = pc->index;
+	 *     count = pc->offset;
+	 *     if (pc->cap_usr_rdpmc && idx) {
+	 *       width = pc->pmc_width;
+	 *       pmc = rdpmc(idx - 1);
+	 *     }
 	 *
 	 *     barrier();
 	 *   } while (pc->lock != seq);
@@ -323,14 +336,57 @@ struct perf_event_mmap_page {
 	__s64	offset;			/* add to hardware event value */
 	__u64	time_enabled;		/* time event active */
 	__u64	time_running;		/* time event on cpu */
-	__u32	time_mult, time_shift;
+	union {
+		__u64	capabilities;
+		__u64	cap_usr_time  : 1,
+			cap_usr_rdpmc : 1,
+			cap_____res   : 62;
+	};
+
+	/*
+	 * If cap_usr_rdpmc this field provides the bit-width of the value
+	 * read using the rdpmc() or equivalent instruction. This can be used
+	 * to sign extend the result like:
+	 *
+	 *   pmc <<= 64 - width;
+	 *   pmc >>= 64 - width; // signed shift right
+	 *   count += pmc;
+	 */
+	__u16	pmc_width;
+
+	/*
+	 * If cap_usr_time the below fields can be used to compute the time
+	 * delta since time_enabled (in ns) using rdtsc or similar.
+	 *
+	 *   u64 quot, rem;
+	 *   u64 delta;
+	 *
+	 *   quot = (cyc >> time_shift);
+	 *   rem = cyc & ((1 << time_shift) - 1);
+	 *   delta = time_offset + quot * time_mult +
+	 *              ((rem * time_mult) >> time_shift);
+	 *
+	 * Where time_offset,time_mult,time_shift and cyc are read in the
+	 * seqcount loop described above. This delta can then be added to
+	 * enabled and possible running (if idx), improving the scaling:
+	 *
+	 *   enabled += delta;
+	 *   if (idx)
+	 *     running += delta;
+	 *
+	 *   quot = count / running;
+	 *   rem  = count % running;
+	 *   count = quot * enabled + (rem * enabled) / running;
+	 */
+	__u16	time_shift;
+	__u32	time_mult;
 	__u64	time_offset;
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[121];	/* align to 1k */
+	__u64	__reserved[120];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -550,6 +606,7 @@ struct perf_guest_info_callbacks {
 #include <linux/irq_work.h>
 #include <linux/static_key.h>
 #include <linux/atomic.h>
+#include <linux/sysfs.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -1291,5 +1348,18 @@ do {									\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
+
+#define PMU_FORMAT_ATTR(_name, _format)					\
+static ssize_t								\
+_name##_show(struct device *dev,					\
+			       struct device_attribute *attr,		\
+			       char *page)				\
+{									\
+	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);			\
+	return sprintf(page, _format "\n");				\
+}									\
+									\
+static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 67be037..7be2e88 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -151,6 +151,9 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
 
 void ring_buffer_record_disable(struct ring_buffer *buffer);
 void ring_buffer_record_enable(struct ring_buffer *buffer);
+void ring_buffer_record_off(struct ring_buffer *buffer);
+void ring_buffer_record_on(struct ring_buffer *buffer);
+int ring_buffer_record_is_on(struct ring_buffer *buffer);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4b50357..a6a9ec4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3348,7 +3348,7 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
-void __weak perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
 
@@ -3398,7 +3398,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
-	perf_update_user_clock(userpg, now);
+	arch_perf_update_userpage(userpg, now);
 
 	barrier();
 	++userpg->lock;
@@ -7116,6 +7116,13 @@ void __init perf_event_init(void)
 
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
+
+	/*
+	 * Build time assertion that we keep the data_head at the intended
+	 * location.  IOW, validation we got the __reserved[] size right.
+	 */
+	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
+		     != 1024);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..a1d2849 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 867bd1d..0fa92f6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -249,7 +249,8 @@ static void update_ftrace_function(void)
 #else
 	__ftrace_trace_function = func;
 #endif
-	ftrace_trace_function = ftrace_test_stop_func;
+	ftrace_trace_function =
+		(func == ftrace_stub) ? func : ftrace_test_stop_func;
 #endif
 }
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f5b7b5c..cf8d11e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -154,33 +154,10 @@ enum {
 
 static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
-#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
-
-/**
- * tracing_on - enable all tracing buffers
- *
- * This function enables all tracing buffers that may have been
- * disabled with tracing_off.
- */
-void tracing_on(void)
-{
-	set_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
-}
-EXPORT_SYMBOL_GPL(tracing_on);
+/* Used for individual buffers (after the counter) */
+#define RB_BUFFER_OFF		(1 << 20)
 
-/**
- * tracing_off - turn off all tracing buffers
- *
- * This function stops all tracing buffers from recording data.
- * It does not disable any overhead the tracers themselves may
- * be causing. This function simply causes all recording to
- * the ring buffers to fail.
- */
-void tracing_off(void)
-{
-	clear_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
-}
-EXPORT_SYMBOL_GPL(tracing_off);
+#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
 
 /**
  * tracing_off_permanent - permanently disable ring buffers
@@ -193,15 +170,6 @@ void tracing_off_permanent(void)
 	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
 }
 
-/**
- * tracing_is_on - show state of ring buffers enabled
- */
-int tracing_is_on(void)
-{
-	return ring_buffer_flags == RB_BUFFERS_ON;
-}
-EXPORT_SYMBOL_GPL(tracing_is_on);
-
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
@@ -2619,6 +2587,63 @@ void ring_buffer_record_enable(struct ring_buffer *buffer)
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
 
 /**
+ * ring_buffer_record_off - stop all writes into the buffer
+ * @buffer: The ring buffer to stop writes to.
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ *
+ * This is different than ring_buffer_record_disable() as
+ * it works like an on/off switch, where as the disable() verison
+ * must be paired with a enable().
+ */
+void ring_buffer_record_off(struct ring_buffer *buffer)
+{
+	unsigned int rd;
+	unsigned int new_rd;
+
+	do {
+		rd = atomic_read(&buffer->record_disabled);
+		new_rd = rd | RB_BUFFER_OFF;
+	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) != rd);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_record_off);
+
+/**
+ * ring_buffer_record_on - restart writes into the buffer
+ * @buffer: The ring buffer to start writes to.
+ *
+ * This enables all writes to the buffer that was disabled by
+ * ring_buffer_record_off().
+ *
+ * This is different than ring_buffer_record_enable() as
+ * it works like an on/off switch, where as the enable() verison
+ * must be paired with a disable().
+ */
+void ring_buffer_record_on(struct ring_buffer *buffer)
+{
+	unsigned int rd;
+	unsigned int new_rd;
+
+	do {
+		rd = atomic_read(&buffer->record_disabled);
+		new_rd = rd & ~RB_BUFFER_OFF;
+	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) != rd);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_record_on);
+
+/**
+ * ring_buffer_record_is_on - return true if the ring buffer can write
+ * @buffer: The ring buffer to see if write is enabled
+ *
+ * Returns true if the ring buffer is in a state that it accepts writes.
+ */
+int ring_buffer_record_is_on(struct ring_buffer *buffer)
+{
+	return !atomic_read(&buffer->record_disabled);
+}
+
+/**
  * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
  * @buffer: The ring buffer to stop writes to.
  * @cpu: The CPU buffer to stop
@@ -4039,68 +4064,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
-#ifdef CONFIG_TRACING
-static ssize_t
-rb_simple_read(struct file *filp, char __user *ubuf,
-	       size_t cnt, loff_t *ppos)
-{
-	unsigned long *p = filp->private_data;
-	char buf[64];
-	int r;
-
-	if (test_bit(RB_BUFFERS_DISABLED_BIT, p))
-		r = sprintf(buf, "permanently disabled\n");
-	else
-		r = sprintf(buf, "%d\n", test_bit(RB_BUFFERS_ON_BIT, p));
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-rb_simple_write(struct file *filp, const char __user *ubuf,
-		size_t cnt, loff_t *ppos)
-{
-	unsigned long *p = filp->private_data;
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
-	if (ret)
-		return ret;
-
-	if (val)
-		set_bit(RB_BUFFERS_ON_BIT, p);
-	else
-		clear_bit(RB_BUFFERS_ON_BIT, p);
-
-	(*ppos)++;
-
-	return cnt;
-}
-
-static const struct file_operations rb_simple_fops = {
-	.open		= tracing_open_generic,
-	.read		= rb_simple_read,
-	.write		= rb_simple_write,
-	.llseek		= default_llseek,
-};
-
-
-static __init int rb_init_debugfs(void)
-{
-	struct dentry *d_tracer;
-
-	d_tracer = tracing_init_dentry();
-
-	trace_create_file("tracing_on", 0644, d_tracer,
-			    &ring_buffer_flags, &rb_simple_fops);
-
-	return 0;
-}
-
-fs_initcall(rb_init_debugfs);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 static int rb_cpu_notify(struct notifier_block *self,
 			 unsigned long action, void *hcpu)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 10d5503..ed7b5d1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -36,6 +36,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/nmi.h>
 #include <linux/fs.h>
 
 #include "trace.h"
@@ -352,6 +353,59 @@ static void wakeup_work_handler(struct work_struct *work)
 static DECLARE_DELAYED_WORK(wakeup_work, wakeup_work_handler);
 
 /**
+ * tracing_on - enable tracing buffers
+ *
+ * This function enables tracing buffers that may have been
+ * disabled with tracing_off.
+ */
+void tracing_on(void)
+{
+	if (global_trace.buffer)
+		ring_buffer_record_on(global_trace.buffer);
+	/*
+	 * This flag is only looked at when buffers haven't been
+	 * allocated yet. We don't really care about the race
+	 * between setting this flag and actually turning
+	 * on the buffer.
+	 */
+	global_trace.buffer_disabled = 0;
+}
+EXPORT_SYMBOL_GPL(tracing_on);
+
+/**
+ * tracing_off - turn off tracing buffers
+ *
+ * This function stops the tracing buffers from recording data.
+ * It does not disable any overhead the tracers themselves may
+ * be causing. This function simply causes all recording to
+ * the ring buffers to fail.
+ */
+void tracing_off(void)
+{
+	if (global_trace.buffer)
+		ring_buffer_record_on(global_trace.buffer);
+	/*
+	 * This flag is only looked at when buffers haven't been
+	 * allocated yet. We don't really care about the race
+	 * between setting this flag and actually turning
+	 * on the buffer.
+	 */
+	global_trace.buffer_disabled = 1;
+}
+EXPORT_SYMBOL_GPL(tracing_off);
+
+/**
+ * tracing_is_on - show state of ring buffers enabled
+ */
+int tracing_is_on(void)
+{
+	if (global_trace.buffer)
+		return ring_buffer_record_is_on(global_trace.buffer);
+	return !global_trace.buffer_disabled;
+}
+EXPORT_SYMBOL_GPL(tracing_is_on);
+
+/**
  * trace_wake_up - wake up tasks waiting for trace input
  *
  * Schedules a delayed work to wake up any task that is blocked on the
@@ -1644,6 +1698,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
+	int next_size = 0;
 	int cpu;
 
 	/*
@@ -1675,9 +1730,12 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 			next_cpu = cpu;
 			next_ts = ts;
 			next_lost = lost_events;
+			next_size = iter->ent_size;
 		}
 	}
 
+	iter->ent_size = next_size;
+
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 
@@ -4567,6 +4625,55 @@ static __init void create_trace_options_dir(void)
 		create_trace_option_core_file(trace_options[i], i);
 }
 
+static ssize_t
+rb_simple_read(struct file *filp, char __user *ubuf,
+	       size_t cnt, loff_t *ppos)
+{
+	struct ring_buffer *buffer = filp->private_data;
+	char buf[64];
+	int r;
+
+	if (buffer)
+		r = ring_buffer_record_is_on(buffer);
+	else
+		r = 0;
+
+	r = sprintf(buf, "%d\n", r);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+rb_simple_write(struct file *filp, const char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	struct ring_buffer *buffer = filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	if (buffer) {
+		if (val)
+			ring_buffer_record_on(buffer);
+		else
+			ring_buffer_record_off(buffer);
+	}
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static const struct file_operations rb_simple_fops = {
+	.open		= tracing_open_generic,
+	.read		= rb_simple_read,
+	.write		= rb_simple_write,
+	.llseek		= default_llseek,
+};
+
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -4626,6 +4733,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("trace_clock", 0644, d_tracer, NULL,
 			  &trace_clock_fops);
 
+	trace_create_file("tracing_on", 0644, d_tracer,
+			    global_trace.buffer, &rb_simple_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -4798,6 +4908,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 			if (ret != TRACE_TYPE_NO_CONSUME)
 				trace_consume(&iter);
 		}
+		touch_nmi_watchdog();
 
 		trace_printk_seq(&iter.seq);
 	}
@@ -4863,6 +4974,8 @@ __init static int tracer_alloc_buffers(void)
 		goto out_free_cpumask;
 	}
 	global_trace.entries = ring_buffer_size(global_trace.buffer);
+	if (global_trace.buffer_disabled)
+		tracing_off();
 
 
 #ifdef CONFIG_TRACER_MAX_TRACE
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54faec7..95059f0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -154,6 +154,7 @@ struct trace_array {
 	struct ring_buffer	*buffer;
 	unsigned long		entries;
 	int			cpu;
+	int			buffer_disabled;
 	cycle_t			time_start;
 	struct task_struct	*waiter;
 	struct trace_array_cpu	*data[NR_CPUS];
@@ -835,13 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_PERF_EVENTS
 #ifdef CONFIG_FUNCTION_TRACER
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
 #endif /* CONFIG_FUNCTION_TRACER */
-#endif /* CONFIG_PERF_EVENTS */
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index d91eb05..4108e12 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -166,6 +166,12 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 
 #define FTRACE_STACK_ENTRIES	8
 
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
 FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	TRACE_STACK,
@@ -175,8 +181,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		__dynamic_array(unsigned long,	caller	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7]),
@@ -193,8 +200,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7]),
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7b46c9b..3dd15e8 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -162,7 +162,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item)
 
 #undef F_printk
-#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+#define F_printk(fmt, args...) __stringify(fmt) ", "  __stringify(args)
 
 #undef FTRACE_ENTRY_REG
 #define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 87feeee..2d89f02 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -48,6 +48,9 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+--symbol-filter=::
+	Only show symbols that match (partially) with this filter.
+
 -U::
 --hide-unresolved::
         Only display entries resolved to a symbol.
@@ -110,6 +113,8 @@ OPTIONS
 	requires a tty, if one is not present, as when piping to other
 	commands, the stdio interface is used.
 
+--gtk:: Use the GTK2 interface.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74fd7f8..820371f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -182,7 +182,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -234,6 +234,25 @@ endif
 
 export PERL_PATH
 
+FLEX = $(CROSS_COMPILE)flex
+BISON= $(CROSS_COMPILE)bison
+
+event-parser:
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+
+$(OUTPUT)util/parse-events-flex.c: event-parser
+$(OUTPUT)util/parse-events-bison.c: event-parser
+
+pmu-parser:
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
+
+$(OUTPUT)util/pmu-flex.c: pmu-parser
+$(OUTPUT)util/pmu-bison.c: pmu-parser
+
+$(OUTPUT)util/parse-events.o: event-parser pmu-parser
+
 LIB_FILE=$(OUTPUT)libperf.a
 
 LIB_H += ../../include/linux/perf_event.h
@@ -249,7 +268,7 @@ LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/module.h
+LIB_H += util/include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
@@ -276,6 +295,7 @@ LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/sysfs.h
+LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
@@ -323,6 +343,7 @@ LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/sysfs.o
+LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
@@ -359,6 +380,10 @@ LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
+LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
+LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
+LIB_OBJS += $(OUTPUT)util/pmu-flex.o
+LIB_OBJS += $(OUTPUT)util/pmu-bison.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
@@ -501,6 +526,20 @@ else
 	endif
 endif
 
+ifdef NO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2
+else
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
+	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
+		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
+		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
+	else
+		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
+		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
+		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
+	endif
+endif
+
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
@@ -647,6 +686,8 @@ ifndef V
 	QUIET_LINK     = @echo '   ' LINK $@;
 	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_FLEX     = @echo '   ' FLEX $@;
+	QUIET_BISON    = @echo '   ' BISON $@;
 endif
 endif
 
@@ -727,12 +768,28 @@ $(OUTPUT)perf.o perf.spec \
 	$(SCRIPTS) \
 	: $(OUTPUT)PERF-VERSION-FILE
 
+.SUFFIXES:
+.SUFFIXES: .o .c .S .s
+
+# These two need to be here so that when O= is not used they take precedence
+# over the general rule for .o
+
+$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+
+$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
 $(OUTPUT)%.o: %.S
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.S
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 
 $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
@@ -795,6 +852,8 @@ help:
 	@echo '  html		- make html documentation'
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
+	@echo '  event-parser	- make event parser code'
+	@echo '  pmu-parser	- make pmu format parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
@@ -931,6 +990,7 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
+	$(RM) $(OUTPUT)util/*-{bison,flex}*
 	$(python-clean)
 
 .PHONY: all install clean strip
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4f19513..d29d350 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,11 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 
+struct perf_diff {
+	struct perf_tool tool;
+	struct perf_session *session;
+};
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -32,12 +37,14 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_tool *tool __used,
+static int diff__process_sample_event(struct perf_tool *tool,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
 				      struct machine *machine)
 {
+	struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
+	struct perf_session *session = _diff->session;
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
@@ -49,24 +56,26 @@ static int diff__process_sample_event(struct perf_tool *tool __used,
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&session->hists, &al, sample->period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	evsel->hists.stats.total_period += sample->period;
+	session->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_tool perf_diff = {
-	.sample	= diff__process_sample_event,
-	.mmap	= perf_event__process_mmap,
-	.comm	= perf_event__process_comm,
-	.exit	= perf_event__process_task,
-	.fork	= perf_event__process_task,
-	.lost	= perf_event__process_lost,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
+static struct perf_diff diff = {
+	.tool = {
+		.sample	= diff__process_sample_event,
+		.mmap	= perf_event__process_mmap,
+		.comm	= perf_event__process_comm,
+		.exit	= perf_event__process_task,
+		.fork	= perf_event__process_task,
+		.lost	= perf_event__process_lost,
+		.ordered_samples = true,
+		.ordering_requires_timestamps = true,
+	},
 };
 
 static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
@@ -107,12 +116,6 @@ static void hists__resort_entries(struct hists *self)
 	self->entries = tmp;
 }
 
-static void hists__set_positions(struct hists *self)
-{
-	hists__output_resort(self);
-	hists__resort_entries(self);
-}
-
 static struct hist_entry *hists__find_entry(struct hists *self,
 					    struct hist_entry *he)
 {
@@ -146,30 +149,37 @@ static void hists__match(struct hists *older, struct hists *newer)
 static int __cmd_diff(void)
 {
 	int ret, i;
+#define older (session[0])
+#define newer (session[1])
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &perf_diff);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &perf_diff);
+	older = perf_session__new(input_old, O_RDONLY, force, false,
+				  &diff.tool);
+	newer = perf_session__new(input_new, O_RDONLY, force, false,
+				  &diff.tool);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < 2; ++i) {
-		ret = perf_session__process_events(session[i], &perf_diff);
+		diff.session = session[i];
+		ret = perf_session__process_events(session[i], &diff.tool);
 		if (ret)
 			goto out_delete;
+		hists__output_resort(&session[i]->hists);
 	}
 
-	hists__output_resort(&session[1]->hists);
 	if (show_displacement)
-		hists__set_positions(&session[0]->hists);
+		hists__resort_entries(&older->hists);
 
-	hists__match(&session[0]->hists, &session[1]->hists);
-	hists__fprintf(&session[1]->hists, &session[0]->hists,
+	hists__match(&older->hists, &newer->hists);
+	hists__fprintf(&newer->hists, &older->hists,
 		       show_displacement, true, 0, 0, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
 	return ret;
+#undef older
+#undef newer
 }
 
 static const char * const diff_usage[] = {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8e91c6e..2e31743 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,7 +40,7 @@ struct perf_report {
 	struct perf_tool	tool;
 	struct perf_session	*session;
 	char const		*input_name;
-	bool			force, use_tui, use_stdio;
+	bool			force, use_tui, use_gtk, use_stdio;
 	bool			hide_unresolved;
 	bool			dont_use_callchains;
 	bool			show_full_info;
@@ -50,6 +50,7 @@ struct perf_report {
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
+	const char		*symbol_filter_str;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -400,6 +401,9 @@ static int __cmd_report(struct perf_report *rep)
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 
+		if (pos->idx == 0)
+			hists->symbol_filter_str = rep->symbol_filter_str;
+
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
@@ -411,8 +415,13 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (use_browser > 0) {
-		perf_evlist__tui_browse_hists(session->evlist, help,
-					      NULL, NULL, 0);
+		if (use_browser == 1) {
+			perf_evlist__tui_browse_hists(session->evlist, help,
+						      NULL, NULL, 0);
+		} else if (use_browser == 2) {
+			perf_evlist__gtk_browse_hists(session->evlist, help,
+						      NULL, NULL, 0);
+		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
 
@@ -569,6 +578,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	OPT_STRING(0, "pretty", &report.pretty_printing_style, "key",
 		   "pretty printing style key: normal raw"),
 	OPT_BOOLEAN(0, "tui", &report.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "gtk", &report.use_gtk, "Use the GTK2 interface"),
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
@@ -591,6 +601,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
+	OPT_STRING(0, "symbol-filter", &report.symbol_filter_str, "filter",
+		   "only show symbols that (partially) match with this filter"),
 	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
 		   "width[,width...]",
 		   "don't try to adjust column width, use these fixed values"),
@@ -624,6 +636,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		use_browser = 0;
 	else if (report.use_tui)
 		use_browser = 1;
+	else if (report.use_gtk)
+		use_browser = 2;
 
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
@@ -660,7 +674,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (strcmp(report.input_name, "-") != 0) {
-		setup_browser(true);
+		if (report.use_gtk)
+			perf_gtk_setup_browser(argc, argv, true);
+		else
+			setup_browser(true);
 	} else {
 		use_browser = 0;
 	}
@@ -709,11 +726,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	} else
 		symbol_conf.exclude_other = false;
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume that
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(report_usage, options);
+
+		report.symbol_filter_str = argv[0];
+	}
 
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ea40e4e..c941bb6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (!target_pid && !target_tid) {
+	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3e087ce..1c5b980 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -13,6 +13,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "util/pmu.h"
 #include "../../include/linux/hw_breakpoint.h"
 
 #include <sys/mman.h>
@@ -650,7 +651,7 @@ static int test__checkevent_raw(struct perf_evlist *evlist)
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
 	return 0;
 }
 
@@ -677,6 +678,24 @@ static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong period",
+			100000 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong config1",
+			0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",
+			1 == evsel->attr.config2);
+	return 0;
+}
+
 static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -858,6 +877,115 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_genhw(evlist);
 }
 
+static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint(evlist);
+}
+
+static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
+static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_r(evlist);
+}
+
+static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_w(evlist);
+}
+
+static int test__checkevent_pmu(struct perf_evlist *evlist)
+{
+
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
+
+	return 0;
+}
+
+static int test__checkevent_list(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* r1 */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* syscalls:sys_enter_open:k */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* 1:1:hp */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -872,7 +1000,7 @@ static struct test__event_st {
 		.check = test__checkevent_tracepoint_multi,
 	},
 	{
-		.name  = "r1",
+		.name  = "r1a",
 		.check = test__checkevent_raw,
 	},
 	{
@@ -884,6 +1012,10 @@ static struct test__event_st {
 		.check = test__checkevent_symbolic_name,
 	},
 	{
+		.name  = "cycles/period=100000,config2/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	{
 		.name  = "faults",
 		.check = test__checkevent_symbolic_alias,
 	},
@@ -916,7 +1048,7 @@ static struct test__event_st {
 		.check = test__checkevent_tracepoint_multi_modifier,
 	},
 	{
-		.name  = "r1:kp",
+		.name  = "r1a:kp",
 		.check = test__checkevent_raw_modifier,
 	},
 	{
@@ -935,6 +1067,30 @@ static struct test__event_st {
 		.name  = "L1-dcache-load-miss:kp",
 		.check = test__checkevent_genhw_modifier,
 	},
+	{
+		.name  = "mem:0:u",
+		.check = test__checkevent_breakpoint_modifier,
+	},
+	{
+		.name  = "mem:0:x:k",
+		.check = test__checkevent_breakpoint_x_modifier,
+	},
+	{
+		.name  = "mem:0:r:hp",
+		.check = test__checkevent_breakpoint_r_modifier,
+	},
+	{
+		.name  = "mem:0:w:up",
+		.check = test__checkevent_breakpoint_w_modifier,
+	},
+	{
+		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
+		.check = test__checkevent_pmu,
+	},
+	{
+		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
@@ -960,10 +1116,9 @@ static int test__parse_events(void)
 		}
 
 		ret = e->check(evlist);
+		perf_evlist__delete(evlist);
 		if (ret)
 			break;
-
-		perf_evlist__delete(evlist);
 	}
 
 	return ret;
@@ -1462,6 +1617,11 @@ static int test__rdpmc(void)
 
 #endif
 
+static int test__perf_pmu(void)
+{
+	return perf_pmu__test();
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1497,6 +1657,10 @@ static struct test {
 		.func = test__PERF_RECORD,
 	},
 	{
+		.desc = "Test perf pmu format parsing",
+		.func = test__perf_pmu,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 6170fd2..d9084e0 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -65,6 +65,21 @@ int main(void)
 endef
 endif
 
+ifndef NO_GTK2
+define SOURCE_GTK2
+#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error \"-Wstrict-prototypes\"
+
+int main(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
+endef
+endif
+
 ifndef NO_LIBPERL
 define SOURCE_PERL_EMBED
 #include <EXTERN.h>
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5a462f..199f69e 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -28,8 +28,8 @@ int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 int symbol__alloc_hist(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	size_t sizeof_sym_hist = (sizeof(struct sym_hist) +
-				  (sym->end - sym->start) * sizeof(u64));
+	const size_t size = sym->end - sym->start + 1;
+	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
 
 	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
 	if (notes->src == NULL)
@@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
+	if (addr > sym->end)
 		return 0;
 
 	offset = addr - sym->start;
@@ -408,7 +408,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	if (!notes->src->lines)
 		return -1;
 
-	start = map->unmap_ip(map, sym->start);
+	start = map__rip_2objdump(map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index fc5e5a0..8dd224d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -45,6 +45,18 @@ void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 #endif
 
+#ifdef NO_GTK2_SUPPORT
+static inline void perf_gtk_setup_browser(int argc __used, const char *argv[] __used, bool fallback_to_pager)
+{
+	if (fallback_to_pager)
+		setup_pager();
+}
+static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
+#else
+void perf_gtk_setup_browser(int argc, const char *argv[], bool fallback_to_pager);
+void perf_gtk_exit_browser(bool wait_for_ok);
+#endif
+
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 159263d..1986d80 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -51,13 +51,15 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel, *first;
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts);
+		perf_evsel__config(evsel, opts, first);
 
 		if (evlist->nr_entries > 1)
 			evsel->attr.sample_type |= PERF_SAMPLE_ID;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f421f7c..8c13dbc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -34,7 +34,7 @@ int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
-static void hists__init(struct hists *hists)
+void hists__init(struct hists *hists)
 {
 	memset(hists, 0, sizeof(*hists));
 	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
@@ -63,7 +63,8 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
-void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
+void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
+			struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
@@ -134,7 +135,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
+	if (!opts->target_pid && !opts->target_tid && !opts->system_wide &&
+	    (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -578,6 +580,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+
+		array = (void *)array + data->raw_size + sizeof(u32);
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4..3d6b3e4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -80,7 +80,8 @@ void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts);
+			struct perf_record_opts *opts,
+			struct perf_evsel *first);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
@@ -169,4 +170,6 @@ static inline int perf_evsel__sample_size(struct perf_evsel *evsel)
 	return __perf_evsel__sample_size(evsel->attr.sample_type);
 }
 
+void hists__init(struct hists *hists);
+
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
new file mode 100644
index 0000000..258352a
--- /dev/null
+++ b/tools/perf/util/gtk/browser.c
@@ -0,0 +1,189 @@
+#include "../evlist.h"
+#include "../cache.h"
+#include "../evsel.h"
+#include "../sort.h"
+#include "../hist.h"
+#include "gtk.h"
+
+#include <signal.h>
+
+#define MAX_COLUMNS			32
+
+void perf_gtk_setup_browser(int argc, const char *argv[],
+			    bool fallback_to_pager __used)
+{
+	gtk_init(&argc, (char ***)&argv);
+}
+
+void perf_gtk_exit_browser(bool wait_for_ok __used)
+{
+	gtk_main_quit();
+}
+
+static void perf_gtk_signal(int sig)
+{
+	psignal(sig, "perf");
+	gtk_main_quit();
+}
+
+static void perf_gtk_resize_window(GtkWidget *window)
+{
+	GdkRectangle rect;
+	GdkScreen *screen;
+	int monitor;
+	int height;
+	int width;
+
+	screen = gtk_widget_get_screen(window);
+
+	monitor = gdk_screen_get_monitor_at_window(screen, window->window);
+
+	gdk_screen_get_monitor_geometry(screen, monitor, &rect);
+
+	width	= rect.width * 3 / 4;
+	height	= rect.height * 3 / 4;
+
+	gtk_window_resize(GTK_WINDOW(window), width, height);
+}
+
+static void perf_gtk_show_hists(GtkWidget *window, struct hists *hists)
+{
+	GType col_types[MAX_COLUMNS];
+	GtkCellRenderer *renderer;
+	struct sort_entry *se;
+	GtkListStore *store;
+	struct rb_node *nd;
+	u64 total_period;
+	GtkWidget *view;
+	int col_idx;
+	int nr_cols;
+
+	nr_cols = 0;
+
+	/* The percentage column */
+	col_types[nr_cols++] = G_TYPE_STRING;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		col_types[nr_cols++] = G_TYPE_STRING;
+	}
+
+	store = gtk_list_store_newv(nr_cols, col_types);
+
+	view = gtk_tree_view_new();
+
+	renderer = gtk_cell_renderer_text_new();
+
+	col_idx = 0;
+
+	/* The percentage column */
+	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+						    -1, "Overhead (%)",
+						    renderer, "text",
+						    col_idx++, NULL);
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, se->se_header,
+							    renderer, "text",
+							    col_idx++, NULL);
+	}
+
+	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
+
+	g_object_unref(GTK_TREE_MODEL(store));
+
+	total_period = hists->stats.total_period;
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+		double percent;
+		char s[512];
+
+		if (h->filtered)
+			continue;
+
+		gtk_list_store_append(store, &iter);
+
+		col_idx = 0;
+
+		percent = (h->period * 100.0) / total_period;
+
+		snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
+
+		gtk_list_store_set(store, &iter, col_idx++, s, -1);
+
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (se->elide)
+				continue;
+
+			se->se_snprintf(h, s, ARRAY_SIZE(s),
+					hists__col_len(hists, se->se_width_idx));
+
+			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+		}
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), view);
+}
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
+				  const char *help __used,
+				  void (*timer) (void *arg)__used,
+				  void *arg __used, int delay_secs __used)
+{
+	struct perf_evsel *pos;
+	GtkWidget *notebook;
+	GtkWidget *window;
+
+	signal(SIGSEGV, perf_gtk_signal);
+	signal(SIGFPE,  perf_gtk_signal);
+	signal(SIGINT,  perf_gtk_signal);
+	signal(SIGQUIT, perf_gtk_signal);
+	signal(SIGTERM, perf_gtk_signal);
+
+	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+
+	gtk_window_set_title(GTK_WINDOW(window), "perf report");
+
+	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+	notebook = gtk_notebook_new();
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		const char *evname = event_name(pos);
+		GtkWidget *scrolled_window;
+		GtkWidget *tab_label;
+
+		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
+
+		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
+							GTK_POLICY_AUTOMATIC,
+							GTK_POLICY_AUTOMATIC);
+
+		perf_gtk_show_hists(scrolled_window, hists);
+
+		tab_label = gtk_label_new(evname);
+
+		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), notebook);
+
+	gtk_widget_show_all(window);
+
+	perf_gtk_resize_window(window);
+
+	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
+
+	gtk_main();
+
+	return 0;
+}
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
new file mode 100644
index 0000000..75177ee
--- /dev/null
+++ b/tools/perf/util/gtk/gtk.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_GTK_H_
+#define _PERF_GTK_H_ 1
+
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+#endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fcd9cf3..4c7c2d7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1177,7 +1177,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		goto error;
 
 	msz = sizeof(attr);
-	if (sz < (ssize_t)msz)
+	if (sz < msz)
 		msz = sz;
 
 	for (i = 0 ; i < nre; i++) {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3dc99a9..2ec4b60 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -10,11 +10,14 @@ static bool hists__filter_entry_by_dso(struct hists *hists,
 				       struct hist_entry *he);
 static bool hists__filter_entry_by_thread(struct hists *hists,
 					  struct hist_entry *he);
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he);
 
 enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
 	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
 };
 
 struct callchain_param	callchain_param = {
@@ -420,6 +423,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 {
 	hists__filter_entry_by_dso(hists, he);
 	hists__filter_entry_by_thread(hists, he);
+	hists__filter_entry_by_symbol(hists, he);
 }
 
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
@@ -603,7 +607,7 @@ static void init_rem_hits(void)
 	rem_hits.ms.sym = rem_sq_bracket;
 }
 
-static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+static size_t __callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 					 u64 total_samples, int depth,
 					 int depth_mask, int left_margin)
 {
@@ -611,21 +615,16 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	struct callchain_node *child;
 	struct callchain_list *chain;
 	int new_depth_mask = depth_mask;
-	u64 new_total;
 	u64 remaining;
 	size_t ret = 0;
 	int i;
 	uint entries_printed = 0;
 
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total_samples;
-
-	remaining = new_total;
+	remaining = total_samples;
 
-	node = rb_first(&self->rb_root);
+	node = rb_first(root);
 	while (node) {
+		u64 new_total;
 		u64 cumul;
 
 		child = rb_entry(node, struct callchain_node, rb_node);
@@ -653,11 +652,17 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		list_for_each_entry(chain, &child->val, list) {
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
-						      new_total,
+						      total_samples,
 						      cumul,
 						      left_margin);
 		}
-		ret += __callchain__fprintf_graph(fp, child, new_total,
+
+		if (callchain_param.mode == CHAIN_GRAPH_REL)
+			new_total = child->children_hit;
+		else
+			new_total = total_samples;
+
+		ret += __callchain__fprintf_graph(fp, &child->rb_root, new_total,
 						  depth + 1,
 						  new_depth_mask | (1 << depth),
 						  left_margin);
@@ -667,61 +672,75 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	}
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL &&
-		remaining && remaining != new_total) {
+		remaining && remaining != total_samples) {
 
 		if (!rem_sq_bracket)
 			return ret;
 
 		new_depth_mask &= ~(1 << (depth - 1));
-
 		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
-					      new_depth_mask, 0, new_total,
+					      new_depth_mask, 0, total_samples,
 					      remaining, left_margin);
 	}
 
 	return ret;
 }
 
-static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 				       u64 total_samples, int left_margin)
 {
+	struct callchain_node *cnode;
 	struct callchain_list *chain;
+	u32 entries_printed = 0;
 	bool printed = false;
+	struct rb_node *node;
 	int i = 0;
-	int ret = 0;
-	u32 entries_printed = 0;
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		if (!printed) {
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "|\n");
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "---");
-
-			left_margin += 3;
-			printed = true;
-		} else
-			ret += callchain__fprintf_left_margin(fp, left_margin);
+	int ret;
 
-		if (chain->ms.sym)
-			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+	/*
+	 * If have one single callchain root, don't bother printing
+	 * its percentage (100 % in fractal mode and the same percentage
+	 * than the hist in graph mode). This also avoid one level of column.
+	 */
+	node = rb_first(root);
+	if (node && !rb_next(node)) {
+		cnode = rb_entry(node, struct callchain_node, rb_node);
+		list_for_each_entry(chain, &cnode->val, list) {
+			/*
+			 * If we sort by symbol, the first entry is the same than
+			 * the symbol. No need to print it otherwise it appears as
+			 * displayed twice.
+			 */
+			if (!i++ && sort__first_dimension == SORT_SYM)
+				continue;
+			if (!printed) {
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+				ret += fprintf(fp, "|\n");
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+				ret += fprintf(fp, "---");
+				left_margin += 3;
+				printed = true;
+			} else
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+
+			if (chain->ms.sym)
+				ret += fprintf(fp, " %s\n", chain->ms.sym->name);
+			else
+				ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
 
-		if (++entries_printed == callchain_param.print_limit)
-			break;
+			if (++entries_printed == callchain_param.print_limit)
+				break;
+		}
+		root = &cnode->rb_root;
 	}
 
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
-
-	return ret;
+	return __callchain__fprintf_graph(fp, root, total_samples,
+					  1, 1, left_margin);
 }
 
-static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
-				      u64 total_samples)
+static size_t __callchain__fprintf_flat(FILE *fp,
+					struct callchain_node *self,
+					u64 total_samples)
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
@@ -729,7 +748,7 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	if (!self)
 		return 0;
 
-	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
+	ret += __callchain__fprintf_flat(fp, self->parent, total_samples);
 
 
 	list_for_each_entry(chain, &self->val, list) {
@@ -745,44 +764,58 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	return ret;
 }
 
-static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
-					    u64 total_samples, int left_margin,
-					    FILE *fp)
+static size_t callchain__fprintf_flat(FILE *fp, struct rb_root *self,
+				      u64 total_samples)
 {
-	struct rb_node *rb_node;
-	struct callchain_node *chain;
 	size_t ret = 0;
 	u32 entries_printed = 0;
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
 
-	rb_node = rb_first(&he->sorted_chain);
+	rb_node = rb_first(self);
 	while (rb_node) {
 		double percent;
 
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
-						     percent);
-			ret += callchain__fprintf_flat(fp, chain, total_samples);
-			break;
-		case CHAIN_GRAPH_ABS: /* Falldown */
-		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples,
-							left_margin);
-		case CHAIN_NONE:
-		default:
-			break;
-		}
+
+		ret = percent_color_fprintf(fp, "           %6.2f%%\n", percent);
+		ret += __callchain__fprintf_flat(fp, chain, total_samples);
 		ret += fprintf(fp, "\n");
 		if (++entries_printed == callchain_param.print_limit)
 			break;
+
 		rb_node = rb_next(rb_node);
 	}
 
 	return ret;
 }
 
+static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
+					    u64 total_samples, int left_margin,
+					    FILE *fp)
+{
+	switch (callchain_param.mode) {
+	case CHAIN_GRAPH_REL:
+		return callchain__fprintf_graph(fp, &he->sorted_chain, he->period,
+						left_margin);
+		break;
+	case CHAIN_GRAPH_ABS:
+		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
+						left_margin);
+		break;
+	case CHAIN_FLAT:
+		return callchain__fprintf_flat(fp, &he->sorted_chain, total_samples);
+		break;
+	case CHAIN_NONE:
+		break;
+	default:
+		pr_err("Bad callchain mode\n");
+	}
+
+	return 0;
+}
+
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 {
 	struct rb_node *next = rb_first(&hists->entries);
@@ -887,9 +920,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 		diff = new_percent - old_percent;
 
 		if (fabs(diff) >= 0.01)
-			ret += scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+			scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
 		else
-			ret += scnprintf(bf, sizeof(bf), " ");
+			scnprintf(bf, sizeof(bf), " ");
 
 		if (sep)
 			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
@@ -898,9 +931,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 
 		if (show_displacement) {
 			if (displacement)
-				ret += scnprintf(bf, sizeof(bf), "%+4ld", displacement);
+				scnprintf(bf, sizeof(bf), "%+4ld", displacement);
 			else
-				ret += scnprintf(bf, sizeof(bf), " ");
+				scnprintf(bf, sizeof(bf), " ");
 
 			if (sep)
 				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
@@ -1247,6 +1280,37 @@ void hists__filter_by_thread(struct hists *hists)
 	}
 }
 
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->symbol_filter_str != NULL &&
+	    (!he->ms.sym || strstr(he->ms.sym->name,
+				   hists->symbol_filter_str) == NULL)) {
+		he->filtered |= (1 << HIST_FILTER__SYMBOL);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_symbol(struct hists *hists)
+{
+	struct rb_node *nd;
+
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (hists__filter_entry_by_symbol(hists, h))
+			continue;
+
+		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
+	}
+}
+
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9413f3e..2cae9df 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -62,6 +62,7 @@ struct hists {
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
+	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -107,6 +108,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
+void hists__filter_by_symbol(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
@@ -145,6 +147,23 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  int refresh);
 #endif
 
+#ifdef NO_GTK2_SUPPORT
+static inline
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __used,
+				  const char *help __used,
+				  void(*timer)(void *arg) __used,
+				  void *arg __used,
+				  int refresh __used)
+{
+	return 0;
+}
+
+#else
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#endif
+
 unsigned int hists__sort_list_width(struct hists *self);
 
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/include/linux/module.h b/tools/perf/util/include/linux/export.h
similarity index 100%
rename from tools/perf/util/include/linux/module.h
rename to tools/perf/util/include/linux/export.h
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c7a6f6f..5b3a0ef 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -11,6 +11,10 @@
 #include "cache.h"
 #include "header.h"
 #include "debugfs.h"
+#include "parse-events-flex.h"
+#include "pmu.h"
+
+#define MAX_NAME_LEN 100
 
 struct event_symbol {
 	u8		type;
@@ -19,11 +23,8 @@ struct event_symbol {
 	const char	*alias;
 };
 
-enum event_result {
-	EVT_FAILED,
-	EVT_HANDLED,
-	EVT_HANDLED_ALL
-};
+int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
+		       int *idx);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -354,7 +355,24 @@ const char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
-static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
+static int add_event(struct list_head *list, int *idx,
+		     struct perf_event_attr *attr, char *name)
+{
+	struct perf_evsel *evsel;
+
+	event_attr_init(attr);
+
+	evsel = perf_evsel__new(attr, (*idx)++);
+	if (!evsel)
+		return -ENOMEM;
+
+	list_add_tail(&evsel->node, list);
+
+	evsel->name = strdup(name);
+	return 0;
+}
+
+static int parse_aliases(char *str, const char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
 	int n, longest = -1;
@@ -362,58 +380,57 @@ static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int
 	for (i = 0; i < size; i++) {
 		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
 			n = strlen(names[i][j]);
-			if (n > longest && !strncasecmp(*str, names[i][j], n))
+			if (n > longest && !strncasecmp(str, names[i][j], n))
 				longest = n;
 		}
-		if (longest > 0) {
-			*str += longest;
+		if (longest > 0)
 			return i;
-		}
 	}
 
 	return -1;
 }
 
-static enum event_result
-parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
+int parse_events_add_cache(struct list_head *list, int *idx,
+			   char *type, char *op_result1, char *op_result2)
 {
-	const char *s = *str;
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 	int cache_type = -1, cache_op = -1, cache_result = -1;
+	char *op_result[2] = { op_result1, op_result2 };
+	int i, n;
 
-	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
 	/*
 	 * No fallback - if we cannot get a clear cache type
 	 * then bail out:
 	 */
+	cache_type = parse_aliases(type, hw_cache,
+				   PERF_COUNT_HW_CACHE_MAX);
 	if (cache_type == -1)
-		return EVT_FAILED;
+		return -EINVAL;
 
-	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
-		++s;
+	n = snprintf(name, MAX_NAME_LEN, "%s", type);
+
+	for (i = 0; (i < 2) && (op_result[i]); i++) {
+		char *str = op_result[i];
+
+		snprintf(name + n, MAX_NAME_LEN - n, "-%s\n", str);
 
 		if (cache_op == -1) {
-			cache_op = parse_aliases(&s, hw_cache_op,
-						PERF_COUNT_HW_CACHE_OP_MAX);
+			cache_op = parse_aliases(str, hw_cache_op,
+						 PERF_COUNT_HW_CACHE_OP_MAX);
 			if (cache_op >= 0) {
 				if (!is_cache_op_valid(cache_type, cache_op))
-					return EVT_FAILED;
+					return -EINVAL;
 				continue;
 			}
 		}
 
 		if (cache_result == -1) {
-			cache_result = parse_aliases(&s, hw_cache_result,
+			cache_result = parse_aliases(str, hw_cache_result,
 						PERF_COUNT_HW_CACHE_RESULT_MAX);
 			if (cache_result >= 0)
 				continue;
 		}
-
-		/*
-		 * Can't parse this as a cache op or result, so back up
-		 * to the '-'.
-		 */
-		--s;
-		break;
 	}
 
 	/*
@@ -428,20 +445,17 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 	if (cache_result == -1)
 		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
 
-	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
-	attr->type = PERF_TYPE_HW_CACHE;
-
-	*str = s;
-	return EVT_HANDLED;
+	memset(&attr, 0, sizeof(attr));
+	attr.config = cache_type | (cache_op << 8) | (cache_result << 16);
+	attr.type = PERF_TYPE_HW_CACHE;
+	return add_event(list, idx, &attr, name);
 }
 
-static enum event_result
-parse_single_tracepoint_event(char *sys_name,
-			      const char *evt_name,
-			      unsigned int evt_length,
-			      struct perf_event_attr *attr,
-			      const char **strp)
+static int add_tracepoint(struct list_head *list, int *idx,
+			  char *sys_name, char *evt_name)
 {
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 	char evt_path[MAXPATHLEN];
 	char id_buf[4];
 	u64 id;
@@ -452,130 +466,80 @@ parse_single_tracepoint_event(char *sys_name,
 
 	fd = open(evt_path, O_RDONLY);
 	if (fd < 0)
-		return EVT_FAILED;
+		return -1;
 
 	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
 		close(fd);
-		return EVT_FAILED;
+		return -1;
 	}
 
 	close(fd);
 	id = atoll(id_buf);
-	attr->config = id;
-	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
-
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
-
-	attr->sample_period = 1;
 
+	memset(&attr, 0, sizeof(attr));
+	attr.config = id;
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type |= PERF_SAMPLE_RAW;
+	attr.sample_type |= PERF_SAMPLE_TIME;
+	attr.sample_type |= PERF_SAMPLE_CPU;
+	attr.sample_period = 1;
 
-	return EVT_HANDLED;
+	snprintf(name, MAX_NAME_LEN, "%s:%s", sys_name, evt_name);
+	return add_event(list, idx, &attr, name);
 }
 
-/* sys + ':' + event + ':' + flags*/
-#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
-static enum event_result
-parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
-				const char *evt_exp, char *flags)
+static int add_tracepoint_multi(struct list_head *list, int *idx,
+				char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
 	DIR *evt_dir;
+	int ret = 0;
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s", tracing_events_path, sys_name);
 	evt_dir = opendir(evt_path);
-
 	if (!evt_dir) {
 		perror("Can't open event dir");
-		return EVT_FAILED;
+		return -1;
 	}
 
-	while ((evt_ent = readdir(evt_dir))) {
-		char event_opt[MAX_EVOPT_LEN + 1];
-		int len;
-
+	while (!ret && (evt_ent = readdir(evt_dir))) {
 		if (!strcmp(evt_ent->d_name, ".")
 		    || !strcmp(evt_ent->d_name, "..")
 		    || !strcmp(evt_ent->d_name, "enable")
 		    || !strcmp(evt_ent->d_name, "filter"))
 			continue;
 
-		if (!strglobmatch(evt_ent->d_name, evt_exp))
+		if (!strglobmatch(evt_ent->d_name, evt_name))
 			continue;
 
-		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
-			       evt_ent->d_name, flags ? ":" : "",
-			       flags ?: "");
-		if (len < 0)
-			return EVT_FAILED;
-
-		if (parse_events(evlist, event_opt, 0))
-			return EVT_FAILED;
+		ret = add_tracepoint(list, idx, sys_name, evt_ent->d_name);
 	}
 
-	return EVT_HANDLED_ALL;
+	return ret;
 }
 
-static enum event_result
-parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
-		       struct perf_event_attr *attr)
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
+				char *sys, char *event)
 {
-	const char *evt_name;
-	char *flags = NULL, *comma_loc;
-	char sys_name[MAX_EVENT_LENGTH];
-	unsigned int sys_length, evt_length;
-
-	if (debugfs_valid_mountpoint(tracing_events_path))
-		return 0;
-
-	evt_name = strchr(*strp, ':');
-	if (!evt_name)
-		return EVT_FAILED;
-
-	sys_length = evt_name - *strp;
-	if (sys_length >= MAX_EVENT_LENGTH)
-		return 0;
+	int ret;
 
-	strncpy(sys_name, *strp, sys_length);
-	sys_name[sys_length] = '\0';
-	evt_name = evt_name + 1;
+	ret = debugfs_valid_mountpoint(tracing_events_path);
+	if (ret)
+		return ret;
 
-	comma_loc = strchr(evt_name, ',');
-	if (comma_loc) {
-		/* take the event name up to the comma */
-		evt_name = strndup(evt_name, comma_loc - evt_name);
-	}
-	flags = strchr(evt_name, ':');
-	if (flags) {
-		/* split it out: */
-		evt_name = strndup(evt_name, flags - evt_name);
-		flags++;
-	}
-
-	evt_length = strlen(evt_name);
-	if (evt_length >= MAX_EVENT_LENGTH)
-		return EVT_FAILED;
-	if (strpbrk(evt_name, "*?")) {
-		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
-		return parse_multiple_tracepoint_event(evlist, sys_name,
-						       evt_name, flags);
-	} else {
-		return parse_single_tracepoint_event(sys_name, evt_name,
-						     evt_length, attr, strp);
-	}
+	return strpbrk(event, "*?") ?
+	       add_tracepoint_multi(list, idx, sys, event) :
+	       add_tracepoint(list, idx, sys, event);
 }
 
-static enum event_result
-parse_breakpoint_type(const char *type, const char **strp,
-		      struct perf_event_attr *attr)
+static int
+parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 {
 	int i;
 
 	for (i = 0; i < 3; i++) {
-		if (!type[i])
+		if (!type || !type[i])
 			break;
 
 		switch (type[i]) {
@@ -589,164 +553,146 @@ parse_breakpoint_type(const char *type, const char **strp,
 			attr->bp_type |= HW_BREAKPOINT_X;
 			break;
 		default:
-			return EVT_FAILED;
+			return -EINVAL;
 		}
 	}
+
 	if (!attr->bp_type) /* Default */
 		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
 
-	*strp = type + i;
-
-	return EVT_HANDLED;
+	return 0;
 }
 
-static enum event_result
-parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
+				void *ptr, char *type)
 {
-	const char *target;
-	const char *type;
-	char *endaddr;
-	u64 addr;
-	enum event_result err;
-
-	target = strchr(*strp, ':');
-	if (!target)
-		return EVT_FAILED;
-
-	if (strncmp(*strp, "mem", target - *strp) != 0)
-		return EVT_FAILED;
-
-	target++;
-
-	addr = strtoull(target, &endaddr, 0);
-	if (target == endaddr)
-		return EVT_FAILED;
-
-	attr->bp_addr = addr;
-	*strp = endaddr;
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 
-	type = strchr(target, ':');
+	memset(&attr, 0, sizeof(attr));
+	attr.bp_addr = (unsigned long) ptr;
 
-	/* If no type is defined, just rw as default */
-	if (!type) {
-		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
-	} else {
-		err = parse_breakpoint_type(++type, strp, attr);
-		if (err == EVT_FAILED)
-			return EVT_FAILED;
-	}
+	if (parse_breakpoint_type(type, &attr))
+		return -EINVAL;
 
 	/*
 	 * We should find a nice way to override the access length
 	 * Provide some defaults for now
 	 */
-	if (attr->bp_type == HW_BREAKPOINT_X)
-		attr->bp_len = sizeof(long);
+	if (attr.bp_type == HW_BREAKPOINT_X)
+		attr.bp_len = sizeof(long);
 	else
-		attr->bp_len = HW_BREAKPOINT_LEN_4;
+		attr.bp_len = HW_BREAKPOINT_LEN_4;
 
-	attr->type = PERF_TYPE_BREAKPOINT;
+	attr.type = PERF_TYPE_BREAKPOINT;
 
-	return EVT_HANDLED;
+	snprintf(name, MAX_NAME_LEN, "mem:%p:%s", ptr, type ? type : "rw");
+	return add_event(list, idx, &attr, name);
 }
 
-static int check_events(const char *str, unsigned int i)
+static int config_term(struct perf_event_attr *attr,
+		       struct parse_events__term *term)
 {
-	int n;
+	switch (term->type) {
+	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+		attr->config = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
+		attr->config1 = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
+		attr->config2 = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
+		attr->sample_period = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
+		/*
+		 * TODO uncomment when the field is available
+		 * attr->branch_sample_type = term->val.num;
+		 */
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
 
-	n = strlen(event_symbols[i].symbol);
-	if (!strncasecmp(str, event_symbols[i].symbol, n))
-		return n;
+static int config_attr(struct perf_event_attr *attr,
+		       struct list_head *head, int fail)
+{
+	struct parse_events__term *term;
 
-	n = strlen(event_symbols[i].alias);
-	if (n) {
-		if (!strncasecmp(str, event_symbols[i].alias, n))
-			return n;
-	}
+	list_for_each_entry(term, head, list)
+		if (config_term(attr, term) && fail)
+			return -EINVAL;
 
 	return 0;
 }
 
-static enum event_result
-parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+int parse_events_add_numeric(struct list_head *list, int *idx,
+			     unsigned long type, unsigned long config,
+			     struct list_head *head_config)
 {
-	const char *str = *strp;
-	unsigned int i;
-	int n;
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		n = check_events(str, i);
-		if (n > 0) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
-			*strp = str + n;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = type;
+	attr.config = config;
+
+	if (head_config &&
+	    config_attr(&attr, head_config, 1))
+		return -EINVAL;
+
+	return add_event(list, idx, &attr,
+			 (char *) __event_name(type, config));
 }
 
-static enum event_result
-parse_raw_event(const char **strp, struct perf_event_attr *attr)
+int parse_events_add_pmu(struct list_head *list, int *idx,
+			 char *name, struct list_head *head_config)
 {
-	const char *str = *strp;
-	u64 config;
-	int n;
-
-	if (*str != 'r')
-		return EVT_FAILED;
-	n = hex2u64(str + 1, &config);
-	if (n > 0) {
-		const char *end = str + n + 1;
-		if (*end != '\0' && *end != ',' && *end != ':')
-			return EVT_FAILED;
-
-		*strp = end;
-		attr->type = PERF_TYPE_RAW;
-		attr->config = config;
-		return EVT_HANDLED;
-	}
-	return EVT_FAILED;
+	struct perf_event_attr attr;
+	struct perf_pmu *pmu;
+
+	pmu = perf_pmu__find(name);
+	if (!pmu)
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+
+	/*
+	 * Configure hardcoded terms first, no need to check
+	 * return value when called with fail == 0 ;)
+	 */
+	config_attr(&attr, head_config, 0);
+
+	if (perf_pmu__config(pmu, &attr, head_config))
+		return -EINVAL;
+
+	return add_event(list, idx, &attr, (char *) "pmu");
 }
 
-static enum event_result
-parse_numeric_event(const char **strp, struct perf_event_attr *attr)
+void parse_events_update_lists(struct list_head *list_event,
+			       struct list_head *list_all)
 {
-	const char *str = *strp;
-	char *endp;
-	unsigned long type;
-	u64 config;
-
-	type = strtoul(str, &endp, 0);
-	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
-		str = endp + 1;
-		config = strtoul(str, &endp, 0);
-		if (endp > str) {
-			attr->type = type;
-			attr->config = config;
-			*strp = endp;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
+	/*
+	 * Called for single event definition. Update the
+	 * 'all event' list, and reinit the 'signle event'
+	 * list, for next event definition.
+	 */
+	list_splice_tail(list_event, list_all);
+	INIT_LIST_HEAD(list_event);
 }
 
-static int
-parse_event_modifier(const char **strp, struct perf_event_attr *attr)
+int parse_events_modifier(struct list_head *list, char *str)
 {
-	const char *str = *strp;
+	struct perf_evsel *evsel;
 	int exclude = 0, exclude_GH = 0;
 	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
 
-	if (!*str)
+	if (str == NULL)
 		return 0;
 
-	if (*str == ',')
-		return 0;
-
-	if (*str++ != ':')
-		return -1;
-
 	while (*str) {
 		if (*str == 'u') {
 			if (!exclude)
@@ -775,111 +721,62 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 
 		++str;
 	}
-	if (str < *strp + 2)
-		return -1;
 
-	*strp = str;
+	/*
+	 * precise ip:
+	 *
+	 *  0 - SAMPLE_IP can have arbitrary skid
+	 *  1 - SAMPLE_IP must have constant skid
+	 *  2 - SAMPLE_IP requested to have 0 skid
+	 *  3 - SAMPLE_IP must have 0 skid
+	 *
+	 *  See also PERF_RECORD_MISC_EXACT_IP
+	 */
+	if (precise > 3)
+		return -EINVAL;
 
-	attr->exclude_user   = eu;
-	attr->exclude_kernel = ek;
-	attr->exclude_hv     = eh;
-	attr->precise_ip     = precise;
-	attr->exclude_host   = eH;
-	attr->exclude_guest  = eG;
+	list_for_each_entry(evsel, list, node) {
+		evsel->attr.exclude_user   = eu;
+		evsel->attr.exclude_kernel = ek;
+		evsel->attr.exclude_hv     = eh;
+		evsel->attr.precise_ip     = precise;
+		evsel->attr.exclude_host   = eH;
+		evsel->attr.exclude_guest  = eG;
+	}
 
 	return 0;
 }
 
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static enum event_result
-parse_event_symbols(struct perf_evlist *evlist, const char **str,
-		    struct perf_event_attr *attr)
+int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 {
-	enum event_result ret;
-
-	ret = parse_tracepoint_event(evlist, str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_raw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	LIST_HEAD(list);
+	LIST_HEAD(list_tmp);
+	YY_BUFFER_STATE buffer;
+	int ret, idx = evlist->nr_entries;
 
-	ret = parse_numeric_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	buffer = parse_events__scan_string(str);
 
-	ret = parse_symbolic_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	ret = parse_events_parse(&list, &list_tmp, &idx);
 
-	ret = parse_generic_hw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	parse_events__flush_buffer(buffer);
+	parse_events__delete_buffer(buffer);
 
-	ret = parse_breakpoint_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
-	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
-	return EVT_FAILED;
-
-modifier:
-	if (parse_event_modifier(str, attr) < 0) {
-		fprintf(stderr, "invalid event modifier: '%s'\n", *str);
-		fprintf(stderr, "Run 'perf list' for a list of valid events and modifiers\n");
-
-		return EVT_FAILED;
+	if (!ret) {
+		int entries = idx - evlist->nr_entries;
+		perf_evlist__splice_list_tail(evlist, &list, entries);
+		return 0;
 	}
 
+	/*
+	 * There are 2 users - builtin-record and builtin-test objects.
+	 * Both call perf_evlist__delete in case of error, so we dont
+	 * need to bother.
+	 */
+	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
+	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return ret;
 }
 
-int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
-{
-	struct perf_event_attr attr;
-	enum event_result ret;
-	const char *ostr;
-
-	for (;;) {
-		ostr = str;
-		memset(&attr, 0, sizeof(attr));
-		event_attr_init(&attr);
-		ret = parse_event_symbols(evlist, &str, &attr);
-		if (ret == EVT_FAILED)
-			return -1;
-
-		if (!(*str == 0 || *str == ',' || isspace(*str)))
-			return -1;
-
-		if (ret != EVT_HANDLED_ALL) {
-			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(&attr, evlist->nr_entries);
-			if (evsel == NULL)
-				return -1;
-			perf_evlist__add(evlist, evsel);
-
-			evsel->name = calloc(str - ostr + 1, 1);
-			if (!evsel->name)
-				return -1;
-			strncpy(evsel->name, ostr, str - ostr);
-		}
-
-		if (*str == 0)
-			break;
-		if (*str == ',')
-			++str;
-		while (isspace(*str))
-			++str;
-	}
-
-	return 0;
-}
-
 int parse_events_option(const struct option *opt, const char *str,
 			int unset __used)
 {
@@ -1052,8 +949,6 @@ int print_hwcache_events(const char *event_glob)
 	return printed;
 }
 
-#define MAX_NAME_LEN 100
-
 /*
  * Print the help text for the event symbols:
  */
@@ -1102,8 +997,12 @@ void print_events(const char *event_glob)
 
 	printf("\n");
 	printf("  %-50s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
+	       "rNNN",
 	       event_type_descriptors[PERF_TYPE_RAW]);
+	printf("  %-50s [%s]\n",
+	       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
+	       event_type_descriptors[PERF_TYPE_RAW]);
+	printf("   (see 'perf list --help' on how to encode it)\n");
 	printf("\n");
 
 	printf("  %-50s [%s]\n",
@@ -1113,3 +1012,51 @@ void print_events(const char *event_glob)
 
 	print_tracepoint_events(NULL, NULL);
 }
+
+int parse_events__is_hardcoded_term(struct parse_events__term *term)
+{
+	return term->type <= PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX;
+}
+
+int parse_events__new_term(struct parse_events__term **_term, int type,
+			   char *config, char *str, long num)
+{
+	struct parse_events__term *term;
+
+	term = zalloc(sizeof(*term));
+	if (!term)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&term->list);
+	term->type = type;
+	term->config = config;
+
+	switch (type) {
+	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
+	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
+	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		term->val.num = num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		term->val.str = str;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_term = term;
+	return 0;
+}
+
+void parse_events__free_terms(struct list_head *terms)
+{
+	struct parse_events__term *term, *h;
+
+	list_for_each_entry_safe(term, h, terms, list)
+		free(term);
+
+	free(terms);
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 7e0cbe7..ca069f8 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,55 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+enum {
+	PARSE_EVENTS__TERM_TYPE_CONFIG,
+	PARSE_EVENTS__TERM_TYPE_CONFIG1,
+	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
+	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_NUM,
+	PARSE_EVENTS__TERM_TYPE_STR,
+
+	PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX =
+		PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+};
+
+struct parse_events__term {
+	char *config;
+	union {
+		char *str;
+		long  num;
+	} val;
+	int type;
+
+	struct list_head list;
+};
+
+int parse_events__is_hardcoded_term(struct parse_events__term *term);
+int parse_events__new_term(struct parse_events__term **term, int type,
+			   char *config, char *str, long num);
+void parse_events__free_terms(struct list_head *terms);
+int parse_events_modifier(struct list_head *list __used, char *str __used);
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
+				char *sys, char *event);
+int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
+			 unsigned long config1, unsigned long config2,
+			 char *mod);
+int parse_events_add_numeric(struct list_head *list, int *idx,
+			     unsigned long type, unsigned long config,
+			     struct list_head *head_config);
+int parse_events_add_cache(struct list_head *list, int *idx,
+			   char *type, char *op_result1, char *op_result2);
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
+				void *ptr, char *type);
+int parse_events_add_pmu(struct list_head *list, int *idx,
+			 char *pmu , struct list_head *head_config);
+void parse_events_update_lists(struct list_head *list_event,
+			       struct list_head *list_all);
+void parse_events_error(struct list_head *list_all,
+			struct list_head *list_event,
+			int *idx, char const *msg);
+
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
 void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
new file mode 100644
index 0000000..05d766e
--- /dev/null
+++ b/tools/perf/util/parse-events.l
@@ -0,0 +1,127 @@
+
+%option prefix="parse_events_"
+
+%{
+#include <errno.h>
+#include "../perf.h"
+#include "parse-events-bison.h"
+#include "parse-events.h"
+
+static int __value(char *str, int base, int token)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(str, NULL, base);
+	if (errno)
+		return PE_ERROR;
+
+	parse_events_lval.num = num;
+	return token;
+}
+
+static int value(int base)
+{
+	return __value(parse_events_text, base, PE_VALUE);
+}
+
+static int raw(void)
+{
+	return __value(parse_events_text + 1, 16, PE_RAW);
+}
+
+static int str(int token)
+{
+	parse_events_lval.str = strdup(parse_events_text);
+	return token;
+}
+
+static int sym(int type, int config)
+{
+	parse_events_lval.num = (type << 16) + config;
+	return PE_VALUE_SYM;
+}
+
+static int term(int type)
+{
+	parse_events_lval.num = type;
+	return PE_TERM;
+}
+
+%}
+
+num_dec		[0-9]+
+num_hex		0x[a-fA-F0-9]+
+num_raw_hex	[a-fA-F0-9]+
+name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
+modifier_event	[ukhp]{1,5}
+modifier_bp	[rwx]
+
+%%
+cpu-cycles|cycles				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
+stalled-cycles-frontend|idle-cycles-frontend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
+stalled-cycles-backend|idle-cycles-backend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
+instructions					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
+cache-references				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
+cache-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
+branch-instructions|branches			{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
+branch-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
+bus-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
+ref-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_REF_CPU_CYCLES); }
+cpu-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
+task-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
+page-faults|faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
+minor-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
+major-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
+context-switches|cs				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
+cpu-migrations|migrations			{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
+alignment-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
+emulation-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+
+L1-dcache|l1-d|l1d|L1-data		|
+L1-icache|l1-i|l1i|L1-instruction	|
+LLC|L2					|
+dTLB|d-tlb|Data-TLB			|
+iTLB|i-tlb|Instruction-TLB		|
+branch|branches|bpu|btb|bpc		|
+node					{ return str(PE_NAME_CACHE_TYPE); }
+
+load|loads|read				|
+store|stores|write			|
+prefetch|prefetches			|
+speculative-read|speculative-load	|
+refs|Reference|ops|access		|
+misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
+
+	/*
+	 * These are event config hardcoded term names to be specified
+	 * within xxx/.../ syntax. So far we dont clash with other names,
+	 * so we can put them here directly. In case the we have a conflict
+	 * in future, this needs to go into '//' condition block.
+	 */
+config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
+config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
+config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
+branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+
+mem:			{ return PE_PREFIX_MEM; }
+r{num_raw_hex}		{ return raw(); }
+{num_dec}		{ return value(10); }
+{num_hex}		{ return value(16); }
+
+{modifier_event}	{ return str(PE_MODIFIER_EVENT); }
+{modifier_bp}		{ return str(PE_MODIFIER_BP); }
+{name}			{ return str(PE_NAME); }
+"/"			{ return '/'; }
+-			{ return '-'; }
+,			{ return ','; }
+:			{ return ':'; }
+=			{ return '='; }
+
+%%
+
+int parse_events_wrap(void)
+{
+	return 1;
+}
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
new file mode 100644
index 0000000..d9637da
--- /dev/null
+++ b/tools/perf/util/parse-events.y
@@ -0,0 +1,229 @@
+
+%name-prefix "parse_events_"
+%parse-param {struct list_head *list_all}
+%parse-param {struct list_head *list_event}
+%parse-param {int *idx}
+
+%{
+
+#define YYDEBUG 1
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include "types.h"
+#include "util.h"
+#include "parse-events.h"
+
+extern int parse_events_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+	if (val) \
+		YYABORT; \
+} while (0)
+
+%}
+
+%token PE_VALUE PE_VALUE_SYM PE_RAW PE_TERM
+%token PE_NAME
+%token PE_MODIFIER_EVENT PE_MODIFIER_BP
+%token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
+%token PE_PREFIX_MEM PE_PREFIX_RAW
+%token PE_ERROR
+%type <num> PE_VALUE
+%type <num> PE_VALUE_SYM
+%type <num> PE_RAW
+%type <num> PE_TERM
+%type <str> PE_NAME
+%type <str> PE_NAME_CACHE_TYPE
+%type <str> PE_NAME_CACHE_OP_RESULT
+%type <str> PE_MODIFIER_EVENT
+%type <str> PE_MODIFIER_BP
+%type <head> event_config
+%type <term> event_term
+
+%union
+{
+	char *str;
+	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
+}
+%%
+
+events:
+events ',' event | event
+
+event:
+event_def PE_MODIFIER_EVENT
+{
+	/*
+	 * Apply modifier on all events added by single event definition
+	 * (there could be more events added for multiple tracepoint
+	 * definitions via '*?'.
+	 */
+	ABORT_ON(parse_events_modifier(list_event, $2));
+	parse_events_update_lists(list_event, list_all);
+}
+|
+event_def
+{
+	parse_events_update_lists(list_event, list_all);
+}
+
+event_def: event_pmu |
+	   event_legacy_symbol |
+	   event_legacy_cache sep_dc |
+	   event_legacy_mem |
+	   event_legacy_tracepoint sep_dc |
+	   event_legacy_numeric sep_dc |
+	   event_legacy_raw sep_dc
+
+event_pmu:
+PE_NAME '/' event_config '/'
+{
+	ABORT_ON(parse_events_add_pmu(list_event, idx, $1, $3));
+	parse_events__free_terms($3);
+}
+
+event_legacy_symbol:
+PE_VALUE_SYM '/' event_config '/'
+{
+	int type = $1 >> 16;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, $3));
+	parse_events__free_terms($3);
+}
+|
+PE_VALUE_SYM sep_slash_dc
+{
+	int type = $1 >> 16;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
+}
+
+event_legacy_cache:
+PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
+{
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, $5));
+}
+|
+PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
+{
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, NULL));
+}
+|
+PE_NAME_CACHE_TYPE
+{
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, NULL, NULL));
+}
+
+event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
+{
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, $4));
+}
+|
+PE_PREFIX_MEM PE_VALUE sep_dc
+{
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, NULL));
+}
+
+event_legacy_tracepoint:
+PE_NAME ':' PE_NAME
+{
+	ABORT_ON(parse_events_add_tracepoint(list_event, idx, $1, $3));
+}
+
+event_legacy_numeric:
+PE_VALUE ':' PE_VALUE
+{
+	ABORT_ON(parse_events_add_numeric(list_event, idx, $1, $3, NULL));
+}
+
+event_legacy_raw:
+PE_RAW
+{
+	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, $1, NULL));
+}
+
+event_config:
+event_config ',' event_term
+{
+	struct list_head *head = $1;
+	struct parse_events__term *term = $3;
+
+	ABORT_ON(!head);
+	list_add_tail(&term->list, head);
+	$$ = $1;
+}
+|
+event_term
+{
+	struct list_head *head = malloc(sizeof(*head));
+	struct parse_events__term *term = $1;
+
+	ABORT_ON(!head);
+	INIT_LIST_HEAD(head);
+	list_add_tail(&term->list, head);
+	$$ = head;
+}
+
+event_term:
+PE_NAME '=' PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
+		 $1, $3, 0));
+	$$ = term;
+}
+|
+PE_NAME '=' PE_VALUE
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 $1, NULL, $3));
+	$$ = term;
+}
+|
+PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 $1, NULL, 1));
+	$$ = term;
+}
+|
+PE_TERM '=' PE_VALUE
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, $3));
+	$$ = term;
+}
+|
+PE_TERM
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, 1));
+	$$ = term;
+}
+
+sep_dc: ':' |
+
+sep_slash_dc: '/' | ':' |
+
+%%
+
+void parse_events_error(struct list_head *list_all __used,
+			struct list_head *list_event __used,
+			int *idx __used,
+			char const *msg __used)
+{
+}
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
new file mode 100644
index 0000000..cb08a11
--- /dev/null
+++ b/tools/perf/util/pmu.c
@@ -0,0 +1,469 @@
+
+#include <linux/list.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <dirent.h>
+#include "sysfs.h"
+#include "util.h"
+#include "pmu.h"
+#include "parse-events.h"
+
+int perf_pmu_parse(struct list_head *list, char *name);
+extern FILE *perf_pmu_in;
+
+static LIST_HEAD(pmus);
+
+/*
+ * Parse & process all the sysfs attributes located under
+ * the directory specified in 'dir' parameter.
+ */
+static int pmu_format_parse(char *dir, struct list_head *head)
+{
+	struct dirent *evt_ent;
+	DIR *format_dir;
+	int ret = 0;
+
+	format_dir = opendir(dir);
+	if (!format_dir)
+		return -EINVAL;
+
+	while (!ret && (evt_ent = readdir(format_dir))) {
+		char path[PATH_MAX];
+		char *name = evt_ent->d_name;
+		FILE *file;
+
+		if (!strcmp(name, ".") || !strcmp(name, ".."))
+			continue;
+
+		snprintf(path, PATH_MAX, "%s/%s", dir, name);
+
+		ret = -EINVAL;
+		file = fopen(path, "r");
+		if (!file)
+			break;
+
+		perf_pmu_in = file;
+		ret = perf_pmu_parse(head, name);
+		fclose(file);
+	}
+
+	closedir(format_dir);
+	return ret;
+}
+
+/*
+ * Reading/parsing the default pmu format definition, which should be
+ * located at:
+ * /sys/bus/event_source/devices/<dev>/format as sysfs group attributes.
+ */
+static int pmu_format(char *name, struct list_head *format)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/format", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	if (pmu_format_parse(path, format))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Reading/parsing the default pmu type value, which should be
+ * located at:
+ * /sys/bus/event_source/devices/<dev>/type as sysfs attribute.
+ */
+static int pmu_type(char *name, __u32 *type)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+	FILE *file;
+	int ret = 0;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/type", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -EINVAL;
+
+	if (1 != fscanf(file, "%u", type))
+		ret = -1;
+
+	fclose(file);
+	return ret;
+}
+
+static struct perf_pmu *pmu_lookup(char *name)
+{
+	struct perf_pmu *pmu;
+	LIST_HEAD(format);
+	__u32 type;
+
+	/*
+	 * The pmu data we store & need consists of the pmu
+	 * type value and format definitions. Load both right
+	 * now.
+	 */
+	if (pmu_format(name, &format))
+		return NULL;
+
+	if (pmu_type(name, &type))
+		return NULL;
+
+	pmu = zalloc(sizeof(*pmu));
+	if (!pmu)
+		return NULL;
+
+	INIT_LIST_HEAD(&pmu->format);
+	list_splice(&format, &pmu->format);
+	pmu->name = strdup(name);
+	pmu->type = type;
+	return pmu;
+}
+
+static struct perf_pmu *pmu_find(char *name)
+{
+	struct perf_pmu *pmu;
+
+	list_for_each_entry(pmu, &pmus, list)
+		if (!strcmp(pmu->name, name))
+			return pmu;
+
+	return NULL;
+}
+
+struct perf_pmu *perf_pmu__find(char *name)
+{
+	struct perf_pmu *pmu;
+
+	/*
+	 * Once PMU is loaded it stays in the list,
+	 * so we keep us from multiple reading/parsing
+	 * the pmu format definitions.
+	 */
+	pmu = pmu_find(name);
+	if (pmu)
+		return pmu;
+
+	return pmu_lookup(name);
+}
+
+static struct perf_pmu__format*
+pmu_find_format(struct list_head *formats, char *name)
+{
+	struct perf_pmu__format *format;
+
+	list_for_each_entry(format, formats, list)
+		if (!strcmp(format->name, name))
+			return format;
+
+	return NULL;
+}
+
+/*
+ * Returns value based on the format definition (format parameter)
+ * and unformated value (value parameter).
+ *
+ * TODO maybe optimize a little ;)
+ */
+static __u64 pmu_format_value(unsigned long *format, __u64 value)
+{
+	unsigned long fbit, vbit;
+	__u64 v = 0;
+
+	for (fbit = 0, vbit = 0; fbit < PERF_PMU_FORMAT_BITS; fbit++) {
+
+		if (!test_bit(fbit, format))
+			continue;
+
+		if (!(value & (1llu << vbit++)))
+			continue;
+
+		v |= (1llu << fbit);
+	}
+
+	return v;
+}
+
+/*
+ * Setup one of config[12] attr members based on the
+ * user input data - temr parameter.
+ */
+static int pmu_config_term(struct list_head *formats,
+			   struct perf_event_attr *attr,
+			   struct parse_events__term *term)
+{
+	struct perf_pmu__format *format;
+	__u64 *vp;
+
+	/*
+	 * Support only for hardcoded and numnerial terms.
+	 * Hardcoded terms should be already in, so nothing
+	 * to be done for them.
+	 */
+	if (parse_events__is_hardcoded_term(term))
+		return 0;
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_NUM)
+		return -EINVAL;
+
+	format = pmu_find_format(formats, term->config);
+	if (!format)
+		return -EINVAL;
+
+	switch (format->value) {
+	case PERF_PMU_FORMAT_VALUE_CONFIG:
+		vp = &attr->config;
+		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG1:
+		vp = &attr->config1;
+		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG2:
+		vp = &attr->config2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*vp |= pmu_format_value(format->bits, term->val.num);
+	return 0;
+}
+
+static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
+		      struct list_head *head_terms)
+{
+	struct parse_events__term *term, *h;
+
+	list_for_each_entry_safe(term, h, head_terms, list)
+		if (pmu_config_term(formats, attr, term))
+			return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Configures event's 'attr' parameter based on the:
+ * 1) users input - specified in terms parameter
+ * 2) pmu format definitions - specified by pmu parameter
+ */
+int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
+		     struct list_head *head_terms)
+{
+	attr->type = pmu->type;
+	return pmu_config(&pmu->format, attr, head_terms);
+}
+
+int perf_pmu__new_format(struct list_head *list, char *name,
+			 int config, unsigned long *bits)
+{
+	struct perf_pmu__format *format;
+
+	format = zalloc(sizeof(*format));
+	if (!format)
+		return -ENOMEM;
+
+	format->name = strdup(name);
+	format->value = config;
+	memcpy(format->bits, bits, sizeof(format->bits));
+
+	list_add_tail(&format->list, list);
+	return 0;
+}
+
+void perf_pmu__set_format(unsigned long *bits, long from, long to)
+{
+	long b;
+
+	if (!to)
+		to = from;
+
+	memset(bits, 0, BITS_TO_LONGS(PERF_PMU_FORMAT_BITS));
+	for (b = from; b <= to; b++)
+		set_bit(b, bits);
+}
+
+/* Simulated format definitions. */
+static struct test_format {
+	const char *name;
+	const char *value;
+} test_formats[] = {
+	{ "krava01", "config:0-1,62-63\n", },
+	{ "krava02", "config:10-17\n", },
+	{ "krava03", "config:5\n", },
+	{ "krava11", "config1:0,2,4,6,8,20-28\n", },
+	{ "krava12", "config1:63\n", },
+	{ "krava13", "config1:45-47\n", },
+	{ "krava21", "config2:0-3,10-13,20-23,30-33,40-43,50-53,60-63\n", },
+	{ "krava22", "config2:8,18,48,58\n", },
+	{ "krava23", "config2:28-29,38\n", },
+};
+
+#define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
+
+/* Simulated users input. */
+static struct parse_events__term test_terms[] = {
+	{
+		.config  = (char *) "krava01",
+		.val.num = 15,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava02",
+		.val.num = 170,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava03",
+		.val.num = 1,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava11",
+		.val.num = 27,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava12",
+		.val.num = 1,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava13",
+		.val.num = 2,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava21",
+		.val.num = 119,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava22",
+		.val.num = 11,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava23",
+		.val.num = 2,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+};
+#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
+
+/*
+ * Prepare format directory data, exported by kernel
+ * at /sys/bus/event_source/devices/<dev>/format.
+ */
+static char *test_format_dir_get(void)
+{
+	static char dir[PATH_MAX];
+	unsigned int i;
+
+	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
+	if (!mkdtemp(dir))
+		return NULL;
+
+	for (i = 0; i < TEST_FORMATS_CNT; i++) {
+		static char name[PATH_MAX];
+		struct test_format *format = &test_formats[i];
+		FILE *file;
+
+		snprintf(name, PATH_MAX, "%s/%s", dir, format->name);
+
+		file = fopen(name, "w");
+		if (!file)
+			return NULL;
+
+		if (1 != fwrite(format->value, strlen(format->value), 1, file))
+			break;
+
+		fclose(file);
+	}
+
+	return dir;
+}
+
+/* Cleanup format directory. */
+static int test_format_dir_put(char *dir)
+{
+	char buf[PATH_MAX];
+	snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
+	if (system(buf))
+		return -1;
+
+	snprintf(buf, PATH_MAX, "rmdir %s\n", dir);
+	return system(buf);
+}
+
+static struct list_head *test_terms_list(void)
+{
+	static LIST_HEAD(terms);
+	unsigned int i;
+
+	for (i = 0; i < TERMS_CNT; i++)
+		list_add_tail(&test_terms[i].list, &terms);
+
+	return &terms;
+}
+
+#undef TERMS_CNT
+
+int perf_pmu__test(void)
+{
+	char *format = test_format_dir_get();
+	LIST_HEAD(formats);
+	struct list_head *terms = test_terms_list();
+	int ret;
+
+	if (!format)
+		return -EINVAL;
+
+	do {
+		struct perf_event_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
+		ret = pmu_format_parse(format, &formats);
+		if (ret)
+			break;
+
+		ret = pmu_config(&formats, &attr, terms);
+		if (ret)
+			break;
+
+		ret = -EINVAL;
+
+		if (attr.config  != 0xc00000000002a823)
+			break;
+		if (attr.config1 != 0x8000400000000145)
+			break;
+		if (attr.config2 != 0x0400000020041d07)
+			break;
+
+		ret = 0;
+	} while (0);
+
+	test_format_dir_put(format);
+	return ret;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
new file mode 100644
index 0000000..68c0db9
--- /dev/null
+++ b/tools/perf/util/pmu.h
@@ -0,0 +1,41 @@
+#ifndef __PMU_H
+#define __PMU_H
+
+#include <linux/bitops.h>
+#include "../../../include/linux/perf_event.h"
+
+enum {
+	PERF_PMU_FORMAT_VALUE_CONFIG,
+	PERF_PMU_FORMAT_VALUE_CONFIG1,
+	PERF_PMU_FORMAT_VALUE_CONFIG2,
+};
+
+#define PERF_PMU_FORMAT_BITS 64
+
+struct perf_pmu__format {
+	char *name;
+	int value;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+	struct list_head list;
+};
+
+struct perf_pmu {
+	char *name;
+	__u32 type;
+	struct list_head format;
+	struct list_head list;
+};
+
+struct perf_pmu *perf_pmu__find(char *name);
+int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
+		     struct list_head *head_terms);
+
+int perf_pmu_wrap(void);
+void perf_pmu_error(struct list_head *list, char *name, char const *msg);
+
+int perf_pmu__new_format(struct list_head *list, char *name,
+			 int config, unsigned long *bits);
+void perf_pmu__set_format(unsigned long *bits, long from, long to);
+
+int perf_pmu__test(void);
+#endif /* __PMU_H */
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
new file mode 100644
index 0000000..a15d9fb
--- /dev/null
+++ b/tools/perf/util/pmu.l
@@ -0,0 +1,43 @@
+%option prefix="perf_pmu_"
+
+%{
+#include <stdlib.h>
+#include <linux/bitops.h>
+#include "pmu.h"
+#include "pmu-bison.h"
+
+static int value(int base)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(perf_pmu_text, NULL, base);
+	if (errno)
+		return PP_ERROR;
+
+	perf_pmu_lval.num = num;
+	return PP_VALUE;
+}
+
+%}
+
+num_dec         [0-9]+
+
+%%
+
+{num_dec}	{ return value(10); }
+config		{ return PP_CONFIG; }
+config1		{ return PP_CONFIG1; }
+config2		{ return PP_CONFIG2; }
+-		{ return '-'; }
+:		{ return ':'; }
+,		{ return ','; }
+.		{ ; }
+\n		{ ; }
+
+%%
+
+int perf_pmu_wrap(void)
+{
+	return 1;
+}
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
new file mode 100644
index 0000000..20ea77e
--- /dev/null
+++ b/tools/perf/util/pmu.y
@@ -0,0 +1,93 @@
+
+%name-prefix "perf_pmu_"
+%parse-param {struct list_head *format}
+%parse-param {char *name}
+
+%{
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include <linux/bitmap.h>
+#include <string.h>
+#include "pmu.h"
+
+extern int perf_pmu_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+        if (val) \
+                YYABORT; \
+} while (0)
+
+%}
+
+%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_VALUE PP_ERROR
+%type <num> PP_VALUE
+%type <bits> bit_term
+%type <bits> bits
+
+%union
+{
+	unsigned long num;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+}
+
+%%
+
+format:
+format format_term
+|
+format_term
+
+format_term:
+PP_CONFIG ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG,
+				      $3));
+}
+|
+PP_CONFIG1 ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG1,
+				      $3));
+}
+|
+PP_CONFIG2 ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG2,
+				      $3));
+}
+
+bits:
+bits ',' bit_term
+{
+	bitmap_or($$, $1, $3, 64);
+}
+|
+bit_term
+{
+	memcpy($$, $1, sizeof($1));
+}
+
+bit_term:
+PP_VALUE '-' PP_VALUE
+{
+	perf_pmu__set_format($$, $1, $3);
+}
+|
+PP_VALUE
+{
+	perf_pmu__set_format($$, $1, 0);
+}
+
+%%
+
+void perf_pmu_error(struct list_head *list __used,
+		    char *name __used,
+		    char const *msg __used)
+{
+}
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 2cc162d..d448984 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -972,10 +972,12 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
+	Dwarf_Attribute attr;
 
 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function))
+	    !die_compare_name(sp_die, pp->function) ||
+	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 002ebbf..9412e3b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -140,6 +140,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
+	hists__init(&self->hists);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5dd83c3..c0a028c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,6 +1,5 @@
 #include <dirent.h>
 #include <errno.h>
-#include <libgen.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -51,6 +50,8 @@ struct symbol_conf symbol_conf = {
 
 int dso__name_len(const struct dso *dso)
 {
+	if (!dso)
+		return strlen("[unknown]");
 	if (verbose)
 		return dso->long_name_len;
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a4088ce..dfd1bd8 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -722,7 +722,7 @@ static char *event_read_name(void)
 static int event_read_id(void)
 {
 	char *token;
-	int id;
+	int id = -1;
 
 	if (read_expected_item(EVENT_ITEM, "ID") < 0)
 		return -1;
@@ -731,15 +731,13 @@ static int event_read_id(void)
 		return -1;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
+		goto free;
 
 	id = strtoul(token, NULL, 0);
-	free_token(token);
-	return id;
 
- fail:
+ free:
 	free_token(token);
-	return -1;
+	return id;
 }
 
 static int field_is_string(struct format_field *field)
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 84d761b..6ee82f6 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -49,6 +49,8 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 			const char *format, ...);
 int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_sec);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index fa530fc..d7a1c4a 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -879,6 +879,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char *options[16];
 	int nr_options = 0;
 	int key = -1;
+	char buf[64];
 
 	if (browser == NULL)
 		return -1;
@@ -933,6 +934,16 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
+		case 's':
+			if (ui_browser__input_window("Symbol to show",
+					"Please enter the name of symbol you want to see",
+					buf, "ENTER: OK, ESC: Cancel",
+					delay_secs * 2) == K_ENTER) {
+				self->symbol_filter_str = *buf ? buf : NULL;
+				hists__filter_by_symbol(self);
+				hist_browser__reset(browser);
+			}
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -950,7 +961,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread");
+					"t             Zoom into current Thread\n"
+					"s             Filter symbol by name");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/util/ui/keysyms.h
index 3458b19..809eca5 100644
--- a/tools/perf/util/ui/keysyms.h
+++ b/tools/perf/util/ui/keysyms.h
@@ -16,6 +16,8 @@
 #define K_TAB	'\t'
 #define K_UNTAB	SL_KEY_UNTAB
 #define K_UP	SL_KEY_UP
+#define K_BKSPC 0x7f
+#define K_DEL	SL_KEY_DELETE
 
 /* Not really keys */
 #define K_TIMER	 -1
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 45daa7c..ad4374a 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -69,6 +69,88 @@ int ui__popup_menu(int argc, char * const argv[])
 	return popup_menu__run(&menu);
 }
 
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_secs)
+{
+	int x, y, len, key;
+	int max_len = 60, nr_lines = 0;
+	static char buf[50];
+	const char *t;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	max_len += 2;
+	nr_lines += 8;
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2;
+	x = SLtt_Screen_Cols / 2 - max_len / 2;
+
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, x++, nr_lines, max_len);
+	if (title) {
+		SLsmg_gotorc(y, x + 1);
+		SLsmg_write_string((char *)title);
+	}
+	SLsmg_gotorc(++y, x);
+	nr_lines -= 7;
+	max_len -= 2;
+	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
+				   nr_lines, max_len, 1);
+	y += nr_lines;
+	len = 5;
+	while (len--) {
+		SLsmg_gotorc(y + len - 1, x);
+		SLsmg_write_nstring((char *)" ", max_len);
+	}
+	SLsmg_draw_box(y++, x + 1, 3, max_len - 2);
+
+	SLsmg_gotorc(y + 3, x);
+	SLsmg_write_nstring((char *)exit_msg, max_len);
+	SLsmg_refresh();
+
+	x += 2;
+	len = 0;
+	key = ui__getch(delay_secs);
+	while (key != K_TIMER && key != K_ENTER && key != K_ESC) {
+		if (key == K_BKSPC) {
+			if (len == 0)
+				goto next_key;
+			SLsmg_gotorc(y, x + --len);
+			SLsmg_write_char(' ');
+		} else {
+			buf[len] = key;
+			SLsmg_gotorc(y, x + len++);
+			SLsmg_write_char(key);
+		}
+		SLsmg_refresh();
+
+		/* XXX more graceful overflow handling needed */
+		if (len == sizeof(buf) - 1) {
+			ui_helpline__push("maximum size of symbol name reached!");
+			key = K_ENTER;
+			break;
+		}
+next_key:
+		key = ui__getch(delay_secs);
+	}
+
+	buf[len] = '\0';
+	strncpy(input, buf, len+1);
+	return key;
+}
+
 int ui__question_window(const char *title, const char *text,
 			const char *exit_msg, int delay_secs)
 {
