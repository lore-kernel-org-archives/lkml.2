Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab1JZNvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:51:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680Ab1JZNvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:51:09 -0400
Date: Wed, 26 Oct 2011 15:48:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.2
Message-ID: <20111026134839.GA27582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

There's a ton of changes as usual. The TUI rework of perf top and 
perf report should be the most user visible one - let us know if 
there's any trouble with that (or with any of the other changes).

As usual you can turn off the TUI via 'perf report --stdio' or via 
editing .perfconfig and get the old output - but obviously we'd 
prefer it if people told us about TUI workflow efficiency problems, 
large and small problems alike, so that we can fix them.

 Thanks,

	Ingo

------------------>
Andi Kleen (2):
      perf tools: Make stat/record print fatal signals of the target program
      perf: Support setting the disassembler style

Andrew Vagin (1):
      perf: Fix counter of ftrace events

Arnaldo Carvalho de Melo (49):
      perf symbols: Stop using 'self' in map_groups__ methods
      perf buildid-list: Add option to show the running kernel build id
      perf buildid-list: Support showing the build id in an ELF file
      perf top browser: Fix up line width calculation
      perf top: Improve lost events warning
      perf report: Fix stdio event name header printing
      perf hists: Stop using 'self' for struct hists
      perf hists: Allow limiting the number of rows and columns in fprintf
      perf report: Add option to show total period
      perf hists: Threaded addition and sorting of entries
      perf browsers: Add live mode to the hists, annotate browsers
      perf top: Reuse the 'report' hist_entry/hists classes
      perf top: Add callgraph support
      perf annotate browser: Allow navigation to called functions
      perf top: Use the TUI interface by default
      perf annotate browser: Use -> to navigate on assembly lines
      perf hists browser: Don't offer symbol actions when symbols not on --sort
      perf hists browser: Fix TAB/UNTAB use with multiple events
      perf hists browser: Update the browser.nr_entries after the timer
      perf tools: Make --no-asm-raw the default
      perf hists browser: Recalculate browser pointers after resort/decay
      perf hists: Don't free decayed entries if in the annotation browser
      perf ui browser: Handle SIGWINCH
      perf ui browser: Remove ui_browser__add_exit_keys
      perf top: Remove entries from entries_collapsed on decay
      perf hists browser: Fix handling of TAB/UNTAB for multiple events
      perf hists browser: Invalidate ui_browser->top after timer calls
      perf annotate browser: Exit when pressing ESC or the left arrow
      perf ui browser: Add filter method
      perf annotate browser: Allow toggling the visualization of source code lines
      perf top: Honour --hide_{user,kernel}_symbols and the 'U' hotkey
      perf top: Fix the 'E' hotkey, select among multiple events
      perf hists browser: Add missing hotkeys to the help window
      perf tui: Catch signals to exit gracefully
      perf ui browser: Allow initial use without navigation UI elements
      perf hists: Don't format the percentage on hist_entry__snprintf
      perf tui: Remove unneeded call to newtCls on startup
      perf ui browser: Make the colors configurable and change the defaults
      perf top tui: Give color hints just on the percentage, like on --stdio
      perf ui browser: Honour the xterm colors
      perf hists: Move the dso and thread filters from hist_browser
      perf hists browser: Apply the dso and thread filters when merging new batches
      perf annotate browser: Don't change selection line when returning from callq
      perf hists browser: Honour symbol_conf.show_{nr_samples,total_period}
      perf hists: Don't decay total_period for filtered entries
      perf hists: Don't consider filtered entries when calculating column widths
      perf hists browser: Elide DSO column when it is set to just one DSO, ditto for threads
      perf ui browser: Use libslang to read keys
      perf hists browser: Refuse 'a' hotkey on non symbolic views

David Ahern (4):
      perf script: Fix unknown feature comment
      perf tools: Add prelink suggestion to dso update message
      perf tools: handle endianness of feature bitmap
      perf hists browser: Do not exit on tab key with single event

Don Zickus (5):
      x86, nmi: Split out nmi from traps.c
      x86, nmi: Create new NMI handler routines
      x86, nmi: Wire up NMI handlers to new routines
      x86, nmi: Add in logic to handle multiple events and unknown NMIs
      x86, nmi: Track NMI usage stats

Eric Dumazet (1):
      watchdog: Make the kthreads NUMA affine

Geunsik Lim (1):
      ftrace: Fix README to state tracing_on to start/stop tracing

Gleb Natapov (1):
      perf, intel: Use GO/HO bits in perf-ctr

Hidetoshi Seto (1):
      x86, mce: Do not call del_timer_sync() in IRQ context

Ingo Molnar (1):
      x86, nmi, drivers: Fix nmi splitup build bug

Jim Cromie (5):
      perf stat: Add --log-fd <N> option to redirect stderr elsewhere
      perf stat: Fix +- nan% in --no-aggr runs
      perf stat: Suppress printing std-dev when its 0
      perf stat: Allow tab as cvs delimiter
      perf stat: Fix spelling in comment

Jiri Olsa (13):
      tracing/filter: Use static allocation for filter predicates
      tracing/filter: Separate predicate init and filter addition
      tracing/filter: Remove field_name from filter_pred struct
      tracing/filter: Simplify tracepoint event lookup
      tracing/filter: Unify predicate tree walking, change check_pred_tree function to use it
      tracing/filter: Change count_leafs function to use walk_pred_tree
      tracing/filter: Change fold_pred_tree function to use walk_pred_tree
      tracing/filter: Change fold_pred function to use walk_pred_tree
      tracing/filter: Change filter_match_preds function to use walk_pred_tree
      tracing/filter: Add startup tests for events filter
      perf sched: Fix script command documentation
      perf symbols: Treat all memory maps without dso file as loaded
      perf tools: Fix tracing info recording

Joerg Roedel (2):
      perf, core: Introduce attrs to count in either host or guest mode
      perf, amd: Use GO/HO bits in perf-ctr

Josh Stone (1):
      x86, perf, kprobes: Make kprobes's twobyte_is_boostable volatile

Kevin Winchester (2):
      x86: jump_label: arch_jump_label_text_poke_early: add missing __init
      x86, perf: Clean up perf_event cpu code

Maarten Lankhorst (1):
      oprofile, x86: Convert memory allocation to static array

Mark Rutland (1):
      perf: provide PMU when initing events

Masami Hiramatsu (2):
      ftrace/kprobes: Fix not to delete probes if in use
      perf probe: Fix to show correct error string

Mathieu Desnoyers (1):
      Tracepoint: Dissociate from module mutex

Mike Galbraith (1):
      perf hists browser: Add missing stdarg.h include

Neil Horman (1):
      perf script: Add drop monitor script

Peter Zijlstra (2):
      perf, x86: Avoid kfree() in CPU_STARTING
      perf: Add PM notifiers to fix CPU hotplug races

Randy Dunlap (1):
      x86: Perf_event_amd.c needs <asm/apicdef.h>

Ricardo Ribalda Delgado (1):
      perf symbols: Increase symbol KSYM_NAME_LEN size

Robert Richter (3):
      oprofile, x86: Fix overflow and warning (commit 1d12d35)
      perf, x86: Share IBS macros between perf and oprofile
      perf, x86: Implement IBS initialization

Stephane Eranian (6):
      perf annotate: Make output more readable
      perf annotate: Add --symfs option
      perf stat: Add -o and --append options
      perf tools: Fix broken number of samples for perf report -n
      perf tools: Make perf.data more self-descriptive (v8)
      perf hists: Fix compilation when NO_NEWT_SUPPORT is set

Steven Rostedt (8):
      tracing: Clean up tb_fmt to not give faulty compile warning
      tracing: Add preempt disable for filter self test
      tracing: Add a counter clock for those that do not trust clocks
      tracing: Fix preemptirqsoff tracer to not stop at preempt off
      tracing: Warn on output if the function tracer was found corrupted
      tracing: Do not allocate buffer for trace_marker
      tracing: Fix returning of duplicate data after EOF in trace_pipe_raw
      m32r: Allow use of atomic64

Thomas Gleixner (1):
      watchdog: Drop FIFO policy in exit path

Thomas Jarosch (1):
      perf buildid: Fix possible unterminated readlink() result buffer

Vaibhav Nagarnaik (2):
      trace: Add a new readonly entry to report total buffer size
      trace: Add ring buffer stats to measure rate of events


 arch/m32r/Kconfig                                  |    1 +
 arch/x86/include/asm/nmi.h                         |   37 +-
 arch/x86/include/asm/perf_event.h                  |   55 +-
 arch/x86/include/asm/reboot.h                      |    2 +-
 arch/x86/kernel/Makefile                           |    2 +-
 arch/x86/kernel/apic/hw_nmi.c                      |   27 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   20 +-
 arch/x86/kernel/cpu/Makefile                       |    7 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |   20 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |   23 +-
 arch/x86/kernel/cpu/perf_event.c                   |  442 +-------
 arch/x86/kernel/cpu/perf_event.h                   |  505 ++++++++
 arch/x86/kernel/cpu/perf_event_amd.c               |   38 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |  294 +++++
 arch/x86/kernel/cpu/perf_event_intel.c             |  146 ++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |   79 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   28 +-
 arch/x86/kernel/cpu/perf_event_p4.c                |   10 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |    9 +-
 arch/x86/kernel/crash.c                            |    5 +-
 arch/x86/kernel/jump_label.c                       |    2 +-
 arch/x86/kernel/kgdb.c                             |   60 +-
 arch/x86/kernel/kprobes.c                          |    4 +-
 arch/x86/kernel/nmi.c                              |  433 +++++++
 arch/x86/kernel/process_32.c                       |    2 +
 arch/x86/kernel/process_64.c                       |    2 +
 arch/x86/kernel/reboot.c                           |   23 +-
 arch/x86/kernel/traps.c                            |  155 ---
 arch/x86/oprofile/nmi_int.c                        |   42 +-
 arch/x86/oprofile/nmi_timer_int.c                  |   28 +-
 arch/x86/oprofile/op_model_amd.c                   |  234 +----
 arch/x86/oprofile/op_model_ppro.c                  |   27 +-
 arch/x86/oprofile/op_x86_model.h                   |    1 -
 drivers/acpi/apei/ghes.c                           |   22 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |   33 +-
 drivers/watchdog/hpwdt.c                           |   25 +-
 include/linux/module.h                             |   12 -
 include/linux/perf_event.h                         |    5 +-
 include/linux/ring_buffer.h                        |    2 +
 include/linux/trace_clock.h                        |    1 +
 include/linux/tracepoint.h                         |   25 +-
 include/trace/ftrace.h                             |    3 +
 kernel/events/core.c                               |  101 ++-
 kernel/module.c                                    |   47 -
 kernel/trace/Makefile                              |    2 +
 kernel/trace/ftrace.c                              |    8 +
 kernel/trace/ring_buffer.c                         |   70 ++-
 kernel/trace/trace.c                               |  181 +++-
 kernel/trace/trace.h                               |   16 +-
 kernel/trace/trace_clock.c                         |   12 +
 kernel/trace/trace_events_filter.c                 |  795 ++++++++------
 kernel/trace/trace_events_filter_test.h            |   50 +
 kernel/trace/trace_irqsoff.c                       |    4 +-
 kernel/trace/trace_kprobe.c                        |   58 +-
 kernel/trace/trace_printk.c                        |   19 +-
 kernel/tracepoint.c                                |  169 +++-
 kernel/watchdog.c                                  |    7 +-
 tools/perf/Documentation/perf-annotate.txt         |   13 +
 tools/perf/Documentation/perf-buildid-list.txt     |    6 +
 tools/perf/Documentation/perf-report.txt           |   20 +-
 tools/perf/Documentation/perf-sched.txt            |    6 +-
 tools/perf/Documentation/perf-script.txt           |    7 +
 tools/perf/Documentation/perf-stat.txt             |   16 +
 tools/perf/Documentation/perf-top.txt              |   48 +-
 tools/perf/Documentation/perfconfig.example        |   20 +
 tools/perf/Makefile                                |    5 +-
 tools/perf/arch/powerpc/Makefile                   |    1 +
 tools/perf/arch/powerpc/util/header.c              |   36 +
 tools/perf/arch/x86/Makefile                       |    1 +
 tools/perf/arch/x86/util/header.c                  |   59 +
 tools/perf/builtin-annotate.c                      |   25 +-
 tools/perf/builtin-buildid-list.c                  |   52 +-
 tools/perf/builtin-diff.c                          |    2 +-
 tools/perf/builtin-record.c                        |   34 +-
 tools/perf/builtin-report.c                        |   28 +-
 tools/perf/builtin-script.c                        |    6 +-
 tools/perf/builtin-stat.c                          |  190 ++--
 tools/perf/builtin-top.c                           |  495 +++++---
 tools/perf/builtin.h                               |    1 -
 tools/perf/perf.c                                  |   24 +
 tools/perf/perf.h                                  |   13 +
 .../perf/scripts/python/bin/net_dropmonitor-record |    2 +
 .../perf/scripts/python/bin/net_dropmonitor-report |    4 +
 tools/perf/scripts/python/net_dropmonitor.py       |   72 ++
 tools/perf/util/annotate.c                         |   11 +-
 tools/perf/util/annotate.h                         |    9 +-
 tools/perf/util/color.c                            |    2 +-
 tools/perf/util/evlist.c                           |    6 +
 tools/perf/util/evlist.h                           |    4 +
 tools/perf/util/evsel.c                            |    1 +
 tools/perf/util/header.c                           | 1231 +++++++++++++++++++-
 tools/perf/util/header.h                           |   29 +-
 tools/perf/util/hist.c                             |  447 ++++++--
 tools/perf/util/hist.h                             |   61 +-
 tools/perf/util/map.c                              |  102 +-
 tools/perf/util/map.h                              |   42 +-
 tools/perf/util/probe-event.c                      |    4 +-
 tools/perf/util/session.c                          |   19 +
 tools/perf/util/session.h                          |    1 +
 tools/perf/util/sort.c                             |    4 +-
 tools/perf/util/sort.h                             |    2 +
 tools/perf/util/symbol.c                           |    3 +-
 tools/perf/util/symbol.h                           |    5 +-
 tools/perf/util/top.c                              |  141 +---
 tools/perf/util/top.h                              |   39 +-
 tools/perf/util/trace-event-info.c                 |  112 ++-
 tools/perf/util/trace-event.h                      |   13 +-
 tools/perf/util/ui/browser.c                       |  386 +++++--
 tools/perf/util/ui/browser.h                       |   12 +-
 tools/perf/util/ui/browsers/annotate.c             |  201 +++-
 tools/perf/util/ui/browsers/hists.c                |  297 +++--
 tools/perf/util/ui/browsers/map.c                  |    6 +-
 tools/perf/util/ui/browsers/top.c                  |  212 ----
 tools/perf/util/ui/helpline.h                      |    3 +
 tools/perf/util/ui/keysyms.h                       |   25 +
 tools/perf/util/ui/libslang.h                      |    2 +
 tools/perf/util/ui/setup.c                         |   38 +-
 117 files changed, 6208 insertions(+), 2878 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_ibs.c
 create mode 100644 arch/x86/kernel/nmi.c
 create mode 100644 kernel/trace/trace_events_filter_test.h
 create mode 100644 tools/perf/Documentation/perfconfig.example
 create mode 100644 tools/perf/arch/powerpc/util/header.c
 create mode 100644 tools/perf/arch/x86/util/header.c
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-record
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-report
 create mode 100755 tools/perf/scripts/python/net_dropmonitor.py
 delete mode 100644 tools/perf/util/ui/browsers/top.c
 create mode 100644 tools/perf/util/ui/keysyms.h

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b92b944..6c4e9aa 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 
 config SBUS
 	bool
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 4886a68..fd3f9f1 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -22,27 +22,26 @@ void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
-/*
- * Define some priorities for the nmi notifier call chain.
- *
- * Create a local nmi bit that has a higher priority than
- * external nmis, because the local ones are more frequent.
- *
- * Also setup some default high/normal/low settings for
- * subsystems to registers with.  Using 4 bits to separate
- * the priorities.  This can go a lot higher if needed be.
- */
-
-#define NMI_LOCAL_SHIFT		16	/* randomly picked */
-#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
-#define NMI_HIGH_PRIOR		(1ULL << 8)
-#define NMI_NORMAL_PRIOR	(1ULL << 4)
-#define NMI_LOW_PRIOR		(1ULL << 0)
-#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
-#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
-#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
+#define NMI_FLAG_FIRST	1
+
+enum {
+	NMI_LOCAL=0,
+	NMI_UNKNOWN,
+	NMI_MAX
+};
+
+#define NMI_DONE	0
+#define NMI_HANDLED	1
+
+typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
+
+int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
+			 const char *);
+
+void unregister_nmi_handler(unsigned int, const char *);
 
 void stop_nmi(void);
 void restart_nmi(void);
+void local_touch_nmi(void);
 
 #endif /* _ASM_X86_NMI_H */
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 094fb30..f61c62f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
+#define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
+
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
 #define INTEL_ARCH_EVENT_MASK	\
@@ -43,14 +46,17 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NUM_COUNTERS				4
+#define AMD64_NUM_COUNTERS_F15H				6
+#define AMD64_NUM_COUNTERS_MAX				AMD64_NUM_COUNTERS_F15H
 
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX			 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX		0
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
 		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
-#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED		6
 
 /*
  * Intel "Architectural Performance Monitoring" CPUID
@@ -110,6 +116,35 @@ union cpuid10_edx {
  */
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
+/*
+ * IBS cpuid feature detection
+ */
+
+#define IBS_CPUID_FEATURES		0x8000001b
+
+/*
+ * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
+ * bit 0 is used to indicate the existence of IBS.
+ */
+#define IBS_CAPS_AVAIL			(1U<<0)
+#define IBS_CAPS_FETCHSAM		(1U<<1)
+#define IBS_CAPS_OPSAM			(1U<<2)
+#define IBS_CAPS_RDWROPCNT		(1U<<3)
+#define IBS_CAPS_OPCNT			(1U<<4)
+#define IBS_CAPS_BRNTRGT		(1U<<5)
+#define IBS_CAPS_OPCNTEXT		(1U<<6)
+
+#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
+					 | IBS_CAPS_FETCHSAM	\
+					 | IBS_CAPS_OPSAM)
+
+/*
+ * IBS APIC setup
+ */
+#define IBSCTL				0x1cc
+#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
+#define IBSCTL_LVT_OFFSET_MASK		0x0F
+
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN	(1ULL<<57)
 #define IBS_FETCH_VAL		(1ULL<<49)
@@ -124,6 +159,8 @@ union cpuid10_edx {
 #define IBS_OP_MAX_CNT		0x0000FFFFULL
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
+extern u32 get_ibs_caps(void);
+
 #ifdef CONFIG_PERF_EVENTS
 extern void perf_events_lapic_init(void);
 
@@ -159,7 +196,19 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 	);							\
 }
 
+struct perf_guest_switch_msr {
+	unsigned msr;
+	u64 host, guest;
+};
+
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 #else
+static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+{
+	*nr = 0;
+	return NULL;
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 3250e3d..92f29706 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -23,7 +23,7 @@ void machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-typedef void (*nmi_shootdown_cb)(int, struct die_args*);
+typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 
 #endif /* _ASM_X86_REBOOT_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 82f2912..8baca3c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -19,7 +19,7 @@ endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time.o ioport.o ldt.o dumpstack.o
+obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index d5e57db0..31cb9ae 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -60,22 +60,10 @@ void arch_trigger_all_cpu_backtrace(void)
 }
 
 static int __kprobes
-arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
-			 unsigned long cmd, void *__args)
+arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = __args;
-	struct pt_regs *regs;
 	int cpu;
 
-	switch (cmd) {
-	case DIE_NMI:
-		break;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
-	regs = args->regs;
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
@@ -86,21 +74,16 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 		show_regs(regs);
 		arch_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	}
 
-	return NOTIFY_DONE;
+	return NMI_DONE;
 }
 
-static __read_mostly struct notifier_block backtrace_notifier = {
-	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
-	.next                   = NULL,
-	.priority               = NMI_LOCAL_LOW_PRIOR,
-};
-
 static int __init register_trigger_all_cpu_backtrace(void)
 {
-	register_die_notifier(&backtrace_notifier);
+	register_nmi_handler(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler,
+				0, "arch_bt");
 	return 0;
 }
 early_initcall(register_trigger_all_cpu_backtrace);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 34b1859..75be00e 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -672,18 +672,11 @@ void __cpuinit uv_cpu_init(void)
 /*
  * When NMI is received, print a stack trace.
  */
-int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
+int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 {
 	unsigned long real_uv_nmi;
 	int bid;
 
-	if (reason != DIE_NMIUNKNOWN)
-		return NOTIFY_OK;
-
-	if (in_crash_kexec)
-		/* do nothing if entering the crash kernel */
-		return NOTIFY_OK;
-
 	/*
 	 * Each blade has an MMR that indicates when an NMI has been sent
 	 * to cpus on the blade. If an NMI is detected, atomically
@@ -704,7 +697,7 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 	}
 
 	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
-		return NOTIFY_DONE;
+		return NMI_DONE;
 
 	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
 
@@ -717,17 +710,12 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 	dump_stack();
 	spin_unlock(&uv_nmi_lock);
 
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
 
-static struct notifier_block uv_dump_stack_nmi_nb = {
-	.notifier_call	= uv_handle_nmi,
-	.priority = NMI_LOCAL_LOW_PRIOR - 1,
-};
-
 void uv_register_nmi_notifier(void)
 {
-	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		printk(KERN_WARNING "UV NMI handler failed to register\n");
 }
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..fe6eb19 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -28,10 +28,15 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
+ifdef CONFIG_PERF_EVENTS
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
+endif
+
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
-obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 0ed633c..6199232 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -78,27 +78,20 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 
 static cpumask_var_t mce_inject_cpumask;
 
-static int mce_raise_notify(struct notifier_block *self,
-			    unsigned long val, void *data)
+static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
-		return NOTIFY_DONE;
+	if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
+		return NMI_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
-		raise_exception(m, args->regs);
+		raise_exception(m, regs);
 	else if (m->status)
 		raise_poll(m);
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
 
-static struct notifier_block mce_raise_nb = {
-	.notifier_call = mce_raise_notify,
-	.priority = NMI_LOCAL_NORMAL_PRIOR,
-};
-
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
@@ -216,7 +209,8 @@ static int inject_init(void)
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
-	register_die_notifier(&mce_raise_nb);
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
+				"mce_notify");
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..fce51ad1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -908,9 +908,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	percpu_inc(mce_exception_count);
 
-	if (notify_die(DIE_NMI, "machine check", regs, error_code,
-			   18, SIGKILL) == NOTIFY_STOP)
-		goto out;
 	if (!banks)
 		goto out;
 
@@ -1140,6 +1137,15 @@ static void mce_start_timer(unsigned long data)
 	add_timer_on(t, smp_processor_id());
 }
 
+/* Must not be called in IRQ context where del_timer_sync() can deadlock */
+static void mce_timer_delete_all(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		del_timer_sync(&per_cpu(mce_timer, cpu));
+}
+
 static void mce_do_trigger(struct work_struct *work)
 {
 	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
@@ -1750,7 +1756,6 @@ static struct syscore_ops mce_syscore_ops = {
 
 static void mce_cpu_restart(void *data)
 {
-	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
@@ -1760,16 +1765,15 @@ static void mce_cpu_restart(void *data)
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
+	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
 /* Toggle features for corrected errors */
-static void mce_disable_ce(void *all)
+static void mce_disable_cmci(void *data)
 {
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
-	if (all)
-		del_timer_sync(&__get_cpu_var(mce_timer));
 	cmci_clear();
 }
 
@@ -1852,7 +1856,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
 	if (mce_ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
-			on_each_cpu(mce_disable_ce, (void *)1, 1);
+			mce_timer_delete_all();
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_ignore_ce = 1;
 		} else {
 			/* enable ce features */
@@ -1875,7 +1880,7 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
 	if (mce_cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
-			on_each_cpu(mce_disable_ce, NULL, 1);
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_cmci_disabled = 1;
 		} else {
 			/* enable cmci */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cfa62ec..6408910 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,8 @@
 #include <asm/smp.h>
 #include <asm/alternative.h>
 
+#include "perf_event.h"
+
 #if 0
 #undef wrmsrl
 #define wrmsrl(msr, val) 					\
@@ -43,283 +45,17 @@ do {								\
 } while (0)
 #endif
 
-/*
- *          |   NHM/WSM    |      SNB     |
- * register -------------------------------
- *          |  HT  | no HT |  HT  | no HT |
- *-----------------------------------------
- * offcore  | core | core  | cpu  | core  |
- * lbr_sel  | core | core  | cpu  | core  |
- * ld_lat   | cpu  | core  | cpu  | core  |
- *-----------------------------------------
- *
- * Given that there is a small number of shared regs,
- * we can pre-allocate their slot in the per-cpu
- * per-core reg tables.
- */
-enum extra_reg_type {
-	EXTRA_REG_NONE  = -1,	/* not used */
-
-	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
-	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
-
-	EXTRA_REG_MAX		/* number of entries needed */
-};
-
-struct event_constraint {
-	union {
-		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-		u64		idxmsk64;
-	};
-	u64	code;
-	u64	cmask;
-	int	weight;
-};
-
-struct amd_nb {
-	int nb_id;  /* NorthBridge id */
-	int refcnt; /* reference count */
-	struct perf_event *owners[X86_PMC_IDX_MAX];
-	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
-};
-
-struct intel_percore;
-
-#define MAX_LBR_ENTRIES		16
-
-struct cpu_hw_events {
-	/*
-	 * Generic x86 PMC bits
-	 */
-	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
-	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int			enabled;
-
-	int			n_events;
-	int			n_added;
-	int			n_txn;
-	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
-	u64			tags[X86_PMC_IDX_MAX];
-	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
-
-	unsigned int		group_flag;
-
-	/*
-	 * Intel DebugStore bits
-	 */
-	struct debug_store	*ds;
-	u64			pebs_enabled;
-
-	/*
-	 * Intel LBR bits
-	 */
-	int				lbr_users;
-	void				*lbr_context;
-	struct perf_branch_stack	lbr_stack;
-	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
-
-	/*
-	 * manage shared (per-core, per-cpu) registers
-	 * used on Intel NHM/WSM/SNB
-	 */
-	struct intel_shared_regs	*shared_regs;
-
-	/*
-	 * AMD specific bits
-	 */
-	struct amd_nb		*amd_nb;
-};
-
-#define __EVENT_CONSTRAINT(c, n, m, w) {\
-	{ .idxmsk64 = (n) },		\
-	.code = (c),			\
-	.cmask = (m),			\
-	.weight = (w),			\
-}
-
-#define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
-
-/*
- * Constraint on the Event code.
- */
-#define INTEL_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
-
-/*
- * Constraint on the Event code + UMask + fixed-mask
- *
- * filter mask to validate fixed counter events.
- * the following filters disqualify for fixed counters:
- *  - inv
- *  - edge
- *  - cnt-mask
- *  The other filters are supported by fixed counters.
- *  The any-thread option is supported starting with v3.
- */
-#define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
-
-/*
- * Constraint on the Event code + UMask
- */
-#define INTEL_UEVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
-
-#define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
-
-#define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
-
-/*
- * Per register state.
- */
-struct er_account {
-	raw_spinlock_t		lock;	/* per-core: protect structure */
-	u64			config;	/* extra MSR config */
-	u64			reg;	/* extra MSR number */
-	atomic_t		ref;	/* reference count */
-};
-
-/*
- * Extra registers for specific events.
- *
- * Some events need large masks and require external MSRs.
- * Those extra MSRs end up being shared for all events on
- * a PMU and sometimes between PMU of sibling HT threads.
- * In either case, the kernel needs to handle conflicting
- * accesses to those extra, shared, regs. The data structure
- * to manage those registers is stored in cpu_hw_event.
- */
-struct extra_reg {
-	unsigned int		event;
-	unsigned int		msr;
-	u64			config_mask;
-	u64			valid_mask;
-	int			idx;  /* per_xxx->regs[] reg index */
-};
-
-#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event = (e),		\
-	.msr = (ms),		\
-	.config_mask = (m),	\
-	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i	\
-	}
-
-#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
-
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
-
-union perf_capabilities {
-	struct {
-		u64	lbr_format    : 6;
-		u64	pebs_trap     : 1;
-		u64	pebs_arch_reg : 1;
-		u64	pebs_format   : 4;
-		u64	smm_freeze    : 1;
-	};
-	u64	capabilities;
-};
-
-/*
- * struct x86_pmu - generic x86 pmu
- */
-struct x86_pmu {
-	/*
-	 * Generic x86 PMC bits
-	 */
-	const char	*name;
-	int		version;
-	int		(*handle_irq)(struct pt_regs *);
-	void		(*disable_all)(void);
-	void		(*enable_all)(int added);
-	void		(*enable)(struct perf_event *);
-	void		(*disable)(struct perf_event *);
-	int		(*hw_config)(struct perf_event *event);
-	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
-	unsigned	eventsel;
-	unsigned	perfctr;
-	u64		(*event_map)(int);
-	int		max_events;
-	int		num_counters;
-	int		num_counters_fixed;
-	int		cntval_bits;
-	u64		cntval_mask;
-	int		apic;
-	u64		max_period;
-	struct event_constraint *
-			(*get_event_constraints)(struct cpu_hw_events *cpuc,
-						 struct perf_event *event);
-
-	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
-						 struct perf_event *event);
-	struct event_constraint *event_constraints;
-	void		(*quirks)(void);
-	int		perfctr_second_write;
-
-	int		(*cpu_prepare)(int cpu);
-	void		(*cpu_starting)(int cpu);
-	void		(*cpu_dying)(int cpu);
-	void		(*cpu_dead)(int cpu);
-
-	/*
-	 * Intel Arch Perfmon v2+
-	 */
-	u64			intel_ctrl;
-	union perf_capabilities intel_cap;
+struct x86_pmu x86_pmu __read_mostly;
 
-	/*
-	 * Intel DebugStore bits
-	 */
-	int		bts, pebs;
-	int		bts_active, pebs_active;
-	int		pebs_record_size;
-	void		(*drain_pebs)(struct pt_regs *regs);
-	struct event_constraint *pebs_constraints;
-
-	/*
-	 * Intel LBR
-	 */
-	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
-	int		lbr_nr;			   /* hardware stack size */
-
-	/*
-	 * Extra registers for events
-	 */
-	struct extra_reg *extra_regs;
-	unsigned int er_flags;
-};
-
-#define ERF_NO_HT_SHARING	1
-#define ERF_HAS_RSP_1		2
-
-static struct x86_pmu x86_pmu __read_mostly;
-
-static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
+DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static int x86_perf_event_set_period(struct perf_event *event);
-
-/*
- * Generalized hw caching related hw_event table, filled
- * in on a per model basis. A value of 0 means
- * 'not supported', -1 means 'hw_event makes no sense on
- * this CPU', any other value means the raw hw_event
- * ID.
- */
-
-#define C(x) PERF_COUNT_HW_CACHE_##x
-
-static u64 __read_mostly hw_cache_event_ids
+u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
-static u64 __read_mostly hw_cache_extra_regs
+u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
@@ -329,8 +65,7 @@ static u64 __read_mostly hw_cache_extra_regs
  * Can only be executed on the CPU where the event is active.
  * Returns the delta events processed.
  */
-static u64
-x86_perf_event_update(struct perf_event *event)
+u64 x86_perf_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.cntval_bits;
@@ -373,30 +108,6 @@ again:
 	return new_raw_count;
 }
 
-static inline int x86_pmu_addr_offset(int index)
-{
-	int offset;
-
-	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
-	alternative_io(ASM_NOP2,
-		       "shll $1, %%eax",
-		       X86_FEATURE_PERFCTR_CORE,
-		       "=a" (offset),
-		       "a"  (index));
-
-	return offset;
-}
-
-static inline unsigned int x86_pmu_config_addr(int index)
-{
-	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
-}
-
-static inline unsigned int x86_pmu_event_addr(int index)
-{
-	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
-}
-
 /*
  * Find and validate any extra registers to set up.
  */
@@ -532,9 +243,6 @@ msr_fail:
 	return false;
 }
 
-static void reserve_ds_buffers(void);
-static void release_ds_buffers(void);
-
 static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
@@ -583,7 +291,7 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 	return x86_pmu_extra_regs(val, event);
 }
 
-static int x86_setup_perfctr(struct perf_event *event)
+int x86_setup_perfctr(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
 	struct hw_perf_event *hwc = &event->hw;
@@ -647,7 +355,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	return 0;
 }
 
-static int x86_pmu_hw_config(struct perf_event *event)
+int x86_pmu_hw_config(struct perf_event *event)
 {
 	if (event->attr.precise_ip) {
 		int precise = 0;
@@ -723,7 +431,7 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	return x86_pmu.hw_config(event);
 }
 
-static void x86_pmu_disable_all(void)
+void x86_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -758,15 +466,7 @@ static void x86_pmu_disable(struct pmu *pmu)
 	x86_pmu.disable_all();
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
-					  u64 enable_mask)
-{
-	if (hwc->extra_reg.reg)
-		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
-	wrmsrl(hwc->config_base, hwc->config | enable_mask);
-}
-
-static void x86_pmu_enable_all(int added)
+void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -788,7 +488,7 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
-static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -959,7 +659,6 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 }
 
 static void x86_pmu_start(struct perf_event *event, int flags);
-static void x86_pmu_stop(struct perf_event *event, int flags);
 
 static void x86_pmu_enable(struct pmu *pmu)
 {
@@ -1031,21 +730,13 @@ static void x86_pmu_enable(struct pmu *pmu)
 	x86_pmu.enable_all(added);
 }
 
-static inline void x86_pmu_disable_event(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-
-	wrmsrl(hwc->config_base, hwc->config);
-}
-
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
 
 /*
  * Set the next IRQ period, based on the hwc->period_left value.
  * To be called with the event disabled in hw:
  */
-static int
-x86_perf_event_set_period(struct perf_event *event)
+int x86_perf_event_set_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 left = local64_read(&hwc->period_left);
@@ -1105,7 +796,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	return ret;
 }
 
-static void x86_pmu_enable_event(struct perf_event *event)
+void x86_pmu_enable_event(struct perf_event *event)
 {
 	if (__this_cpu_read(cpu_hw_events.enabled))
 		__x86_pmu_enable_event(&event->hw,
@@ -1244,7 +935,7 @@ void perf_event_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void x86_pmu_stop(struct perf_event *event, int flags)
+void x86_pmu_stop(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -1297,7 +988,7 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
-static int x86_pmu_handle_irq(struct pt_regs *regs)
+int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
@@ -1367,109 +1058,28 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-struct pmu_nmi_state {
-	unsigned int	marked;
-	int		handled;
-};
-
-static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
-
 static int __kprobes
-perf_event_nmi_handler(struct notifier_block *self,
-			 unsigned long cmd, void *__args)
+perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = __args;
-	unsigned int this_nmi;
-	int handled;
-
 	if (!atomic_read(&active_events))
-		return NOTIFY_DONE;
-
-	switch (cmd) {
-	case DIE_NMI:
-		break;
-	case DIE_NMIUNKNOWN:
-		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __this_cpu_read(pmu_nmi.marked))
-			/* let the kernel handle the unknown nmi */
-			return NOTIFY_DONE;
-		/*
-		 * This one is a PMU back-to-back nmi. Two events
-		 * trigger 'simultaneously' raising two back-to-back
-		 * NMIs. If the first NMI handles both, the latter
-		 * will be empty and daze the CPU. So, we drop it to
-		 * avoid false-positive 'unknown nmi' messages.
-		 */
-		return NOTIFY_STOP;
-	default:
-		return NOTIFY_DONE;
-	}
-
-	handled = x86_pmu.handle_irq(args->regs);
-	if (!handled)
-		return NOTIFY_DONE;
-
-	this_nmi = percpu_read(irq_stat.__nmi_count);
-	if ((handled > 1) ||
-		/* the next nmi could be a back-to-back nmi */
-	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
-	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
-		/*
-		 * We could have two subsequent back-to-back nmis: The
-		 * first handles more than one counter, the 2nd
-		 * handles only one counter and the 3rd handles no
-		 * counter.
-		 *
-		 * This is the 2nd nmi because the previous was
-		 * handling more than one counter. We will mark the
-		 * next (3rd) and then drop it if unhandled.
-		 */
-		__this_cpu_write(pmu_nmi.marked, this_nmi + 1);
-		__this_cpu_write(pmu_nmi.handled, handled);
-	}
+		return NMI_DONE;
 
-	return NOTIFY_STOP;
+	return x86_pmu.handle_irq(regs);
 }
 
-static __read_mostly struct notifier_block perf_event_nmi_notifier = {
-	.notifier_call		= perf_event_nmi_handler,
-	.next			= NULL,
-	.priority		= NMI_LOCAL_LOW_PRIOR,
-};
-
-static struct event_constraint unconstrained;
-static struct event_constraint emptyconstraint;
-
-static struct event_constraint *
-x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
-{
-	struct event_constraint *c;
-
-	if (x86_pmu.event_constraints) {
-		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
-				return c;
-		}
-	}
-
-	return &unconstrained;
-}
-
-#include "perf_event_amd.c"
-#include "perf_event_p6.c"
-#include "perf_event_p4.c"
-#include "perf_event_intel_lbr.c"
-#include "perf_event_intel_ds.c"
-#include "perf_event_intel.c"
+struct event_constraint emptyconstraint;
+struct event_constraint unconstrained;
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 	int ret = NOTIFY_OK;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
+		cpuc->kfree_on_online = NULL;
 		if (x86_pmu.cpu_prepare)
 			ret = x86_pmu.cpu_prepare(cpu);
 		break;
@@ -1479,6 +1089,10 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 			x86_pmu.cpu_starting(cpu);
 		break;
 
+	case CPU_ONLINE:
+		kfree(cpuc->kfree_on_online);
+		break;
+
 	case CPU_DYING:
 		if (x86_pmu.cpu_dying)
 			x86_pmu.cpu_dying(cpu);
@@ -1557,7 +1171,7 @@ static int __init init_hw_perf_events(void)
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	perf_events_lapic_init();
-	register_die_notifier(&perf_event_nmi_notifier);
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
new file mode 100644
index 0000000..b9698d4
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -0,0 +1,505 @@
+/*
+ * Performance events x86 architecture header
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2009 Jaswinder Singh Rajput
+ *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
+ *  Copyright (C) 2009 Google, Inc., Stephane Eranian
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+
+/*
+ *          |   NHM/WSM    |      SNB     |
+ * register -------------------------------
+ *          |  HT  | no HT |  HT  | no HT |
+ *-----------------------------------------
+ * offcore  | core | core  | cpu  | core  |
+ * lbr_sel  | core | core  | cpu  | core  |
+ * ld_lat   | cpu  | core  | cpu  | core  |
+ *-----------------------------------------
+ *
+ * Given that there is a small number of shared regs,
+ * we can pre-allocate their slot in the per-cpu
+ * per-core reg tables.
+ */
+enum extra_reg_type {
+	EXTRA_REG_NONE  = -1,	/* not used */
+
+	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
+	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
+
+	EXTRA_REG_MAX		/* number of entries needed */
+};
+
+struct event_constraint {
+	union {
+		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+		u64		idxmsk64;
+	};
+	u64	code;
+	u64	cmask;
+	int	weight;
+};
+
+struct amd_nb {
+	int nb_id;  /* NorthBridge id */
+	int refcnt; /* reference count */
+	struct perf_event *owners[X86_PMC_IDX_MAX];
+	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
+};
+
+/* The maximal number of PEBS events: */
+#define MAX_PEBS_EVENTS		4
+
+/*
+ * A debug store configuration.
+ *
+ * We only support architectures that use 64bit fields.
+ */
+struct debug_store {
+	u64	bts_buffer_base;
+	u64	bts_index;
+	u64	bts_absolute_maximum;
+	u64	bts_interrupt_threshold;
+	u64	pebs_buffer_base;
+	u64	pebs_index;
+	u64	pebs_absolute_maximum;
+	u64	pebs_interrupt_threshold;
+	u64	pebs_event_reset[MAX_PEBS_EVENTS];
+};
+
+/*
+ * Per register state.
+ */
+struct er_account {
+	raw_spinlock_t		lock;	/* per-core: protect structure */
+	u64                 config;	/* extra MSR config */
+	u64                 reg;	/* extra MSR number */
+	atomic_t            ref;	/* reference count */
+};
+
+/*
+ * Per core/cpu state
+ *
+ * Used to coordinate shared registers between HT threads or
+ * among events on a single PMU.
+ */
+struct intel_shared_regs {
+	struct er_account       regs[EXTRA_REG_MAX];
+	int                     refcnt;		/* per-core: #HT threads */
+	unsigned                core_id;	/* per-core: core id */
+};
+
+#define MAX_LBR_ENTRIES		16
+
+struct cpu_hw_events {
+	/*
+	 * Generic x86 PMC bits
+	 */
+	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int			enabled;
+
+	int			n_events;
+	int			n_added;
+	int			n_txn;
+	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
+	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
+
+	unsigned int		group_flag;
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	struct debug_store	*ds;
+	u64			pebs_enabled;
+
+	/*
+	 * Intel LBR bits
+	 */
+	int				lbr_users;
+	void				*lbr_context;
+	struct perf_branch_stack	lbr_stack;
+	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
+
+	/*
+	 * Intel host/guest exclude bits
+	 */
+	u64				intel_ctrl_guest_mask;
+	u64				intel_ctrl_host_mask;
+	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
+
+	/*
+	 * manage shared (per-core, per-cpu) registers
+	 * used on Intel NHM/WSM/SNB
+	 */
+	struct intel_shared_regs	*shared_regs;
+
+	/*
+	 * AMD specific bits
+	 */
+	struct amd_nb		*amd_nb;
+
+	void				*kfree_on_online;
+};
+
+#define __EVENT_CONSTRAINT(c, n, m, w) {\
+	{ .idxmsk64 = (n) },		\
+	.code = (c),			\
+	.cmask = (m),			\
+	.weight = (w),			\
+}
+
+#define EVENT_CONSTRAINT(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+
+/*
+ * Constraint on the Event code.
+ */
+#define INTEL_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
+
+/*
+ * Constraint on the Event code + UMask + fixed-mask
+ *
+ * filter mask to validate fixed counter events.
+ * the following filters disqualify for fixed counters:
+ *  - inv
+ *  - edge
+ *  - cnt-mask
+ *  The other filters are supported by fixed counters.
+ *  The any-thread option is supported starting with v3.
+ */
+#define FIXED_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+
+/*
+ * Constraint on the Event code + UMask
+ */
+#define INTEL_UEVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+
+#define EVENT_CONSTRAINT_END		\
+	EVENT_CONSTRAINT(0, 0, 0)
+
+#define for_each_event_constraint(e, c)	\
+	for ((e) = (c); (e)->weight; (e)++)
+
+/*
+ * Extra registers for specific events.
+ *
+ * Some events need large masks and require external MSRs.
+ * Those extra MSRs end up being shared for all events on
+ * a PMU and sometimes between PMU of sibling HT threads.
+ * In either case, the kernel needs to handle conflicting
+ * accesses to those extra, shared, regs. The data structure
+ * to manage those registers is stored in cpu_hw_event.
+ */
+struct extra_reg {
+	unsigned int		event;
+	unsigned int		msr;
+	u64			config_mask;
+	u64			valid_mask;
+	int			idx;  /* per_xxx->regs[] reg index */
+};
+
+#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
+	.event = (e),		\
+	.msr = (ms),		\
+	.config_mask = (m),	\
+	.valid_mask = (vm),	\
+	.idx = EXTRA_REG_##i	\
+	}
+
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
+
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
+
+union perf_capabilities {
+	struct {
+		u64	lbr_format:6;
+		u64	pebs_trap:1;
+		u64	pebs_arch_reg:1;
+		u64	pebs_format:4;
+		u64	smm_freeze:1;
+	};
+	u64	capabilities;
+};
+
+/*
+ * struct x86_pmu - generic x86 pmu
+ */
+struct x86_pmu {
+	/*
+	 * Generic x86 PMC bits
+	 */
+	const char	*name;
+	int		version;
+	int		(*handle_irq)(struct pt_regs *);
+	void		(*disable_all)(void);
+	void		(*enable_all)(int added);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
+	int		(*hw_config)(struct perf_event *event);
+	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
+	unsigned	eventsel;
+	unsigned	perfctr;
+	u64		(*event_map)(int);
+	int		max_events;
+	int		num_counters;
+	int		num_counters_fixed;
+	int		cntval_bits;
+	u64		cntval_mask;
+	int		apic;
+	u64		max_period;
+	struct event_constraint *
+			(*get_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
+
+	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
+	struct event_constraint *event_constraints;
+	void		(*quirks)(void);
+	int		perfctr_second_write;
+
+	int		(*cpu_prepare)(int cpu);
+	void		(*cpu_starting)(int cpu);
+	void		(*cpu_dying)(int cpu);
+	void		(*cpu_dead)(int cpu);
+
+	/*
+	 * Intel Arch Perfmon v2+
+	 */
+	u64			intel_ctrl;
+	union perf_capabilities intel_cap;
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	int		bts, pebs;
+	int		bts_active, pebs_active;
+	int		pebs_record_size;
+	void		(*drain_pebs)(struct pt_regs *regs);
+	struct event_constraint *pebs_constraints;
+
+	/*
+	 * Intel LBR
+	 */
+	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
+	int		lbr_nr;			   /* hardware stack size */
+
+	/*
+	 * Extra registers for events
+	 */
+	struct extra_reg *extra_regs;
+	unsigned int er_flags;
+
+	/*
+	 * Intel host/guest support (KVM)
+	 */
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+};
+
+#define ERF_NO_HT_SHARING	1
+#define ERF_HAS_RSP_1		2
+
+extern struct x86_pmu x86_pmu __read_mostly;
+
+DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
+
+int x86_perf_event_set_period(struct perf_event *event);
+
+/*
+ * Generalized hw caching related hw_event table, filled
+ * in on a per model basis. A value of 0 means
+ * 'not supported', -1 means 'hw_event makes no sense on
+ * this CPU', any other value means the raw hw_event
+ * ID.
+ */
+
+#define C(x) PERF_COUNT_HW_CACHE_##x
+
+extern u64 __read_mostly hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+extern u64 __read_mostly hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+
+u64 x86_perf_event_update(struct perf_event *event);
+
+static inline int x86_pmu_addr_offset(int index)
+{
+	int offset;
+
+	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
+	alternative_io(ASM_NOP2,
+		       "shll $1, %%eax",
+		       X86_FEATURE_PERFCTR_CORE,
+		       "=a" (offset),
+		       "a"  (index));
+
+	return offset;
+}
+
+static inline unsigned int x86_pmu_config_addr(int index)
+{
+	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
+}
+
+static inline unsigned int x86_pmu_event_addr(int index)
+{
+	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
+}
+
+int x86_setup_perfctr(struct perf_event *event);
+
+int x86_pmu_hw_config(struct perf_event *event);
+
+void x86_pmu_disable_all(void);
+
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
+{
+	if (hwc->extra_reg.reg)
+		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
+	wrmsrl(hwc->config_base, hwc->config | enable_mask);
+}
+
+void x86_pmu_enable_all(int added);
+
+int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
+
+void x86_pmu_stop(struct perf_event *event, int flags);
+
+static inline void x86_pmu_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, hwc->config);
+}
+
+void x86_pmu_enable_event(struct perf_event *event);
+
+int x86_pmu_handle_irq(struct pt_regs *regs);
+
+extern struct event_constraint emptyconstraint;
+
+extern struct event_constraint unconstrained;
+
+#ifdef CONFIG_CPU_SUP_AMD
+
+int amd_pmu_init(void);
+
+#else /* CONFIG_CPU_SUP_AMD */
+
+static inline int amd_pmu_init(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CPU_SUP_AMD */
+
+#ifdef CONFIG_CPU_SUP_INTEL
+
+int intel_pmu_save_and_restart(struct perf_event *event);
+
+struct event_constraint *
+x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event);
+
+struct intel_shared_regs *allocate_shared_regs(int cpu);
+
+int intel_pmu_init(void);
+
+void init_debug_store_on_cpu(int cpu);
+
+void fini_debug_store_on_cpu(int cpu);
+
+void release_ds_buffers(void);
+
+void reserve_ds_buffers(void);
+
+extern struct event_constraint bts_constraint;
+
+void intel_pmu_enable_bts(u64 config);
+
+void intel_pmu_disable_bts(void);
+
+int intel_pmu_drain_bts_buffer(void);
+
+extern struct event_constraint intel_core2_pebs_event_constraints[];
+
+extern struct event_constraint intel_atom_pebs_event_constraints[];
+
+extern struct event_constraint intel_nehalem_pebs_event_constraints[];
+
+extern struct event_constraint intel_westmere_pebs_event_constraints[];
+
+extern struct event_constraint intel_snb_pebs_event_constraints[];
+
+struct event_constraint *intel_pebs_constraints(struct perf_event *event);
+
+void intel_pmu_pebs_enable(struct perf_event *event);
+
+void intel_pmu_pebs_disable(struct perf_event *event);
+
+void intel_pmu_pebs_enable_all(void);
+
+void intel_pmu_pebs_disable_all(void);
+
+void intel_ds_init(void);
+
+void intel_pmu_lbr_reset(void);
+
+void intel_pmu_lbr_enable(struct perf_event *event);
+
+void intel_pmu_lbr_disable(struct perf_event *event);
+
+void intel_pmu_lbr_enable_all(void);
+
+void intel_pmu_lbr_disable_all(void);
+
+void intel_pmu_lbr_read(void);
+
+void intel_pmu_lbr_init_core(void);
+
+void intel_pmu_lbr_init_nhm(void);
+
+void intel_pmu_lbr_init_atom(void);
+
+int p4_pmu_init(void);
+
+int p6_pmu_init(void);
+
+#else /* CONFIG_CPU_SUP_INTEL */
+
+static inline void reserve_ds_buffers(void)
+{
+}
+
+static inline void release_ds_buffers(void)
+{
+}
+
+static inline int intel_pmu_init(void)
+{
+	return 0;
+}
+
+static inline struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 941caa2..aeefd45 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,4 +1,10 @@
-#ifdef CONFIG_CPU_SUP_AMD
+#include <linux/perf_event.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <asm/apicdef.h>
+
+#include "perf_event.h"
 
 static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -132,6 +138,19 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (event->attr.exclude_host && event->attr.exclude_guest)
+		/*
+		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
+		 * and will count in both modes. We don't want to count in that
+		 * case so we emulate no-counting by setting US = OS = 0.
+		 */
+		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
+				      ARCH_PERFMON_EVENTSEL_OS);
+	else if (event->attr.exclude_host)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
+	else if (event->attr.exclude_guest)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
@@ -350,7 +369,7 @@ static void amd_pmu_cpu_starting(int cpu)
 			continue;
 
 		if (nb->nb_id == nb_id) {
-			kfree(cpuc->amd_nb);
+			cpuc->kfree_on_online = cpuc->amd_nb;
 			cpuc->amd_nb = nb;
 			break;
 		}
@@ -392,7 +411,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 4,
+	.num_counters		= AMD64_NUM_COUNTERS,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
@@ -556,7 +575,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.perfctr		= MSR_F15H_PERF_CTR,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 6,
+	.num_counters		= AMD64_NUM_COUNTERS_F15H,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
@@ -573,7 +592,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 #endif
 };
 
-static __init int amd_pmu_init(void)
+__init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
@@ -602,12 +621,3 @@ static __init int amd_pmu_init(void)
 
 	return 0;
 }
-
-#else /* CONFIG_CPU_SUP_AMD */
-
-static int amd_pmu_init(void)
-{
-	return 0;
-}
-
-#endif
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
new file mode 100644
index 0000000..ab6343d
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -0,0 +1,294 @@
+/*
+ * Performance events - AMD IBS
+ *
+ *  Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include <asm/apic.h>
+
+static u32 ibs_caps;
+
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
+
+static struct pmu perf_ibs;
+
+static int perf_ibs_init(struct perf_event *event)
+{
+	if (perf_ibs.type != event->attr.type)
+		return -ENOENT;
+	return 0;
+}
+
+static int perf_ibs_add(struct perf_event *event, int flags)
+{
+	return 0;
+}
+
+static void perf_ibs_del(struct perf_event *event, int flags)
+{
+}
+
+static struct pmu perf_ibs = {
+	.event_init= perf_ibs_init,
+	.add= perf_ibs_add,
+	.del= perf_ibs_del,
+};
+
+static __init int perf_event_ibs_init(void)
+{
+	if (!ibs_caps)
+		return -ENODEV;	/* ibs not supported by the cpu */
+
+	perf_pmu_register(&perf_ibs, "ibs", -1);
+	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
+
+	return 0;
+}
+
+#else /* defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD) */
+
+static __init int perf_event_ibs_init(void) { return 0; }
+
+#endif
+
+/* IBS - apic initialization, for perf and oprofile */
+
+static __init u32 __get_ibs_caps(void)
+{
+	u32 caps;
+	unsigned int max_level;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return 0;
+
+	/* check IBS cpuid feature flags */
+	max_level = cpuid_eax(0x80000000);
+	if (max_level < IBS_CPUID_FEATURES)
+		return IBS_CAPS_DEFAULT;
+
+	caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(caps & IBS_CAPS_AVAIL))
+		/* cpuid flags not valid */
+		return IBS_CAPS_DEFAULT;
+
+	return caps;
+}
+
+u32 get_ibs_caps(void)
+{
+	return ibs_caps;
+}
+
+EXPORT_SYMBOL(get_ibs_caps);
+
+static inline int get_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
+}
+
+static inline int put_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, 0, 1);
+}
+
+/*
+ * Check and reserve APIC extended interrupt LVT offset for IBS if available.
+ */
+static inline int ibs_eilvt_valid(void)
+{
+	int offset;
+	u64 val;
+	int valid = 0;
+
+	preempt_disable();
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	offset = val & IBSCTL_LVT_OFFSET_MASK;
+
+	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
+		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		goto out;
+	}
+
+	if (!get_eilvt(offset)) {
+		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		goto out;
+	}
+
+	valid = 1;
+out:
+	preempt_enable();
+
+	return valid;
+}
+
+static int setup_ibs_ctl(int ibs_eilvt_off)
+{
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVT_OFFSET_VALID);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVT_OFFSET_VALID)) {
+			pci_dev_put(cpu_cfg);
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+			       "IBSCTL = 0x%08x\n", value);
+			return -EINVAL;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * This runs only on the current cpu. We try to find an LVT offset and
+ * setup the local APIC. For this we must disable preemption. On
+ * success we initialize all nodes with this offset. This updates then
+ * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
+ * the IBS interrupt vector is handled by perf_ibs_cpu_notifier that
+ * is using the new offset.
+ */
+static int force_ibs_eilvt_setup(void)
+{
+	int offset;
+	int ret;
+
+	preempt_disable();
+	/* find the next free available EILVT entry, skip offset 0 */
+	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
+		if (get_eilvt(offset))
+			break;
+	}
+	preempt_enable();
+
+	if (offset == APIC_EILVT_NR_MAX) {
+		printk(KERN_DEBUG "No EILVT entry available\n");
+		return -EBUSY;
+	}
+
+	ret = setup_ibs_ctl(offset);
+	if (ret)
+		goto out;
+
+	if (!ibs_eilvt_valid()) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
+	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+
+	return 0;
+out:
+	preempt_disable();
+	put_eilvt(offset);
+	preempt_enable();
+	return ret;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void *dummy)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("perf: IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void *dummy)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int __cpuinit
+perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		setup_APIC_ibs(NULL);
+		break;
+	case CPU_DYING:
+		clear_APIC_ibs(NULL);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static __init int amd_ibs_init(void)
+{
+	u32 caps;
+	int ret;
+
+	caps = __get_ibs_caps();
+	if (!caps)
+		return -ENODEV;	/* ibs not supported by the cpu */
+
+	if (!ibs_eilvt_valid()) {
+		ret = force_ibs_eilvt_setup();
+		if (ret) {
+			pr_err("Failed to setup IBS, %d\n", ret);
+			return ret;
+		}
+	}
+
+	get_online_cpus();
+	ibs_caps = caps;
+	/* make ibs_caps visible to other cpus: */
+	smp_mb();
+	perf_cpu_notifier(perf_ibs_cpu_notifier);
+	smp_call_function(setup_APIC_ibs, NULL, 1);
+	put_online_cpus();
+
+	return perf_event_ibs_init();
+}
+
+/* Since we need the pci subsystem to init ibs we can't do this earlier: */
+device_initcall(amd_ibs_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f88af2c..e09ca20 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,16 +1,19 @@
-#ifdef CONFIG_CPU_SUP_INTEL
-
 /*
  * Per core/cpu state
  *
  * Used to coordinate shared registers between HT threads or
  * among events on a single PMU.
  */
-struct intel_shared_regs {
-	struct er_account       regs[EXTRA_REG_MAX];
-	int                     refcnt;		/* per-core: #HT threads */
-	unsigned                core_id;	/* per-core: core id */
-};
+
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+
+#include <asm/hardirq.h>
+#include <asm/apic.h>
+
+#include "perf_event.h"
 
 /*
  * Intel PerfMon, used on Core and later.
@@ -746,7 +749,8 @@ static void intel_pmu_enable_all(int added)
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
+			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
@@ -869,6 +873,7 @@ static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
@@ -876,6 +881,9 @@ static void intel_pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
+	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc);
 		return;
@@ -921,6 +929,7 @@ static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__this_cpu_read(cpu_hw_events.enabled))
@@ -930,6 +939,11 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
+	if (event->attr.exclude_host)
+		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
+	if (event->attr.exclude_guest)
+		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_enable_fixed(hwc);
 		return;
@@ -945,7 +959,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
  */
-static int intel_pmu_save_and_restart(struct perf_event *event)
+int intel_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event);
 	return x86_perf_event_set_period(event);
@@ -1197,6 +1211,21 @@ intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 	return c;
 }
 
+struct event_constraint *
+x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (x86_pmu.event_constraints) {
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if ((event->hw.config & c->cmask) == c->code)
+				return c;
+		}
+	}
+
+	return &unconstrained;
+}
+
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -1284,12 +1313,84 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+{
+	if (x86_pmu.guest_get_msrs)
+		return x86_pmu.guest_get_msrs(nr);
+	*nr = 0;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
+
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+
+	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
+	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+
+	*nr = 1;
+	return arr;
+}
+
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++)  {
+		struct perf_event *event = cpuc->events[idx];
+
+		arr[idx].msr = x86_pmu_config_addr(idx);
+		arr[idx].host = arr[idx].guest = 0;
+
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+
+		arr[idx].host = arr[idx].guest =
+			event->hw.config | ARCH_PERFMON_EVENTSEL_ENABLE;
+
+		if (event->attr.exclude_host)
+			arr[idx].host &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+		else if (event->attr.exclude_guest)
+			arr[idx].guest &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	}
+
+	*nr = x86_pmu.num_counters;
+	return arr;
+}
+
+static void core_pmu_enable_event(struct perf_event *event)
+{
+	if (!event->attr.exclude_host)
+		x86_pmu_enable_event(event);
+}
+
+static void core_pmu_enable_all(int added)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
+
+		if (!test_bit(idx, cpuc->active_mask) ||
+				cpuc->events[idx]->attr.exclude_host)
+			continue;
+
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
+	.enable_all		= core_pmu_enable_all,
+	.enable			= core_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
@@ -1307,9 +1408,10 @@ static __initconst const struct x86_pmu core_pmu = {
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
+	.guest_get_msrs		= core_guest_get_msrs,
 };
 
-static struct intel_shared_regs *allocate_shared_regs(int cpu)
+struct intel_shared_regs *allocate_shared_regs(int cpu)
 {
 	struct intel_shared_regs *regs;
 	int i;
@@ -1362,7 +1464,7 @@ static void intel_pmu_cpu_starting(int cpu)
 
 		pc = per_cpu(cpu_hw_events, i).shared_regs;
 		if (pc && pc->core_id == core_id) {
-			kfree(cpuc->shared_regs);
+			cpuc->kfree_on_online = cpuc->shared_regs;
 			cpuc->shared_regs = pc;
 			break;
 		}
@@ -1413,6 +1515,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
+	.guest_get_msrs		= intel_guest_get_msrs,
 };
 
 static void intel_clovertown_quirks(void)
@@ -1441,7 +1544,7 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static __init int intel_pmu_init(void)
+__init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -1597,7 +1700,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
-		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
@@ -1628,16 +1731,3 @@ static __init int intel_pmu_init(void)
 	}
 	return 0;
 }
-
-#else /* CONFIG_CPU_SUP_INTEL */
-
-static int intel_pmu_init(void)
-{
-	return 0;
-}
-
-static struct intel_shared_regs *allocate_shared_regs(int cpu)
-{
-	return NULL;
-}
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1b1ef3a..c0d238f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1,7 +1,10 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/slab.h>
 
-/* The maximal number of PEBS events: */
-#define MAX_PEBS_EVENTS		4
+#include <asm/perf_event.h>
+
+#include "perf_event.h"
 
 /* The size of a BTS record in bytes: */
 #define BTS_RECORD_SIZE		24
@@ -37,24 +40,7 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
-/*
- * A debug store configuration.
- *
- * We only support architectures that use 64bit fields.
- */
-struct debug_store {
-	u64	bts_buffer_base;
-	u64	bts_index;
-	u64	bts_absolute_maximum;
-	u64	bts_interrupt_threshold;
-	u64	pebs_buffer_base;
-	u64	pebs_index;
-	u64	pebs_absolute_maximum;
-	u64	pebs_interrupt_threshold;
-	u64	pebs_event_reset[MAX_PEBS_EVENTS];
-};
-
-static void init_debug_store_on_cpu(int cpu)
+void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 
@@ -66,7 +52,7 @@ static void init_debug_store_on_cpu(int cpu)
 		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
-static void fini_debug_store_on_cpu(int cpu)
+void fini_debug_store_on_cpu(int cpu)
 {
 	if (!per_cpu(cpu_hw_events, cpu).ds)
 		return;
@@ -175,7 +161,7 @@ static void release_ds_buffer(int cpu)
 	kfree(ds);
 }
 
-static void release_ds_buffers(void)
+void release_ds_buffers(void)
 {
 	int cpu;
 
@@ -194,7 +180,7 @@ static void release_ds_buffers(void)
 	put_online_cpus();
 }
 
-static void reserve_ds_buffers(void)
+void reserve_ds_buffers(void)
 {
 	int bts_err = 0, pebs_err = 0;
 	int cpu;
@@ -260,10 +246,10 @@ static void reserve_ds_buffers(void)
  * BTS
  */
 
-static struct event_constraint bts_constraint =
+struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
-static void intel_pmu_enable_bts(u64 config)
+void intel_pmu_enable_bts(u64 config)
 {
 	unsigned long debugctlmsr;
 
@@ -282,7 +268,7 @@ static void intel_pmu_enable_bts(u64 config)
 	update_debugctlmsr(debugctlmsr);
 }
 
-static void intel_pmu_disable_bts(void)
+void intel_pmu_disable_bts(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long debugctlmsr;
@@ -299,7 +285,7 @@ static void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
-static int intel_pmu_drain_bts_buffer(void)
+int intel_pmu_drain_bts_buffer(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
@@ -361,7 +347,7 @@ static int intel_pmu_drain_bts_buffer(void)
 /*
  * PEBS
  */
-static struct event_constraint intel_core2_pebs_event_constraints[] = {
+struct event_constraint intel_core2_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
@@ -370,14 +356,14 @@ static struct event_constraint intel_core2_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_atom_pebs_event_constraints[] = {
+struct event_constraint intel_atom_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
 	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
+struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
@@ -392,7 +378,7 @@ static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_westmere_pebs_event_constraints[] = {
+struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
@@ -407,7 +393,7 @@ static struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_snb_pebs_events[] = {
+struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
@@ -428,8 +414,7 @@ static struct event_constraint intel_snb_pebs_events[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint *
-intel_pebs_constraints(struct perf_event *event)
+struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
 
@@ -446,7 +431,7 @@ intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
-static void intel_pmu_pebs_enable(struct perf_event *event)
+void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -460,7 +445,7 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 		intel_pmu_lbr_enable(event);
 }
 
-static void intel_pmu_pebs_disable(struct perf_event *event)
+void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -475,7 +460,7 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 		intel_pmu_lbr_disable(event);
 }
 
-static void intel_pmu_pebs_enable_all(void)
+void intel_pmu_pebs_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -483,7 +468,7 @@ static void intel_pmu_pebs_enable_all(void)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 }
 
-static void intel_pmu_pebs_disable_all(void)
+void intel_pmu_pebs_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -576,8 +561,6 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	return 0;
 }
 
-static int intel_pmu_save_and_restart(struct perf_event *event);
-
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
@@ -716,7 +699,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
  * BTS, PEBS probe and setup
  */
 
-static void intel_ds_init(void)
+void intel_ds_init(void)
 {
 	/*
 	 * No support for 32bit formats
@@ -749,15 +732,3 @@ static void intel_ds_init(void)
 		}
 	}
 }
-
-#else /* CONFIG_CPU_SUP_INTEL */
-
-static void reserve_ds_buffers(void)
-{
-}
-
-static void release_ds_buffers(void)
-{
-}
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d202c1b..3fab3de 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -1,4 +1,10 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include <asm/perf_event.h>
+#include <asm/msr.h>
+
+#include "perf_event.h"
 
 enum {
 	LBR_FORMAT_32		= 0x00,
@@ -48,7 +54,7 @@ static void intel_pmu_lbr_reset_64(void)
 	}
 }
 
-static void intel_pmu_lbr_reset(void)
+void intel_pmu_lbr_reset(void)
 {
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -59,7 +65,7 @@ static void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
-static void intel_pmu_lbr_enable(struct perf_event *event)
+void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -81,7 +87,7 @@ static void intel_pmu_lbr_enable(struct perf_event *event)
 	cpuc->lbr_users++;
 }
 
-static void intel_pmu_lbr_disable(struct perf_event *event)
+void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -95,7 +101,7 @@ static void intel_pmu_lbr_disable(struct perf_event *event)
 		__intel_pmu_lbr_disable();
 }
 
-static void intel_pmu_lbr_enable_all(void)
+void intel_pmu_lbr_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -103,7 +109,7 @@ static void intel_pmu_lbr_enable_all(void)
 		__intel_pmu_lbr_enable();
 }
 
-static void intel_pmu_lbr_disable_all(void)
+void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -178,7 +184,7 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 	cpuc->lbr_stack.nr = i;
 }
 
-static void intel_pmu_lbr_read(void)
+void intel_pmu_lbr_read(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -191,7 +197,7 @@ static void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_64(cpuc);
 }
 
-static void intel_pmu_lbr_init_core(void)
+void intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = 0x01c9;
@@ -199,7 +205,7 @@ static void intel_pmu_lbr_init_core(void)
 	x86_pmu.lbr_to     = 0x60;
 }
 
-static void intel_pmu_lbr_init_nhm(void)
+void intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = 0x01c9;
@@ -207,12 +213,10 @@ static void intel_pmu_lbr_init_nhm(void)
 	x86_pmu.lbr_to     = 0x6c0;
 }
 
-static void intel_pmu_lbr_init_atom(void)
+void intel_pmu_lbr_init_atom(void)
 {
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x40;
 	x86_pmu.lbr_to     = 0x60;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 7809d2bc..492bf13 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -7,9 +7,13 @@
  *  For licencing details see kernel-base/COPYING
  */
 
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
 
 #include <asm/perf_event_p4.h>
+#include <asm/hardirq.h>
+#include <asm/apic.h>
+
+#include "perf_event.h"
 
 #define P4_CNTR_LIMIT 3
 /*
@@ -1303,7 +1307,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.perfctr_second_write	= 1,
 };
 
-static __init int p4_pmu_init(void)
+__init int p4_pmu_init(void)
 {
 	unsigned int low, high;
 
@@ -1326,5 +1330,3 @@ static __init int p4_pmu_init(void)
 
 	return 0;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 20c097e..c7181be 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -1,4 +1,7 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "perf_event.h"
 
 /*
  * Not sure about some of these
@@ -114,7 +117,7 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.event_constraints	= p6_event_constraints,
 };
 
-static __init int p6_pmu_init(void)
+__init int p6_pmu_init(void)
 {
 	switch (boot_cpu_data.x86_model) {
 	case 1:
@@ -138,5 +141,3 @@ static __init int p6_pmu_init(void)
 
 	return 0;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 764c7c2..13ad899 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -32,15 +32,12 @@ int in_crash_kexec;
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
-static void kdump_nmi_callback(int cpu, struct die_args *args)
+static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 {
-	struct pt_regs *regs;
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
 
-	regs = args->regs;
-
 #ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..cacdd46 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -42,7 +42,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init_or_module arch_jump_label_text_poke_early(jump_label_t addr)
 {
 	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
 			JUMP_LABEL_NOP_SIZE);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 00354d4..faba5771 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -511,28 +511,37 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
 
 static int was_in_debug_nmi[NR_CPUS];
 
-static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+static int kgdb_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct pt_regs *regs = args->regs;
-
 	switch (cmd) {
-	case DIE_NMI:
+	case NMI_LOCAL:
 		if (atomic_read(&kgdb_active) != -1) {
 			/* KGDB CPU roundup */
 			kgdb_nmicallback(raw_smp_processor_id(), regs);
 			was_in_debug_nmi[raw_smp_processor_id()] = 1;
 			touch_nmi_watchdog();
-			return NOTIFY_STOP;
+			return NMI_HANDLED;
 		}
-		return NOTIFY_DONE;
+		break;
 
-	case DIE_NMIUNKNOWN:
+	case NMI_UNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
-			return NOTIFY_STOP;
+			return NMI_HANDLED;
 		}
-		return NOTIFY_DONE;
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+	return NMI_DONE;
+}
+
+static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+{
+	struct pt_regs *regs = args->regs;
 
+	switch (cmd) {
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
@@ -590,11 +599,6 @@ kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 
 static struct notifier_block kgdb_notifier = {
 	.notifier_call	= kgdb_notify,
-
-	/*
-	 * Lowest-prio notifier priority, we want to be notified last:
-	 */
-	.priority	= NMI_LOCAL_LOW_PRIOR,
 };
 
 /**
@@ -605,7 +609,31 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
-	return register_die_notifier(&kgdb_notifier);
+	int retval;
+
+	retval = register_die_notifier(&kgdb_notifier);
+	if (retval)
+		goto out;
+
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
+					0, "kgdb");
+	if (retval)
+		goto out1;
+
+	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
+					0, "kgdb");
+
+	if (retval)
+		goto out2;
+
+	return retval;
+
+out2:
+	unregister_nmi_handler(NMI_LOCAL, "kgdb");
+out1:
+	unregister_die_notifier(&kgdb_notifier);
+out:
+	return retval;
 }
 
 static void kgdb_hw_overflow_handler(struct perf_event *event,
@@ -673,6 +701,8 @@ void kgdb_arch_exit(void)
 			breakinfo[i].pev = NULL;
 		}
 	}
+	unregister_nmi_handler(NMI_UNKNOWN, "kgdb");
+	unregister_nmi_handler(NMI_LOCAL, "kgdb");
 	unregister_die_notifier(&kgdb_notifier);
 }
 
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f1a6244..c0ed3d9 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -75,8 +75,10 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 	/*
 	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
 	 * Groups, and some special opcodes can not boost.
+	 * This is volatile to keep gcc from statically optimizing it out, as
+	 * variable_test_bit makes gcc think only *(unsigned long*) is used.
 	 */
-static const u32 twobyte_is_boostable[256 / 32] = {
+static volatile const u32 twobyte_is_boostable[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
 	/*      ----------------------------------------------          */
 	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
new file mode 100644
index 0000000..7ec5bd1
--- /dev/null
+++ b/arch/x86/kernel/nmi.c
@@ -0,0 +1,433 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ *  Copyright (C) 2011	Don Zickus Red Hat, Inc.
+ *
+ *  Pentium III FXSR, SSE support
+ *	Gareth Hughes <gareth@valinux.com>, May 2000
+ */
+
+/*
+ * Handle hardware traps and faults.
+ */
+#include <linux/spinlock.h>
+#include <linux/kprobes.h>
+#include <linux/kdebug.h>
+#include <linux/nmi.h>
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <linux/slab.h>
+
+#include <linux/mca.h>
+
+#if defined(CONFIG_EDAC)
+#include <linux/edac.h>
+#endif
+
+#include <linux/atomic.h>
+#include <asm/traps.h>
+#include <asm/mach_traps.h>
+#include <asm/nmi.h>
+
+#define NMI_MAX_NAMELEN	16
+struct nmiaction {
+	struct list_head list;
+	nmi_handler_t handler;
+	unsigned int flags;
+	char *name;
+};
+
+struct nmi_desc {
+	spinlock_t lock;
+	struct list_head head;
+};
+
+static struct nmi_desc nmi_desc[NMI_MAX] = 
+{
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[0].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[0].head),
+	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[1].head),
+	},
+
+};
+
+struct nmi_stats {
+	unsigned int normal;
+	unsigned int unknown;
+	unsigned int external;
+	unsigned int swallow;
+};
+
+static DEFINE_PER_CPU(struct nmi_stats, nmi_stats);
+
+static int ignore_nmis;
+
+int unknown_nmi_panic;
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
+
+static int __init setup_unknown_nmi_panic(char *str)
+{
+	unknown_nmi_panic = 1;
+	return 1;
+}
+__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
+
+#define nmi_to_desc(type) (&nmi_desc[type])
+
+static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *a;
+	int handled=0;
+
+	rcu_read_lock();
+
+	/*
+	 * NMIs are edge-triggered, which means if you have enough
+	 * of them concurrently, you can lose some because only one
+	 * can be latched at any given time.  Walk the whole list
+	 * to handle those situations.
+	 */
+	list_for_each_entry_rcu(a, &desc->head, list)
+		handled += a->handler(type, regs);
+
+	rcu_read_unlock();
+
+	/* return total number of NMI events handled */
+	return handled;
+}
+
+static int __setup_nmi(unsigned int type, struct nmiaction *action)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	/*
+	 * most handlers of type NMI_UNKNOWN never return because
+	 * they just assume the NMI is theirs.  Just a sanity check
+	 * to manage expectations
+	 */
+	WARN_ON_ONCE(type == NMI_UNKNOWN && !list_empty(&desc->head));
+
+	/*
+	 * some handlers need to be executed first otherwise a fake
+	 * event confuses some handlers (kdump uses this flag)
+	 */
+	if (action->flags & NMI_FLAG_FIRST)
+		list_add_rcu(&action->list, &desc->head);
+	else
+		list_add_tail_rcu(&action->list, &desc->head);
+	
+	spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+
+static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *n;
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	list_for_each_entry_rcu(n, &desc->head, list) {
+		/*
+		 * the name passed in to describe the nmi handler
+		 * is used as the lookup key
+		 */
+		if (!strcmp(n->name, name)) {
+			WARN(in_nmi(),
+				"Trying to free NMI (%s) from NMI context!\n", n->name);
+			list_del_rcu(&n->list);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&desc->lock, flags);
+	synchronize_rcu();
+	return (n);
+}
+
+int register_nmi_handler(unsigned int type, nmi_handler_t handler,
+			unsigned long nmiflags, const char *devname)
+{
+	struct nmiaction *action;
+	int retval = -ENOMEM;
+
+	if (!handler)
+		return -EINVAL;
+
+	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
+	if (!action)
+		goto fail_action;
+
+	action->handler = handler;
+	action->flags = nmiflags;
+	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
+	if (!action->name)
+		goto fail_action_name;
+
+	retval = __setup_nmi(type, action);
+
+	if (retval)
+		goto fail_setup_nmi;
+
+	return retval;
+
+fail_setup_nmi:
+	kfree(action->name);
+fail_action_name:
+	kfree(action);
+fail_action:	
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(register_nmi_handler);
+
+void unregister_nmi_handler(unsigned int type, const char *name)
+{
+	struct nmiaction *a;
+
+	a = __free_nmi(type, name);
+	if (a) {
+		kfree(a->name);
+		kfree(a);
+	}
+}
+
+EXPORT_SYMBOL_GPL(unregister_nmi_handler);
+
+static notrace __kprobes void
+pci_serr_error(unsigned char reason, struct pt_regs *regs)
+{
+	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+
+	/*
+	 * On some machines, PCI SERR line is used to report memory
+	 * errors. EDAC makes use of it.
+	 */
+#if defined(CONFIG_EDAC)
+	if (edac_handler_set()) {
+		edac_atomic_assert_error();
+		return;
+	}
+#endif
+
+	if (panic_on_unrecovered_nmi)
+		panic("NMI: Not continuing");
+
+	pr_emerg("Dazed and confused, but trying to continue\n");
+
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
+	outb(reason, NMI_REASON_PORT);
+}
+
+static notrace __kprobes void
+io_check_error(unsigned char reason, struct pt_regs *regs)
+{
+	unsigned long i;
+
+	pr_emerg(
+	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+	show_registers(regs);
+
+	if (panic_on_io_nmi)
+		panic("NMI IOCK error: Not continuing");
+
+	/* Re-enable the IOCK line, wait for a few seconds */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
+
+	i = 20000;
+	while (--i) {
+		touch_nmi_watchdog();
+		udelay(100);
+	}
+
+	reason &= ~NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
+}
+
+static notrace __kprobes void
+unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
+{
+	int handled;
+
+	/*
+	 * Use 'false' as back-to-back NMIs are dealt with one level up.
+	 * Of course this makes having multiple 'unknown' handlers useless
+	 * as only the first one is ever run (unless it can actually determine
+	 * if it caused the NMI)
+	 */
+	handled = nmi_handle(NMI_UNKNOWN, regs, false);
+	if (handled) {
+		__this_cpu_add(nmi_stats.unknown, handled);
+		return;
+	}
+
+	__this_cpu_add(nmi_stats.unknown, 1);
+
+#ifdef CONFIG_MCA
+	/*
+	 * Might actually be able to figure out what the guilty party
+	 * is:
+	 */
+	if (MCA_bus) {
+		mca_handle_nmi();
+		return;
+	}
+#endif
+	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+
+	pr_emerg("Do you have a strange power saving mode enabled?\n");
+	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
+		panic("NMI: Not continuing");
+
+	pr_emerg("Dazed and confused, but trying to continue\n");
+}
+
+static DEFINE_PER_CPU(bool, swallow_nmi);
+static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
+
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+{
+	unsigned char reason = 0;
+	int handled;
+	bool b2b = false;
+
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
+
+	/*
+	 * Back-to-back NMIs are interesting because they can either
+	 * be two NMI or more than two NMIs (any thing over two is dropped
+	 * due to NMI being edge-triggered).  If this is the second half
+	 * of the back-to-back NMI, assume we dropped things and process
+	 * more handlers.  Otherwise reset the 'swallow' NMI behaviour
+	 */
+	if (regs->ip == __this_cpu_read(last_nmi_rip))
+		b2b = true;
+	else
+		__this_cpu_write(swallow_nmi, false);
+
+	__this_cpu_write(last_nmi_rip, regs->ip);
+
+	handled = nmi_handle(NMI_LOCAL, regs, b2b);
+	__this_cpu_add(nmi_stats.normal, handled);
+	if (handled) {
+		/*
+		 * There are cases when a NMI handler handles multiple
+		 * events in the current NMI.  One of these events may
+		 * be queued for in the next NMI.  Because the event is
+		 * already handled, the next NMI will result in an unknown
+		 * NMI.  Instead lets flag this for a potential NMI to
+		 * swallow.
+		 */
+		if (handled > 1)
+			__this_cpu_write(swallow_nmi, true);
+		return;
+	}
+
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
+
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
+#endif
+		__this_cpu_add(nmi_stats.external, 1);
+		raw_spin_unlock(&nmi_reason_lock);
+		return;
+	}
+	raw_spin_unlock(&nmi_reason_lock);
+
+	/*
+	 * Only one NMI can be latched at a time.  To handle
+	 * this we may process multiple nmi handlers at once to
+	 * cover the case where an NMI is dropped.  The downside
+	 * to this approach is we may process an NMI prematurely,
+	 * while its real NMI is sitting latched.  This will cause
+	 * an unknown NMI on the next run of the NMI processing.
+	 *
+	 * We tried to flag that condition above, by setting the
+	 * swallow_nmi flag when we process more than one event.
+	 * This condition is also only present on the second half
+	 * of a back-to-back NMI, so we flag that condition too.
+	 *
+	 * If both are true, we assume we already processed this
+	 * NMI previously and we swallow it.  Otherwise we reset
+	 * the logic.
+	 *
+	 * There are scenarios where we may accidentally swallow
+	 * a 'real' unknown NMI.  For example, while processing
+	 * a perf NMI another perf NMI comes in along with a
+	 * 'real' unknown NMI.  These two NMIs get combined into
+	 * one (as descibed above).  When the next NMI gets
+	 * processed, it will be flagged by perf as handled, but
+	 * noone will know that there was a 'real' unknown NMI sent
+	 * also.  As a result it gets swallowed.  Or if the first
+	 * perf NMI returns two events handled then the second
+	 * NMI will get eaten by the logic below, again losing a
+	 * 'real' unknown NMI.  But this is the best we can do
+	 * for now.
+	 */
+	if (b2b && __this_cpu_read(swallow_nmi))
+		__this_cpu_add(nmi_stats.swallow, 1);
+	else
+		unknown_nmi_error(reason, regs);
+}
+
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_enter();
+
+	inc_irq_stat(__nmi_count);
+
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+}
+
+/* reset the back-to-back NMI logic */
+void local_touch_nmi(void)
+{
+	__this_cpu_write(last_nmi_rip, 0);
+}
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7a3b651..46ff054 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -57,6 +57,7 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
+#include <asm/nmi.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -107,6 +108,7 @@ void cpu_idle(void)
 			if (cpu_is_offline(cpu))
 				play_dead();
 
+			local_touch_nmi();
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index f693e44..3bd7e6e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -51,6 +51,7 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
+#include <asm/nmi.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -133,6 +134,7 @@ void cpu_idle(void)
 			 * from here on, until they go to idle.
 			 * Otherwise, idle callbacks can misfire.
 			 */
+			local_touch_nmi();
 			local_irq_disable();
 			enter_idle();
 			/* Don't trace irqs off for idle */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9242436..e334be1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -464,7 +464,7 @@ static inline void kb_wait(void)
 	}
 }
 
-static void vmxoff_nmi(int cpu, struct die_args *args)
+static void vmxoff_nmi(int cpu, struct pt_regs *regs)
 {
 	cpu_emergency_vmxoff();
 }
@@ -736,14 +736,10 @@ static nmi_shootdown_cb shootdown_callback;
 
 static atomic_t waiting_for_crash_ipi;
 
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
+static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	int cpu;
 
-	if (val != DIE_NMI)
-		return NOTIFY_OK;
-
 	cpu = raw_smp_processor_id();
 
 	/* Don't do anything if this handler is invoked on crashing cpu.
@@ -751,10 +747,10 @@ static int crash_nmi_callback(struct notifier_block *self,
 	 * an NMI if system was initially booted with nmi_watchdog parameter.
 	 */
 	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	local_irq_disable();
 
-	shootdown_callback(cpu, (struct die_args *)data);
+	shootdown_callback(cpu, regs);
 
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -762,7 +758,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 	for (;;)
 		cpu_relax();
 
-	return 1;
+	return NMI_HANDLED;
 }
 
 static void smp_send_nmi_allbutself(void)
@@ -770,12 +766,6 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-	/* we want to be the first one called */
-	.priority = NMI_LOCAL_HIGH_PRIOR+1,
-};
-
 /* Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
@@ -794,7 +784,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
-	if (register_die_notifier(&crash_nmi_nb))
+	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
+				 NMI_FLAG_FIRST, "crash"))
 		return;		/* return what? */
 	/* Ensure the new callback function is set before sending
 	 * out the NMI
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6913369..a8e3eb8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -81,15 +81,6 @@ gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
 
-static int ignore_nmis;
-
-int unknown_nmi_panic;
-/*
- * Prevent NMI reason port (0x61) being accessed simultaneously, can
- * only be used in NMI handler.
- */
-static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
-
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -307,152 +298,6 @@ gp_in_kernel:
 	die("general protection fault", regs, error_code);
 }
 
-static int __init setup_unknown_nmi_panic(char *str)
-{
-	unknown_nmi_panic = 1;
-	return 1;
-}
-__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
-
-static notrace __kprobes void
-pci_serr_error(unsigned char reason, struct pt_regs *regs)
-{
-	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-
-	/*
-	 * On some machines, PCI SERR line is used to report memory
-	 * errors. EDAC makes use of it.
-	 */
-#if defined(CONFIG_EDAC)
-	if (edac_handler_set()) {
-		edac_atomic_assert_error();
-		return;
-	}
-#endif
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	pr_emerg("Dazed and confused, but trying to continue\n");
-
-	/* Clear and disable the PCI SERR error line. */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
-	outb(reason, NMI_REASON_PORT);
-}
-
-static notrace __kprobes void
-io_check_error(unsigned char reason, struct pt_regs *regs)
-{
-	unsigned long i;
-
-	pr_emerg(
-	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-	show_registers(regs);
-
-	if (panic_on_io_nmi)
-		panic("NMI IOCK error: Not continuing");
-
-	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
-
-	i = 20000;
-	while (--i) {
-		touch_nmi_watchdog();
-		udelay(100);
-	}
-
-	reason &= ~NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
-}
-
-static notrace __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
-{
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
-#ifdef CONFIG_MCA
-	/*
-	 * Might actually be able to figure out what the guilty party
-	 * is:
-	 */
-	if (MCA_bus) {
-		mca_handle_nmi();
-		return;
-	}
-#endif
-	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-
-	pr_emerg("Do you have a strange power saving mode enabled?\n");
-	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	pr_emerg("Dazed and confused, but trying to continue\n");
-}
-
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
-{
-	unsigned char reason = 0;
-
-	/*
-	 * CPU-specific NMI must be processed before non-CPU-specific
-	 * NMI, otherwise we may lose it, because the CPU-specific
-	 * NMI can not be detected/processed on other CPUs.
-	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
-	raw_spin_lock(&nmi_reason_lock);
-	reason = get_nmi_reason();
-
-	if (reason & NMI_REASON_MASK) {
-		if (reason & NMI_REASON_SERR)
-			pci_serr_error(reason, regs);
-		else if (reason & NMI_REASON_IOCHK)
-			io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-		/*
-		 * Reassert NMI in case it became active
-		 * meanwhile as it's edge-triggered:
-		 */
-		reassert_nmi();
-#endif
-		raw_spin_unlock(&nmi_reason_lock);
-		return;
-	}
-	raw_spin_unlock(&nmi_reason_lock);
-
-	unknown_nmi_error(reason, regs);
-}
-
-dotraplinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-
-	inc_irq_stat(__nmi_count);
-
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-}
-
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 68894fd..c04dc14 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -61,26 +61,15 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 }
 
 
-static int profile_exceptions_notify(struct notifier_block *self,
-				     unsigned long val, void *data)
+static int profile_exceptions_notify(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_NMI:
-		if (ctr_running)
-			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
-		else if (!nmi_enabled)
-			break;
-		else
-			model->stop(&__get_cpu_var(cpu_msrs));
-		ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
+	if (ctr_running)
+		model->check_ctrs(regs, &__get_cpu_var(cpu_msrs));
+	else if (!nmi_enabled)
+		return NMI_DONE;
+	else
+		model->stop(&__get_cpu_var(cpu_msrs));
+	return NMI_HANDLED;
 }
 
 static void nmi_cpu_save_registers(struct op_msrs *msrs)
@@ -363,12 +352,6 @@ static void nmi_cpu_setup(void *dummy)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-static struct notifier_block profile_exceptions_nb = {
-	.notifier_call = profile_exceptions_notify,
-	.next = NULL,
-	.priority = NMI_LOCAL_LOW_PRIOR,
-};
-
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
@@ -402,8 +385,6 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
-	if (model->cpu_down)
-		model->cpu_down();
 }
 
 static void nmi_cpu_up(void *dummy)
@@ -508,7 +489,8 @@ static int nmi_setup(void)
 	ctr_running = 0;
 	/* make variables visible to the nmi handler: */
 	smp_mb();
-	err = register_die_notifier(&profile_exceptions_nb);
+	err = register_nmi_handler(NMI_LOCAL, profile_exceptions_notify,
+					0, "oprofile");
 	if (err)
 		goto fail;
 
@@ -538,7 +520,7 @@ static void nmi_shutdown(void)
 	put_online_cpus();
 	/* make variables visible to the nmi handler: */
 	smp_mb();
-	unregister_die_notifier(&profile_exceptions_nb);
+	unregister_nmi_handler(NMI_LOCAL, "oprofile");
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index 720bf5a..7f8052c 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -18,32 +18,16 @@
 #include <asm/apic.h>
 #include <asm/ptrace.h>
 
-static int profile_timer_exceptions_notify(struct notifier_block *self,
-					   unsigned long val, void *data)
+static int profile_timer_exceptions_notify(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_NMI:
-		oprofile_add_sample(args->regs, 0);
-		ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
+	oprofile_add_sample(regs, 0);
+	return NMI_HANDLED;
 }
 
-static struct notifier_block profile_timer_exceptions_nb = {
-	.notifier_call = profile_timer_exceptions_notify,
-	.next = NULL,
-	.priority = NMI_LOW_PRIOR,
-};
-
 static int timer_start(void)
 {
-	if (register_die_notifier(&profile_timer_exceptions_nb))
+	if (register_nmi_handler(NMI_LOCAL, profile_timer_exceptions_notify,
+					0, "oprofile-timer"))
 		return 1;
 	return 0;
 }
@@ -51,7 +35,7 @@ static int timer_start(void)
 
 static void timer_stop(void)
 {
-	unregister_die_notifier(&profile_timer_exceptions_nb);
+	unregister_nmi_handler(NMI_LOCAL, "oprofile-timer");
 	synchronize_sched();  /* Allow already-started NMIs to complete. */
 }
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9cbb710..303f086 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -29,8 +29,6 @@
 #include "op_x86_model.h"
 #include "op_counter.h"
 
-#define NUM_COUNTERS		4
-#define NUM_COUNTERS_F15H	6
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 #define NUM_VIRT_COUNTERS	32
 #else
@@ -70,62 +68,12 @@ static struct ibs_config ibs_config;
 static struct ibs_state ibs_state;
 
 /*
- * IBS cpuid feature detection
- */
-
-#define IBS_CPUID_FEATURES		0x8000001b
-
-/*
- * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
- * bit 0 is used to indicate the existence of IBS.
- */
-#define IBS_CAPS_AVAIL			(1U<<0)
-#define IBS_CAPS_FETCHSAM		(1U<<1)
-#define IBS_CAPS_OPSAM			(1U<<2)
-#define IBS_CAPS_RDWROPCNT		(1U<<3)
-#define IBS_CAPS_OPCNT			(1U<<4)
-#define IBS_CAPS_BRNTRGT		(1U<<5)
-#define IBS_CAPS_OPCNTEXT		(1U<<6)
-
-#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
-					 | IBS_CAPS_FETCHSAM	\
-					 | IBS_CAPS_OPSAM)
-
-/*
- * IBS APIC setup
- */
-#define IBSCTL				0x1cc
-#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
-#define IBSCTL_LVT_OFFSET_MASK		0x0F
-
-/*
  * IBS randomization macros
  */
 #define IBS_RANDOM_BITS			12
 #define IBS_RANDOM_MASK			((1ULL << IBS_RANDOM_BITS) - 1)
 #define IBS_RANDOM_MAXCNT_OFFSET	(1ULL << (IBS_RANDOM_BITS - 5))
 
-static u32 get_ibs_caps(void)
-{
-	u32 ibs_caps;
-	unsigned int max_level;
-
-	if (!boot_cpu_has(X86_FEATURE_IBS))
-		return 0;
-
-	/* check IBS cpuid feature flags */
-	max_level = cpuid_eax(0x80000000);
-	if (max_level < IBS_CPUID_FEATURES)
-		return IBS_CAPS_DEFAULT;
-
-	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
-	if (!(ibs_caps & IBS_CAPS_AVAIL))
-		/* cpuid flags not valid */
-		return IBS_CAPS_DEFAULT;
-
-	return ibs_caps;
-}
-
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -316,81 +264,6 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-static inline int get_eilvt(int offset)
-{
-	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
-}
-
-static inline int put_eilvt(int offset)
-{
-	return !setup_APIC_eilvt(offset, 0, 0, 1);
-}
-
-static inline int ibs_eilvt_valid(void)
-{
-	int offset;
-	u64 val;
-	int valid = 0;
-
-	preempt_disable();
-
-	rdmsrl(MSR_AMD64_IBSCTL, val);
-	offset = val & IBSCTL_LVT_OFFSET_MASK;
-
-	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
-		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		goto out;
-	}
-
-	if (!get_eilvt(offset)) {
-		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		goto out;
-	}
-
-	valid = 1;
-out:
-	preempt_enable();
-
-	return valid;
-}
-
-static inline int get_ibs_offset(void)
-{
-	u64 val;
-
-	rdmsrl(MSR_AMD64_IBSCTL, val);
-	if (!(val & IBSCTL_LVT_OFFSET_VALID))
-		return -EINVAL;
-
-	return val & IBSCTL_LVT_OFFSET_MASK;
-}
-
-static void setup_APIC_ibs(void)
-{
-	int offset;
-
-	offset = get_ibs_offset();
-	if (offset < 0)
-		goto failed;
-
-	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
-		return;
-failed:
-	pr_warn("oprofile: IBS APIC setup failed on cpu #%d\n",
-		smp_processor_id());
-}
-
-static void clear_APIC_ibs(void)
-{
-	int offset;
-
-	offset = get_ibs_offset();
-	if (offset >= 0)
-		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
-}
-
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
@@ -439,7 +312,7 @@ static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 			goto fail;
 		}
 		/* both registers must be reserved */
-		if (num_counters == NUM_COUNTERS_F15H) {
+		if (num_counters == AMD64_NUM_COUNTERS_F15H) {
 			msrs->counters[i].addr = MSR_F15H_PERF_CTR + (i << 1);
 			msrs->controls[i].addr = MSR_F15H_PERF_CTL + (i << 1);
 		} else {
@@ -504,15 +377,6 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 		val |= op_x86_get_ctrl(model, &counter_config[virt]);
 		wrmsrl(msrs->controls[i].addr, val);
 	}
-
-	if (ibs_caps)
-		setup_APIC_ibs();
-}
-
-static void op_amd_cpu_shutdown(void)
-{
-	if (ibs_caps)
-		clear_APIC_ibs();
 }
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
@@ -575,86 +439,6 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static int setup_ibs_ctl(int ibs_eilvt_off)
-{
-	struct pci_dev *cpu_cfg;
-	int nodes;
-	u32 value = 0;
-
-	nodes = 0;
-	cpu_cfg = NULL;
-	do {
-		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
-					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
-					 cpu_cfg);
-		if (!cpu_cfg)
-			break;
-		++nodes;
-		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
-				       | IBSCTL_LVT_OFFSET_VALID);
-		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
-		if (value != (ibs_eilvt_off | IBSCTL_LVT_OFFSET_VALID)) {
-			pci_dev_put(cpu_cfg);
-			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
-			       "IBSCTL = 0x%08x\n", value);
-			return -EINVAL;
-		}
-	} while (1);
-
-	if (!nodes) {
-		printk(KERN_DEBUG "No CPU node configured for IBS\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/*
- * This runs only on the current cpu. We try to find an LVT offset and
- * setup the local APIC. For this we must disable preemption. On
- * success we initialize all nodes with this offset. This updates then
- * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
- * the IBS interrupt vector is called from op_amd_setup_ctrs()/op_-
- * amd_cpu_shutdown() using the new offset.
- */
-static int force_ibs_eilvt_setup(void)
-{
-	int offset;
-	int ret;
-
-	preempt_disable();
-	/* find the next free available EILVT entry, skip offset 0 */
-	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
-		if (get_eilvt(offset))
-			break;
-	}
-	preempt_enable();
-
-	if (offset == APIC_EILVT_NR_MAX) {
-		printk(KERN_DEBUG "No EILVT entry available\n");
-		return -EBUSY;
-	}
-
-	ret = setup_ibs_ctl(offset);
-	if (ret)
-		goto out;
-
-	if (!ibs_eilvt_valid()) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
-	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
-
-	return 0;
-out:
-	preempt_disable();
-	put_eilvt(offset);
-	preempt_enable();
-	return ret;
-}
-
 /*
  * check and reserve APIC extended interrupt LVT offset for IBS if
  * available
@@ -667,17 +451,6 @@ static void init_ibs(void)
 	if (!ibs_caps)
 		return;
 
-	if (ibs_eilvt_valid())
-		goto out;
-
-	if (!force_ibs_eilvt_setup())
-		goto out;
-
-	/* Failed to setup ibs */
-	ibs_caps = 0;
-	return;
-
-out:
 	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 }
 
@@ -741,9 +514,9 @@ static int op_amd_init(struct oprofile_operations *ops)
 	ops->create_files = setup_ibs_files;
 
 	if (boot_cpu_data.x86 == 0x15) {
-		num_counters = NUM_COUNTERS_F15H;
+		num_counters = AMD64_NUM_COUNTERS_F15H;
 	} else {
-		num_counters = NUM_COUNTERS;
+		num_counters = AMD64_NUM_COUNTERS;
 	}
 
 	op_amd_spec.num_counters = num_counters;
@@ -760,7 +533,6 @@ struct op_x86_model_spec op_amd_spec = {
 	.init			= op_amd_init,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
-	.cpu_down		= &op_amd_cpu_shutdown,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 94b7450..d90528e 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -28,7 +28,7 @@ static int counter_width = 32;
 
 #define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
 
-static u64 *reset_value;
+static u64 reset_value[OP_MAX_COUNTER];
 
 static void ppro_shutdown(struct op_msrs const * const msrs)
 {
@@ -40,10 +40,6 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
-	if (reset_value) {
-		kfree(reset_value);
-		reset_value = NULL;
-	}
 }
 
 static int ppro_fill_in_addresses(struct op_msrs * const msrs)
@@ -79,13 +75,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	u64 val;
 	int i;
 
-	if (!reset_value) {
-		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
-					GFP_ATOMIC);
-		if (!reset_value)
-			return;
-	}
-
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
@@ -141,13 +130,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	/*
-	 * This can happen if perf counters are in use when
-	 * we steal the die notifier NMI.
-	 */
-	if (unlikely(!reset_value))
-		goto out;
-
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -158,7 +140,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 	}
 
-out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
@@ -179,8 +160,6 @@ static void ppro_start(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
@@ -196,8 +175,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -242,7 +219,7 @@ static void arch_perfmon_setup_counters(void)
 		eax.split.bit_width = 40;
 	}
 
-	num_counters = eax.split.num_counters;
+	num_counters = min((int)eax.split.num_counters, OP_MAX_COUNTER);
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 89017fa..71e8a67 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -43,7 +43,6 @@ struct op_x86_model_spec {
 	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
-	void		(*cpu_down)(void);
 	int		(*check_ctrs)(struct pt_regs * const regs,
 				      struct op_msrs const * const msrs);
 	void		(*start)(struct op_msrs const * const msrs);
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0784f99..b8e08cb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -50,6 +50,7 @@
 #include <acpi/hed.h>
 #include <asm/mce.h>
 #include <asm/tlbflush.h>
+#include <asm/nmi.h>
 
 #include "apei-internal.h"
 
@@ -749,15 +750,11 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 	}
 }
 
-static int ghes_notify_nmi(struct notifier_block *this,
-				  unsigned long cmd, void *data)
+static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct ghes *ghes, *ghes_global = NULL;
 	int sev, sev_global = -1;
-	int ret = NOTIFY_DONE;
-
-	if (cmd != DIE_NMI)
-		return ret;
+	int ret = NMI_DONE;
 
 	raw_spin_lock(&ghes_nmi_lock);
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
@@ -770,10 +767,10 @@ static int ghes_notify_nmi(struct notifier_block *this,
 			sev_global = sev;
 			ghes_global = ghes;
 		}
-		ret = NOTIFY_STOP;
+		ret = NMI_HANDLED;
 	}
 
-	if (ret == NOTIFY_DONE)
+	if (ret == NMI_DONE)
 		goto out;
 
 	if (sev_global >= GHES_SEV_PANIC) {
@@ -825,10 +822,6 @@ static struct notifier_block ghes_notifier_sci = {
 	.notifier_call = ghes_notify_sci,
 };
 
-static struct notifier_block ghes_notifier_nmi = {
-	.notifier_call = ghes_notify_nmi,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -918,7 +911,8 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 		ghes_estatus_pool_expand(len);
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_nmi))
-			register_die_notifier(&ghes_notifier_nmi);
+			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
+						"ghes");
 		list_add_rcu(&ghes->list, &ghes_nmi);
 		mutex_unlock(&ghes_list_mutex);
 		break;
@@ -964,7 +958,7 @@ static int __devexit ghes_remove(struct platform_device *ghes_dev)
 		mutex_lock(&ghes_list_mutex);
 		list_del_rcu(&ghes->list);
 		if (list_empty(&ghes_nmi))
-			unregister_die_notifier(&ghes_notifier_nmi);
+			unregister_nmi_handler(NMI_LOCAL, "ghes");
 		mutex_unlock(&ghes_list_mutex);
 		/*
 		 * To synchronize with NMI handler, ghes can only be
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 3302586..c2917ffa 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -65,6 +65,7 @@
  * mechanism for it at that time.
  */
 #include <asm/kdebug.h>
+#include <asm/nmi.h>
 #define HAVE_DIE_NMI
 #endif
 
@@ -1077,17 +1078,8 @@ static void ipmi_unregister_watchdog(int ipmi_intf)
 
 #ifdef HAVE_DIE_NMI
 static int
-ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
+ipmi_nmi(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = data;
-
-	if (val != DIE_NMIUNKNOWN)
-		return NOTIFY_OK;
-
-	/* Hack, if it's a memory or I/O error, ignore it. */
-	if (args->err & 0xc0)
-		return NOTIFY_OK;
-
 	/*
 	 * If we get here, it's an NMI that's not a memory or I/O
 	 * error.  We can't truly tell if it's from IPMI or not
@@ -1097,15 +1089,15 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 
 	if (testing_nmi) {
 		testing_nmi = 2;
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	}
 
 	/* If we are not expecting a timeout, ignore it. */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
-		return NOTIFY_OK;
+		return NMI_DONE;
 
 	if (preaction_val != WDOG_PRETIMEOUT_NMI)
-		return NOTIFY_OK;
+		return NMI_DONE;
 
 	/*
 	 * If no one else handled the NMI, we assume it was the IPMI
@@ -1120,12 +1112,8 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 			panic(PFX "pre-timeout");
 	}
 
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
-
-static struct notifier_block ipmi_nmi_handler = {
-	.notifier_call = ipmi_nmi
-};
 #endif
 
 static int wdog_reboot_handler(struct notifier_block *this,
@@ -1290,7 +1278,8 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_die_notifier(&ipmi_nmi_handler);
+		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
+						"ipmi");
 		if (rv) {
 			printk(KERN_WARNING PFX
 			       "Can't register nmi handler\n");
@@ -1298,7 +1287,7 @@ static void check_parms(void)
 		} else
 			nmi_handler_registered = 1;
 	} else if (!do_nmi && nmi_handler_registered) {
-		unregister_die_notifier(&ipmi_nmi_handler);
+		unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 		nmi_handler_registered = 0;
 	}
 #endif
@@ -1336,7 +1325,7 @@ static int __init ipmi_wdog_init(void)
 	if (rv) {
 #ifdef HAVE_DIE_NMI
 		if (nmi_handler_registered)
-			unregister_die_notifier(&ipmi_nmi_handler);
+			unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 #endif
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &wdog_panic_notifier);
@@ -1357,7 +1346,7 @@ static void __exit ipmi_wdog_exit(void)
 
 #ifdef HAVE_DIE_NMI
 	if (nmi_handler_registered)
-		unregister_die_notifier(&ipmi_nmi_handler);
+		unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 #endif
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 809cbda..3774c9b 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -35,6 +35,7 @@
 #include <linux/notifier.h>
 #include <asm/cacheflush.h>
 #endif /* CONFIG_HPWDT_NMI_DECODING */
+#include <asm/nmi.h>
 
 #define HPWDT_VERSION			"1.3.0"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
@@ -477,15 +478,11 @@ static int hpwdt_time_left(void)
 /*
  *	NMI Handler
  */
-static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
-				void *data)
+static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 {
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMIUNKNOWN)
-		goto out;
-
 	if (!hpwdt_nmi_decoding)
 		goto out;
 
@@ -508,7 +505,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		"Management Log for details.\n");
 
 out:
-	return NOTIFY_OK;
+	return NMI_DONE;
 }
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 
@@ -648,13 +645,6 @@ static struct miscdevice hpwdt_miscdev = {
 	.fops = &hpwdt_fops,
 };
 
-#ifdef CONFIG_HPWDT_NMI_DECODING
-static struct notifier_block die_notifier = {
-	.notifier_call = hpwdt_pretimeout,
-	.priority = 0,
-};
-#endif /* CONFIG_HPWDT_NMI_DECODING */
-
 /*
  *	Init & Exit
  */
@@ -740,10 +730,9 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * die notify list to handle a critical NMI. The default is to
 	 * be last so other users of the NMI signal can function.
 	 */
-	if (priority)
-		die_notifier.priority = 0x7FFFFFFF;
-
-	retval = register_die_notifier(&die_notifier);
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
+					(priority) ? NMI_FLAG_FIRST : 0,
+					"hpwdt");
 	if (retval != 0) {
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",
@@ -763,7 +752,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 
 static void hpwdt_exit_nmi_decoding(void)
 {
-	unregister_die_notifier(&die_notifier);
+	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 }
diff --git a/include/linux/module.h b/include/linux/module.h
index 1c30087..8639216 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -580,9 +580,6 @@ int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
 
-extern void module_update_tracepoints(void);
-extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -698,15 +695,6 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
 static inline void print_modules(void)
 {
 }
-
-static inline void module_update_tracepoints(void)
-{
-}
-
-static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	return 0;
-}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..1e9ebe5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -220,7 +220,10 @@ struct perf_event_attr {
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
 
-				__reserved_1   : 45;
+				exclude_host   :  1, /* don't count in host   */
+				exclude_guest  :  1, /* don't count in guest  */
+
+				__reserved_1   : 43;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b891de9..67be037 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -154,6 +154,8 @@ void ring_buffer_record_enable(struct ring_buffer *buffer);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
+unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..4eb4902 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -15,5 +15,6 @@
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
+extern u64 notrace trace_clock_counter(void);
 
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d530a44..df0a779 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -54,8 +54,18 @@ extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
 						void *data);
 extern void tracepoint_probe_update_all(void);
 
+#ifdef CONFIG_MODULES
+struct tp_module {
+	struct list_head list;
+	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
+};
+#endif /* CONFIG_MODULES */
+
 struct tracepoint_iter {
-	struct module *module;
+#ifdef CONFIG_MODULES
+	struct tp_module *module;
+#endif /* CONFIG_MODULES */
 	struct tracepoint * const *tracepoint;
 };
 
@@ -63,8 +73,6 @@ extern void tracepoint_iter_start(struct tracepoint_iter *iter);
 extern void tracepoint_iter_next(struct tracepoint_iter *iter);
 extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
 extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
-	struct tracepoint * const *begin, struct tracepoint * const *end);
 
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
@@ -78,17 +86,6 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define PARAMS(args...) args
 
-#ifdef CONFIG_TRACEPOINTS
-extern
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end);
-#else
-static inline
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end)
-{ }
-#endif /* CONFIG_TRACEPOINTS */
-
 #endif /* _LINUX_TRACEPOINT_H */
 
 /*
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 533c49f..7697249 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -711,6 +711,9 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
+#undef TP_perf_assign
+#define TP_perf_assign(args...) args
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f85778..d1a1bee 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -29,6 +29,7 @@
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
@@ -5758,6 +5759,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (ret)
 			pmu = ERR_PTR(ret);
@@ -5765,6 +5767,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
 			goto unlock;
@@ -5891,8 +5894,6 @@ done:
 		return ERR_PTR(err);
 	}
 
-	event->pmu = pmu;
-
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
 			jump_label_inc(&perf_sched_events);
@@ -6852,7 +6853,7 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
-	if (swhash->hlist_refcount > 0) {
+	if (swhash->hlist_refcount > 0 && !swhash->swevent_hlist) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
@@ -6941,7 +6942,14 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
+	/*
+	 * Ignore suspend/resume action, the perf_pm_notifier will
+	 * take care of that.
+	 */
+	if (action & CPU_TASKS_FROZEN)
+		return NOTIFY_OK;
+
+	switch (action) {
 
 	case CPU_UP_PREPARE:
 	case CPU_DOWN_FAILED:
@@ -6960,6 +6968,90 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+static void perf_pm_resume_cpu(void *unused)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		ctx = cpuctx->task_ctx;
+
+		perf_ctx_lock(cpuctx, ctx);
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+		if (ctx)
+			ctx_sched_out(ctx, cpuctx, EVENT_ALL);
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+		perf_ctx_unlock(cpuctx, ctx);
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+}
+
+static void perf_pm_suspend_cpu(void *unused)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		ctx = cpuctx->task_ctx;
+
+		perf_ctx_lock(cpuctx, ctx);
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		perf_event_sched_in(cpuctx, ctx, current);
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+		perf_ctx_unlock(cpuctx, ctx);
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+}
+
+static int perf_resume(void)
+{
+	get_online_cpus();
+	smp_call_function(perf_pm_resume_cpu, NULL, 1);
+	put_online_cpus();
+
+	return NOTIFY_OK;
+}
+
+static int perf_suspend(void)
+{
+	get_online_cpus();
+	smp_call_function(perf_pm_suspend_cpu, NULL, 1);
+	put_online_cpus();
+
+	return NOTIFY_OK;
+}
+
+static int perf_pm(struct notifier_block *self, unsigned long action, void *ptr)
+{
+	switch (action) {
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return perf_resume();
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return perf_suspend();
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block perf_pm_notifier = {
+	.notifier_call = perf_pm,
+};
+
 void __init perf_event_init(void)
 {
 	int ret;
@@ -6974,6 +7066,7 @@ void __init perf_event_init(void)
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 	register_reboot_notifier(&perf_reboot_notifier);
+	register_pm_notifier(&perf_pm_notifier);
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
diff --git a/kernel/module.c b/kernel/module.c
index 04379f92..93342d9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3487,50 +3487,3 @@ void module_layout(struct module *mod,
 }
 EXPORT_SYMBOL(module_layout);
 #endif
-
-#ifdef CONFIG_TRACEPOINTS
-void module_update_tracepoints(void)
-{
-	struct module *mod;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(mod, &modules, list)
-		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints_ptrs,
-				mod->tracepoints_ptrs + mod->num_tracepoints);
-	mutex_unlock(&module_mutex);
-}
-
-/*
- * Returns 0 if current not found.
- * Returns 1 if current found.
- */
-int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	struct module *iter_mod;
-	int found = 0;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(iter_mod, &modules, list) {
-		if (!iter_mod->taints) {
-			/*
-			 * Sorted module list
-			 */
-			if (iter_mod < iter->module)
-				continue;
-			else if (iter_mod > iter->module)
-				iter->tracepoint = NULL;
-			found = tracepoint_get_iter_range(&iter->tracepoint,
-				iter_mod->tracepoints_ptrs,
-				iter_mod->tracepoints_ptrs
-					+ iter_mod->num_tracepoints);
-			if (found) {
-				iter->module = iter_mod;
-				break;
-			}
-		}
-	}
-	mutex_unlock(&module_mutex);
-	return found;
-}
-#endif
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 761c510..b384ed5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,6 +15,8 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_trace_events_filter.o := -I$(src)
+
 #
 # Make the trace clocks available generally: it's infrastructure
 # relied on by ptrace for example:
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c3e4575..077d853 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3863,6 +3863,14 @@ void ftrace_kill(void)
 }
 
 /**
+ * Test if ftrace is dead or not.
+ */
+int ftrace_is_dead(void)
+{
+	return ftrace_disabled;
+}
+
+/**
  * register_ftrace_function - register a function for profiling
  * @ops - ops structure that holds the function for profiling.
  *
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 731201b..acf6b68 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -488,12 +488,14 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*reader_page;
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
+	local_t				entries_bytes;
 	local_t				commit_overrun;
 	local_t				overrun;
 	local_t				entries;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
+	unsigned long			read_bytes;
 	u64				write_stamp;
 	u64				read_stamp;
 };
@@ -1708,6 +1710,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 * the counters.
 		 */
 		local_add(entries, &cpu_buffer->overrun);
+		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -1863,6 +1866,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	event = __rb_page_index(tail_page, tail);
 	kmemcheck_annotate_bitfield(event, bitfield);
 
+	/* account for padding bytes */
+	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
+
 	/*
 	 * Save the original length to the meta data.
 	 * This will be used by the reader to add lost event
@@ -2054,6 +2060,9 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	if (!tail)
 		tail_page->page->time_stamp = ts;
 
+	/* account for these added bytes */
+	local_add(length, &cpu_buffer->entries_bytes);
+
 	return event;
 }
 
@@ -2076,6 +2085,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
 			local_read(&bpage->write) & ~RB_WRITE_MASK;
+		unsigned long event_length = rb_event_length(event);
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
@@ -2085,8 +2095,11 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 		old_index += write_mask;
 		new_index += write_mask;
 		index = local_cmpxchg(&bpage->write, old_index, new_index);
-		if (index == old_index)
+		if (index == old_index) {
+			/* update counters */
+			local_sub(event_length, &cpu_buffer->entries_bytes);
 			return 1;
+		}
 	}
 
 	/* could not discard */
@@ -2661,6 +2674,58 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 /**
+ * ring_buffer_oldest_event_ts - get the oldest event timestamp from the buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to read from.
+ */
+unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
+{
+	unsigned long flags;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct buffer_page *bpage;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	/*
+	 * if the tail is on reader_page, oldest time stamp is on the reader
+	 * page
+	 */
+	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+		bpage = cpu_buffer->reader_page;
+	else
+		bpage = rb_set_head_page(cpu_buffer);
+	ret = bpage->page->time_stamp;
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_oldest_event_ts);
+
+/**
+ * ring_buffer_bytes_cpu - get the number of bytes consumed in a cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to read from.
+ */
+unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = local_read(&cpu_buffer->entries_bytes) - cpu_buffer->read_bytes;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_bytes_cpu);
+
+/**
  * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the entries from.
@@ -3527,11 +3592,13 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->read = 0;
 
 	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->entries_bytes, 0);
 	local_set(&cpu_buffer->overrun, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
 	cpu_buffer->read = 0;
+	cpu_buffer->read_bytes = 0;
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -3918,6 +3985,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	} else {
 		/* update the entry counter */
 		cpu_buffer->read += rb_page_entries(reader);
+		cpu_buffer->read_bytes += BUF_PAGE_SIZE;
 
 		/* swap the pages */
 		rb_init_page(bpage);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..b24a72d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,7 @@ static struct {
 } trace_clocks[] = {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
+	{ trace_clock_counter,	"counter" },
 };
 
 int trace_clock_id;
@@ -2159,6 +2160,14 @@ void trace_default_header(struct seq_file *m)
 	}
 }
 
+static void test_ftrace_alive(struct seq_file *m)
+{
+	if (!ftrace_is_dead())
+		return;
+	seq_printf(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
+}
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
@@ -2168,6 +2177,7 @@ static int s_show(struct seq_file *m, void *v)
 		if (iter->tr) {
 			seq_printf(m, "# tracer: %s\n", iter->trace->name);
 			seq_puts(m, "#\n");
+			test_ftrace_alive(m);
 		}
 		if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
@@ -2710,9 +2720,9 @@ static const char readme_msg[] =
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
 	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
 ;
 
 static ssize_t
@@ -3569,6 +3579,30 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 }
 
 static ssize_t
+tracing_total_entries_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	char buf[64];
+	int r, cpu;
+	unsigned long size = 0, expanded_size = 0;
+
+	mutex_lock(&trace_types_lock);
+	for_each_tracing_cpu(cpu) {
+		size += tr->entries >> 10;
+		if (!ring_buffer_expanded)
+			expanded_size += trace_buf_size >> 10;
+	}
+	if (ring_buffer_expanded)
+		r = sprintf(buf, "%lu\n", size);
+	else
+		r = sprintf(buf, "%lu (expanded: %lu)\n", size, expanded_size);
+	mutex_unlock(&trace_types_lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
 tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
 			  size_t cnt, loff_t *ppos)
 {
@@ -3594,22 +3628,24 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int mark_printk(const char *fmt, ...)
-{
-	int ret;
-	va_list args;
-	va_start(args, fmt);
-	ret = trace_vprintk(0, fmt, args);
-	va_end(args);
-	return ret;
-}
-
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
-	char *buf;
-	size_t written;
+	unsigned long addr = (unsigned long)ubuf;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	struct print_entry *entry;
+	unsigned long irq_flags;
+	struct page *pages[2];
+	int nr_pages = 1;
+	ssize_t written;
+	void *page1;
+	void *page2;
+	int offset;
+	int size;
+	int len;
+	int ret;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3617,28 +3653,81 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (cnt > TRACE_BUF_SIZE)
 		cnt = TRACE_BUF_SIZE;
 
-	buf = kmalloc(cnt + 2, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
+	/*
+	 * Userspace is injecting traces into the kernel trace buffer.
+	 * We want to be as non intrusive as possible.
+	 * To do so, we do not want to allocate any special buffers
+	 * or take any locks, but instead write the userspace data
+	 * straight into the ring buffer.
+	 *
+	 * First we need to pin the userspace buffer into memory,
+	 * which, most likely it is, because it just referenced it.
+	 * But there's no guarantee that it is. By using get_user_pages_fast()
+	 * and kmap_atomic/kunmap_atomic() we can get access to the
+	 * pages directly. We then write the data directly into the
+	 * ring buffer.
+	 */
+	BUILD_BUG_ON(TRACE_BUF_SIZE >= PAGE_SIZE);
 
-	if (copy_from_user(buf, ubuf, cnt)) {
-		kfree(buf);
-		return -EFAULT;
+	/* check if we cross pages */
+	if ((addr & PAGE_MASK) != ((addr + cnt) & PAGE_MASK))
+		nr_pages = 2;
+
+	offset = addr & (PAGE_SIZE - 1);
+	addr &= PAGE_MASK;
+
+	ret = get_user_pages_fast(addr, nr_pages, 0, pages);
+	if (ret < nr_pages) {
+		while (--ret >= 0)
+			put_page(pages[ret]);
+		written = -EFAULT;
+		goto out;
+	}
+
+	page1 = kmap_atomic(pages[0]);
+	if (nr_pages == 2)
+		page2 = kmap_atomic(pages[1]);
+
+	local_save_flags(irq_flags);
+	size = sizeof(*entry) + cnt + 2; /* possible \n added */
+	buffer = global_trace.buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
+					  irq_flags, preempt_count());
+	if (!event) {
+		/* Ring buffer disabled, return as if not open for write */
+		written = -EBADF;
+		goto out_unlock;
 	}
-	if (buf[cnt-1] != '\n') {
-		buf[cnt] = '\n';
-		buf[cnt+1] = '\0';
+
+	entry = ring_buffer_event_data(event);
+	entry->ip = _THIS_IP_;
+
+	if (nr_pages == 2) {
+		len = PAGE_SIZE - offset;
+		memcpy(&entry->buf, page1 + offset, len);
+		memcpy(&entry->buf[len], page2, cnt - len);
 	} else
-		buf[cnt] = '\0';
+		memcpy(&entry->buf, page1 + offset, cnt);
 
-	written = mark_printk("%s", buf);
-	kfree(buf);
-	*fpos += written;
+	if (entry->buf[cnt - 1] != '\n') {
+		entry->buf[cnt] = '\n';
+		entry->buf[cnt + 1] = '\0';
+	} else
+		entry->buf[cnt] = '\0';
+
+	ring_buffer_unlock_commit(buffer, event);
 
-	/* don't tell userspace we wrote more - it might confuse them */
-	if (written > cnt)
-		written = cnt;
+	written = cnt;
 
+	*fpos += written;
+
+ out_unlock:
+	if (nr_pages == 2)
+		kunmap_atomic(page2);
+	kunmap_atomic(page1);
+	while (nr_pages > 0)
+		put_page(pages[--nr_pages]);
+ out:
 	return written;
 }
 
@@ -3739,6 +3828,12 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_total_entries_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_total_entries_read,
+	.llseek		= generic_file_llseek,
+};
+
 static const struct file_operations tracing_free_buffer_fops = {
 	.write		= tracing_free_buffer_write,
 	.release	= tracing_free_buffer_release,
@@ -3808,8 +3903,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (info->read < PAGE_SIZE)
 		goto read;
 
-	info->read = 0;
-
 	trace_access_lock(info->cpu);
 	ret = ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
@@ -3819,6 +3912,8 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (ret < 0)
 		return 0;
 
+	info->read = 0;
+
 read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
@@ -4026,6 +4121,8 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_array *tr = &global_trace;
 	struct trace_seq *s;
 	unsigned long cnt;
+	unsigned long long t;
+	unsigned long usec_rem;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
@@ -4042,6 +4139,17 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
+	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "bytes: %ld\n", cnt);
+
+	t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
+	usec_rem = do_div(t, USEC_PER_SEC);
+	trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n", t, usec_rem);
+
+	t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+	usec_rem = do_div(t, USEC_PER_SEC);
+	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -4450,6 +4558,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
+			&global_trace, &tracing_total_entries_fops);
+
 	trace_create_file("free_buffer", 0644, d_tracer,
 			&global_trace, &tracing_free_buffer_fops);
 
@@ -4566,6 +4677,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
 	tracing_off();
 
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	if (disable_tracing)
 		ftrace_kill();
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 616846b..092e1f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -579,11 +579,13 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 	return test_tsk_trace_trace(task);
 }
+extern int ftrace_is_dead(void);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
+static inline int ftrace_is_dead(void) { return 0; }
 #endif
 
 /*
@@ -761,16 +763,10 @@ struct filter_pred {
 	filter_pred_fn_t 	fn;
 	u64 			val;
 	struct regex		regex;
-	/*
-	 * Leaf nodes use field_name, ops is used by AND and OR
-	 * nodes. The field_name is always freed when freeing a pred.
-	 * We can overload field_name for ops and have it freed
-	 * as well.
-	 */
-	union {
-		char		*field_name;
-		unsigned short	*ops;
-	};
+	unsigned short		*ops;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	struct ftrace_event_field *field;
+#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..3947835 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -113,3 +113,15 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+
+static atomic64_t trace_counter;
+
+/*
+ * trace_clock_counter(): simply an atomic counter.
+ * Use the trace_counter "counter" for cases where you do not care
+ * about timings, but are interested in strict ordering.
+ */
+u64 notrace trace_clock_counter(void)
+{
+	return atomic64_add_return(1, &trace_counter);
+}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 256764e..816d3d0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,63 @@ get_pred_parent(struct filter_pred *pred, struct filter_pred *preds,
 	return pred;
 }
 
+enum walk_return {
+	WALK_PRED_ABORT,
+	WALK_PRED_PARENT,
+	WALK_PRED_DEFAULT,
+};
+
+typedef int (*filter_pred_walkcb_t) (enum move_type move,
+				     struct filter_pred *pred,
+				     int *err, void *data);
+
+static int walk_pred_tree(struct filter_pred *preds,
+			  struct filter_pred *root,
+			  filter_pred_walkcb_t cb, void *data)
+{
+	struct filter_pred *pred = root;
+	enum move_type move = MOVE_DOWN;
+	int done = 0;
+
+	if  (!preds)
+		return -EINVAL;
+
+	do {
+		int err = 0, ret;
+
+		ret = cb(move, pred, &err, data);
+		if (ret == WALK_PRED_ABORT)
+			return err;
+		if (ret == WALK_PRED_PARENT)
+			goto get_parent;
+
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+			goto get_parent;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+ get_parent:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent,
+					       &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	/* We are fine. */
+	return 0;
+}
+
 /*
  * A series of AND or ORs where found together. Instead of
  * climbing up and down the tree branches, an array of the
@@ -410,99 +467,91 @@ static int process_ops(struct filter_pred *preds,
 
 	for (i = 0; i < op->val; i++) {
 		pred = &preds[op->ops[i]];
-		match = pred->fn(pred, rec);
+		if (!WARN_ON_ONCE(!pred->fn))
+			match = pred->fn(pred, rec);
 		if (!!match == type)
 			return match;
 	}
 	return match;
 }
 
+struct filter_match_preds_data {
+	struct filter_pred *preds;
+	int match;
+	void *rec;
+};
+
+static int filter_match_preds_cb(enum move_type move, struct filter_pred *pred,
+				 int *err, void *data)
+{
+	struct filter_match_preds_data *d = data;
+
+	*err = 0;
+	switch (move) {
+	case MOVE_DOWN:
+		/* only AND and OR have children */
+		if (pred->left != FILTER_PRED_INVALID) {
+			/* If ops is set, then it was folded. */
+			if (!pred->ops)
+				return WALK_PRED_DEFAULT;
+			/* We can treat folded ops as a leaf node */
+			d->match = process_ops(d->preds, pred, d->rec);
+		} else {
+			if (!WARN_ON_ONCE(!pred->fn))
+				d->match = pred->fn(pred, d->rec);
+		}
+
+		return WALK_PRED_PARENT;
+	case MOVE_UP_FROM_LEFT:
+		/*
+		 * Check for short circuits.
+		 *
+		 * Optimization: !!match == (pred->op == OP_OR)
+		 *   is the same as:
+		 * if ((match && pred->op == OP_OR) ||
+		 *     (!match && pred->op == OP_AND))
+		 */
+		if (!!d->match == (pred->op == OP_OR))
+			return WALK_PRED_PARENT;
+		break;
+	case MOVE_UP_FROM_RIGHT:
+		break;
+	}
+
+	return WALK_PRED_DEFAULT;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	int match = -1;
-	enum move_type move = MOVE_DOWN;
 	struct filter_pred *preds;
-	struct filter_pred *pred;
 	struct filter_pred *root;
-	int n_preds;
-	int done = 0;
+	struct filter_match_preds_data data = {
+		/* match is currently meaningless */
+		.match = -1,
+		.rec   = rec,
+	};
+	int n_preds, ret;
 
 	/* no filter is considered a match */
 	if (!filter)
 		return 1;
 
 	n_preds = filter->n_preds;
-
 	if (!n_preds)
 		return 1;
 
 	/*
 	 * n_preds, root and filter->preds are protect with preemption disabled.
 	 */
-	preds = rcu_dereference_sched(filter->preds);
 	root = rcu_dereference_sched(filter->root);
 	if (!root)
 		return 1;
 
-	pred = root;
-
-	/* match is currently meaningless */
-	match = -1;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			/* only AND and OR have children */
-			if (pred->left != FILTER_PRED_INVALID) {
-				/* If ops is set, then it was folded. */
-				if (!pred->ops) {
-					/* keep going to down the left side */
-					pred = &preds[pred->left];
-					continue;
-				}
-				/* We can treat folded ops as a leaf node */
-				match = process_ops(preds, pred, rec);
-			} else
-				match = pred->fn(pred, rec);
-			/* If this pred is the only pred */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			/*
-			 * Check for short circuits.
-			 *
-			 * Optimization: !!match == (pred->op == OP_OR)
-			 *   is the same as:
-			 * if ((match && pred->op == OP_OR) ||
-			 *     (!match && pred->op == OP_AND))
-			 */
-			if (!!match == (pred->op == OP_OR)) {
-				if (pred == root)
-					break;
-				pred = get_pred_parent(pred, preds,
-						       pred->parent, &move);
-				continue;
-			}
-			/* now go down the right side of the tree. */
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			/* We finished this equation. */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
-
-	return match;
+	data.preds = preds = rcu_dereference_sched(filter->preds);
+	ret = walk_pred_tree(preds, root, filter_match_preds_cb, &data);
+	WARN_ON(ret);
+	return data.match;
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
@@ -628,22 +677,6 @@ find_event_field(struct ftrace_event_call *call, char *name)
 	return __find_event_field(head, name);
 }
 
-static void filter_free_pred(struct filter_pred *pred)
-{
-	if (!pred)
-		return;
-
-	kfree(pred->field_name);
-	kfree(pred);
-}
-
-static void filter_clear_pred(struct filter_pred *pred)
-{
-	kfree(pred->field_name);
-	pred->field_name = NULL;
-	pred->regex.len = 0;
-}
-
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
 	stack->preds = kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
@@ -689,20 +722,13 @@ __pop_pred_stack(struct pred_stack *stack)
 static int filter_set_pred(struct event_filter *filter,
 			   int idx,
 			   struct pred_stack *stack,
-			   struct filter_pred *src,
-			   filter_pred_fn_t fn)
+			   struct filter_pred *src)
 {
 	struct filter_pred *dest = &filter->preds[idx];
 	struct filter_pred *left;
 	struct filter_pred *right;
 
 	*dest = *src;
-	if (src->field_name) {
-		dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
-		if (!dest->field_name)
-			return -ENOMEM;
-	}
-	dest->fn = fn;
 	dest->index = idx;
 
 	if (dest->op == OP_OR || dest->op == OP_AND) {
@@ -743,11 +769,7 @@ static int filter_set_pred(struct event_filter *filter,
 
 static void __free_preds(struct event_filter *filter)
 {
-	int i;
-
 	if (filter->preds) {
-		for (i = 0; i < filter->a_preds; i++)
-			kfree(filter->preds[i].field_name);
 		kfree(filter->preds);
 		filter->preds = NULL;
 	}
@@ -840,23 +862,19 @@ static void filter_free_subsystem_filters(struct event_subsystem *system)
 	}
 }
 
-static int filter_add_pred_fn(struct filter_parse_state *ps,
-			      struct ftrace_event_call *call,
-			      struct event_filter *filter,
-			      struct filter_pred *pred,
-			      struct pred_stack *stack,
-			      filter_pred_fn_t fn)
+static int filter_add_pred(struct filter_parse_state *ps,
+			   struct event_filter *filter,
+			   struct filter_pred *pred,
+			   struct pred_stack *stack)
 {
-	int idx, err;
+	int err;
 
 	if (WARN_ON(filter->n_preds == filter->a_preds)) {
 		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
 	}
 
-	idx = filter->n_preds;
-	filter_clear_pred(&filter->preds[idx]);
-	err = filter_set_pred(filter, idx, stack, pred, fn);
+	err = filter_set_pred(filter, filter->n_preds, stack, pred);
 	if (err)
 		return err;
 
@@ -937,31 +955,15 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 	return fn;
 }
 
-static int filter_add_pred(struct filter_parse_state *ps,
-			   struct ftrace_event_call *call,
-			   struct event_filter *filter,
-			   struct filter_pred *pred,
-			   struct pred_stack *stack,
-			   bool dry_run)
+static int init_pred(struct filter_parse_state *ps,
+		     struct ftrace_event_field *field,
+		     struct filter_pred *pred)
+
 {
-	struct ftrace_event_field *field;
-	filter_pred_fn_t fn;
+	filter_pred_fn_t fn = filter_pred_none;
 	unsigned long long val;
 	int ret;
 
-	fn = pred->fn = filter_pred_none;
-
-	if (pred->op == OP_AND)
-		goto add_pred_fn;
-	else if (pred->op == OP_OR)
-		goto add_pred_fn;
-
-	field = find_event_field(call, pred->field_name);
-	if (!field) {
-		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
-		return -EINVAL;
-	}
-
 	pred->offset = field->offset;
 
 	if (!is_legal_op(field, pred->op)) {
@@ -1001,9 +1003,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	if (pred->op == OP_NE)
 		pred->not = 1;
 
-add_pred_fn:
-	if (!dry_run)
-		return filter_add_pred_fn(ps, call, filter, pred, stack, fn);
+	pred->fn = fn;
 	return 0;
 }
 
@@ -1302,39 +1302,37 @@ parse_operand:
 	return 0;
 }
 
-static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
+static struct filter_pred *create_pred(struct filter_parse_state *ps,
+				       struct ftrace_event_call *call,
+				       int op, char *operand1, char *operand2)
 {
-	struct filter_pred *pred;
+	struct ftrace_event_field *field;
+	static struct filter_pred pred;
 
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
-		return NULL;
+	memset(&pred, 0, sizeof(pred));
+	pred.op = op;
 
-	pred->field_name = kstrdup(operand1, GFP_KERNEL);
-	if (!pred->field_name) {
-		kfree(pred);
+	if (op == OP_AND || op == OP_OR)
+		return &pred;
+
+	if (!operand1 || !operand2) {
+		parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
 		return NULL;
 	}
 
-	strcpy(pred->regex.pattern, operand2);
-	pred->regex.len = strlen(pred->regex.pattern);
-
-	pred->op = op;
-
-	return pred;
-}
-
-static struct filter_pred *create_logical_pred(int op)
-{
-	struct filter_pred *pred;
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	field = find_event_field(call, operand1);
+	if (!field) {
+		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
+	}
 
-	pred->op = op;
+	strcpy(pred.regex.pattern, operand2);
+	pred.regex.len = strlen(pred.regex.pattern);
 
-	return pred;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	pred.field = field;
+#endif
+	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
 static int check_preds(struct filter_parse_state *ps)
@@ -1375,6 +1373,23 @@ static int count_preds(struct filter_parse_state *ps)
 	return n_preds;
 }
 
+struct check_pred_data {
+	int count;
+	int max;
+};
+
+static int check_pred_tree_cb(enum move_type move, struct filter_pred *pred,
+			      int *err, void *data)
+{
+	struct check_pred_data *d = data;
+
+	if (WARN_ON(d->count++ > d->max)) {
+		*err = -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
 /*
  * The tree is walked at filtering of an event. If the tree is not correctly
  * built, it may cause an infinite loop. Check here that the tree does
@@ -1383,107 +1398,76 @@ static int count_preds(struct filter_parse_state *ps)
 static int check_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
-	int done = 0;
-	int max;
-
-	/*
-	 * The max that we can hit a node is three times.
-	 * Once going down, once coming up from left, and
-	 * once coming up from right. This is more than enough
-	 * since leafs are only hit a single time.
-	 */
-	max = 3 * filter->n_preds;
+	struct check_pred_data data = {
+		/*
+		 * The max that we can hit a node is three times.
+		 * Once going down, once coming up from left, and
+		 * once coming up from right. This is more than enough
+		 * since leafs are only hit a single time.
+		 */
+		.max   = 3 * filter->n_preds,
+		.count = 0,
+	};
 
-	preds = filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred = root;
+	return walk_pred_tree(filter->preds, root,
+			      check_pred_tree_cb, &data);
+}
 
-	do {
-		if (WARN_ON(count++ > max))
-			return -EINVAL;
+static int count_leafs_cb(enum move_type move, struct filter_pred *pred,
+			  int *err, void *data)
+{
+	int *count = data;
 
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
+	if ((move == MOVE_DOWN) &&
+	    (pred->left == FILTER_PRED_INVALID))
+		(*count)++;
 
-	/* We are fine. */
-	return 0;
+	return WALK_PRED_DEFAULT;
 }
 
 static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
 {
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
-	int done = 0;
+	int count = 0, ret;
 
-	pred = root;
+	ret = walk_pred_tree(preds, root, count_leafs_cb, &count);
+	WARN_ON(ret);
+	return count;
+}
 
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred == root)
-				return 1;
-			count++;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
+struct fold_pred_data {
+	struct filter_pred *root;
+	int count;
+	int children;
+};
 
-	return count;
+static int fold_pred_cb(enum move_type move, struct filter_pred *pred,
+			int *err, void *data)
+{
+	struct fold_pred_data *d = data;
+	struct filter_pred *root = d->root;
+
+	if (move != MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (pred->left != FILTER_PRED_INVALID)
+		return WALK_PRED_DEFAULT;
+
+	if (WARN_ON(d->count == d->children)) {
+		*err = -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+
+	pred->index &= ~FILTER_PRED_FOLD;
+	root->ops[d->count++] = pred->index;
+	return WALK_PRED_DEFAULT;
 }
 
 static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 {
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
+	struct fold_pred_data data = {
+		.root  = root,
+		.count = 0,
+	};
 	int children;
-	int done = 0;
 
 	/* No need to keep the fold flag */
 	root->index &= ~FILTER_PRED_FOLD;
@@ -1501,37 +1485,26 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 		return -ENOMEM;
 
 	root->val = children;
+	data.children = children;
+	return walk_pred_tree(preds, root, fold_pred_cb, &data);
+}
 
-	pred = root;
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			if (WARN_ON(count == children))
-				return -EINVAL;
-			pred->index &= ~FILTER_PRED_FOLD;
-			root->ops[count++] = pred->index;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
+static int fold_pred_tree_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	struct filter_pred *preds = data;
 
-	return 0;
+	if (move != MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (!(pred->index & FILTER_PRED_FOLD))
+		return WALK_PRED_DEFAULT;
+
+	*err = fold_pred(preds, pred);
+	if (*err)
+		return WALK_PRED_ABORT;
+
+	/* eveyrhing below is folded, continue with parent */
+	return WALK_PRED_PARENT;
 }
 
 /*
@@ -1542,51 +1515,8 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 static int fold_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int done = 0;
-	int err;
-
-	preds = filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred = root;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->index & FILTER_PRED_FOLD) {
-				err = fold_pred(preds, pred);
-				if (err)
-					return err;
-				/* Folded nodes are like leafs */
-			} else if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
-
-	return 0;
+	return walk_pred_tree(filter->preds, root, fold_pred_tree_cb,
+			      filter->preds);
 }
 
 static int replace_preds(struct ftrace_event_call *call,
@@ -1643,27 +1573,17 @@ static int replace_preds(struct ftrace_event_call *call,
 			goto fail;
 		}
 
-		if (elt->op == OP_AND || elt->op == OP_OR) {
-			pred = create_logical_pred(elt->op);
-			goto add_pred;
-		}
-
-		if (!operand1 || !operand2) {
-			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
+		pred = create_pred(ps, call, elt->op, operand1, operand2);
+		if (!pred) {
 			err = -EINVAL;
 			goto fail;
 		}
 
-		pred = create_pred(elt->op, operand1, operand2);
-add_pred:
-		if (!pred) {
-			err = -ENOMEM;
-			goto fail;
+		if (!dry_run) {
+			err = filter_add_pred(ps, filter, pred, &stack);
+			if (err)
+				goto fail;
 		}
-		err = filter_add_pred(ps, call, filter, pred, &stack, dry_run);
-		filter_free_pred(pred);
-		if (err)
-			goto fail;
 
 		operand1 = operand2 = NULL;
 	}
@@ -1958,17 +1878,14 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	int err;
 	struct event_filter *filter;
 	struct filter_parse_state *ps;
-	struct ftrace_event_call *call = NULL;
+	struct ftrace_event_call *call;
 
 	mutex_lock(&event_mutex);
 
-	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->event.type == event_id)
-			break;
-	}
+	call = event->tp_event;
 
 	err = -EINVAL;
-	if (&call->list == &ftrace_events)
+	if (!call)
 		goto out_unlock;
 
 	err = -EEXIST;
@@ -2012,3 +1929,215 @@ out_unlock:
 
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace_events_filter_test.h"
+
+static int test_get_filter(char *filter_str, struct ftrace_event_call *call,
+			   struct event_filter **pfilter)
+{
+	struct event_filter *filter;
+	struct filter_parse_state *ps;
+	int err = -ENOMEM;
+
+	filter = __alloc_filter();
+	if (!filter)
+		goto out;
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto free_filter;
+
+	parse_init(ps, filter_ops, filter_str);
+	err = filter_parse(ps);
+	if (err)
+		goto free_ps;
+
+	err = replace_preds(call, filter, ps, filter_str, false);
+	if (!err)
+		*pfilter = filter;
+
+ free_ps:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+ free_filter:
+	if (err)
+		__free_filter(filter);
+
+ out:
+	return err;
+}
+
+#define DATA_REC(m, va, vb, vc, vd, ve, vf, vg, vh, nvisit) \
+{ \
+	.filter = FILTER, \
+	.rec    = { .a = va, .b = vb, .c = vc, .d = vd, \
+		    .e = ve, .f = vf, .g = vg, .h = vh }, \
+	.match  = m, \
+	.not_visited = nvisit, \
+}
+#define YES 1
+#define NO  0
+
+static struct test_filter_data_t {
+	char *filter;
+	struct ftrace_raw_ftrace_test_filter rec;
+	int match;
+	char *not_visited;
+} test_filter_data[] = {
+#define FILTER "a == 1 && b == 1 && c == 1 && d == 1 && " \
+	       "e == 1 && f == 1 && g == 1 && h == 1"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, ""),
+	DATA_REC(NO,  0, 1, 1, 1, 1, 1, 1, 1, "bcdefgh"),
+	DATA_REC(NO,  1, 1, 1, 1, 1, 1, 1, 0, ""),
+#undef FILTER
+#define FILTER "a == 1 || b == 1 || c == 1 || d == 1 || " \
+	       "e == 1 || f == 1 || g == 1 || h == 1"
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 0, 0, 0, 0, 0, 0, "bcdefgh"),
+#undef FILTER
+#define FILTER "(a == 1 || b == 1) && (c == 1 || d == 1) && " \
+	       "(e == 1 || f == 1) && (g == 1 || h == 1)"
+	DATA_REC(NO,  0, 0, 1, 1, 1, 1, 1, 1, "dfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 0, 1, 0, 1, "bd"),
+	DATA_REC(NO,  1, 0, 1, 0, 0, 1, 0, 0, "bd"),
+#undef FILTER
+#define FILTER "(a == 1 && b == 1) || (c == 1 && d == 1) || " \
+	       "(e == 1 && f == 1) || (g == 1 && h == 1)"
+	DATA_REC(YES, 1, 0, 1, 1, 1, 1, 1, 1, "efgh"),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 1, 1, ""),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+#undef FILTER
+#define FILTER "(a == 1 && b == 1) && (c == 1 && d == 1) && " \
+	       "(e == 1 && f == 1) || (g == 1 && h == 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 0, "gh"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, ""),
+#undef FILTER
+#define FILTER "((a == 1 || b == 1) || (c == 1 || d == 1) || " \
+	       "(e == 1 || f == 1)) && (g == 1 || h == 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 1, "bcdef"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, "h"),
+#undef FILTER
+#define FILTER "((((((((a == 1) && (b == 1)) || (c == 1)) && (d == 1)) || " \
+	       "(e == 1)) && (f == 1)) || (g == 1)) && (h == 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "ceg"),
+	DATA_REC(NO,  0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(NO,  1, 0, 1, 0, 1, 0, 1, 0, ""),
+#undef FILTER
+#define FILTER "((((((((a == 1) || (b == 1)) && (c == 1)) || (d == 1)) && " \
+	       "(e == 1)) || (f == 1)) && (g == 1)) || (h == 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "bdfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 1, 0, 1, 0, "bdfh"),
+};
+
+#undef DATA_REC
+#undef FILTER
+#undef YES
+#undef NO
+
+#define DATA_CNT (sizeof(test_filter_data)/sizeof(struct test_filter_data_t))
+
+static int test_pred_visited;
+
+static int test_pred_visited_fn(struct filter_pred *pred, void *event)
+{
+	struct ftrace_event_field *field = pred->field;
+
+	test_pred_visited = 1;
+	printk(KERN_INFO "\npred visited %s\n", field->name);
+	return 1;
+}
+
+static int test_walk_pred_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	char *fields = data;
+
+	if ((move == MOVE_DOWN) &&
+	    (pred->left == FILTER_PRED_INVALID)) {
+		struct ftrace_event_field *field = pred->field;
+
+		if (!field) {
+			WARN(1, "all leafs should have field defined");
+			return WALK_PRED_DEFAULT;
+		}
+		if (!strchr(fields, *field->name))
+			return WALK_PRED_DEFAULT;
+
+		WARN_ON(!pred->fn);
+		pred->fn = test_pred_visited_fn;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
+static __init int ftrace_test_event_filter(void)
+{
+	int i;
+
+	printk(KERN_INFO "Testing ftrace filter: ");
+
+	for (i = 0; i < DATA_CNT; i++) {
+		struct event_filter *filter = NULL;
+		struct test_filter_data_t *d = &test_filter_data[i];
+		int err;
+
+		err = test_get_filter(d->filter, &event_ftrace_test_filter,
+				      &filter);
+		if (err) {
+			printk(KERN_INFO
+			       "Failed to get filter for '%s', err %d\n",
+			       d->filter, err);
+			break;
+		}
+
+		/*
+		 * The preemption disabling is not really needed for self
+		 * tests, but the rcu dereference will complain without it.
+		 */
+		preempt_disable();
+		if (*d->not_visited)
+			walk_pred_tree(filter->preds, filter->root,
+				       test_walk_pred_cb,
+				       d->not_visited);
+
+		test_pred_visited = 0;
+		err = filter_match_preds(filter, &d->rec);
+		preempt_enable();
+
+		__free_filter(filter);
+
+		if (test_pred_visited) {
+			printk(KERN_INFO
+			       "Failed, unwanted pred visited for filter %s\n",
+			       d->filter);
+			break;
+		}
+
+		if (err != d->match) {
+			printk(KERN_INFO
+			       "Failed to match filter '%s', expected %d\n",
+			       d->filter, d->match);
+			break;
+		}
+	}
+
+	if (i == DATA_CNT)
+		printk(KERN_CONT "OK\n");
+
+	return 0;
+}
+
+late_initcall(ftrace_test_event_filter);
+
+#endif /* CONFIG_FTRACE_STARTUP_TEST */
diff --git a/kernel/trace/trace_events_filter_test.h b/kernel/trace/trace_events_filter_test.h
new file mode 100644
index 0000000..bfd4dba
--- /dev/null
+++ b/kernel/trace/trace_events_filter_test.h
@@ -0,0 +1,50 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM test
+
+#if !defined(_TRACE_TEST_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TEST_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ftrace_test_filter,
+
+	TP_PROTO(int a, int b, int c, int d, int e, int f, int g, int h),
+
+	TP_ARGS(a, b, c, d, e, f, g, h),
+
+	TP_STRUCT__entry(
+		__field(int, a)
+		__field(int, b)
+		__field(int, c)
+		__field(int, d)
+		__field(int, e)
+		__field(int, f)
+		__field(int, g)
+		__field(int, h)
+	),
+
+	TP_fast_assign(
+		__entry->a = a;
+		__entry->b = b;
+		__entry->c = c;
+		__entry->d = d;
+		__entry->e = e;
+		__entry->f = f;
+		__entry->g = g;
+		__entry->h = h;
+	),
+
+	TP_printk("a %d, b %d, c %d, d %d, e %d, f %d, g %d, h %d",
+		  __entry->a, __entry->b, __entry->c, __entry->d,
+		  __entry->e, __entry->f, __entry->g, __entry->h)
+);
+
+#endif /* _TRACE_TEST_H || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_events_filter_test
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..a1a3359 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -505,13 +505,13 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller);
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		stop_critical_timing(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5fb3697..00d527c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -836,11 +836,17 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static void unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_probe(struct trace_probe *tp)
 {
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
+
+	return 0;
 }
 
 /* Register a trace_probe and probe_event */
@@ -854,7 +860,9 @@ static int register_trace_probe(struct trace_probe *tp)
 	/* Delete old (same name) event if exist */
 	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
-		unregister_trace_probe(old_tp);
+		ret = unregister_trace_probe(old_tp);
+		if (ret < 0)
+			goto end;
 		free_trace_probe(old_tp);
 	}
 
@@ -892,6 +900,7 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 	mutex_lock(&probe_lock);
 	list_for_each_entry(tp, &probe_list, list) {
 		if (trace_probe_within_module(tp, mod)) {
+			/* Don't need to check busy - this should have gone. */
 			__unregister_trace_probe(tp);
 			ret = __register_trace_probe(tp);
 			if (ret)
@@ -1205,10 +1214,11 @@ static int create_trace_probe(int argc, char **argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_probe(tp);
-		free_trace_probe(tp);
+		ret = unregister_trace_probe(tp);
+		if (ret == 0)
+			free_trace_probe(tp);
 		mutex_unlock(&probe_lock);
-		return 0;
+		return ret;
 	}
 
 	if (argc < 2) {
@@ -1317,18 +1327,29 @@ error:
 	return ret;
 }
 
-static void release_all_trace_probes(void)
+static int release_all_trace_probes(void)
 {
 	struct trace_probe *tp;
+	int ret = 0;
 
 	mutex_lock(&probe_lock);
+	/* Ensure no probe is in use. */
+	list_for_each_entry(tp, &probe_list, list)
+		if (trace_probe_is_enabled(tp)) {
+			ret = -EBUSY;
+			goto end;
+		}
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
 		unregister_trace_probe(tp);
 		free_trace_probe(tp);
 	}
+
+end:
 	mutex_unlock(&probe_lock);
+
+	return ret;
 }
 
 /* Probes listing interfaces */
@@ -1380,9 +1401,13 @@ static const struct seq_operations probes_seq_op = {
 
 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		release_all_trace_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = release_all_trace_probes();
+		if (ret < 0)
+			return ret;
+	}
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -2055,6 +2080,21 @@ static __init int kprobe_trace_self_tests_init(void)
 
 	ret = target(1, 2, 3, 4, 5, 6);
 
+	/* Disable trace points before removing it */
+	tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp == NULL)) {
+		pr_warning("error on getting test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
+	tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp == NULL)) {
+		pr_warning("error on getting 2nd test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
 	ret = command_trace_probe("-:testprobe");
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error on deleting a probe.\n");
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 1f06468..6fd4ffd 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -59,18 +59,19 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 			continue;
 		}
 
+		fmt = NULL;
 		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
-		if (tb_fmt)
+		if (tb_fmt) {
 			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt && fmt) {
-			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
-			strcpy(fmt, *iter);
-			tb_fmt->fmt = fmt;
-			*iter = tb_fmt->fmt;
-		} else {
-			kfree(tb_fmt);
-			*iter = NULL;
+			if (fmt) {
+				list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
+				strcpy(fmt, *iter);
+				tb_fmt->fmt = fmt;
+			} else
+				kfree(tb_fmt);
 		}
+		*iter = fmt;
+
 	}
 	mutex_unlock(&btrace_mutex);
 }
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index b219f14..db110b8 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -34,11 +34,16 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
 static const int tracepoint_debug;
 
 /*
- * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects the
- * builtin and module tracepoints and the hash table.
+ * Tracepoints mutex protects the builtin and module tracepoints and the hash
+ * table, as well as the local module list.
  */
 static DEFINE_MUTEX(tracepoints_mutex);
 
+#ifdef CONFIG_MODULES
+/* Local list of struct module */
+static LIST_HEAD(tracepoint_module_list);
+#endif /* CONFIG_MODULES */
+
 /*
  * Tracepoint hash table, containing the active tracepoints.
  * Protected by tracepoints_mutex.
@@ -292,9 +297,10 @@ static void disable_tracepoint(struct tracepoint *elem)
  * @end: end of the range
  *
  * Updates the probe callback corresponding to a range of tracepoints.
+ * Called with tracepoints_mutex held.
  */
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-				   struct tracepoint * const *end)
+static void tracepoint_update_probe_range(struct tracepoint * const *begin,
+					  struct tracepoint * const *end)
 {
 	struct tracepoint * const *iter;
 	struct tracepoint_entry *mark_entry;
@@ -302,7 +308,6 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 	if (!begin)
 		return;
 
-	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_tracepoint((*iter)->name);
 		if (mark_entry) {
@@ -312,11 +317,27 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 			disable_tracepoint(*iter);
 		}
 	}
-	mutex_unlock(&tracepoints_mutex);
 }
 
+#ifdef CONFIG_MODULES
+void module_update_tracepoints(void)
+{
+	struct tp_module *tp_mod;
+
+	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
+		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
+			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
+}
+#else /* CONFIG_MODULES */
+void module_update_tracepoints(void)
+{
+}
+#endif /* CONFIG_MODULES */
+
+
 /*
  * Update probes, removing the faulty probes.
+ * Called with tracepoints_mutex held.
  */
 static void tracepoint_update_probes(void)
 {
@@ -359,11 +380,12 @@ int tracepoint_probe_register(const char *name, void *probe, void *data)
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_add_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -402,11 +424,12 @@ int tracepoint_probe_unregister(const char *name, void *probe, void *data)
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_remove_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -489,9 +512,8 @@ void tracepoint_probe_update_all(void)
 	if (!list_empty(&old_probes))
 		list_replace_init(&old_probes, &release_probes);
 	need_update = 0;
-	mutex_unlock(&tracepoints_mutex);
-
 	tracepoint_update_probes();
+	mutex_unlock(&tracepoints_mutex);
 	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
 		list_del(&pos->u.list);
 		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
@@ -509,7 +531,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
  * Will return the first tracepoint in the range if the input tracepoint is
  * NULL.
  */
-int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+static int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
 	struct tracepoint * const *begin, struct tracepoint * const *end)
 {
 	if (!*tracepoint && begin != end) {
@@ -520,11 +542,12 @@ int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
 		return 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
 
+#ifdef CONFIG_MODULES
 static void tracepoint_get_iter(struct tracepoint_iter *iter)
 {
 	int found = 0;
+	struct tp_module *iter_mod;
 
 	/* Core kernel tracepoints */
 	if (!iter->module) {
@@ -534,12 +557,43 @@ static void tracepoint_get_iter(struct tracepoint_iter *iter)
 		if (found)
 			goto end;
 	}
-	/* tracepoints in modules. */
-	found = module_get_iter_tracepoints(iter);
+	/* Tracepoints in modules */
+	mutex_lock(&tracepoints_mutex);
+	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
+		/*
+		 * Sorted module list
+		 */
+		if (iter_mod < iter->module)
+			continue;
+		else if (iter_mod > iter->module)
+			iter->tracepoint = NULL;
+		found = tracepoint_get_iter_range(&iter->tracepoint,
+			iter_mod->tracepoints_ptrs,
+			iter_mod->tracepoints_ptrs
+				+ iter_mod->num_tracepoints);
+		if (found) {
+			iter->module = iter_mod;
+			break;
+		}
+	}
+	mutex_unlock(&tracepoints_mutex);
 end:
 	if (!found)
 		tracepoint_iter_reset(iter);
 }
+#else /* CONFIG_MODULES */
+static void tracepoint_get_iter(struct tracepoint_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel tracepoints */
+	found = tracepoint_get_iter_range(&iter->tracepoint,
+			__start___tracepoints_ptrs,
+			__stop___tracepoints_ptrs);
+	if (!found)
+		tracepoint_iter_reset(iter);
+}
+#endif /* CONFIG_MODULES */
 
 void tracepoint_iter_start(struct tracepoint_iter *iter)
 {
@@ -566,26 +620,98 @@ EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
 
 void tracepoint_iter_reset(struct tracepoint_iter *iter)
 {
+#ifdef CONFIG_MODULES
 	iter->module = NULL;
+#endif /* CONFIG_MODULES */
 	iter->tracepoint = NULL;
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
 #ifdef CONFIG_MODULES
+static int tracepoint_module_coming(struct module *mod)
+{
+	struct tp_module *tp_mod, *iter;
+	int ret = 0;
+
+	/*
+	 * We skip modules that tain the kernel, especially those with different
+	 * module header (for forced load), to make sure we don't cause a crash.
+	 */
+	if (mod->taints)
+		return 0;
+	mutex_lock(&tracepoints_mutex);
+	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
+	if (!tp_mod) {
+		ret = -ENOMEM;
+		goto end;
+	}
+	tp_mod->num_tracepoints = mod->num_tracepoints;
+	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
+
+	/*
+	 * tracepoint_module_list is kept sorted by struct module pointer
+	 * address for iteration on tracepoints from a seq_file that can release
+	 * the mutex between calls.
+	 */
+	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
+		BUG_ON(iter == tp_mod);	/* Should never be in the list twice */
+		if (iter < tp_mod) {
+			/* We belong to the location right after iter. */
+			list_add(&tp_mod->list, &iter->list);
+			goto module_added;
+		}
+	}
+	/* We belong to the beginning of the list */
+	list_add(&tp_mod->list, &tracepoint_module_list);
+module_added:
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+
+static int tracepoint_module_going(struct module *mod)
+{
+	struct tp_module *pos;
+
+	mutex_lock(&tracepoints_mutex);
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+	list_for_each_entry(pos, &tracepoint_module_list, list) {
+		if (pos->tracepoints_ptrs == mod->tracepoints_ptrs) {
+			list_del(&pos->list);
+			kfree(pos);
+			break;
+		}
+	}
+	/*
+	 * In the case of modules that were tainted at "coming", we'll simply
+	 * walk through the list without finding it. We cannot use the "tainted"
+	 * flag on "going", in case a module taints the kernel only after being
+	 * loaded.
+	 */
+	mutex_unlock(&tracepoints_mutex);
+	return 0;
+}
 
 int tracepoint_module_notify(struct notifier_block *self,
 			     unsigned long val, void *data)
 {
 	struct module *mod = data;
+	int ret = 0;
 
 	switch (val) {
 	case MODULE_STATE_COMING:
+		ret = tracepoint_module_coming(mod);
+		break;
+	case MODULE_STATE_LIVE:
+		break;
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints_ptrs,
-			mod->tracepoints_ptrs + mod->num_tracepoints);
+		ret = tracepoint_module_going(mod);
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 struct notifier_block tracepoint_module_nb = {
@@ -598,7 +724,6 @@ static int init_tracepoints(void)
 	return register_module_notifier(&tracepoint_module_nb);
 }
 __initcall(init_tracepoints);
-
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..d680381 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -321,7 +321,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
  */
 static int watchdog(void *unused)
 {
-	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
@@ -350,7 +350,8 @@ static int watchdog(void *unused)
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
-
+	param.sched_priority = 0;
+	sched_setscheduler(current, SCHED_NORMAL, &param);
 	return 0;
 }
 
@@ -438,7 +439,7 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
-		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
 			if (!err) {
diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 85c5f02..fe6762e 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -72,6 +72,19 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+--asm-raw::
+	Show raw instruction encoding of assembly instructions.
+
+--source::
+	Interleave source code with assembly code. Enabled by default,
+	disable with --no-source.
+
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index 5eaac6f..cc22325 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -16,6 +16,9 @@ This command displays the buildids found in a perf.data file, so that other
 tools can be used to fetch packages with matching symbol tables for use by
 perf report.
 
+It can also be used to show the build id of the running kernel or in an ELF
+file using -i/--input.
+
 OPTIONS
 -------
 -H::
@@ -27,6 +30,9 @@ OPTIONS
 -f::
 --force::
 	Don't do ownership validation.
+-k::
+--kernel::
+	Show running kernel build id.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 04253c0..212f24d 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -134,6 +134,24 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
+--source::
+	Interleave source code with assembly code. Enabled by default,
+	disable with --no-source.
+
+--asm-raw::
+	Show raw instruction encoding of assembly instructions.
+
+--show-total-period:: Show a column with the sum of periods.
+
+-I::
+--show-info::
+	Display extended information about the perf.data file. This adds
+	information which may be very large and thus may clutter the display.
+	It currently includes: cpu and numa topology of the host system.
+
 SEE ALSO
 --------
-linkperf:perf-stat[1]
+linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 46822d5..5b212b5 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf sched' {record|latency|map|replay|trace}
+'perf sched' {record|latency|map|replay|script}
 
 DESCRIPTION
 -----------
@@ -20,8 +20,8 @@ There are five variants of perf sched:
   'perf sched latency' to report the per task scheduling latencies
   and other scheduling properties of the workload.
 
-  'perf sched trace' to see a detailed trace of the workload that
-  was recorded.
+  'perf sched script' to see a detailed trace of the workload that
+   was recorded (aliased to 'perf script' for now).
 
   'perf sched replay' to simulate the workload that was recorded
   via perf sched record. (this is done by starting up mockup threads
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index db01786..dec87ec 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -188,6 +188,13 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-I::
+--show-info::
+	Display extended information about the perf.data file. This adds
+	information which may be very large and thus may clutter the display.
+	It currently includes: cpu and numa topology of the host system.
+	It can only be used with the perf script report mode.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 918cc38..8966b9a 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -94,6 +94,22 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+-o file::
+--output file::
+Print the output into the designated file.
+
+--append::
+Append to the output file designated with the -o option. Ignored if -o is not specified.
+
+--log-fd::
+
+Log output to fd, instead of stderr.  Complementary to --output, and mutually exclusive
+with it.  --append may be used here.  Examples:
+     3>results  perf stat --log-fd 3          -- $cmd
+     3>>results perf stat --log-fd 3 --append -- $cmd
+
+
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f6eb1cd..b1a5bbb 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -106,6 +106,51 @@ Default is to monitor all CPUS.
 --zero::
 	Zero history across display updates.
 
+-s::
+--sort::
+	Sort by key(s): pid, comm, dso, symbol, parent
+
+-n::
+--show-nr-samples::
+	Show a column with the number of samples.
+
+--show-total-period::
+	Show a column with the sum of periods.
+
+--dsos::
+	Only consider symbols in these dsos.
+
+--comms::
+	Only consider symbols in these comms.
+
+--symbols::
+	Only consider these symbols.
+
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
+--source::
+	Interleave source code with assembly code. Enabled by default,
+	disable with --no-source.
+
+--asm-raw::
+	Show raw instruction encoding of assembly instructions.
+
+-G [type,min,order]::
+--call-graph::
+        Display call chains using type, min percent threshold and order.
+	type can be either:
+	- flat: single column, linear exposure of call chains.
+	- graph: use a graph tree, displaying absolute overhead rates.
+	- fractal: like graph, but displays relative rates. Each branch of
+		 the tree is considered as a new profiled object.
+
+	order can be either:
+	- callee: callee based call graph.
+	- caller: inverted caller based call graph.
+
+	Default: fractal,0.5,callee.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
@@ -130,9 +175,6 @@ INTERACTIVE PROMPTING KEYS
 [S]::
 	Stop annotation, return to full profile display.
 
-[w]::
-	Toggle between weighted sum and individual count[E]r profile.
-
 [z]::
 	Toggle event count zeroing across display updates.
 
diff --git a/tools/perf/Documentation/perfconfig.example b/tools/perf/Documentation/perfconfig.example
new file mode 100644
index 0000000..d144866
--- /dev/null
+++ b/tools/perf/Documentation/perfconfig.example
@@ -0,0 +1,20 @@
+[colors]
+
+	# These were the old defaults
+	top = red, lightgray
+	medium = green, lightgray
+	normal = black, lightgray
+	selected = lightgray, magenta
+	code = blue, lightgray
+
+[tui]
+
+	# Defaults if linked with libslang
+	report = on
+	annotate = on
+	top = on
+
+[buildid]
+
+	# Default, disable using /dev/null
+	dir = /root/.debug
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e9d5c27..b98e307 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -466,13 +466,13 @@ else
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)util/ui/browsers/top.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_OBJS += $(OUTPUT)util/ui/util.o
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/browsers/map.h
 		LIB_H += util/ui/helpline.h
+		LIB_H += util/ui/keysyms.h
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
 		LIB_H += util/ui/util.h
@@ -729,9 +729,6 @@ $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/ui/browsers/top.o: util/ui/browsers/top.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
 $(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
new file mode 100644
index 0000000..eba80c2
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -0,0 +1,36 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+#define __stringify_1(x)        #x
+#define __stringify(x)          __stringify_1(x)
+
+#define mfspr(rn)       ({unsigned long rval; \
+			 asm volatile("mfspr %0," __stringify(rn) \
+				      : "=r" (rval)); rval; })
+
+#define SPRN_PVR        0x11F	/* Processor Version Register */
+#define PVR_VER(pvr)    (((pvr) >>  16) & 0xFFFF) /* Version field */
+#define PVR_REV(pvr)    (((pvr) >>   0) & 0xFFFF) /* Revison field */
+
+int
+get_cpuid(char *buffer, size_t sz)
+{
+	unsigned long pvr;
+	int nb;
+
+	pvr = mfspr(SPRN_PVR);
+
+	nb = snprintf(buffer, sz, "%lu,%lu$", PVR_VER(pvr), PVR_REV(pvr));
+
+	/* look for end marker to ensure the entire data fit */
+	if (strchr(buffer, '$')) {
+		buffer[nb-1] = '\0';
+		return 0;
+	}
+	return -1;
+}
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
new file mode 100644
index 0000000..f940060
--- /dev/null
+++ b/tools/perf/arch/x86/util/header.c
@@ -0,0 +1,59 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+static inline void
+cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
+      unsigned int *d)
+{
+	__asm__ __volatile__ (".byte 0x53\n\tcpuid\n\t"
+			      "movl %%ebx, %%esi\n\t.byte 0x5b"
+			: "=a" (*a),
+			"=S" (*b),
+			"=c" (*c),
+			"=d" (*d)
+			: "a" (op));
+}
+
+int
+get_cpuid(char *buffer, size_t sz)
+{
+	unsigned int a, b, c, d, lvl;
+	int family = -1, model = -1, step = -1;
+	int nb;
+	char vendor[16];
+
+	cpuid(0, &lvl, &b, &c, &d);
+	strncpy(&vendor[0], (char *)(&b), 4);
+	strncpy(&vendor[4], (char *)(&d), 4);
+	strncpy(&vendor[8], (char *)(&c), 4);
+	vendor[12] = '\0';
+
+	if (lvl >= 1) {
+		cpuid(1, &a, &b, &c, &d);
+
+		family = (a >> 8) & 0xf;  /* bits 11 - 8 */
+		model  = (a >> 4) & 0xf;  /* Bits  7 - 4 */
+		step   = a & 0xf;
+
+		/* extended family */
+		if (family == 0xf)
+			family += (a >> 20) & 0xff;
+
+		/* extended model */
+		if (family >= 0x6)
+			model += ((a >> 16) & 0xf) << 4;
+	}
+	nb = snprintf(buffer, sz, "%s,%u,%u,%u$", vendor, family, model, step);
+
+	/* look for end marker to ensure the entire data fit */
+	if (strchr(buffer, '$')) {
+		buffer[nb-1] = '\0';
+		return 0;
+	}
+	return -1;
+}
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 555aefd..46b4c24 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -114,10 +114,11 @@ static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 				    print_line, full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx)
+static void hists__find_annotations(struct hists *self, int evidx,
+				    int nr_events)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
-	int key = KEY_RIGHT;
+	int key = K_RIGHT;
 
 	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
@@ -129,7 +130,7 @@ static void hists__find_annotations(struct hists *self, int evidx)
 		notes = symbol__annotation(he->ms.sym);
 		if (notes->src == NULL) {
 find_next:
-			if (key == KEY_LEFT)
+			if (key == K_LEFT)
 				nd = rb_prev(nd);
 			else
 				nd = rb_next(nd);
@@ -137,12 +138,13 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx);
+			key = hist_entry__tui_annotate(he, evidx, nr_events,
+						       NULL, NULL, 0);
 			switch (key) {
-			case KEY_RIGHT:
+			case K_RIGHT:
 				next = rb_next(nd);
 				break;
-			case KEY_LEFT:
+			case K_LEFT:
 				next = rb_prev(nd);
 				break;
 			default:
@@ -215,7 +217,8 @@ static int __cmd_annotate(void)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx);
+			hists__find_annotations(hists, pos->idx,
+						session->evlist->nr_entries);
 		}
 	}
 
@@ -267,6 +270,14 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		   "Look for files with symbols relative to this directory"),
+	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
+		    "Interleave source code with assembly code (default)"),
+	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
+		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
+		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 5af32ae..cb690a6 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -1,7 +1,8 @@
 /*
  * builtin-buildid-list.c
  *
- * Builtin buildid-list command: list buildids in perf.data
+ * Builtin buildid-list command: list buildids in perf.data, in the running
+ * kernel and in ELF files.
  *
  * Copyright (C) 2009, Red Hat Inc.
  * Copyright (C) 2009, Arnaldo Carvalho de Melo <acme@redhat.com>
@@ -15,8 +16,11 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
+#include <libelf.h>
+
 static char const *input_name = "perf.data";
 static bool force;
+static bool show_kernel;
 static bool with_hits;
 
 static const char * const buildid_list_usage[] = {
@@ -29,12 +33,13 @@ static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose"),
 	OPT_END()
 };
 
-static int __cmd_buildid_list(void)
+static int perf_session__list_build_ids(void)
 {
 	struct perf_session *session;
 
@@ -52,6 +57,49 @@ static int __cmd_buildid_list(void)
 	return 0;
 }
 
+static int sysfs__fprintf_build_id(FILE *fp)
+{
+	u8 kallsyms_build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
+				 sizeof(kallsyms_build_id)) != 0)
+		return -1;
+
+	build_id__sprintf(kallsyms_build_id, sizeof(kallsyms_build_id),
+			  sbuild_id);
+	fprintf(fp, "%s\n", sbuild_id);
+	return 0;
+}
+
+static int filename__fprintf_build_id(const char *name, FILE *fp)
+{
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	if (filename__read_build_id(name, build_id,
+				    sizeof(build_id)) != sizeof(build_id))
+		return 0;
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	return fprintf(fp, "%s\n", sbuild_id);
+}
+
+static int __cmd_buildid_list(void)
+{
+	if (show_kernel)
+		return sysfs__fprintf_build_id(stdout);
+
+	elf_version(EV_CURRENT);
+	/*
+ 	 * See if this is an ELF file first:
+ 	 */
+	if (filename__fprintf_build_id(input_name, stdout))
+		return 0;
+
+	return perf_session__list_build_ids();
+}
+
 int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e821999..b39f3a1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -162,7 +162,7 @@ static int __cmd_diff(void)
 
 	hists__match(&session[0]->hists, &session[1]->hists);
 	hists__fprintf(&session[1]->hists, &session[0]->hists,
-		       show_displacement, stdout);
+		       show_displacement, true, 0, 0, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4c3fbe..f82480f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -73,6 +73,7 @@ static off_t			post_processing_offset;
 
 static struct perf_session	*session;
 static const char		*cpu_list;
+static const char               *progname;
 
 static void advance_output(size_t size)
 {
@@ -137,17 +138,29 @@ static void mmap_read(struct perf_mmap *md)
 
 static volatile int done = 0;
 static volatile int signr = -1;
+static volatile int child_finished = 0;
 
 static void sig_handler(int sig)
 {
+	if (sig == SIGCHLD)
+		child_finished = 1;
+
 	done = 1;
 	signr = sig;
 }
 
 static void sig_atexit(void)
 {
-	if (child_pid > 0)
-		kill(child_pid, SIGTERM);
+	int status;
+
+	if (child_pid > 0) {
+		if (!child_finished)
+			kill(child_pid, SIGTERM);
+
+		wait(&status);
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), progname);
+	}
 
 	if (signr == -1 || signr == SIGUSR1)
 		return;
@@ -446,6 +459,8 @@ static int __cmd_record(int argc, const char **argv)
 	char buf;
 	struct machine *machine;
 
+	progname = argv[0];
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	atexit(sig_atexit);
@@ -514,6 +529,19 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	perf_header__set_feat(&session->header, HEADER_HOSTNAME);
+	perf_header__set_feat(&session->header, HEADER_OSRELEASE);
+	perf_header__set_feat(&session->header, HEADER_ARCH);
+	perf_header__set_feat(&session->header, HEADER_CPUDESC);
+	perf_header__set_feat(&session->header, HEADER_NRCPUS);
+	perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
+	perf_header__set_feat(&session->header, HEADER_CMDLINE);
+	perf_header__set_feat(&session->header, HEADER_VERSION);
+	perf_header__set_feat(&session->header, HEADER_CPU_TOPOLOGY);
+	perf_header__set_feat(&session->header, HEADER_TOTAL_MEM);
+	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
+	perf_header__set_feat(&session->header, HEADER_CPUID);
+
 	/* 512 kiB: default amount of unprivileged mlocked memory */
 	if (mmap_pages == UINT_MAX)
 		mmap_pages = (512 * 1024) / page_size;
@@ -785,6 +813,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	int err = -ENOMEM;
 	struct perf_evsel *pos;
 
+	perf_header__set_cmdline(argc, argv);
+
 	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d7ff277..4d7c834 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,6 +40,7 @@ static char		const *input_name = "perf.data";
 static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
 static bool		dont_use_callchains;
+static bool		show_full_info;
 
 static bool		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -229,13 +230,10 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
-		const char *evname = NULL;
-
-		if (rb_first(&hists->entries) != rb_last(&hists->entries))
-			evname = event_name(pos);
+		const char *evname = event_name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
-		hists__fprintf(hists, NULL, false, stdout);
+		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
@@ -276,6 +274,9 @@ static int __cmd_report(void)
 			goto out_delete;
 	}
 
+	if (use_browser <= 0)
+		perf_session__fprintf_info(session, stdout, show_full_info);
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -330,9 +331,10 @@ static int __cmd_report(void)
 		goto out_delete;
 	}
 
-	if (use_browser > 0)
-		perf_evlist__tui_browse_hists(session->evlist, help);
-	else
+	if (use_browser > 0) {
+		perf_evlist__tui_browse_hists(session->evlist, help,
+					      NULL, NULL, 0);
+	} else
 		perf_evlist__tty_browse_hists(session->evlist, help);
 
 out_delete:
@@ -487,6 +489,16 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_BOOLEAN('I', "show-info", &show_full_info,
+		    "Display extended information about perf.data file"),
+	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
+		    "Interleave source code with assembly code (default)"),
+	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
+		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
+		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
+	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
+		    "Show a column with the sum of periods"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 09024ec..2f62a29 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -22,6 +22,7 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static bool			show_full_info;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
@@ -1083,7 +1084,8 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
-
+	OPT_BOOLEAN('I', "show-info", &show_full_info,
+		    "display extended information from perf.data file"),
 	OPT_END()
 };
 
@@ -1268,6 +1270,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 			return -1;
 	}
 
+	perf_session__fprintf_info(session, stdout, show_full_info);
+
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5deb17d..7ce65f5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -194,6 +194,9 @@ static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 static bool			group				= false;
+static const char		*output_name			= NULL;
+static FILE			*output				= NULL;
+static int			output_fd;
 
 static volatile int done = 0;
 
@@ -251,8 +254,13 @@ static double avg_stats(struct stats *stats)
  */
 static double stddev_stats(struct stats *stats)
 {
-	double variance = stats->M2 / (stats->n - 1);
-	double variance_mean = variance / stats->n;
+	double variance, variance_mean;
+
+	if (!stats->n)
+		return 0.0;
+
+	variance = stats->M2 / (stats->n - 1);
+	variance_mean = variance / stats->n;
 
 	return sqrt(variance_mean);
 }
@@ -352,7 +360,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 		update_stats(&ps->res_stats[i], count[i]);
 
 	if (verbose) {
-		fprintf(stderr, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
+		fprintf(output, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
 			event_name(counter), count[0], count[1], count[2]);
 	}
 
@@ -487,6 +495,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (forks) {
 		close(go_pipe[1]);
 		wait(&status);
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), argv[0]);
 	} else {
 		while(!done) sleep(1);
 	}
@@ -519,9 +529,9 @@ static void print_noise_pct(double total, double avg)
 		pct = 100.0*total/avg;
 
 	if (csv_output)
-		fprintf(stderr, "%s%.2f%%", csv_sep, pct);
-	else
-		fprintf(stderr, "  ( +-%6.2f%% )", pct);
+		fprintf(output, "%s%.2f%%", csv_sep, pct);
+	else if (pct)
+		fprintf(output, "  ( +-%6.2f%% )", pct);
 }
 
 static void print_noise(struct perf_evsel *evsel, double avg)
@@ -546,16 +556,17 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 			csv_output ? 0 : -4,
 			evsel_list->cpus->map[cpu], csv_sep);
 
-	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	fprintf(output, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
 	if (evsel->cgrp)
-		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
 
 	if (csv_output)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
+		fprintf(output, " # %8.3f CPUs utilized          ",
+			avg / avg_stats(&walltime_nsecs_stats));
 }
 
 static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -576,9 +587,9 @@ static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __us
 	else if (ratio > 10.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " frontend cycles idle   ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " frontend cycles idle   ");
 }
 
 static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -599,9 +610,9 @@ static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __use
 	else if (ratio > 20.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " backend  cycles idle   ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " backend  cycles idle   ");
 }
 
 static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -622,9 +633,9 @@ static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all branches        ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all branches        ");
 }
 
 static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -645,9 +656,9 @@ static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all L1-dcache hits  ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all L1-dcache hits  ");
 }
 
 static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -668,9 +679,9 @@ static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all L1-icache hits  ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all L1-icache hits  ");
 }
 
 static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -691,9 +702,9 @@ static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all dTLB cache hits ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all dTLB cache hits ");
 }
 
 static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -714,9 +725,9 @@ static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all iTLB cache hits ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all iTLB cache hits ");
 }
 
 static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -737,9 +748,9 @@ static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, doub
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #  ");
-	color_fprintf(stderr, color, "%6.2f%%", ratio);
-	fprintf(stderr, " of all LL-cache hits   ");
+	fprintf(output, " #  ");
+	color_fprintf(output, color, "%6.2f%%", ratio);
+	fprintf(output, " of all LL-cache hits   ");
 }
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
@@ -762,10 +773,10 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
+	fprintf(output, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
 	if (evsel->cgrp)
-		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
 
 	if (csv_output)
 		return;
@@ -776,14 +787,14 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " #   %5.2f  insns per cycle        ", ratio);
+		fprintf(output, " #   %5.2f  insns per cycle        ", ratio);
 
 		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
 		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
 
 		if (total && avg) {
 			ratio = total / avg;
-			fprintf(stderr, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
+			fprintf(output, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
 		}
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
@@ -831,7 +842,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
+		fprintf(output, " # %8.3f %% of all cache refs    ", ratio);
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_FRONTEND)) {
 		print_stalled_cycles_frontend(cpu, evsel, avg);
@@ -843,16 +854,16 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = 1.0 * avg / total;
 
-		fprintf(stderr, " # %8.3f GHz                    ", ratio);
+		fprintf(output, " # %8.3f GHz                    ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
 			ratio = 1000.0 * avg / total;
 
-		fprintf(stderr, " # %8.3f M/sec                  ", ratio);
+		fprintf(output, " # %8.3f M/sec                  ", ratio);
 	} else {
-		fprintf(stderr, "                                   ");
+		fprintf(output, "                                   ");
 	}
 }
 
@@ -867,7 +878,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	int scaled = counter->counts->scaled;
 
 	if (scaled == -1) {
-		fprintf(stderr, "%*s%s%*s",
+		fprintf(output, "%*s%s%*s",
 			csv_output ? 0 : 18,
 			counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 			csv_sep,
@@ -875,9 +886,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
 			event_name(counter));
 
 		if (counter->cgrp)
-			fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+			fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
 
-		fputc('\n', stderr);
+		fputc('\n', output);
 		return;
 	}
 
@@ -889,7 +900,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	print_noise(counter, avg);
 
 	if (csv_output) {
-		fputc('\n', stderr);
+		fputc('\n', output);
 		return;
 	}
 
@@ -899,9 +910,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(stderr, " [%5.2f%%]", 100 * avg_running / avg_enabled);
+		fprintf(output, " [%5.2f%%]", 100 * avg_running / avg_enabled);
 	}
-	fprintf(stderr, "\n");
+	fprintf(output, "\n");
 }
 
 /*
@@ -918,7 +929,7 @@ static void print_counter(struct perf_evsel *counter)
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%*d%s%*s%s%*s",
+			fprintf(output, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
@@ -928,9 +939,10 @@ static void print_counter(struct perf_evsel *counter)
 				event_name(counter));
 
 			if (counter->cgrp)
-				fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+				fprintf(output, "%s%s",
+					csv_sep, counter->cgrp->name);
 
-			fputc('\n', stderr);
+			fputc('\n', output);
 			continue;
 		}
 
@@ -943,9 +955,10 @@ static void print_counter(struct perf_evsel *counter)
 			print_noise(counter, 1.0);
 
 			if (run != ena)
-				fprintf(stderr, "  (%.2f%%)", 100.0 * run / ena);
+				fprintf(output, "  (%.2f%%)",
+					100.0 * run / ena);
 		}
-		fputc('\n', stderr);
+		fputc('\n', output);
 	}
 }
 
@@ -957,21 +970,21 @@ static void print_stat(int argc, const char **argv)
 	fflush(stdout);
 
 	if (!csv_output) {
-		fprintf(stderr, "\n");
-		fprintf(stderr, " Performance counter stats for ");
+		fprintf(output, "\n");
+		fprintf(output, " Performance counter stats for ");
 		if(target_pid == -1 && target_tid == -1) {
-			fprintf(stderr, "\'%s", argv[0]);
+			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
-				fprintf(stderr, " %s", argv[i]);
+				fprintf(output, " %s", argv[i]);
 		} else if (target_pid != -1)
-			fprintf(stderr, "process id \'%d", target_pid);
+			fprintf(output, "process id \'%d", target_pid);
 		else
-			fprintf(stderr, "thread id \'%d", target_tid);
+			fprintf(output, "thread id \'%d", target_tid);
 
-		fprintf(stderr, "\'");
+		fprintf(output, "\'");
 		if (run_count > 1)
-			fprintf(stderr, " (%d runs)", run_count);
-		fprintf(stderr, ":\n\n");
+			fprintf(output, " (%d runs)", run_count);
+		fprintf(output, ":\n\n");
 	}
 
 	if (no_aggr) {
@@ -984,15 +997,15 @@ static void print_stat(int argc, const char **argv)
 
 	if (!csv_output) {
 		if (!null_run)
-			fprintf(stderr, "\n");
-		fprintf(stderr, " %17.9f seconds time elapsed",
+			fprintf(output, "\n");
+		fprintf(output, " %17.9f seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
-			fprintf(stderr, "                                        ");
+			fprintf(output, "                                        ");
 			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
 					avg_stats(&walltime_nsecs_stats));
 		}
-		fprintf(stderr, "\n\n");
+		fprintf(output, "\n\n");
 	}
 }
 
@@ -1030,6 +1043,8 @@ static int stat__set_big_num(const struct option *opt __used,
 	return 0;
 }
 
+static bool append_file;
+
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
@@ -1070,6 +1085,11 @@ static const struct option options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
+	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
+	OPT_INTEGER(0, "log-fd", &output_fd,
+		    "log output to fd, instead of stderr"),
 	OPT_END()
 };
 
@@ -1141,6 +1161,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
+	const char *mode;
 
 	setlocale(LC_ALL, "");
 
@@ -1151,16 +1172,46 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 
-	if (csv_sep)
+	output = stderr;
+	if (output_name && strcmp(output_name, "-"))
+		output = NULL;
+
+	if (output_name && output_fd) {
+		fprintf(stderr, "cannot use both --output and --log-fd\n");
+		usage_with_options(stat_usage, options);
+	}
+	if (!output) {
+		struct timespec tm;
+		mode = append_file ? "a" : "w";
+
+		output = fopen(output_name, mode);
+		if (!output) {
+			perror("failed to create output file");
+			exit(-1);
+		}
+		clock_gettime(CLOCK_REALTIME, &tm);
+		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
+	} else if (output_fd != 2) {
+		mode = append_file ? "a" : "w";
+		output = fdopen(output_fd, mode);
+		if (!output) {
+			perror("Failed opening logfd");
+			return -errno;
+		}
+	}
+
+	if (csv_sep) {
 		csv_output = true;
-	else
+		if (!strcmp(csv_sep, "\\t"))
+			csv_sep = "\t";
+	} else
 		csv_sep = DEFAULT_SEPARATOR;
 
 	/*
 	 * let the spreadsheet do the pretty-printing
 	 */
 	if (csv_output) {
-		/* User explicitely passed -B? */
+		/* User explicitly passed -B? */
 		if (big_num_opt == 1) {
 			fprintf(stderr, "-B option not supported with -x\n");
 			usage_with_options(stat_usage, options);
@@ -1226,7 +1277,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
-			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
+			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
+				run_idx + 1);
 
 		if (sync_run)
 			sync();
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d28013b..7a87171 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -5,6 +5,7 @@
  * any workload, CPU or specific PID.
  *
  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ *		 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
  *
  * Improvements and fixes by:
  *
@@ -36,6 +37,7 @@
 #include "util/parse-events.h"
 #include "util/cpumap.h"
 #include "util/xyarray.h"
+#include "util/sort.h"
 
 #include "util/debug.h"
 
@@ -65,12 +67,8 @@
 static struct perf_top top = {
 	.count_filter		= 5,
 	.delay_secs		= 2,
-	.display_weighted	= -1,
 	.target_pid		= -1,
 	.target_tid		= -1,
-	.active_symbols		= LIST_HEAD_INIT(top.active_symbols),
-	.active_symbols_lock	= PTHREAD_MUTEX_INITIALIZER,
-	.active_symbols_cond	= PTHREAD_COND_INITIALIZER,
 	.freq			= 1000, /* 1 KHz */
 };
 
@@ -78,6 +76,12 @@ static bool			system_wide			=  false;
 
 static bool			use_tui, use_stdio;
 
+static bool			sort_has_symbols;
+
+static bool			dont_use_callchains;
+static char			callchain_default_opt[]		= "fractal,0.5,callee";
+
+
 static int			default_interval		=      0;
 
 static bool			kptr_restrict_warned;
@@ -85,7 +89,6 @@ static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
-static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 
 static bool			dump_symtab                     =  false;
@@ -93,7 +96,6 @@ static bool			dump_symtab                     =  false;
 static struct winsize		winsize;
 
 static const char		*sym_filter			=   NULL;
-struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 
 /*
@@ -136,18 +138,18 @@ static void sig_winch_handler(int sig __used)
 	update_print_entries(&winsize);
 }
 
-static int parse_source(struct sym_entry *syme)
+static int parse_source(struct hist_entry *he)
 {
 	struct symbol *sym;
 	struct annotation *notes;
 	struct map *map;
 	int err = -1;
 
-	if (!syme)
+	if (!he || !he->ms.sym)
 		return -1;
 
-	sym = sym_entry__symbol(syme);
-	map = syme->map;
+	sym = he->ms.sym;
+	map = he->ms.map;
 
 	/*
 	 * We can't annotate with just /proc/kallsyms
@@ -175,53 +177,62 @@ static int parse_source(struct sym_entry *syme)
 		return err;
 	}
 
-	err = symbol__annotate(sym, syme->map, 0);
+	err = symbol__annotate(sym, map, 0);
 	if (err == 0) {
 out_assign:
-		top.sym_filter_entry = syme;
+		top.sym_filter_entry = he;
 	}
 
 	pthread_mutex_unlock(&notes->lock);
 	return err;
 }
 
-static void __zero_source_counters(struct sym_entry *syme)
+static void __zero_source_counters(struct hist_entry *he)
 {
-	struct symbol *sym = sym_entry__symbol(syme);
+	struct symbol *sym = he->ms.sym;
 	symbol__annotate_zero_histograms(sym);
 }
 
-static void record_precise_ip(struct sym_entry *syme, struct map *map,
-			      int counter, u64 ip)
+static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 {
 	struct annotation *notes;
 	struct symbol *sym;
 
-	if (syme != top.sym_filter_entry)
+	if (he == NULL || he->ms.sym == NULL ||
+	    (he != top.sym_filter_entry && use_browser != 1))
 		return;
 
-	sym = sym_entry__symbol(syme);
+	sym = he->ms.sym;
 	notes = symbol__annotation(sym);
 
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
-	ip = map->map_ip(map, ip);
-	symbol__inc_addr_samples(sym, map, counter, ip);
+	if (notes->src == NULL &&
+	    symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
+		pthread_mutex_unlock(&notes->lock);
+		pr_err("Not enough memory for annotating '%s' symbol!\n",
+		       sym->name);
+		sleep(1);
+		return;
+	}
+
+	ip = he->ms.map->map_ip(he->ms.map, ip);
+	symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static void show_details(struct sym_entry *syme)
+static void show_details(struct hist_entry *he)
 {
 	struct annotation *notes;
 	struct symbol *symbol;
 	int more;
 
-	if (!syme)
+	if (!he)
 		return;
 
-	symbol = sym_entry__symbol(syme);
+	symbol = he->ms.sym;
 	notes = symbol__annotation(symbol);
 
 	pthread_mutex_lock(&notes->lock);
@@ -232,7 +243,7 @@ static void show_details(struct sym_entry *syme)
 	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, syme->map, top.sym_evsel->idx,
+	more = symbol__annotate_printf(symbol, he->ms.map, top.sym_evsel->idx,
 				       0, sym_pcnt_filter, top.print_entries, 4);
 	if (top.zero)
 		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
@@ -246,21 +257,28 @@ out_unlock:
 
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-static void __list_insert_active_sym(struct sym_entry *syme)
+static struct hist_entry *
+	perf_session__add_hist_entry(struct perf_session *session,
+				     struct addr_location *al,
+				     struct perf_sample *sample,
+				     struct perf_evsel *evsel)
 {
-	list_add(&syme->node, &top.active_symbols);
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	if (he == NULL)
+		return NULL;
+
+	session->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	return he;
 }
 
-static void print_sym_table(struct perf_session *session)
+static void print_sym_table(void)
 {
 	char bf[160];
 	int printed = 0;
-	struct rb_node *nd;
-	struct sym_entry *syme;
-	struct rb_root tmp = RB_ROOT;
 	const int win_width = winsize.ws_col - 1;
-	int sym_width, dso_width, dso_short_width;
-	float sum_ksamples = perf_top__decay_samples(&top, &tmp);
 
 	puts(CONSOLE_CLEAR);
 
@@ -271,10 +289,12 @@ static void print_sym_table(struct perf_session *session)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (session->hists.stats.total_lost != 0) {
+	if (top.total_lost_warned != top.session->hists.stats.total_lost) {
+		top.total_lost_warned = top.session->hists.stats.total_lost;
 		color_fprintf(stdout, PERF_COLOR_RED, "WARNING:");
 		printf(" LOST %" PRIu64 " events, Check IO/CPU overload\n",
-		       session->hists.stats.total_lost);
+		       top.total_lost_warned);
+		++printed;
 	}
 
 	if (top.sym_filter_entry) {
@@ -282,58 +302,15 @@ static void print_sym_table(struct perf_session *session)
 		return;
 	}
 
-	perf_top__find_widths(&top, &tmp, &dso_width, &dso_short_width,
-			      &sym_width);
-
-	if (sym_width + dso_width > winsize.ws_col - 29) {
-		dso_width = dso_short_width;
-		if (sym_width + dso_width > winsize.ws_col - 29)
-			sym_width = winsize.ws_col - dso_width - 29;
-	}
+	hists__collapse_resort_threaded(&top.sym_evsel->hists);
+	hists__output_resort_threaded(&top.sym_evsel->hists);
+	hists__decay_entries_threaded(&top.sym_evsel->hists,
+				      top.hide_user_symbols,
+				      top.hide_kernel_symbols);
+	hists__output_recalc_col_len(&top.sym_evsel->hists, winsize.ws_row - 3);
 	putchar('\n');
-	if (top.evlist->nr_entries == 1)
-		printf("             samples  pcnt");
-	else
-		printf("   weight    samples  pcnt");
-
-	if (verbose)
-		printf("         RIP       ");
-	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
-	printf("   %s    _______ _____",
-	       top.evlist->nr_entries == 1 ? "      " : "______");
-	if (verbose)
-		printf(" ________________");
-	printf(" %-*.*s", sym_width, sym_width, graph_line);
-	printf(" %-*.*s", dso_width, dso_width, graph_line);
-	puts("\n");
-
-	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		struct symbol *sym;
-		double pcnt;
-
-		syme = rb_entry(nd, struct sym_entry, rb_node);
-		sym = sym_entry__symbol(syme);
-		if (++printed > top.print_entries ||
-		    (int)syme->snap_count < top.count_filter)
-			continue;
-
-		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
-					 sum_ksamples));
-
-		if (top.evlist->nr_entries == 1 || !top.display_weighted)
-			printf("%20.2f ", syme->weight);
-		else
-			printf("%9.1f %10ld ", syme->weight, syme->snap_count);
-
-		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
-		if (verbose)
-			printf(" %016" PRIx64, sym->start);
-		printf(" %-*.*s", sym_width, sym_width, sym->name);
-		printf(" %-*.*s\n", dso_width, dso_width,
-		       dso_width >= syme->map->dso->long_name_len ?
-					syme->map->dso->long_name :
-					syme->map->dso->short_name);
-	}
+	hists__fprintf(&top.sym_evsel->hists, NULL, false, false,
+		       winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -371,10 +348,11 @@ static void prompt_percent(int *target, const char *msg)
 		*target = tmp;
 }
 
-static void prompt_symbol(struct sym_entry **target, const char *msg)
+static void prompt_symbol(struct hist_entry **target, const char *msg)
 {
 	char *buf = malloc(0), *p;
-	struct sym_entry *syme = *target, *n, *found = NULL;
+	struct hist_entry *syme = *target, *n, *found = NULL;
+	struct rb_node *next;
 	size_t dummy = 0;
 
 	/* zero counters of active symbol */
@@ -391,17 +369,14 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	if (p)
 		*p = 0;
 
-	pthread_mutex_lock(&top.active_symbols_lock);
-	syme = list_entry(top.active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&top.active_symbols_lock);
-
-	list_for_each_entry_safe_from(syme, n, &top.active_symbols, node) {
-		struct symbol *sym = sym_entry__symbol(syme);
-
-		if (!strcmp(buf, sym->name)) {
-			found = syme;
+	next = rb_first(&top.sym_evsel->hists.entries);
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
+			found = n;
 			break;
 		}
+		next = rb_next(&n->rb_node);
 	}
 
 	if (!found) {
@@ -420,7 +395,7 @@ static void print_mapped_keys(void)
 	char *name = NULL;
 
 	if (top.sym_filter_entry) {
-		struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
+		struct symbol *sym = top.sym_filter_entry->ms.sym;
 		name = sym->name;
 	}
 
@@ -437,9 +412,6 @@ static void print_mapped_keys(void)
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
-	if (top.evlist->nr_entries > 1)
-		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", top.display_weighted ? 1 : 0);
-
 	fprintf(stdout,
 		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
 		top.hide_kernel_symbols ? "yes" : "no");
@@ -466,7 +438,6 @@ static int key_mapped(int c)
 		case 'S':
 			return 1;
 		case 'E':
-		case 'w':
 			return top.evlist->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
@@ -475,7 +446,7 @@ static int key_mapped(int c)
 	return 0;
 }
 
-static void handle_keypress(struct perf_session *session, int c)
+static void handle_keypress(int c)
 {
 	if (!key_mapped(c)) {
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
@@ -551,7 +522,7 @@ static void handle_keypress(struct perf_session *session, int c)
 		case 'Q':
 			printf("exiting.\n");
 			if (dump_symtab)
-				perf_session__fprintf_dsos(session, stderr);
+				perf_session__fprintf_dsos(top.session, stderr);
 			exit(0);
 		case 's':
 			prompt_symbol(&top.sym_filter_entry, "Enter details symbol");
@@ -560,7 +531,7 @@ static void handle_keypress(struct perf_session *session, int c)
 			if (!top.sym_filter_entry)
 				break;
 			else {
-				struct sym_entry *syme = top.sym_filter_entry;
+				struct hist_entry *syme = top.sym_filter_entry;
 
 				top.sym_filter_entry = NULL;
 				__zero_source_counters(syme);
@@ -569,9 +540,6 @@ static void handle_keypress(struct perf_session *session, int c)
 		case 'U':
 			top.hide_user_symbols = !top.hide_user_symbols;
 			break;
-		case 'w':
-			top.display_weighted = ~top.display_weighted;
-			break;
 		case 'z':
 			top.zero = !top.zero;
 			break;
@@ -580,19 +548,31 @@ static void handle_keypress(struct perf_session *session, int c)
 	}
 }
 
+static void perf_top__sort_new_samples(void *arg)
+{
+	struct perf_top *t = arg;
+	perf_top__reset_sample_counters(t);
+
+	if (t->evlist->selected != NULL)
+		t->sym_evsel = t->evlist->selected;
+
+	hists__collapse_resort_threaded(&t->sym_evsel->hists);
+	hists__output_resort_threaded(&t->sym_evsel->hists);
+	hists__decay_entries_threaded(&t->sym_evsel->hists,
+				      top.hide_user_symbols,
+				      top.hide_kernel_symbols);
+	hists__output_recalc_col_len(&t->sym_evsel->hists, winsize.ws_row - 3);
+}
+
 static void *display_thread_tui(void *arg __used)
 {
-	int err = 0;
-	pthread_mutex_lock(&top.active_symbols_lock);
-	while (list_empty(&top.active_symbols)) {
-		err = pthread_cond_wait(&top.active_symbols_cond,
-					&top.active_symbols_lock);
-		if (err)
-			break;
-	}
-	pthread_mutex_unlock(&top.active_symbols_lock);
-	if (!err)
-		perf_top__tui_browser(&top);
+	const char *help = "For a higher level overview, try: perf top --sort comm,dso";
+
+	perf_top__sort_new_samples(&top);
+	perf_evlist__tui_browse_hists(top.evlist, help,
+				      perf_top__sort_new_samples,
+				      &top, top.delay_secs);
+
 	exit_browser(0);
 	exit(0);
 	return NULL;
@@ -603,7 +583,6 @@ static void *display_thread(void *arg __used)
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 	struct termios tc, save;
 	int delay_msecs, c;
-	struct perf_session *session = (struct perf_session *) arg;
 
 	tcgetattr(0, &save);
 	tc = save;
@@ -611,20 +590,35 @@ static void *display_thread(void *arg __used)
 	tc.c_cc[VMIN] = 0;
 	tc.c_cc[VTIME] = 0;
 
+	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top.delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);
 	/* trash return*/
 	getc(stdin);
 
-	do {
-		print_sym_table(session);
-	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
-
+	while (1) {
+		print_sym_table();
+		/*
+		 * Either timeout expired or we got an EINTR due to SIGWINCH,
+		 * refresh screen in both cases.
+		 */
+		switch (poll(&stdin_poll, 1, delay_msecs)) {
+		case 0:
+			continue;
+		case -1:
+			if (errno == EINTR)
+				continue;
+			/* Fall trhu */
+		default:
+			goto process_hotkey;
+		}
+	}
+process_hotkey:
 	c = getc(stdin);
 	tcsetattr(0, TCSAFLUSH, &save);
 
-	handle_keypress(session, c);
+	handle_keypress(c);
 	goto repeat;
 
 	return NULL;
@@ -645,9 +639,8 @@ static const char *skip_symbols[] = {
 	NULL
 };
 
-static int symbol_filter(struct map *map, struct symbol *sym)
+static int symbol_filter(struct map *map __used, struct symbol *sym)
 {
-	struct sym_entry *syme;
 	const char *name = sym->name;
 	int i;
 
@@ -667,16 +660,6 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	    strstr(name, "_text_end"))
 		return 1;
 
-	syme = symbol__priv(sym);
-	syme->map = map;
-	symbol__annotate_init(map, sym);
-
-	if (!top.sym_filter_entry && sym_filter && !strcmp(name, sym_filter)) {
-		/* schedule initial sym_filter_entry setup */
-		sym_filter_entry_sched = syme;
-		sym_filter = NULL;
-	}
-
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
 			sym->ignore = true;
@@ -691,10 +674,11 @@ static void perf_event__process_sample(const union perf_event *event,
 				       struct perf_sample *sample,
 				       struct perf_session *session)
 {
+	struct symbol *parent = NULL;
 	u64 ip = event->ip.ip;
-	struct sym_entry *syme;
 	struct addr_location al;
 	struct machine *machine;
+	int err;
 	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	++top.samples;
@@ -783,46 +767,41 @@ static void perf_event__process_sample(const union perf_event *event,
 				sleep(5);
 			vmlinux_warned = true;
 		}
-
-		return;
-	}
-
-	/* let's see, whether we need to install initial sym_filter_entry */
-	if (sym_filter_entry_sched) {
-		top.sym_filter_entry = sym_filter_entry_sched;
-		sym_filter_entry_sched = NULL;
-		if (parse_source(top.sym_filter_entry) < 0) {
-			struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
-
-			pr_err("Can't annotate %s", sym->name);
-			if (top.sym_filter_entry->map->dso->symtab_type == SYMTAB__KALLSYMS) {
-				pr_err(": No vmlinux file was found in the path:\n");
-				machine__fprintf_vmlinux_path(machine, stderr);
-			} else
-				pr_err(".\n");
-			exit(1);
-		}
 	}
 
-	syme = symbol__priv(al.sym);
-	if (!al.sym->ignore) {
+	if (al.sym == NULL || !al.sym->ignore) {
 		struct perf_evsel *evsel;
+		struct hist_entry *he;
 
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
-		syme->count[evsel->idx]++;
-		record_precise_ip(syme, al.map, evsel->idx, ip);
-		pthread_mutex_lock(&top.active_symbols_lock);
-		if (list_empty(&syme->node) || !syme->node.next) {
-			static bool first = true;
-			__list_insert_active_sym(syme);
-			if (first) {
-				pthread_cond_broadcast(&top.active_symbols_cond);
-				first = false;
-			}
+
+		if ((sort__has_parent || symbol_conf.use_callchain) &&
+		    sample->callchain) {
+			err = perf_session__resolve_callchain(session, al.thread,
+							      sample->callchain, &parent);
+			if (err)
+				return;
 		}
-		pthread_mutex_unlock(&top.active_symbols_lock);
+
+		he = perf_session__add_hist_entry(session, &al, sample, evsel);
+		if (he == NULL) {
+			pr_err("Problem incrementing symbol period, skipping event\n");
+			return;
+		}
+
+		if (symbol_conf.use_callchain) {
+			err = callchain_append(he->callchain, &session->callchain_cursor,
+					       sample->period);
+			if (err)
+				return;
+		}
+
+		if (sort_has_symbols)
+			record_precise_ip(he, evsel->idx, ip);
 	}
+
+	return;
 }
 
 static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
@@ -873,7 +852,11 @@ static void start_counters(struct perf_evlist *evlist)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
+		if (symbol_conf.use_callchain)
+			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
+
 		attr->mmap = 1;
+		attr->comm = 1;
 		attr->inherit = inherit;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
@@ -928,35 +911,56 @@ out_err:
 	exit(0);
 }
 
+static int setup_sample_type(void)
+{
+	if (!sort_has_symbols) {
+		if (symbol_conf.use_callchain) {
+			ui__warning("Selected -g but \"sym\" not present in --sort/-s.");
+			return -EINVAL;
+		}
+	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
+		if (callchain_register_param(&callchain_param) < 0) {
+			ui__warning("Can't register callchain params.\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int __cmd_top(void)
 {
 	pthread_t thread;
-	int ret __used;
+	int ret;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
-	if (session == NULL)
+	top.session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+	if (top.session == NULL)
 		return -ENOMEM;
 
+	ret = setup_sample_type();
+	if (ret)
+		goto out_delete;
+
 	if (top.target_tid != -1)
 		perf_event__synthesize_thread_map(top.evlist->threads,
-						  perf_event__process, session);
+						  perf_event__process, top.session);
 	else
-		perf_event__synthesize_threads(perf_event__process, session);
+		perf_event__synthesize_threads(perf_event__process, top.session);
 
 	start_counters(top.evlist);
-	session->evlist = top.evlist;
-	perf_session__update_sample_type(session);
+	top.session->evlist = top.evlist;
+	perf_session__update_sample_type(top.session);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 
-	perf_session__mmap_read(session);
+	perf_session__mmap_read(top.session);
 
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
-							     display_thread), session)) {
+							     display_thread), NULL)) {
 		printf("Could not create display thread.\n");
 		exit(-1);
 	}
@@ -974,12 +978,96 @@ static int __cmd_top(void)
 	while (1) {
 		u64 hits = top.samples;
 
-		perf_session__mmap_read(session);
+		perf_session__mmap_read(top.session);
 
 		if (hits == top.samples)
 			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 	}
 
+out_delete:
+	perf_session__delete(top.session);
+	top.session = NULL;
+
+	return 0;
+}
+
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset)
+{
+	char *tok, *tok2;
+	char *endptr;
+
+	/*
+	 * --no-call-graph
+	 */
+	if (unset) {
+		dont_use_callchains = true;
+		return 0;
+	}
+
+	symbol_conf.use_callchain = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+
+		return 0;
+	}
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtod(tok2, &endptr);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strcmp(tok2, "caller"))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strcmp(tok2, "callee"))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		fprintf(stderr, "Can't register callchain params\n");
+		return -1;
+	}
 	return 0;
 }
 
@@ -1019,7 +1107,7 @@ static const struct option options[] = {
 			    "put the counters into a counter group"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
+	OPT_STRING(0, "sym-annotate", &sym_filter, "symbol name",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &top.zero,
 		    "zero history across updates"),
@@ -1033,6 +1121,28 @@ static const struct option options[] = {
 	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
+	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
+		    "Show a column with the number of samples"),
+	OPT_CALLBACK_DEFAULT('G', "call-graph", NULL, "output_type,min_percent, call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none), min percent threshold and callchain order. "
+		     "Default: fractal,0.5,callee", &parse_callchain_opt,
+		     callchain_default_opt),
+	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
+		    "Show a column with the sum of periods"),
+	OPT_STRING(0, "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_STRING(0, "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
+	OPT_STRING(0, "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
+	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
+		    "Interleave source code with assembly code (default)"),
+	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
+		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
+		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
 };
 
@@ -1045,18 +1155,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
+	symbol_conf.exclude_other = false;
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	/*
- 	 * XXX For now start disabled, only using TUI if explicitely asked for.
- 	 * Change that when handle_keys equivalent gets written, live annotation
- 	 * done, etc.
- 	 */
-	use_browser = 0;
+	if (sort_order == default_sort_order)
+		sort_order = "dso,symbol";
+
+	setup_sorting(top_usage, options);
 
 	if (use_stdio)
 		use_browser = 0;
@@ -1119,13 +1227,22 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
-	symbol_conf.priv_size = (sizeof(struct sym_entry) + sizeof(struct annotation) +
-				 (top.evlist->nr_entries + 1) * sizeof(unsigned long));
+	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
 		return -1;
 
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+
+	/*
+	 * Avoid annotation data structures overhead when symbols aren't on the
+	 * sort list.
+	 */
+	sort_has_symbols = sort_sym.list.next != NULL;
+
 	get_term_dimensions(&winsize);
 	if (top.print_entries == 0) {
 		update_print_entries(&winsize);
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 4702e24..b382bd5 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -4,7 +4,6 @@
 #include "util/util.h"
 #include "util/strbuf.h"
 
-extern const char perf_version_string[];
 extern const char perf_usage_string[];
 extern const char perf_more_info_string[];
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ec635b7..73d0cac 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -427,6 +427,24 @@ static void get_debugfs_mntpt(void)
 		debugfs_mntpt[0] = '\0';
 }
 
+static void pthread__block_sigwinch(void)
+{
+	sigset_t set;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGWINCH);
+	pthread_sigmask(SIG_BLOCK, &set, NULL);
+}
+
+void pthread__unblock_sigwinch(void)
+{
+	sigset_t set;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGWINCH);
+	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
+}
+
 int main(int argc, const char **argv)
 {
 	const char *cmd;
@@ -480,6 +498,12 @@ int main(int argc, const char **argv)
 	 * time.
 	 */
 	setup_path();
+	/*
+	 * Block SIGWINCH notifications so that the thread that wants it can
+	 * unblock and get syscalls like select interrupted instead of waiting
+	 * forever while the signal goes to some other non interested thread.
+	 */
+	pthread__block_sigwinch();
 
 	while (1) {
 		static int done_help;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a5fc660..914c895 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -9,18 +9,21 @@ void get_term_dimensions(struct winsize *ws);
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
 #endif
 
 #if defined(__x86_64__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __powerpc__
 #include "../../arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
@@ -37,30 +40,35 @@ void get_term_dimensions(struct winsize *ws);
 # define rmb()		asm volatile("" ::: "memory")
 #endif
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu type"
 #endif
 
 #ifdef __hppa__
 #include "../../arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
 #include "../../arch/sparc/include/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
 #include "../../arch/alpha/include/asm/unistd.h"
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
 #include "../../arch/ia64/include/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __arm__
@@ -71,6 +79,7 @@ void get_term_dimensions(struct winsize *ws);
  */
 #define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
+#define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __mips__
@@ -83,6 +92,7 @@ void get_term_dimensions(struct winsize *ws);
 				: /* no input */			\
 				: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
 #endif
 
 #include <time.h>
@@ -171,5 +181,8 @@ struct ip_callchain {
 };
 
 extern bool perf_host, perf_guest;
+extern const char perf_version_string[];
+
+void pthread__unblock_sigwinch(void);
 
 #endif
diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-record b/tools/perf/scripts/python/bin/net_dropmonitor-record
new file mode 100755
index 0000000..423fb81
--- /dev/null
+++ b/tools/perf/scripts/python/bin/net_dropmonitor-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -e skb:kfree_skb $@
diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-report b/tools/perf/scripts/python/bin/net_dropmonitor-report
new file mode 100755
index 0000000..8d698f5
--- /dev/null
+++ b/tools/perf/scripts/python/bin/net_dropmonitor-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: display a table of dropped frames
+
+perf script -s "$PERF_EXEC_PATH"/scripts/python/net_dropmonitor.py $@
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
new file mode 100755
index 0000000..a4ffc95
--- /dev/null
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -0,0 +1,72 @@
+# Monitor the system for dropped packets and proudce a report of drop locations and counts
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+		'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+from Util import *
+
+drop_log = {}
+kallsyms = []
+
+def get_kallsyms_table():
+	global kallsyms
+	try:
+		f = open("/proc/kallsyms", "r")
+		linecount = 0
+		for line in f:
+			linecount = linecount+1
+		f.seek(0)
+	except:
+		return
+
+
+	j = 0
+	for line in f:
+		loc = int(line.split()[0], 16)
+		name = line.split()[2]
+		j = j +1
+		if ((j % 100) == 0):
+			print "\r" + str(j) + "/" + str(linecount),
+		kallsyms.append({ 'loc': loc, 'name' : name})
+
+	print "\r" + str(j) + "/" + str(linecount)
+	kallsyms.sort()
+	return
+
+def get_sym(sloc):
+	loc = int(sloc)
+	for i in kallsyms:
+		if (i['loc'] >= loc):
+			return (i['name'], i['loc']-loc)
+	return (None, 0)
+
+def print_drop_table():
+	print "%25s %25s %25s" % ("LOCATION", "OFFSET", "COUNT")
+	for i in drop_log.keys():
+		(sym, off) = get_sym(i)
+		if sym == None:
+			sym = i
+		print "%25s %25s %25s" % (sym, off, drop_log[i])
+
+
+def trace_begin():
+	print "Starting trace (Ctrl-C to dump results)"
+
+def trace_end():
+	print "Gathering kallsyms data"
+	get_kallsyms_table()
+	print_drop_table()
+
+# called from perf, when it finds a correspoinding event
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+			skbaddr, protocol, location):
+	slocation = str(location)
+	try:
+		drop_log[slocation] = drop_log[slocation] + 1
+	except:
+		drop_log[slocation] = 1
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e01af2b..bc8f477 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -16,6 +16,8 @@
 #include "annotate.h"
 #include <pthread.h>
 
+const char 	*disassembler_style;
+
 int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -323,10 +325,15 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016" PRIx64
-		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 "objdump %s%s --start-address=0x%016" PRIx64
+		 " --stop-address=0x%016" PRIx64
+		 " -d %s %s -C %s|grep -v %s|expand",
+		 disassembler_style ? "-M " : "",
+		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
+		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
+		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
 
 	pr_debug("Executing: %s\n", command);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c2c2868..d907252 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -91,13 +91,18 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used,
-				       int evidx __used, int refresh __used)
+				       int evidx __used,
+				       void(*timer)(void *arg) __used,
+				       void *arg __used, int delay_secs __used)
 {
 	return 0;
 }
 #else
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int refresh);
+			 int nr_events, void(*timer)(void *arg), void *arg,
+			 int delay_secs);
 #endif
 
+extern const char	*disassembler_style;
+
 #endif	/* __PERF_ANNOTATE_H */
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index e191eb9..521c38a 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -200,7 +200,7 @@ static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
 	 * Auto-detect:
 	 */
 	if (perf_use_color_default < 0) {
-		if (isatty(1) || pager_in_use())
+		if (isatty(fileno(fp)) || pager_in_use())
 			perf_use_color_default = 1;
 		else
 			perf_use_color_default = 0;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 72e9f48..2f6bc89 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -533,3 +533,9 @@ bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 	return first->attr.sample_id_all;
 }
+
+void perf_evlist__set_selected(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel)
+{
+	evlist->selected = evsel;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f349150..6be71fc 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -25,6 +25,7 @@ struct perf_evlist {
 	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
+	struct perf_evsel *selected;
 };
 
 struct perf_evsel;
@@ -56,6 +57,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist);
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
+void perf_evlist__set_selected(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel);
+
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
 					 struct thread_map *threads)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e389815..b46f6e4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -39,6 +39,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
 	INIT_LIST_HEAD(&evsel->node);
+	hists__init(&evsel->hists);
 }
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..76c0b2c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
+#include <sys/utsname.h>
 
 #include "evlist.h"
 #include "evsel.h"
@@ -17,12 +18,19 @@
 #include "session.h"
 #include "symbol.h"
 #include "debug.h"
+#include "cpumap.h"
 
 static bool no_buildid_cache = false;
 
 static int event_count;
 static struct perf_trace_event_type *events;
 
+static u32 header_argc;
+static const char **header_argv;
+
+static int dsos__write_buildid_table(struct perf_header *header, int fd);
+static int perf_session__cache_build_ids(struct perf_session *session);
+
 int perf_header__push_event(u64 id, const char *name)
 {
 	if (strlen(name) > MAX_EVENT_NAME)
@@ -110,6 +118,1020 @@ static int write_padded(int fd, const void *bf, size_t count,
 	return err;
 }
 
+static int do_write_string(int fd, const char *str)
+{
+	u32 len, olen;
+	int ret;
+
+	olen = strlen(str) + 1;
+	len = ALIGN(olen, NAME_ALIGN);
+
+	/* write len, incl. \0 */
+	ret = do_write(fd, &len, sizeof(len));
+	if (ret < 0)
+		return ret;
+
+	return write_padded(fd, str, olen, len);
+}
+
+static char *do_read_string(int fd, struct perf_header *ph)
+{
+	ssize_t sz, ret;
+	u32 len;
+	char *buf;
+
+	sz = read(fd, &len, sizeof(len));
+	if (sz < (ssize_t)sizeof(len))
+		return NULL;
+
+	if (ph->needs_swap)
+		len = bswap_32(len);
+
+	buf = malloc(len);
+	if (!buf)
+		return NULL;
+
+	ret = read(fd, buf, len);
+	if (ret == (ssize_t)len) {
+		/*
+		 * strings are padded by zeroes
+		 * thus the actual strlen of buf
+		 * may be less than len
+		 */
+		return buf;
+	}
+
+	free(buf);
+	return NULL;
+}
+
+int
+perf_header__set_cmdline(int argc, const char **argv)
+{
+	int i;
+
+	header_argc = (u32)argc;
+
+	/* do not include NULL termination */
+	header_argv = calloc(argc, sizeof(char *));
+	if (!header_argv)
+		return -ENOMEM;
+
+	/*
+	 * must copy argv contents because it gets moved
+	 * around during option parsing
+	 */
+	for (i = 0; i < argc ; i++)
+		header_argv[i] = argv[i];
+
+	return 0;
+}
+
+static int write_trace_info(int fd, struct perf_header *h __used,
+			    struct perf_evlist *evlist)
+{
+	return read_tracing_data(fd, &evlist->entries);
+}
+
+
+static int write_build_id(int fd, struct perf_header *h,
+			  struct perf_evlist *evlist __used)
+{
+	struct perf_session *session;
+	int err;
+
+	session = container_of(h, struct perf_session, header);
+
+	err = dsos__write_buildid_table(h, fd);
+	if (err < 0) {
+		pr_debug("failed to write buildid table\n");
+		return err;
+	}
+	if (!no_buildid_cache)
+		perf_session__cache_build_ids(session);
+
+	return 0;
+}
+
+static int write_hostname(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.nodename);
+}
+
+static int write_osrelease(int fd, struct perf_header *h __used,
+			   struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.release);
+}
+
+static int write_arch(int fd, struct perf_header *h __used,
+		      struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.machine);
+}
+
+static int write_version(int fd, struct perf_header *h __used,
+			 struct perf_evlist *evlist __used)
+{
+	return do_write_string(fd, perf_version_string);
+}
+
+static int write_cpudesc(int fd, struct perf_header *h __used,
+		       struct perf_evlist *evlist __used)
+{
+#ifndef CPUINFO_PROC
+#define CPUINFO_PROC NULL
+#endif
+	FILE *file;
+	char *buf = NULL;
+	char *s, *p;
+	const char *search = CPUINFO_PROC;
+	size_t len = 0;
+	int ret = -1;
+
+	if (!search)
+		return -1;
+
+	file = fopen("/proc/cpuinfo", "r");
+	if (!file)
+		return -1;
+
+	while (getline(&buf, &len, file) > 0) {
+		ret = strncmp(buf, search, strlen(search));
+		if (!ret)
+			break;
+	}
+
+	if (ret)
+		goto done;
+
+	s = buf;
+
+	p = strchr(buf, ':');
+	if (p && *(p+1) == ' ' && *(p+2))
+		s = p + 2;
+	p = strchr(s, '\n');
+	if (p)
+		*p = '\0';
+
+	/* squash extra space characters (branding string) */
+	p = s;
+	while (*p) {
+		if (isspace(*p)) {
+			char *r = p + 1;
+			char *q = r;
+			*p = ' ';
+			while (*q && isspace(*q))
+				q++;
+			if (q != (p+1))
+				while ((*r++ = *q++));
+		}
+		p++;
+	}
+	ret = do_write_string(fd, s);
+done:
+	free(buf);
+	fclose(file);
+	return ret;
+}
+
+static int write_nrcpus(int fd, struct perf_header *h __used,
+			struct perf_evlist *evlist __used)
+{
+	long nr;
+	u32 nrc, nra;
+	int ret;
+
+	nr = sysconf(_SC_NPROCESSORS_CONF);
+	if (nr < 0)
+		return -1;
+
+	nrc = (u32)(nr & UINT_MAX);
+
+	nr = sysconf(_SC_NPROCESSORS_ONLN);
+	if (nr < 0)
+		return -1;
+
+	nra = (u32)(nr & UINT_MAX);
+
+	ret = do_write(fd, &nrc, sizeof(nrc));
+	if (ret < 0)
+		return ret;
+
+	return do_write(fd, &nra, sizeof(nra));
+}
+
+static int write_event_desc(int fd, struct perf_header *h __used,
+			    struct perf_evlist *evlist)
+{
+	struct perf_evsel *attr;
+	u32 nre = 0, nri, sz;
+	int ret;
+
+	list_for_each_entry(attr, &evlist->entries, node)
+		nre++;
+
+	/*
+	 * write number of events
+	 */
+	ret = do_write(fd, &nre, sizeof(nre));
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * size of perf_event_attr struct
+	 */
+	sz = (u32)sizeof(attr->attr);
+	ret = do_write(fd, &sz, sizeof(sz));
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(attr, &evlist->entries, node) {
+
+		ret = do_write(fd, &attr->attr, sz);
+		if (ret < 0)
+			return ret;
+		/*
+		 * write number of unique id per event
+		 * there is one id per instance of an event
+		 *
+		 * copy into an nri to be independent of the
+		 * type of ids,
+		 */
+		nri = attr->ids;
+		ret = do_write(fd, &nri, sizeof(nri));
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * write event string as passed on cmdline
+		 */
+		ret = do_write_string(fd, attr->name);
+		if (ret < 0)
+			return ret;
+		/*
+		 * write unique ids for this event
+		 */
+		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int write_cmdline(int fd, struct perf_header *h __used,
+			 struct perf_evlist *evlist __used)
+{
+	char buf[MAXPATHLEN];
+	char proc[32];
+	u32 i, n;
+	int ret;
+
+	/*
+	 * actual atual path to perf binary
+	 */
+	sprintf(proc, "/proc/%d/exe", getpid());
+	ret = readlink(proc, buf, sizeof(buf));
+	if (ret <= 0)
+		return -1;
+
+	/* readlink() does not add null termination */
+	buf[ret] = '\0';
+
+	/* account for binary path */
+	n = header_argc + 1;
+
+	ret = do_write(fd, &n, sizeof(n));
+	if (ret < 0)
+		return ret;
+
+	ret = do_write_string(fd, buf);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0 ; i < header_argc; i++) {
+		ret = do_write_string(fd, header_argv[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+#define CORE_SIB_FMT \
+	"/sys/devices/system/cpu/cpu%d/topology/core_siblings_list"
+#define THRD_SIB_FMT \
+	"/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list"
+
+struct cpu_topo {
+	u32 core_sib;
+	u32 thread_sib;
+	char **core_siblings;
+	char **thread_siblings;
+};
+
+static int build_cpu_topo(struct cpu_topo *tp, int cpu)
+{
+	FILE *fp;
+	char filename[MAXPATHLEN];
+	char *buf = NULL, *p;
+	size_t len = 0;
+	u32 i = 0;
+	int ret = -1;
+
+	sprintf(filename, CORE_SIB_FMT, cpu);
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	fclose(fp);
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	for (i = 0; i < tp->core_sib; i++) {
+		if (!strcmp(buf, tp->core_siblings[i]))
+			break;
+	}
+	if (i == tp->core_sib) {
+		tp->core_siblings[i] = buf;
+		tp->core_sib++;
+		buf = NULL;
+		len = 0;
+	}
+
+	sprintf(filename, THRD_SIB_FMT, cpu);
+	fp = fopen(filename, "r");
+	if (!fp)
+		goto done;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	for (i = 0; i < tp->thread_sib; i++) {
+		if (!strcmp(buf, tp->thread_siblings[i]))
+			break;
+	}
+	if (i == tp->thread_sib) {
+		tp->thread_siblings[i] = buf;
+		tp->thread_sib++;
+		buf = NULL;
+	}
+	ret = 0;
+done:
+	if(fp)
+		fclose(fp);
+	free(buf);
+	return ret;
+}
+
+static void free_cpu_topo(struct cpu_topo *tp)
+{
+	u32 i;
+
+	if (!tp)
+		return;
+
+	for (i = 0 ; i < tp->core_sib; i++)
+		free(tp->core_siblings[i]);
+
+	for (i = 0 ; i < tp->thread_sib; i++)
+		free(tp->thread_siblings[i]);
+
+	free(tp);
+}
+
+static struct cpu_topo *build_cpu_topology(void)
+{
+	struct cpu_topo *tp;
+	void *addr;
+	u32 nr, i;
+	size_t sz;
+	long ncpus;
+	int ret = -1;
+
+	ncpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (ncpus < 0)
+		return NULL;
+
+	nr = (u32)(ncpus & UINT_MAX);
+
+	sz = nr * sizeof(char *);
+
+	addr = calloc(1, sizeof(*tp) + 2 * sz);
+	if (!addr)
+		return NULL;
+
+	tp = addr;
+
+	addr += sizeof(*tp);
+	tp->core_siblings = addr;
+	addr += sz;
+	tp->thread_siblings = addr;
+
+	for (i = 0; i < nr; i++) {
+		ret = build_cpu_topo(tp, i);
+		if (ret < 0)
+			break;
+	}
+	if (ret) {
+		free_cpu_topo(tp);
+		tp = NULL;
+	}
+	return tp;
+}
+
+static int write_cpu_topology(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	struct cpu_topo *tp;
+	u32 i;
+	int ret;
+
+	tp = build_cpu_topology();
+	if (!tp)
+		return -1;
+
+	ret = do_write(fd, &tp->core_sib, sizeof(tp->core_sib));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < tp->core_sib; i++) {
+		ret = do_write_string(fd, tp->core_siblings[i]);
+		if (ret < 0)
+			goto done;
+	}
+	ret = do_write(fd, &tp->thread_sib, sizeof(tp->thread_sib));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < tp->thread_sib; i++) {
+		ret = do_write_string(fd, tp->thread_siblings[i]);
+		if (ret < 0)
+			break;
+	}
+done:
+	free_cpu_topo(tp);
+	return ret;
+}
+
+
+
+static int write_total_mem(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	char *buf = NULL;
+	FILE *fp;
+	size_t len = 0;
+	int ret = -1, n;
+	uint64_t mem;
+
+	fp = fopen("/proc/meminfo", "r");
+	if (!fp)
+		return -1;
+
+	while (getline(&buf, &len, fp) > 0) {
+		ret = strncmp(buf, "MemTotal:", 9);
+		if (!ret)
+			break;
+	}
+	if (!ret) {
+		n = sscanf(buf, "%*s %"PRIu64, &mem);
+		if (n == 1)
+			ret = do_write(fd, &mem, sizeof(mem));
+	}
+	free(buf);
+	fclose(fp);
+	return ret;
+}
+
+static int write_topo_node(int fd, int node)
+{
+	char str[MAXPATHLEN];
+	char field[32];
+	char *buf = NULL, *p;
+	size_t len = 0;
+	FILE *fp;
+	u64 mem_total, mem_free, mem;
+	int ret = -1;
+
+	sprintf(str, "/sys/devices/system/node/node%d/meminfo", node);
+	fp = fopen(str, "r");
+	if (!fp)
+		return -1;
+
+	while (getline(&buf, &len, fp) > 0) {
+		/* skip over invalid lines */
+		if (!strchr(buf, ':'))
+			continue;
+		if (sscanf(buf, "%*s %*d %s %"PRIu64, field, &mem) != 2)
+			goto done;
+		if (!strcmp(field, "MemTotal:"))
+			mem_total = mem;
+		if (!strcmp(field, "MemFree:"))
+			mem_free = mem;
+	}
+
+	fclose(fp);
+
+	ret = do_write(fd, &mem_total, sizeof(u64));
+	if (ret)
+		goto done;
+
+	ret = do_write(fd, &mem_free, sizeof(u64));
+	if (ret)
+		goto done;
+
+	ret = -1;
+	sprintf(str, "/sys/devices/system/node/node%d/cpulist", node);
+
+	fp = fopen(str, "r");
+	if (!fp)
+		goto done;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	ret = do_write_string(fd, buf);
+done:
+	free(buf);
+	fclose(fp);
+	return ret;
+}
+
+static int write_numa_topology(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	char *buf = NULL;
+	size_t len = 0;
+	FILE *fp;
+	struct cpu_map *node_map = NULL;
+	char *c;
+	u32 nr, i, j;
+	int ret = -1;
+
+	fp = fopen("/sys/devices/system/node/online", "r");
+	if (!fp)
+		return -1;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	c = strchr(buf, '\n');
+	if (c)
+		*c = '\0';
+
+	node_map = cpu_map__new(buf);
+	if (!node_map)
+		goto done;
+
+	nr = (u32)node_map->nr;
+
+	ret = do_write(fd, &nr, sizeof(nr));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < nr; i++) {
+		j = (u32)node_map->map[i];
+		ret = do_write(fd, &j, sizeof(j));
+		if (ret < 0)
+			break;
+
+		ret = write_topo_node(fd, i);
+		if (ret < 0)
+			break;
+	}
+done:
+	free(buf);
+	fclose(fp);
+	free(node_map);
+	return ret;
+}
+
+/*
+ * default get_cpuid(): nothing gets recorded
+ * actual implementation must be in arch/$(ARCH)/util/header.c
+ */
+int __attribute__((weak)) get_cpuid(char *buffer __used, size_t sz __used)
+{
+	return -1;
+}
+
+static int write_cpuid(int fd, struct perf_header *h __used,
+		       struct perf_evlist *evlist __used)
+{
+	char buffer[64];
+	int ret;
+
+	ret = get_cpuid(buffer, sizeof(buffer));
+	if (!ret)
+		goto write_it;
+
+	return -1;
+write_it:
+	return do_write_string(fd, buffer);
+}
+
+static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# hostname : %s\n", str);
+	free(str);
+}
+
+static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# os release : %s\n", str);
+	free(str);
+}
+
+static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# arch : %s\n", str);
+	free(str);
+}
+
+static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# cpudesc : %s\n", str);
+	free(str);
+}
+
+static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# nrcpus online : %u\n", nr);
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# nrcpus avail : %u\n", nr);
+}
+
+static void print_version(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# perf version : %s\n", str);
+	free(str);
+}
+
+static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	char *str;
+	u32 nr, i;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# cmdline : ");
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "%s ", str);
+		free(str);
+	}
+	fputc('\n', fp);
+}
+
+static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr, i;
+	char *str;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# sibling cores   : %s\n", str);
+		free(str);
+	}
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# sibling threads : %s\n", str);
+		free(str);
+	}
+}
+
+static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+{
+	struct perf_event_attr attr;
+	uint64_t id;
+	void *buf = NULL;
+	char *str;
+	u32 nre, sz, nr, i, j, msz;
+	int ret;
+
+	/* number of events */
+	ret = read(fd, &nre, sizeof(nre));
+	if (ret != (ssize_t)sizeof(nre))
+		goto error;
+
+	if (ph->needs_swap)
+		nre = bswap_32(nre);
+
+	ret = read(fd, &sz, sizeof(sz));
+	if (ret != (ssize_t)sizeof(sz))
+		goto error;
+
+	if (ph->needs_swap)
+		sz = bswap_32(sz);
+
+	/*
+	 * ensure it is at least to our ABI rev
+	 */
+	if (sz < (u32)sizeof(attr))
+		goto error;
+
+	memset(&attr, 0, sizeof(attr));
+
+	/* read entire region to sync up to next field */
+	buf = malloc(sz);
+	if (!buf)
+		goto error;
+
+	msz = sizeof(attr);
+	if (sz < msz)
+		msz = sz;
+
+	for (i = 0 ; i < nre; i++) {
+
+		ret = read(fd, buf, sz);
+		if (ret != (ssize_t)sz)
+			goto error;
+
+		if (ph->needs_swap)
+			perf_event__attr_swap(buf);
+
+		memcpy(&attr, buf, msz);
+
+		ret = read(fd, &nr, sizeof(nr));
+		if (ret != (ssize_t)sizeof(nr))
+			goto error;
+
+		if (ph->needs_swap)
+			nr = bswap_32(nr);
+
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# event : name = %s, ", str);
+		free(str);
+
+		fprintf(fp, "type = %d, config = 0x%"PRIx64
+			    ", config1 = 0x%"PRIx64", config2 = 0x%"PRIx64,
+				attr.type,
+				(u64)attr.config,
+				(u64)attr.config1,
+				(u64)attr.config2);
+
+		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
+				attr.exclude_user,
+				attr.exclude_kernel);
+
+		if (nr)
+			fprintf(fp, ", id = {");
+
+		for (j = 0 ; j < nr; j++) {
+			ret = read(fd, &id, sizeof(id));
+			if (ret != (ssize_t)sizeof(id))
+				goto error;
+
+			if (ph->needs_swap)
+				id = bswap_64(id);
+
+			if (j)
+				fputc(',', fp);
+
+			fprintf(fp, " %"PRIu64, id);
+		}
+		if (nr && j == nr)
+			fprintf(fp, " }");
+		fputc('\n', fp);
+	}
+	free(buf);
+	return;
+error:
+	fprintf(fp, "# event desc: not available or unable to read\n");
+}
+
+static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
+{
+	uint64_t mem;
+	ssize_t ret;
+
+	ret = read(fd, &mem, sizeof(mem));
+	if (ret != sizeof(mem))
+		goto error;
+
+	if (h->needs_swap)
+		mem = bswap_64(mem);
+
+	fprintf(fp, "# total memory : %"PRIu64" kB\n", mem);
+	return;
+error:
+	fprintf(fp, "# total memory : unknown\n");
+}
+
+static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr, c, i;
+	char *str;
+	uint64_t mem_total, mem_free;
+
+	/* nr nodes */
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		goto error;
+
+	if (h->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+
+		/* node number */
+		ret = read(fd, &c, sizeof(c));
+		if (ret != (ssize_t)sizeof(c))
+			goto error;
+
+		if (h->needs_swap)
+			c = bswap_32(c);
+
+		ret = read(fd, &mem_total, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		ret = read(fd, &mem_free, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		if (h->needs_swap) {
+			mem_total = bswap_64(mem_total);
+			mem_free = bswap_64(mem_free);
+		}
+
+		fprintf(fp, "# node%u meminfo  : total = %"PRIu64" kB,"
+			    " free = %"PRIu64" kB\n",
+			c,
+			mem_total,
+			mem_free);
+
+		str = do_read_string(fd, h);
+		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+		free(str);
+	}
+	return;
+error:
+	fprintf(fp, "# numa topology : not available\n");
+}
+
+static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# cpuid : %s\n", str);
+	free(str);
+}
+
+struct feature_ops {
+	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
+	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	const char *name;
+	bool full_only;
+};
+
+#define FEAT_OPA(n, w, p) \
+	[n] = { .name = #n, .write = w, .print = p }
+#define FEAT_OPF(n, w, p) \
+	[n] = { .name = #n, .write = w, .print = p, .full_only = true }
+
+static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
+	FEAT_OPA(HEADER_TRACE_INFO, write_trace_info, NULL),
+	FEAT_OPA(HEADER_BUILD_ID, write_build_id, NULL),
+	FEAT_OPA(HEADER_HOSTNAME, write_hostname, print_hostname),
+	FEAT_OPA(HEADER_OSRELEASE, write_osrelease, print_osrelease),
+	FEAT_OPA(HEADER_VERSION, write_version, print_version),
+	FEAT_OPA(HEADER_ARCH, write_arch, print_arch),
+	FEAT_OPA(HEADER_NRCPUS, write_nrcpus, print_nrcpus),
+	FEAT_OPA(HEADER_CPUDESC, write_cpudesc, print_cpudesc),
+	FEAT_OPA(HEADER_CPUID, write_cpuid, print_cpuid),
+	FEAT_OPA(HEADER_TOTAL_MEM, write_total_mem, print_total_mem),
+	FEAT_OPA(HEADER_EVENT_DESC, write_event_desc, print_event_desc),
+	FEAT_OPA(HEADER_CMDLINE, write_cmdline, print_cmdline),
+	FEAT_OPF(HEADER_CPU_TOPOLOGY, write_cpu_topology, print_cpu_topology),
+	FEAT_OPF(HEADER_NUMA_TOPOLOGY, write_numa_topology, print_numa_topology),
+};
+
+struct header_print_data {
+	FILE *fp;
+	bool full; /* extended list of headers */
+};
+
+static int perf_file_section__fprintf_info(struct perf_file_section *section,
+					   struct perf_header *ph,
+					   int feat, int fd, void *data)
+{
+	struct header_print_data *hd = data;
+
+	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
+		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
+				"%d, continuing...\n", section->offset, feat);
+		return 0;
+	}
+	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
+		pr_warning("unknown feature %d\n", feat);
+		return -1;
+	}
+	if (!feat_ops[feat].print)
+		return 0;
+
+	if (!feat_ops[feat].full_only || hd->full)
+		feat_ops[feat].print(ph, fd, hd->fp);
+	else
+		fprintf(hd->fp, "# %s info available, use -I to display\n",
+			feat_ops[feat].name);
+
+	return 0;
+}
+
+int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
+{
+	struct header_print_data hd;
+	struct perf_header *header = &session->header;
+	int fd = session->fd;
+	hd.fp = fp;
+	hd.full = full;
+
+	perf_header__process_sections(header, fd, &hd,
+				      perf_file_section__fprintf_info);
+	return 0;
+}
+
 #define dsos__for_each_with_build_id(pos, head)	\
 	list_for_each_entry(pos, head, node)	\
 		if (!pos->has_build_id)		\
@@ -267,7 +1289,7 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 	if (access(linkname, F_OK))
 		goto out_free;
 
-	if (readlink(linkname, filename, size) < 0)
+	if (readlink(linkname, filename, size - 1) < 0)
 		goto out_free;
 
 	if (unlink(linkname))
@@ -356,15 +1378,41 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
+static int do_write_feat(int fd, struct perf_header *h, int type,
+			 struct perf_file_section **p,
+			 struct perf_evlist *evlist)
+{
+	int err;
+	int ret = 0;
+
+	if (perf_header__has_feat(h, type)) {
+
+		(*p)->offset = lseek(fd, 0, SEEK_CUR);
+
+		err = feat_ops[type].write(fd, h, evlist);
+		if (err < 0) {
+			pr_debug("failed to write feature %d\n", type);
+
+			/* undo anything written */
+			lseek(fd, (*p)->offset, SEEK_SET);
+
+			return -1;
+		}
+		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
+		(*p)++;
+	}
+	return ret;
+}
+
 static int perf_header__adds_write(struct perf_header *header,
 				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
 	struct perf_session *session;
-	struct perf_file_section *feat_sec;
+	struct perf_file_section *feat_sec, *p;
 	int sec_size;
 	u64 sec_start;
-	int idx = 0, err;
+	int err;
 
 	session = container_of(header, struct perf_session, header);
 
@@ -376,7 +1424,7 @@ static int perf_header__adds_write(struct perf_header *header,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
 	if (feat_sec == NULL)
 		return -ENOMEM;
 
@@ -385,36 +1433,69 @@ static int perf_header__adds_write(struct perf_header *header,
 	sec_start = header->data_offset + header->data_size;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
-	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
-		struct perf_file_section *trace_sec;
-
-		trace_sec = &feat_sec[idx++];
+	err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
+	if (err)
+		goto out_free;
 
-		/* Write trace info */
-		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, &evlist->entries);
-		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
+	err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
+	if (err) {
+		perf_header__clear_feat(header, HEADER_BUILD_ID);
+		goto out_free;
 	}
 
-	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
-		struct perf_file_section *buildid_sec;
+	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_HOSTNAME);
 
-		buildid_sec = &feat_sec[idx++];
+	err = do_write_feat(fd, header, HEADER_OSRELEASE, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_OSRELEASE);
 
-		/* Write build-ids */
-		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		err = dsos__write_buildid_table(header, fd);
-		if (err < 0) {
-			pr_debug("failed to write buildid table\n");
-			goto out_free;
-		}
-		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
-					  buildid_sec->offset;
-		if (!no_buildid_cache)
-			perf_session__cache_build_ids(session);
-	}
+	err = do_write_feat(fd, header, HEADER_VERSION, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_VERSION);
+
+	err = do_write_feat(fd, header, HEADER_ARCH, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_ARCH);
+
+	err = do_write_feat(fd, header, HEADER_NRCPUS, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_NRCPUS);
+
+	err = do_write_feat(fd, header, HEADER_CPUDESC, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPUDESC);
+
+	err = do_write_feat(fd, header, HEADER_CPUID, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPUID);
+
+	err = do_write_feat(fd, header, HEADER_TOTAL_MEM, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_TOTAL_MEM);
+
+	err = do_write_feat(fd, header, HEADER_CMDLINE, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CMDLINE);
+
+	err = do_write_feat(fd, header, HEADER_EVENT_DESC, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_EVENT_DESC);
+
+	err = do_write_feat(fd, header, HEADER_CPU_TOPOLOGY, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPU_TOPOLOGY);
+
+	err = do_write_feat(fd, header, HEADER_NUMA_TOPOLOGY, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_NUMA_TOPOLOGY);
 
 	lseek(fd, sec_start, SEEK_SET);
+	/*
+	 * may write more than needed due to dropped feature, but
+	 * this is okay, reader will skip the mising entries
+	 */
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
@@ -554,9 +1635,10 @@ static int perf_header__getbuffer64(struct perf_header *header,
 }
 
 int perf_header__process_sections(struct perf_header *header, int fd,
+				  void *data,
 				  int (*process)(struct perf_file_section *section,
-						 struct perf_header *ph,
-						 int feat, int fd))
+				  struct perf_header *ph,
+				  int feat, int fd, void *data))
 {
 	struct perf_file_section *feat_sec;
 	int nr_sections;
@@ -584,7 +1666,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 		if (perf_header__has_feat(header, feat)) {
 			struct perf_file_section *sec = &feat_sec[idx++];
 
-			err = process(sec, header, feat, fd);
+			err = process(sec, header, feat, fd, data);
 			if (err < 0)
 				break;
 		}
@@ -621,21 +1703,41 @@ int perf_file_header__read(struct perf_file_header *header,
 			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
 		else
 			return -1;
+	} else if (ph->needs_swap) {
+		unsigned int i;
+		/*
+		 * feature bitmap is declared as an array of unsigned longs --
+		 * not good since its size can differ between the host that
+		 * generated the data file and the host analyzing the file.
+		 *
+		 * We need to handle endianness, but we don't know the size of
+		 * the unsigned long where the file was generated. Take a best
+		 * guess at determining it: try 64-bit swap first (ie., file
+		 * created on a 64-bit host), and check if the hostname feature
+		 * bit is set (this feature bit is forced on as of fbe96f2).
+		 * If the bit is not, undo the 64-bit swap and try a 32-bit
+		 * swap. If the hostname bit is still not set (e.g., older data
+		 * file), punt and fallback to the original behavior --
+		 * clearing all feature bits and setting buildid.
+		 */
+		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
+			header->adds_features[i] = bswap_64(header->adds_features[i]);
+
+		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
+			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
+				header->adds_features[i] = bswap_64(header->adds_features[i]);
+				header->adds_features[i] = bswap_32(header->adds_features[i]);
+			}
+		}
+
+		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
+			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
+			set_bit(HEADER_BUILD_ID, header->adds_features);
+		}
 	}
 
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
-	/*
-	 * FIXME: hack that assumes that if we need swap the perf.data file
-	 * may be coming from an arch with a different word-size, ergo different
-	 * DEFINE_BITMAP format, investigate more later, but for now its mostly
-	 * safe to assume that we have a build-id section. Trace files probably
-	 * have several other issues in this realm anyway...
-	 */
-	if (ph->needs_swap) {
-		memset(&ph->adds_features, 0, sizeof(ph->adds_features));
-		perf_header__set_feat(ph, HEADER_BUILD_ID);
-	}
 
 	ph->event_offset = header->event_types.offset;
 	ph->event_size   = header->event_types.size;
@@ -796,7 +1898,7 @@ out:
 
 static int perf_file_section__process(struct perf_file_section *section,
 				      struct perf_header *ph,
-				      int feat, int fd)
+				      int feat, int fd, void *data __used)
 {
 	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
@@ -813,6 +1915,21 @@ static int perf_file_section__process(struct perf_file_section *section,
 		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
 			pr_debug("Failed to read buildids, continuing...\n");
 		break;
+
+	case HEADER_HOSTNAME:
+	case HEADER_OSRELEASE:
+	case HEADER_VERSION:
+	case HEADER_ARCH:
+	case HEADER_NRCPUS:
+	case HEADER_CPUDESC:
+	case HEADER_CPUID:
+	case HEADER_TOTAL_MEM:
+	case HEADER_CMDLINE:
+	case HEADER_EVENT_DESC:
+	case HEADER_CPU_TOPOLOGY:
+	case HEADER_NUMA_TOPOLOGY:
+		break;
+
 	default:
 		pr_debug("unknown feature %d, continuing...\n", feat);
 	}
@@ -935,7 +2052,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	perf_header__process_sections(header, fd, perf_file_section__process);
+	perf_header__process_sections(header, fd, NULL,
+				      perf_file_section__process);
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
@@ -1100,15 +2218,29 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 				   struct perf_session *session __unused)
 {
 	union perf_event ev;
+	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __used = 0;
 
+	/*
+	 * We are going to store the size of the data followed
+	 * by the data contents. Since the fd descriptor is a pipe,
+	 * we cannot seek back to store the size of the data once
+	 * we know it. Instead we:
+	 *
+	 * - write the tracing data to the temp file
+	 * - get/write the data size to pipe
+	 * - write the tracing data from the temp file
+	 *   to the pipe
+	 */
+	tdata = tracing_data_get(&evlist->entries, fd, true);
+	if (!tdata)
+		return -1;
+
 	memset(&ev, 0, sizeof(ev));
 
 	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
-	size = read_tracing_data_size(fd, &evlist->entries);
-	if (size <= 0)
-		return size;
+	size = tdata->size;
 	aligned_size = ALIGN(size, sizeof(u64));
 	padding = aligned_size - size;
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
@@ -1116,7 +2248,12 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 
 	process(&ev, NULL, session);
 
-	err = read_tracing_data(fd, &evlist->entries);
+	/*
+	 * The put function will copy all the tracing data
+	 * stored in temp file to the pipe.
+	 */
+	tracing_data_put(tdata);
+
 	write_padded(fd, NULL, 0, padding);
 
 	return aligned_size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 1886256..3d5a742 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -12,6 +12,20 @@
 enum {
 	HEADER_TRACE_INFO = 1,
 	HEADER_BUILD_ID,
+
+	HEADER_HOSTNAME,
+	HEADER_OSRELEASE,
+	HEADER_VERSION,
+	HEADER_ARCH,
+	HEADER_NRCPUS,
+	HEADER_CPUDESC,
+	HEADER_CPUID,
+	HEADER_TOTAL_MEM,
+	HEADER_CMDLINE,
+	HEADER_EVENT_DESC,
+	HEADER_CPU_TOPOLOGY,
+	HEADER_NUMA_TOPOLOGY,
+
 	HEADER_LAST_FEATURE,
 };
 
@@ -68,10 +82,15 @@ void perf_header__set_feat(struct perf_header *header, int feat);
 void perf_header__clear_feat(struct perf_header *header, int feat);
 bool perf_header__has_feat(const struct perf_header *header, int feat);
 
+int perf_header__set_cmdline(int argc, const char **argv);
+
 int perf_header__process_sections(struct perf_header *header, int fd,
+				  void *data,
 				  int (*process)(struct perf_file_section *section,
-						 struct perf_header *ph,
-						 int feat, int fd));
+				  struct perf_header *ph,
+				  int feat, int fd, void *data));
+
+int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
@@ -104,4 +123,10 @@ int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
 				    struct perf_session *session);
 int perf_event__process_build_id(union perf_event *event,
 				 struct perf_session *session);
+
+/*
+ * arch specific callback
+ */
+int get_cpuid(char *buffer, size_t sz);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 677e1da..f6a9939 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -6,6 +6,11 @@
 #include "sort.h"
 #include <math.h>
 
+static bool hists__filter_entry_by_dso(struct hists *hists,
+				       struct hist_entry *he);
+static bool hists__filter_entry_by_thread(struct hists *hists,
+					  struct hist_entry *he);
+
 enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
@@ -18,56 +23,56 @@ struct callchain_param	callchain_param = {
 	.order  = ORDER_CALLEE
 };
 
-u16 hists__col_len(struct hists *self, enum hist_column col)
+u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
-	return self->col_len[col];
+	return hists->col_len[col];
 }
 
-void hists__set_col_len(struct hists *self, enum hist_column col, u16 len)
+void hists__set_col_len(struct hists *hists, enum hist_column col, u16 len)
 {
-	self->col_len[col] = len;
+	hists->col_len[col] = len;
 }
 
-bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len)
+bool hists__new_col_len(struct hists *hists, enum hist_column col, u16 len)
 {
-	if (len > hists__col_len(self, col)) {
-		hists__set_col_len(self, col, len);
+	if (len > hists__col_len(hists, col)) {
+		hists__set_col_len(hists, col, len);
 		return true;
 	}
 	return false;
 }
 
-static void hists__reset_col_len(struct hists *self)
+static void hists__reset_col_len(struct hists *hists)
 {
 	enum hist_column col;
 
 	for (col = 0; col < HISTC_NR_COLS; ++col)
-		hists__set_col_len(self, col, 0);
+		hists__set_col_len(hists, col, 0);
 }
 
-static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
+static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 {
 	u16 len;
 
 	if (h->ms.sym)
-		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen);
+		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen);
 	else {
 		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
 
-		if (hists__col_len(self, HISTC_DSO) < unresolved_col_width &&
+		if (hists__col_len(hists, HISTC_DSO) < unresolved_col_width &&
 		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 		    !symbol_conf.dso_list)
-			hists__set_col_len(self, HISTC_DSO,
+			hists__set_col_len(hists, HISTC_DSO,
 					   unresolved_col_width);
 	}
 
 	len = thread__comm_len(h->thread);
-	if (hists__new_col_len(self, HISTC_COMM, len))
-		hists__set_col_len(self, HISTC_THREAD, len + 6);
+	if (hists__new_col_len(hists, HISTC_COMM, len))
+		hists__set_col_len(hists, HISTC_THREAD, len + 6);
 
 	if (h->ms.map) {
 		len = dso__name_len(h->ms.map->dso);
-		hists__new_col_len(self, HISTC_DSO, len);
+		hists__new_col_len(hists, HISTC_DSO, len);
 	}
 }
 
@@ -92,6 +97,67 @@ static void hist_entry__add_cpumode_period(struct hist_entry *self,
 	}
 }
 
+static void hist_entry__decay(struct hist_entry *he)
+{
+	he->period = (he->period * 7) / 8;
+	he->nr_events = (he->nr_events * 7) / 8;
+}
+
+static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
+{
+	u64 prev_period = he->period;
+
+	if (prev_period == 0)
+		return true;
+
+	hist_entry__decay(he);
+
+	if (!he->filtered)
+		hists->stats.total_period -= prev_period - he->period;
+
+	return he->period == 0;
+}
+
+static void __hists__decay_entries(struct hists *hists, bool zap_user,
+				   bool zap_kernel, bool threaded)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+		/*
+		 * We may be annotating this, for instance, so keep it here in
+		 * case some it gets new samples, we'll eventually free it when
+		 * the user stops browsing and it agains gets fully decayed.
+		 */
+		if (((zap_user && n->level == '.') ||
+		     (zap_kernel && n->level != '.') ||
+		     hists__decay_entry(hists, n)) &&
+		    !n->used) {
+			rb_erase(&n->rb_node, &hists->entries);
+
+			if (sort__need_collapse || threaded)
+				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
+
+			hist_entry__free(n);
+			--hists->nr_entries;
+		}
+	}
+}
+
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
+{
+	return __hists__decay_entries(hists, zap_user, zap_kernel, false);
+}
+
+void hists__decay_entries_threaded(struct hists *hists,
+				   bool zap_user, bool zap_kernel)
+{
+	return __hists__decay_entries(hists, zap_user, zap_kernel, true);
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
@@ -113,11 +179,12 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return self;
 }
 
-static void hists__inc_nr_entries(struct hists *self, struct hist_entry *h)
+static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
-		hists__calc_col_len(self, h);
-		++self->nr_entries;
+		hists__calc_col_len(hists, h);
+		++hists->nr_entries;
+		hists->stats.total_period += h->period;
 	}
 }
 
@@ -128,11 +195,11 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-struct hist_entry *__hists__add_entry(struct hists *self,
+struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
 {
-	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -150,9 +217,13 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 	};
 	int cmp;
 
+	pthread_mutex_lock(&hists->lock);
+
+	p = &hists->entries_in->rb_node;
+
 	while (*p != NULL) {
 		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
+		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
 		cmp = hist_entry__cmp(&entry, he);
 
@@ -170,12 +241,14 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 
 	he = hist_entry__new(&entry);
 	if (!he)
-		return NULL;
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &self->entries);
-	hists__inc_nr_entries(self, he);
+		goto out_unlock;
+
+	rb_link_node(&he->rb_node_in, parent, p);
+	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
+out_unlock:
+	pthread_mutex_unlock(&hists->lock);
 	return he;
 }
 
@@ -222,7 +295,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *self,
+static bool hists__collapse_insert_entry(struct hists *hists,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -233,15 +306,16 @@ static bool hists__collapse_insert_entry(struct hists *self,
 
 	while (*p != NULL) {
 		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
+		iter = rb_entry(parent, struct hist_entry, rb_node_in);
 
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
 			iter->period += he->period;
+			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&self->callchain_cursor);
-				callchain_merge(&self->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&hists->callchain_cursor);
+				callchain_merge(&hists->callchain_cursor, iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
@@ -254,35 +328,70 @@ static bool hists__collapse_insert_entry(struct hists *self,
 			p = &(*p)->rb_right;
 	}
 
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
+	rb_link_node(&he->rb_node_in, parent, p);
+	rb_insert_color(&he->rb_node_in, root);
 	return true;
 }
 
-void hists__collapse_resort(struct hists *self)
+static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
+{
+	struct rb_root *root;
+
+	pthread_mutex_lock(&hists->lock);
+
+	root = hists->entries_in;
+	if (++hists->entries_in > &hists->entries_in_array[1])
+		hists->entries_in = &hists->entries_in_array[0];
+
+	pthread_mutex_unlock(&hists->lock);
+
+	return root;
+}
+
+static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
+{
+	hists__filter_entry_by_dso(hists, he);
+	hists__filter_entry_by_thread(hists, he);
+}
+
+static void __hists__collapse_resort(struct hists *hists, bool threaded)
 {
-	struct rb_root tmp;
+	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 
-	if (!sort__need_collapse)
+	if (!sort__need_collapse && !threaded)
 		return;
 
-	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
-	self->nr_entries = 0;
-	hists__reset_col_len(self);
+	root = hists__get_rotate_entries_in(hists);
+	next = rb_first(root);
+	hists->stats.total_period = 0;
 
 	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &self->entries);
-		if (hists__collapse_insert_entry(self, &tmp, n))
-			hists__inc_nr_entries(self, n);
+		n = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&n->rb_node_in);
+
+		rb_erase(&n->rb_node_in, root);
+		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n)) {
+			/*
+			 * If it wasn't combined with one of the entries already
+			 * collapsed, we need to apply the filters that may have
+			 * been set by, say, the hist_browser.
+			 */
+			hists__apply_filters(hists, n);
+			hists__inc_nr_entries(hists, n);
+		}
 	}
+}
 
-	self->entries = tmp;
+void hists__collapse_resort(struct hists *hists)
+{
+	return __hists__collapse_resort(hists, false);
+}
+
+void hists__collapse_resort_threaded(struct hists *hists)
+{
+	return __hists__collapse_resort(hists, true);
 }
 
 /*
@@ -315,31 +424,43 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-void hists__output_resort(struct hists *self)
+static void __hists__output_resort(struct hists *hists, bool threaded)
 {
-	struct rb_root tmp;
+	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
-	min_callchain_hits = self->stats.total_period * (callchain_param.min_percent / 100);
+	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
+
+	if (sort__need_collapse || threaded)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
 
-	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
+	next = rb_first(root);
+	hists->entries = RB_ROOT;
 
-	self->nr_entries = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = 0;
+	hists__reset_col_len(hists);
 
 	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
+		n = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&n->rb_node_in);
 
-		rb_erase(&n->rb_node, &self->entries);
-		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
-		hists__inc_nr_entries(self, n);
+		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
+		hists__inc_nr_entries(hists, n);
 	}
+}
 
-	self->entries = tmp;
+void hists__output_resort(struct hists *hists)
+{
+	return __hists__output_resort(hists, false);
+}
+
+void hists__output_resort_threaded(struct hists *hists)
+{
+	return __hists__output_resort(hists, true);
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -594,12 +715,27 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
-			 struct hists *hists, struct hists *pair_hists,
-			 bool show_displacement, long displacement,
-			 bool color, u64 session_total)
+void hists__output_recalc_col_len(struct hists *hists, int max_rows)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+	int row = 0;
+
+	hists__reset_col_len(hists);
+
+	while (next && row++ < max_rows) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
+		next = rb_next(&n->rb_node);
+	}
+}
+
+static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
+				     size_t size, struct hists *pair_hists,
+				     bool show_displacement, long displacement,
+				     bool color, u64 session_total)
 {
-	struct sort_entry *se;
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
 	u64 nr_events;
 	const char *sep = symbol_conf.field_sep;
@@ -664,6 +800,13 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 			ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
 	}
 
+	if (symbol_conf.show_total_period) {
+		if (sep)
+			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
+		else
+			ret += snprintf(s + ret, size - ret, " %12" PRIu64, period);
+	}
+
 	if (pair_hists) {
 		char bf[32];
 		double old_percent = 0, new_percent = 0, diff;
@@ -698,26 +841,42 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		}
 	}
 
+	return ret;
+}
+
+int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
+			 struct hists *hists)
+{
+	const char *sep = symbol_conf.field_sep;
+	struct sort_entry *se;
+	int ret = 0;
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
 
 		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(self, s + ret, size - ret,
+		ret += se->se_snprintf(he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
 
 	return ret;
 }
 
-int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
 			long displacement, FILE *fp, u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), hists, pair_hists,
-			     show_displacement, displacement,
-			     true, session_total);
+	int ret;
+
+	if (size == 0 || size > sizeof(bf))
+		size = sizeof(bf);
+
+	ret = hist_entry__pcnt_snprintf(he, bf, size, pair_hists,
+					show_displacement, displacement,
+					true, session_total);
+	hist_entry__snprintf(he, bf + ret, size - ret, hists);
 	return fprintf(fp, "%s\n", bf);
 }
 
@@ -738,8 +897,9 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 					     left_margin);
 }
 
-size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, FILE *fp)
+size_t hists__fprintf(struct hists *hists, struct hists *pair,
+		      bool show_displacement, bool show_header, int max_rows,
+		      int max_cols, FILE *fp)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -749,9 +909,13 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
+	int nr_rows = 0;
 
 	init_rem_hits();
 
+	if (!show_header)
+		goto print_entries;
+
 	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
 
 	if (symbol_conf.show_nr_samples) {
@@ -761,6 +925,13 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 			fputs("  Samples  ", fp);
 	}
 
+	if (symbol_conf.show_total_period) {
+		if (sep)
+			ret += fprintf(fp, "%cPeriod", *sep);
+		else
+			ret += fprintf(fp, "   Period    ");
+	}
+
 	if (symbol_conf.show_cpu_utilization) {
 		if (sep) {
 			ret += fprintf(fp, "%csys", *sep);
@@ -803,18 +974,21 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		width = strlen(se->se_header);
 		if (symbol_conf.col_width_list_str) {
 			if (col_width) {
-				hists__set_col_len(self, se->se_width_idx,
+				hists__set_col_len(hists, se->se_width_idx,
 						   atoi(col_width));
 				col_width = strchr(col_width, ',');
 				if (col_width)
 					++col_width;
 			}
 		}
-		if (!hists__new_col_len(self, se->se_width_idx, width))
-			width = hists__col_len(self, se->se_width_idx);
+		if (!hists__new_col_len(hists, se->se_width_idx, width))
+			width = hists__col_len(hists, se->se_width_idx);
 		fprintf(fp, "  %*s", width, se->se_header);
 	}
+
 	fprintf(fp, "\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
 
 	if (sep)
 		goto print_entries;
@@ -822,6 +996,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 	fprintf(fp, "# ........");
 	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
+	if (symbol_conf.show_total_period)
+		fprintf(fp, " ............");
 	if (pair) {
 		fprintf(fp, " ..........");
 		if (show_displacement)
@@ -834,17 +1010,23 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 			continue;
 
 		fprintf(fp, "  ");
-		width = hists__col_len(self, se->se_width_idx);
+		width = hists__col_len(hists, se->se_width_idx);
 		if (width == 0)
 			width = strlen(se->se_header);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
 
-	fprintf(fp, "\n#\n");
+	fprintf(fp, "\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
+
+	fprintf(fp, "#\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
 
 print_entries:
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
@@ -858,19 +1040,22 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, self, pair, show_displacement,
-					   displacement, fp, self->stats.total_period);
+		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
+					   displacement, fp, hists->stats.total_period);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, self, fp,
-							     self->stats.total_period);
+			ret += hist_entry__fprintf_callchain(h, hists, fp,
+							     hists->stats.total_period);
+		if (max_rows && ++nr_rows >= max_rows)
+			goto out;
+
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
-
+out:
 	free(rem_sq_bracket);
 
 	return ret;
@@ -879,7 +1064,7 @@ print_entries:
 /*
  * See hists__fprintf to match the column widths
  */
-unsigned int hists__sort_list_width(struct hists *self)
+unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int ret = 9; /* total % */
@@ -896,9 +1081,12 @@ unsigned int hists__sort_list_width(struct hists *self)
 	if (symbol_conf.show_nr_samples)
 		ret += 11;
 
+	if (symbol_conf.show_total_period)
+		ret += 13;
+
 	list_for_each_entry(se, &hist_entry__sort_list, list)
 		if (!se->elide)
-			ret += 2 + hists__col_len(self, se->se_width_idx);
+			ret += 2 + hists__col_len(hists, se->se_width_idx);
 
 	if (verbose) /* Addr + origin */
 		ret += 3 + BITS_PER_LONG / 4;
@@ -906,63 +1094,84 @@ unsigned int hists__sort_list_width(struct hists *self)
 	return ret;
 }
 
-static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
+static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
 	h->filtered &= ~(1 << filter);
 	if (h->filtered)
 		return;
 
-	++self->nr_entries;
+	++hists->nr_entries;
 	if (h->ms.unfolded)
-		self->nr_entries += h->nr_rows;
+		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	self->stats.total_period += h->period;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+	hists->stats.total_period += h->period;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 
-	hists__calc_col_len(self, h);
+	hists__calc_col_len(hists, h);
 }
 
-void hists__filter_by_dso(struct hists *self, const struct dso *dso)
+
+static bool hists__filter_entry_by_dso(struct hists *hists,
+				       struct hist_entry *he)
+{
+	if (hists->dso_filter != NULL &&
+	    (he->ms.map == NULL || he->ms.map->dso != hists->dso_filter)) {
+		he->filtered |= (1 << HIST_FILTER__DSO);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (symbol_conf.exclude_other && !h->parent)
 			continue;
 
-		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
-			h->filtered |= (1 << HIST_FILTER__DSO);
+		if (hists__filter_entry_by_dso(hists, h))
 			continue;
-		}
 
-		hists__remove_entry_filter(self, h, HIST_FILTER__DSO);
+		hists__remove_entry_filter(hists, h, HIST_FILTER__DSO);
 	}
 }
 
-void hists__filter_by_thread(struct hists *self, const struct thread *thread)
+static bool hists__filter_entry_by_thread(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->thread_filter != NULL &&
+	    he->thread != hists->thread_filter) {
+		he->filtered |= (1 << HIST_FILTER__THREAD);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
-		if (thread != NULL && h->thread != thread) {
-			h->filtered |= (1 << HIST_FILTER__THREAD);
+		if (hists__filter_entry_by_thread(hists, h))
 			continue;
-		}
 
-		hists__remove_entry_filter(self, h, HIST_FILTER__THREAD);
+		hists__remove_entry_filter(hists, h, HIST_FILTER__THREAD);
 	}
 }
 
@@ -976,13 +1185,13 @@ int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
 
-void hists__inc_nr_events(struct hists *self, u32 type)
+void hists__inc_nr_events(struct hists *hists, u32 type)
 {
-	++self->stats.nr_events[0];
-	++self->stats.nr_events[type];
+	++hists->stats.nr_events[0];
+	++hists->stats.nr_events[type];
 }
 
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
+size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 {
 	int i;
 	size_t ret = 0;
@@ -990,7 +1199,7 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
 		const char *name;
 
-		if (self->stats.nr_events[i] == 0)
+		if (hists->stats.nr_events[i] == 0)
 			continue;
 
 		name = perf_event__name(i);
@@ -998,8 +1207,18 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 			continue;
 
 		ret += fprintf(fp, "%16s events: %10d\n", name,
-			       self->stats.nr_events[i]);
+			       hists->stats.nr_events[i]);
 	}
 
 	return ret;
 }
+
+void hists__init(struct hists *hists)
+{
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3beb97c..ff93ddc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -2,6 +2,7 @@
 #define __PERF_HIST_H
 
 #include <linux/types.h>
+#include <pthread.h>
 #include "callchain.h"
 
 extern struct callchain_param callchain_param;
@@ -42,9 +43,18 @@ enum hist_column {
 	HISTC_NR_COLS, /* Last entry */
 };
 
+struct thread;
+struct dso;
+
 struct hists {
+	struct rb_root		entries_in_array[2];
+	struct rb_root		*entries_in;
 	struct rb_root		entries;
+	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	const struct thread	*thread_filter;
+	const struct dso	*dso_filter;
+	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
@@ -52,34 +62,42 @@ struct hists {
 	struct callchain_cursor	callchain_cursor;
 };
 
+void hists__init(struct hists *hists);
+
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
-			long displacement, FILE *fp, u64 total);
+			long displacement, FILE *fp, u64 session_total);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-			 struct hists *hists, struct hists *pair_hists,
-			 bool show_displacement, long displacement,
-			 bool color, u64 total);
+			 struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *self);
+void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
+void hists__collapse_resort_threaded(struct hists *hists);
+
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
+void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
+				   bool zap_kernel);
+void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, FILE *fp);
+		      bool show_displacement, bool show_header,
+		      int max_rows, int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
-void hists__filter_by_dso(struct hists *self, const struct dso *dso);
-void hists__filter_by_thread(struct hists *self, const struct thread *thread);
+void hists__filter_by_dso(struct hists *hists);
+void hists__filter_by_thread(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
@@ -90,26 +108,33 @@ struct perf_evlist;
 #ifdef NO_NEWT_SUPPORT
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
-				  const char *help __used)
+				  const char *help __used,
+				  void(*timer)(void *arg) __used,
+				  void *arg __used,
+				  int refresh __used)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-					   int evidx __used)
+					   int evidx __used,
+					   int nr_events __used,
+					   void(*timer)(void *arg) __used,
+					   void *arg __used,
+					   int delay_secs __used)
 {
 	return 0;
 }
-#define KEY_LEFT -1
-#define KEY_RIGHT -2
+#define K_LEFT -1
+#define K_RIGHT -2
 #else
-#include <newt.h>
-int hist_entry__tui_annotate(struct hist_entry *self, int evidx);
-
-#define KEY_LEFT NEWT_KEY_LEFT
-#define KEY_RIGHT NEWT_KEY_RIGHT
+#include "ui/keysyms.h"
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
+			     void(*timer)(void *arg), void *arg, int delay_secs);
 
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help);
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a16ecab..78284b1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -18,6 +18,13 @@ static inline int is_anon_memory(const char *filename)
 	return strcmp(filename, "//anon") == 0;
 }
 
+static inline int is_no_dso_memory(const char *filename)
+{
+	return !strcmp(filename, "[stack]") ||
+	       !strcmp(filename, "[vdso]")  ||
+	       !strcmp(filename, "[heap]");
+}
+
 void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
@@ -42,9 +49,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (self != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon;
+		int anon, no_dso;
 
 		anon = is_anon_memory(filename);
+		no_dso = is_no_dso_memory(filename);
 
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
@@ -57,12 +65,16 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 
 		map__init(self, type, start, start + len, pgoff, dso);
 
-		if (anon) {
-set_identity:
+		if (anon || no_dso) {
 			self->map_ip = self->unmap_ip = identity__map_ip;
-		} else if (strcmp(filename, "[vdso]") == 0) {
-			dso__set_loaded(dso, self->type);
-			goto set_identity;
+
+			/*
+			 * Set memory without DSO as loaded. All map__find_*
+			 * functions still return NULL, and we avoid the
+			 * unnecessary map__load warning.
+			 */
+			if (no_dso)
+				dso__set_loaded(dso, self->type);
 		}
 	}
 	return self;
@@ -127,8 +139,8 @@ int map__load(struct map *self, symbol_filter_t filter)
 
 		if (len > sizeof(DSO__DELETED) &&
 		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-			pr_warning("%.*s was updated, restart the long "
-				   "running apps that use it!\n",
+			pr_warning("%.*s was updated (is prelink enabled?). "
+				"Restart the long running apps that use it!\n",
 				   (int)real_len, name);
 		} else {
 			pr_warning("no symbols found in %s, maybe install "
@@ -220,55 +232,55 @@ u64 map__objdump_2ip(struct map *map, u64 addr)
 	return ip;
 }
 
-void map_groups__init(struct map_groups *self)
+void map_groups__init(struct map_groups *mg)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		self->maps[i] = RB_ROOT;
-		INIT_LIST_HEAD(&self->removed_maps[i]);
+		mg->maps[i] = RB_ROOT;
+		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
-	self->machine = NULL;
+	mg->machine = NULL;
 }
 
-static void maps__delete(struct rb_root *self)
+static void maps__delete(struct rb_root *maps)
 {
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(maps);
 
 	while (next) {
 		struct map *pos = rb_entry(next, struct map, rb_node);
 
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, maps);
 		map__delete(pos);
 	}
 }
 
-static void maps__delete_removed(struct list_head *self)
+static void maps__delete_removed(struct list_head *maps)
 {
 	struct map *pos, *n;
 
-	list_for_each_entry_safe(pos, n, self, node) {
+	list_for_each_entry_safe(pos, n, maps, node) {
 		list_del(&pos->node);
 		map__delete(pos);
 	}
 }
 
-void map_groups__exit(struct map_groups *self)
+void map_groups__exit(struct map_groups *mg)
 {
 	int i;
 
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		maps__delete(&self->maps[i]);
-		maps__delete_removed(&self->removed_maps[i]);
+		maps__delete(&mg->maps[i]);
+		maps__delete_removed(&mg->removed_maps[i]);
 	}
 }
 
-void map_groups__flush(struct map_groups *self)
+void map_groups__flush(struct map_groups *mg)
 {
 	int type;
 
 	for (type = 0; type < MAP__NR_TYPES; type++) {
-		struct rb_root *root = &self->maps[type];
+		struct rb_root *root = &mg->maps[type];
 		struct rb_node *next = rb_first(root);
 
 		while (next) {
@@ -280,17 +292,17 @@ void map_groups__flush(struct map_groups *self)
 			 * instance in some hist_entry instances, so
 			 * just move them to a separate list.
 			 */
-			list_add_tail(&pos->node, &self->removed_maps[pos->type]);
+			list_add_tail(&pos->node, &mg->removed_maps[pos->type]);
 		}
 	}
 }
 
-struct symbol *map_groups__find_symbol(struct map_groups *self,
+struct symbol *map_groups__find_symbol(struct map_groups *mg,
 				       enum map_type type, u64 addr,
 				       struct map **mapp,
 				       symbol_filter_t filter)
 {
-	struct map *map = map_groups__find(self, type, addr);
+	struct map *map = map_groups__find(mg, type, addr);
 
 	if (map != NULL) {
 		if (mapp != NULL)
@@ -301,7 +313,7 @@ struct symbol *map_groups__find_symbol(struct map_groups *self,
 	return NULL;
 }
 
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       enum map_type type,
 					       const char *name,
 					       struct map **mapp,
@@ -309,7 +321,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
 
@@ -323,13 +335,13 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 	return NULL;
 }
 
-size_t __map_groups__fprintf_maps(struct map_groups *self,
+size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
@@ -342,22 +354,22 @@ size_t __map_groups__fprintf_maps(struct map_groups *self,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(mg, i, verbose, fp);
 	return printed;
 }
 
-static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
+static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
 						 enum map_type type,
 						 int verbose, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
 
-	list_for_each_entry(pos, &self->removed_maps[type], node) {
+	list_for_each_entry(pos, &mg->removed_maps[type], node) {
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
 		if (verbose > 1) {
@@ -368,26 +380,26 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
 	return printed;
 }
 
-static size_t map_groups__fprintf_removed_maps(struct map_groups *self,
+static size_t map_groups__fprintf_removed_maps(struct map_groups *mg,
 					       int verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(mg, i, verbose, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(self, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(mg, verbose, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(self, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(mg, verbose, fp);
 }
 
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				   int verbose, FILE *fp)
 {
-	struct rb_root *root = &self->maps[map->type];
+	struct rb_root *root = &mg->maps[map->type];
 	struct rb_node *next = rb_first(root);
 	int err = 0;
 
@@ -418,7 +430,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 			}
 
 			before->end = map->start - 1;
-			map_groups__insert(self, before);
+			map_groups__insert(mg, before);
 			if (verbose >= 2)
 				map__fprintf(before, fp);
 		}
@@ -432,7 +444,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 			}
 
 			after->start = map->end + 1;
-			map_groups__insert(self, after);
+			map_groups__insert(mg, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
 		}
@@ -441,7 +453,7 @@ move_map:
 		 * If we have references, just move them to a separate list.
 		 */
 		if (pos->referenced)
-			list_add_tail(&pos->node, &self->removed_maps[map->type]);
+			list_add_tail(&pos->node, &mg->removed_maps[map->type]);
 		else
 			map__delete(pos);
 
@@ -455,7 +467,7 @@ move_map:
 /*
  * XXX This should not really _copy_ te maps, but refcount them.
  */
-int map_groups__clone(struct map_groups *self,
+int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type)
 {
 	struct rb_node *nd;
@@ -464,7 +476,7 @@ int map_groups__clone(struct map_groups *self,
 		struct map *new = map__clone(map);
 		if (new == NULL)
 			return -ENOMEM;
-		map_groups__insert(self, new);
+		map_groups__insert(mg, new);
 	}
 	return 0;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b397c03..890d855 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -123,17 +123,17 @@ void map__fixup_end(struct map *self);
 
 void map__reloc_vmlinux(struct map *self);
 
-size_t __map_groups__fprintf_maps(struct map_groups *self,
+size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
-void maps__remove(struct rb_root *self, struct map *map);
+void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
-void map_groups__init(struct map_groups *self);
-void map_groups__exit(struct map_groups *self);
-int map_groups__clone(struct map_groups *self,
+void map_groups__init(struct map_groups *mg);
+void map_groups__exit(struct map_groups *mg);
+int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp);
+size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
+size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
 
 typedef void (*machine__process_t)(struct machine *self, void *data);
 
@@ -162,29 +162,29 @@ static inline bool machine__is_host(struct machine *self)
 	return self ? self->pid == HOST_KERNEL_ID : false;
 }
 
-static inline void map_groups__insert(struct map_groups *self, struct map *map)
+static inline void map_groups__insert(struct map_groups *mg, struct map *map)
 {
-	maps__insert(&self->maps[map->type], map);
-	map->groups = self;
+	maps__insert(&mg->maps[map->type], map);
+	map->groups = mg;
 }
 
-static inline void map_groups__remove(struct map_groups *self, struct map *map)
+static inline void map_groups__remove(struct map_groups *mg, struct map *map)
 {
-	maps__remove(&self->maps[map->type], map);
+	maps__remove(&mg->maps[map->type], map);
 }
 
-static inline struct map *map_groups__find(struct map_groups *self,
+static inline struct map *map_groups__find(struct map_groups *mg,
 					   enum map_type type, u64 addr)
 {
-	return maps__find(&self->maps[type], addr);
+	return maps__find(&mg->maps[type], addr);
 }
 
-struct symbol *map_groups__find_symbol(struct map_groups *self,
+struct symbol *map_groups__find_symbol(struct map_groups *mg,
 				       enum map_type type, u64 addr,
 				       struct map **mapp,
 				       symbol_filter_t filter);
 
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       enum map_type type,
 					       const char *name,
 					       struct map **mapp,
@@ -208,11 +208,11 @@ struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
 }
 
 static inline
-struct symbol *map_groups__find_function_by_name(struct map_groups *self,
+struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
 						 symbol_filter_t filter)
 {
-	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
+	return map_groups__find_symbol_by_name(mg, MAP__FUNCTION, name, mapp, filter);
 }
 
 static inline
@@ -225,13 +225,13 @@ struct symbol *machine__find_kernel_function_by_name(struct machine *self,
 						 filter);
 }
 
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				   int verbose, FILE *fp);
 
-struct map *map_groups__find_by_name(struct map_groups *self,
+struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
 struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
 
-void map_groups__flush(struct map_groups *self);
+void map_groups__flush(struct map_groups *mg);
 
 #endif /* __PERF_MAP_H */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1c7bfa5..eb25900 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1956,8 +1956,10 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 
 	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
-	if (ret < 0)
+	if (ret < 0) {
+		ret = -errno;
 		goto error;
+	}
 
 	printf("Remove event: %s\n", ent->s);
 	return 0;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 72458d9..20e011c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1326,3 +1326,22 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 
 	return 0;
 }
+
+void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
+				bool full)
+{
+	struct stat st;
+	int ret;
+
+	if (session == NULL || fp == NULL)
+		return;
+
+	ret = fstat(session->fd, &st);
+	if (ret == -1)
+		return;
+
+	fprintf(fp, "# ========\n");
+	fprintf(fp, "# captured on: %s", ctime(&st.st_ctime));
+	perf_header__fprintf_info(session, fp, full);
+	fprintf(fp, "# ========\n#\n");
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 974d0cb..514b06d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -177,4 +177,5 @@ void perf_session__print_ip(union perf_event *event,
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
 
+void perf_session__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1ee8f1e..16da30d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -177,7 +177,9 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				       BITS_PER_LONG / 4, self->ip, o);
 	}
 
-	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
+	if (!sort_dso.elide)
+		ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
+
 	if (self->ms.sym)
 		ret += repsep_snprintf(bf + ret, size - ret, "%s",
 				       self->ms.sym->name);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 77d0388..3f67ae3 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -45,6 +45,7 @@ extern enum sort_type sort__first_dimension;
  * @nr_rows - rows expanded in callchain, recalculated on folding/unfolding
  */
 struct hist_entry {
+	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
 	u64			period;
 	u64			period_sys;
@@ -63,6 +64,7 @@ struct hist_entry {
 
 	bool			init_have_children;
 	char			level;
+	bool			used;
 	u8			filtered;
 	struct symbol		*parent;
 	union {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 40eeaf0..632b50c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -24,7 +24,7 @@
 #include <sys/utsname.h>
 
 #ifndef KSYM_NAME_LEN
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 256
 #endif
 
 #ifndef NT_GNU_BUILD_ID
@@ -46,6 +46,7 @@ struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
+	.annotate_src	  = true,
 	.symfs            = "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4f377d9..29f8d74 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -72,11 +72,14 @@ struct symbol_conf {
 			use_modules,
 			sort_by_name,
 			show_nr_samples,
+			show_total_period,
 			use_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-			kptr_restrict;
+			kptr_restrict,
+			annotate_asm_raw,
+			annotate_src;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index a11f607..500471d 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -15,52 +15,6 @@
 #include "top.h"
 #include <inttypes.h>
 
-/*
- * Ordering weight: count-1 * count-2 * ... / count-n
- */
-static double sym_weight(const struct sym_entry *sym, struct perf_top *top)
-{
-	double weight = sym->snap_count;
-	int counter;
-
-	if (!top->display_weighted)
-		return weight;
-
-	for (counter = 1; counter < top->evlist->nr_entries - 1; counter++)
-		weight *= sym->count[counter];
-
-	weight /= (sym->count[counter] + 1);
-
-	return weight;
-}
-
-static void perf_top__remove_active_sym(struct perf_top *top, struct sym_entry *syme)
-{
-	pthread_mutex_lock(&top->active_symbols_lock);
-	list_del_init(&syme->node);
-	pthread_mutex_unlock(&top->active_symbols_lock);
-}
-
-static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
-{
-	struct rb_node **p = &tree->rb_node;
-	struct rb_node *parent = NULL;
-	struct sym_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct sym_entry, rb_node);
-
-		if (se->weight > iter->weight)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&se->rb_node, parent, p);
-	rb_insert_color(&se->rb_node, tree);
-}
-
 #define SNPRINTF(buf, size, fmt, args...) \
 ({ \
 	size_t r = snprintf(buf, size, fmt, ## args); \
@@ -69,7 +23,6 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 {
-	struct perf_evsel *counter;
 	float samples_per_sec = top->samples / top->delay_secs;
 	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
 	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
@@ -104,7 +57,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 			       esamples_percent);
 	}
 
-	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
+	if (top->evlist->nr_entries == 1) {
 		struct perf_evsel *first;
 		first = list_entry(top->evlist->entries.next, struct perf_evsel, node);
 		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
@@ -112,27 +65,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 				top->freq ? "Hz" : "");
 	}
 
-	if (!top->display_weighted) {
-		ret += SNPRINTF(bf + ret, size - ret, "%s",
-				event_name(top->sym_evsel));
-	} else {
-		/*
-		 * Don't let events eat all the space. Leaving 30 bytes
-		 * for the rest should be enough.
-		 */
-		size_t last_pos = size - 30;
-
-		list_for_each_entry(counter, &top->evlist->entries, node) {
-			ret += SNPRINTF(bf + ret, size - ret, "%s%s",
-					counter->idx ? "/" : "",
-					event_name(counter));
-			if (ret > last_pos) {
-				sprintf(bf + last_pos - 3, "..");
-				ret = last_pos - 1;
-				break;
-			}
-		}
-	}
+	ret += SNPRINTF(bf + ret, size - ret, "%s", event_name(top->sym_evsel));
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
@@ -166,73 +99,3 @@ void perf_top__reset_sample_counters(struct perf_top *top)
 	top->exact_samples = top->guest_kernel_samples =
 	top->guest_us_samples = 0;
 }
-
-float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
-{
-	struct sym_entry *syme, *n;
-	float sum_ksamples = 0.0;
-	int snap = !top->display_weighted ? top->sym_evsel->idx : 0, j;
-
-	/* Sort the active symbols */
-	pthread_mutex_lock(&top->active_symbols_lock);
-	syme = list_entry(top->active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&top->active_symbols_lock);
-
-	top->rb_entries = 0;
-	list_for_each_entry_safe_from(syme, n, &top->active_symbols, node) {
-		syme->snap_count = syme->count[snap];
-		if (syme->snap_count != 0) {
-
-			if ((top->hide_user_symbols &&
-			     syme->map->dso->kernel == DSO_TYPE_USER) ||
-			    (top->hide_kernel_symbols &&
-			     syme->map->dso->kernel == DSO_TYPE_KERNEL)) {
-				perf_top__remove_active_sym(top, syme);
-				continue;
-			}
-			syme->weight = sym_weight(syme, top);
-
-			if ((int)syme->snap_count >= top->count_filter) {
-				rb_insert_active_sym(root, syme);
-				++top->rb_entries;
-			}
-			sum_ksamples += syme->snap_count;
-
-			for (j = 0; j < top->evlist->nr_entries; j++)
-				syme->count[j] = top->zero ? 0 : syme->count[j] * 7 / 8;
-		} else
-			perf_top__remove_active_sym(top, syme);
-	}
-
-	return sum_ksamples;
-}
-
-/*
- * Find the longest symbol name that will be displayed
- */
-void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
-			   int *dso_width, int *dso_short_width, int *sym_width)
-{
-	struct rb_node *nd;
-	int printed = 0;
-
-	*sym_width = *dso_width = *dso_short_width = 0;
-
-	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
-		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
-		struct symbol *sym = sym_entry__symbol(syme);
-
-		if (++printed > top->print_entries ||
-		    (int)syme->snap_count < top->count_filter)
-			continue;
-
-		if (syme->map->dso->long_name_len > *dso_width)
-			*dso_width = syme->map->dso->long_name_len;
-
-		if (syme->map->dso->short_name_len > *dso_short_width)
-			*dso_short_width = syme->map->dso->short_name_len;
-
-		if (sym->namelen > *sym_width)
-			*sym_width = sym->namelen;
-	}
-}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index bfbf95b..01d1057 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -4,26 +4,10 @@
 #include "types.h"
 #include "../perf.h"
 #include <stddef.h>
-#include <pthread.h>
-#include <linux/list.h>
-#include <linux/rbtree.h>
 
 struct perf_evlist;
 struct perf_evsel;
-
-struct sym_entry {
-	struct rb_node		rb_node;
-	struct list_head	node;
-	unsigned long		snap_count;
-	double			weight;
-	struct map		*map;
-	unsigned long		count[0];
-};
-
-static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
-{
-       return ((void *)self) + symbol_conf.priv_size;
-}
+struct perf_session;
 
 struct perf_top {
 	struct perf_evlist *evlist;
@@ -31,34 +15,21 @@ struct perf_top {
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
 	 */
-	struct list_head   active_symbols;
-	pthread_mutex_t	   active_symbols_lock;
-	pthread_cond_t	   active_symbols_cond;
 	u64		   samples;
 	u64		   kernel_samples, us_samples;
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
+	u64		   total_lost_warned;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries;
+	int		   freq;
 	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
-	struct sym_entry   *sym_filter_entry;
+	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
+	struct perf_session *session;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
-float perf_top__decay_samples(struct perf_top *top, struct rb_root *root);
-void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
-			   int *dso_width, int *dso_short_width, int *sym_width);
-
-#ifdef NO_NEWT_SUPPORT
-static inline int perf_top__tui_browser(struct perf_top *top __used)
-{
-	return 0;
-}
-#else
-int perf_top__tui_browser(struct perf_top *top);
-#endif
 #endif /* __PERF_TOP_H */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3403f81..2d530cf 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -196,7 +196,8 @@ static void record_file(const char *file, size_t hdr_sz)
 		die("Can't read '%s'", file);
 
 	/* put in zeros for file size, then fill true size later */
-	write_or_die(&size, hdr_sz);
+	if (hdr_sz)
+		write_or_die(&size, hdr_sz);
 
 	do {
 		r = read(fd, buf, BUFSIZ);
@@ -212,7 +213,7 @@ static void record_file(const char *file, size_t hdr_sz)
 	if (bigendian())
 		sizep += sizeof(u64) - hdr_sz;
 
-	if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
 		die("writing to %s", output_file);
 }
 
@@ -428,6 +429,19 @@ get_tracepoints_path(struct list_head *pattrs)
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
+static void
+put_tracepoints_path(struct tracepoint_path *tps)
+{
+	while (tps) {
+		struct tracepoint_path *t = tps;
+
+		tps = tps->next;
+		free(t->name);
+		free(t->system);
+		free(t);
+	}
+}
+
 bool have_tracepoints(struct list_head *pattrs)
 {
 	struct perf_evsel *pos;
@@ -439,19 +453,11 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-int read_tracing_data(int fd, struct list_head *pattrs)
+static void tracing_data_header(void)
 {
-	char buf[BUFSIZ];
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
-
-	/*
-	 * What? No tracepoints? No sense writing anything here, bail out.
-	 */
-	if (tps == NULL)
-		return -1;
-
-	output_fd = fd;
+	char buf[20];
 
+	/* just guessing this is someone's birthday.. ;) */
 	buf[0] = 23;
 	buf[1] = 8;
 	buf[2] = 68;
@@ -476,28 +482,86 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 	/* save page_size */
 	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
+}
+
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp)
+{
+	struct tracepoint_path *tps;
+	struct tracing_data *tdata;
+
+	output_fd = fd;
+
+	tps = get_tracepoints_path(pattrs);
+	if (!tps)
+		return NULL;
 
+	tdata = malloc_or_die(sizeof(*tdata));
+	tdata->temp = temp;
+	tdata->size = 0;
+
+	if (temp) {
+		int temp_fd;
+
+		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
+			 "/tmp/perf-XXXXXX");
+		if (!mkstemp(tdata->temp_file))
+			die("Can't make temp file");
+
+		temp_fd = open(tdata->temp_file, O_RDWR);
+		if (temp_fd < 0)
+			die("Can't read '%s'", tdata->temp_file);
+
+		/*
+		 * Set the temp file the default output, so all the
+		 * tracing data are stored into it.
+		 */
+		output_fd = temp_fd;
+	}
+
+	tracing_data_header();
 	read_header_files();
 	read_ftrace_files(tps);
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
 
-	return 0;
+	/*
+	 * All tracing data are stored by now, we can restore
+	 * the default output file in case we used temp file.
+	 */
+	if (temp) {
+		tdata->size = lseek(output_fd, 0, SEEK_CUR);
+		close(output_fd);
+		output_fd = fd;
+	}
+
+	put_tracepoints_path(tps);
+	return tdata;
 }
 
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs)
+void tracing_data_put(struct tracing_data *tdata)
 {
-	ssize_t size;
-	int err = 0;
+	if (tdata->temp) {
+		record_file(tdata->temp_file, 0);
+		unlink(tdata->temp_file);
+	}
 
-	calc_data_size = 1;
-	err = read_tracing_data(fd, pattrs);
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	free(tdata);
+}
 
-	if (err < 0)
-		return err;
+int read_tracing_data(int fd, struct list_head *pattrs)
+{
+	struct tracing_data *tdata;
 
-	return size;
+	/*
+	 * We work over the real file, so we can write data
+	 * directly, no temp file is needed.
+	 */
+	tdata = tracing_data_get(pattrs, fd, false);
+	if (!tdata)
+		return -ENOMEM;
+
+	tracing_data_put(tdata);
+	return 0;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f674dda..a841008 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -263,7 +263,18 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct list_head *pattrs);
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
+
+struct tracing_data {
+	/* size is only valid if temp is 'true' */
+	ssize_t size;
+	bool temp;
+	char temp_file[50];
+};
+
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp);
+void tracing_data_put(struct tracing_data *tdata);
+
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 611219f..5359f37 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,4 +1,8 @@
+#include "../util.h"
+#include "../cache.h"
+#include "../../perf.h"
 #include "libslang.h"
+#include <newt.h>
 #include "ui.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
@@ -7,13 +11,13 @@
 #include <sys/ttydefaults.h>
 #include "browser.h"
 #include "helpline.h"
+#include "keysyms.h"
 #include "../color.h"
-#include "../util.h"
-#include <stdio.h>
 
-static int ui_browser__percent_color(double percent, bool current)
+static int ui_browser__percent_color(struct ui_browser *browser,
+				     double percent, bool current)
 {
-	if (current)
+	if (current && (!browser->use_navkeypressed || browser->navkeypressed))
 		return HE_COLORSET_SELECTED;
 	if (percent >= MIN_RED)
 		return HE_COLORSET_TOP;
@@ -30,7 +34,7 @@ void ui_browser__set_color(struct ui_browser *self __used, int color)
 void ui_browser__set_percent_color(struct ui_browser *self,
 				   double percent, bool current)
 {
-	 int color = ui_browser__percent_color(percent, current);
+	 int color = ui_browser__percent_color(self, percent, current);
 	 ui_browser__set_color(self, color);
 }
 
@@ -39,31 +43,62 @@ void ui_browser__gotorc(struct ui_browser *self, int y, int x)
 	SLsmg_gotorc(self->y + y, self->x + x);
 }
 
+static struct list_head *
+ui_browser__list_head_filter_entries(struct ui_browser *browser,
+				     struct list_head *pos)
+{
+	do {
+		if (!browser->filter || !browser->filter(browser, pos))
+			return pos;
+		pos = pos->next;
+	} while (pos != browser->entries);
+
+	return NULL;
+}
+
+static struct list_head *
+ui_browser__list_head_filter_prev_entries(struct ui_browser *browser,
+					  struct list_head *pos)
+{
+	do {
+		if (!browser->filter || !browser->filter(browser, pos))
+			return pos;
+		pos = pos->prev;
+	} while (pos != browser->entries);
+
+	return NULL;
+}
+
 void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
 {
 	struct list_head *head = self->entries;
 	struct list_head *pos;
 
+	if (self->nr_entries == 0)
+		return;
+
 	switch (whence) {
 	case SEEK_SET:
-		pos = head->next;
+		pos = ui_browser__list_head_filter_entries(self, head->next);
 		break;
 	case SEEK_CUR:
 		pos = self->top;
 		break;
 	case SEEK_END:
-		pos = head->prev;
+		pos = ui_browser__list_head_filter_prev_entries(self, head->prev);
 		break;
 	default:
 		return;
 	}
 
+	assert(pos != NULL);
+
 	if (offset > 0) {
 		while (offset-- != 0)
-			pos = pos->next;
+			pos = ui_browser__list_head_filter_entries(self, pos->next);
 	} else {
 		while (offset++ != 0)
-			pos = pos->prev;
+			pos = ui_browser__list_head_filter_prev_entries(self, pos->prev);
 	}
 
 	self->top = pos;
@@ -127,11 +162,8 @@ bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
 
 void ui_browser__refresh_dimensions(struct ui_browser *self)
 {
-	int cols, rows;
-	newtGetScreenSize(&cols, &rows);
-
-	self->width = cols - 1;
-	self->height = rows - 2;
+	self->width = SLtt_Screen_Cols - 1;
+	self->height = SLtt_Screen_Rows - 2;
 	self->y = 1;
 	self->x = 0;
 }
@@ -142,26 +174,11 @@ void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
-void ui_browser__add_exit_key(struct ui_browser *self, int key)
-{
-	newtFormAddHotKey(self->form, key);
-}
-
-void ui_browser__add_exit_keys(struct ui_browser *self, int keys[])
-{
-	int i = 0;
-
-	while (keys[i] && i < 64) {
-		ui_browser__add_exit_key(self, keys[i]);
-		++i;
-	}
-}
-
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	SLsmg_gotorc(0, 0);
 	ui_browser__set_color(browser, NEWT_COLORSET_ROOT);
-	slsmg_write_nstring(title, browser->width);
+	slsmg_write_nstring(title, browser->width + 1);
 }
 
 void ui_browser__show_title(struct ui_browser *browser, const char *title)
@@ -174,78 +191,189 @@ void ui_browser__show_title(struct ui_browser *browser, const char *title)
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...)
 {
+	int err;
 	va_list ap;
-	int keys[] = { NEWT_KEY_UP, NEWT_KEY_DOWN, NEWT_KEY_PGUP,
-		       NEWT_KEY_PGDN, NEWT_KEY_HOME, NEWT_KEY_END, ' ',
-		       NEWT_KEY_LEFT, NEWT_KEY_ESCAPE, 'q', CTRL('c'), 0 };
-
-	if (self->form != NULL)
-		newtFormDestroy(self->form);
 
 	ui_browser__refresh_dimensions(self);
-	self->form = newtForm(NULL, NULL, 0);
-	if (self->form == NULL)
-		return -1;
-
-	self->sb = newtVerticalScrollbar(self->width, 1, self->height,
-					 HE_COLORSET_NORMAL,
-					 HE_COLORSET_SELECTED);
-	if (self->sb == NULL)
-		return -1;
 
 	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(self, title);
 
-	ui_browser__add_exit_keys(self, keys);
-	newtFormAddComponent(self->form, self->sb);
+	self->title = title;
+	free(self->helpline);
+	self->helpline = NULL;
 
 	va_start(ap, helpline);
-	ui_helpline__vpush(helpline, ap);
+	err = vasprintf(&self->helpline, helpline, ap);
 	va_end(ap);
+	if (err > 0)
+		ui_helpline__push(self->helpline);
 	pthread_mutex_unlock(&ui__lock);
-	return 0;
+	return err ? 0 : -1;
 }
 
-void ui_browser__hide(struct ui_browser *self)
+void ui_browser__hide(struct ui_browser *browser __used)
 {
 	pthread_mutex_lock(&ui__lock);
-	newtFormDestroy(self->form);
-	self->form = NULL;
 	ui_helpline__pop();
 	pthread_mutex_unlock(&ui__lock);
 }
 
-int ui_browser__refresh(struct ui_browser *self)
+static void ui_browser__scrollbar_set(struct ui_browser *browser)
+{
+	int height = browser->height, h = 0, pct = 0,
+	    col = browser->width,
+	    row = browser->y - 1;
+
+	if (browser->nr_entries > 1) {
+		pct = ((browser->index * (browser->height - 1)) /
+		       (browser->nr_entries - 1));
+	}
+
+	while (h < height) {
+	        ui_browser__gotorc(browser, row++, col);
+		SLsmg_set_char_set(1);
+		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_BOARD_CHAR);
+		SLsmg_set_char_set(0);
+		++h;
+	}
+}
+
+static int __ui_browser__refresh(struct ui_browser *browser)
 {
 	int row;
+	int width = browser->width;
+
+	row = browser->refresh(browser);
+	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
+
+	if (!browser->use_navkeypressed || browser->navkeypressed)
+		ui_browser__scrollbar_set(browser);
+	else
+		width += 1;
 
+	SLsmg_fill_region(browser->y + row, browser->x,
+			  browser->height - row, width, ' ');
+
+	return 0;
+}
+
+int ui_browser__refresh(struct ui_browser *browser)
+{
 	pthread_mutex_lock(&ui__lock);
-	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
-	row = self->refresh(self);
-	ui_browser__set_color(self, HE_COLORSET_NORMAL);
-	SLsmg_fill_region(self->y + row, self->x,
-			  self->height - row, self->width, ' ');
+	__ui_browser__refresh(browser);
 	pthread_mutex_unlock(&ui__lock);
 
 	return 0;
 }
 
-int ui_browser__run(struct ui_browser *self)
+/*
+ * Here we're updating nr_entries _after_ we started browsing, i.e.  we have to
+ * forget about any reference to any entry in the underlying data structure,
+ * that is why we do a SEEK_SET. Think about 'perf top' in the hists browser
+ * after an output_resort and hist decay.
+ */
+void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 {
-	struct newtExitStruct es;
+	off_t offset = nr_entries - browser->nr_entries;
+
+	browser->nr_entries = nr_entries;
 
-	if (ui_browser__refresh(self) < 0)
-		return -1;
+	if (offset < 0) {
+		if (browser->top_idx < (u64)-offset)
+			offset = -browser->top_idx;
+
+		browser->index += offset;
+		browser->top_idx += offset;
+	}
+
+	browser->top = NULL;
+	browser->seek(browser, browser->top_idx, SEEK_SET);
+}
+
+static int ui__getch(int delay_secs)
+{
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
+	fd_set read_set;
+	int err, key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+
+	if (delay_secs) {
+		timeout.tv_sec = delay_secs;
+		timeout.tv_usec = 0;
+	}
+
+        err = select(1, &read_set, NULL, NULL, ptimeout);
+
+	if (err == 0)
+		return K_TIMER;
+
+	if (err == -1) {
+		if (errno == EINTR)
+			return K_RESIZE;
+		return K_ERROR;
+	}
+
+	key = SLang_getkey();
+	if (key != K_ESC)
+		return key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 20;
+        err = select(1, &read_set, NULL, NULL, &timeout);
+	if (err == 0)
+		return K_ESC;
+
+	SLang_ungetkey(key);
+	return SLkp_getkey();
+}
+
+int ui_browser__run(struct ui_browser *self, int delay_secs)
+{
+	int err, key;
+
+	pthread__unblock_sigwinch();
 
 	while (1) {
 		off_t offset;
 
-		newtFormRun(self->form, &es);
-
-		if (es.reason != NEWT_EXIT_HOTKEY)
+		pthread_mutex_lock(&ui__lock);
+		err = __ui_browser__refresh(self);
+		SLsmg_refresh();
+		pthread_mutex_unlock(&ui__lock);
+		if (err < 0)
 			break;
-		switch (es.u.key) {
-		case NEWT_KEY_DOWN:
+
+		key = ui__getch(delay_secs);
+
+		if (key == K_RESIZE) {
+			pthread_mutex_lock(&ui__lock);
+			SLtt_get_screen_size();
+			SLsmg_reinit_smg();
+			pthread_mutex_unlock(&ui__lock);
+			ui_browser__refresh_dimensions(self);
+			__ui_browser__show_title(self, self->title);
+			ui_helpline__puts(self->helpline);
+			continue;
+		}
+
+		if (self->use_navkeypressed && !self->navkeypressed) {
+			if (key == K_DOWN || key == K_UP ||
+			    key == K_PGDN || key == K_PGUP ||
+			    key == K_HOME || key == K_END ||
+			    key == ' ') {
+				self->navkeypressed = true;
+				continue;
+			} else
+				return key;
+		}
+
+		switch (key) {
+		case K_DOWN:
 			if (self->index == self->nr_entries - 1)
 				break;
 			++self->index;
@@ -254,7 +382,7 @@ int ui_browser__run(struct ui_browser *self)
 				self->seek(self, +1, SEEK_CUR);
 			}
 			break;
-		case NEWT_KEY_UP:
+		case K_UP:
 			if (self->index == 0)
 				break;
 			--self->index;
@@ -263,7 +391,7 @@ int ui_browser__run(struct ui_browser *self)
 				self->seek(self, -1, SEEK_CUR);
 			}
 			break;
-		case NEWT_KEY_PGDN:
+		case K_PGDN:
 		case ' ':
 			if (self->top_idx + self->height > self->nr_entries - 1)
 				break;
@@ -275,7 +403,7 @@ int ui_browser__run(struct ui_browser *self)
 			self->top_idx += offset;
 			self->seek(self, +offset, SEEK_CUR);
 			break;
-		case NEWT_KEY_PGUP:
+		case K_PGUP:
 			if (self->top_idx == 0)
 				break;
 
@@ -288,10 +416,10 @@ int ui_browser__run(struct ui_browser *self)
 			self->top_idx -= offset;
 			self->seek(self, -offset, SEEK_CUR);
 			break;
-		case NEWT_KEY_HOME:
+		case K_HOME:
 			ui_browser__reset_index(self);
 			break;
-		case NEWT_KEY_END:
+		case K_END:
 			offset = self->height - 1;
 			if (offset >= self->nr_entries)
 				offset = self->nr_entries - 1;
@@ -301,10 +429,8 @@ int ui_browser__run(struct ui_browser *self)
 			self->seek(self, -offset, SEEK_END);
 			break;
 		default:
-			return es.u.key;
+			return key;
 		}
-		if (ui_browser__refresh(self) < 0)
-			return -1;
 	}
 	return -1;
 }
@@ -316,41 +442,105 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	int row = 0;
 
 	if (self->top == NULL || self->top == self->entries)
-                self->top = head->next;
+                self->top = ui_browser__list_head_filter_entries(self, head->next);
 
 	pos = self->top;
 
 	list_for_each_from(pos, head) {
-		ui_browser__gotorc(self, row, 0);
-		self->write(self, pos, row);
-		if (++row == self->height)
-			break;
+		if (!self->filter || !self->filter(self, pos)) {
+			ui_browser__gotorc(self, row, 0);
+			self->write(self, pos, row);
+			if (++row == self->height)
+				break;
+		}
 	}
 
 	return row;
 }
 
-static struct newtPercentTreeColors {
-	const char *topColorFg, *topColorBg;
-	const char *mediumColorFg, *mediumColorBg;
-	const char *normalColorFg, *normalColorBg;
-	const char *selColorFg, *selColorBg;
-	const char *codeColorFg, *codeColorBg;
-} defaultPercentTreeColors = {
-	"red",       "lightgray",
-	"green",     "lightgray",
-	"black",     "lightgray",
-	"lightgray", "magenta",
-	"blue",	     "lightgray",
+static struct ui_browser__colorset {
+	const char *name, *fg, *bg;
+	int colorset;
+} ui_browser__colorsets[] = {
+	{
+		.colorset = HE_COLORSET_TOP,
+		.name	  = "top",
+		.fg	  = "red",
+		.bg	  = "default",
+	},
+	{
+		.colorset = HE_COLORSET_MEDIUM,
+		.name	  = "medium",
+		.fg	  = "green",
+		.bg	  = "default",
+	},
+	{
+		.colorset = HE_COLORSET_NORMAL,
+		.name	  = "normal",
+		.fg	  = "default",
+		.bg	  = "default",
+	},
+	{
+		.colorset = HE_COLORSET_SELECTED,
+		.name	  = "selected",
+		.fg	  = "black",
+		.bg	  = "lightgray",
+	},
+	{
+		.colorset = HE_COLORSET_CODE,
+		.name	  = "code",
+		.fg	  = "blue",
+		.bg	  = "default",
+	},
+	{
+		.name = NULL,
+	}
 };
 
+
+static int ui_browser__color_config(const char *var, const char *value,
+				    void *data __used)
+{
+	char *fg = NULL, *bg;
+	int i;
+
+	/* same dir for all commands */
+	if (prefixcmp(var, "colors.") != 0)
+		return 0;
+
+	for (i = 0; ui_browser__colorsets[i].name != NULL; ++i) {
+		const char *name = var + 7;
+
+		if (strcmp(ui_browser__colorsets[i].name, name) != 0)
+			continue;
+
+		fg = strdup(value);
+		if (fg == NULL)
+			break;
+
+		bg = strchr(fg, ',');
+		if (bg == NULL)
+			break;
+
+		*bg = '\0';
+		while (isspace(*++bg));
+		ui_browser__colorsets[i].bg = bg;
+		ui_browser__colorsets[i].fg = fg;
+		return 0;
+	}
+
+	free(fg);
+	return -1;
+}
+
 void ui_browser__init(void)
 {
-	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
+	int i = 0;
 
-	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
-	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
-	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
-	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
-	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
+	perf_config(ui_browser__color_config, NULL);
+
+	while (ui_browser__colorsets[i].name) {
+		struct ui_browser__colorset *c = &ui_browser__colorsets[i++];
+		sltt_set_color(c->colorset, c->name, c->fg, c->bg);
+	}
 }
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index fc63dda..a2c707d 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -2,7 +2,6 @@
 #define _PERF_UI_BROWSER_H_ 1
 
 #include <stdbool.h>
-#include <newt.h>
 #include <sys/types.h>
 #include "../types.h"
 
@@ -13,15 +12,19 @@
 #define HE_COLORSET_CODE	54
 
 struct ui_browser {
-	newtComponent form, sb;
 	u64	      index, top_idx;
 	void	      *top, *entries;
 	u16	      y, x, width, height;
 	void	      *priv;
+	const char    *title;
+	char	      *helpline;
 	unsigned int  (*refresh)(struct ui_browser *self);
 	void	      (*write)(struct ui_browser *self, void *entry, int row);
 	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
+	bool	      (*filter)(struct ui_browser *self, void *entry);
 	u32	      nr_entries;
+	bool	      navkeypressed;
+	bool	      use_navkeypressed;
 };
 
 void ui_browser__set_color(struct ui_browser *self, int color);
@@ -32,15 +35,14 @@ void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
-void ui_browser__add_exit_key(struct ui_browser *self, int key);
-void ui_browser__add_exit_keys(struct ui_browser *self, int keys[]);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
-int ui_browser__run(struct ui_browser *self);
+int ui_browser__run(struct ui_browser *browser, int delay_secs);
+void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 0229723..4e0cb7fe 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -6,6 +6,7 @@
 #include "../../sort.h"
 #include "../../symbol.h"
 #include <pthread.h>
+#include <newt.h>
 
 static void ui__error_window(const char *fmt, ...)
 {
@@ -20,12 +21,17 @@ struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
+	struct objdump_line *selection;
+	int		    nr_asm_entries;
+	int		    nr_entries;
+	bool		    hide_src_code;
 };
 
 struct objdump_line_rb_node {
 	struct rb_node	rb_node;
 	double		percent;
 	u32		idx;
+	int		idx_asm;
 };
 
 static inline
@@ -34,9 +40,22 @@ struct objdump_line_rb_node *objdump_line__rb(struct objdump_line *self)
 	return (struct objdump_line_rb_node *)(self + 1);
 }
 
+static bool objdump_line__filter(struct ui_browser *browser, void *entry)
+{
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
+
+	if (ab->hide_src_code) {
+		struct objdump_line *ol = list_entry(entry, struct objdump_line, node);
+		return ol->offset == -1;
+	}
+
+	return false;
+}
+
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
-	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
+	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
+	struct objdump_line *ol = list_entry(entry, struct objdump_line, node);
 	bool current_entry = ui_browser__is_current_entry(self, row);
 	int width = self->width;
 
@@ -51,6 +70,11 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	SLsmg_write_char(':');
 	slsmg_write_nstring(" ", 8);
+
+	/* The scroll bar isn't being used */
+	if (!self->navkeypressed)
+		width += 1;
+
 	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
 	else
@@ -58,6 +82,8 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	if (!current_entry)
 		ui_browser__set_color(self, HE_COLORSET_CODE);
+	else
+		ab->selection = ol;
 }
 
 static double objdump_line__calc_percent(struct objdump_line *self,
@@ -141,7 +167,8 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
 					   int evidx)
 {
-	struct symbol *sym = browser->b.priv;
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
 	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *pos;
 
@@ -163,25 +190,60 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	browser->curr_hot = rb_last(&browser->entries);
 }
 
+static bool annotate_browser__toggle_source(struct annotate_browser *browser)
+{
+	struct objdump_line *ol;
+	struct objdump_line_rb_node *olrb;
+	off_t offset = browser->b.index - browser->b.top_idx;
+
+	browser->b.seek(&browser->b, offset, SEEK_CUR);
+	ol = list_entry(browser->b.top, struct objdump_line, node);
+	olrb = objdump_line__rb(ol);
+
+	if (browser->hide_src_code) {
+		if (olrb->idx_asm < offset)
+			offset = olrb->idx;
+
+		browser->b.nr_entries = browser->nr_entries;
+		browser->hide_src_code = false;
+		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		browser->b.top_idx = olrb->idx - offset;
+		browser->b.index = olrb->idx;
+	} else {
+		if (olrb->idx_asm < 0) {
+			ui_helpline__puts("Only available for assembly lines.");
+			browser->b.seek(&browser->b, -offset, SEEK_CUR);
+			return false;
+		}
+
+		if (olrb->idx_asm < offset)
+			offset = olrb->idx_asm;
+
+		browser->b.nr_entries = browser->nr_asm_entries;
+		browser->hide_src_code = true;
+		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		browser->b.top_idx = olrb->idx_asm - offset;
+		browser->b.index = olrb->idx_asm;
+	}
+
+	return true;
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
-				 int refresh)
+				 int nr_events, void(*timer)(void *arg),
+				 void *arg, int delay_secs)
 {
 	struct rb_node *nd = NULL;
-	struct symbol *sym = self->b.priv;
-	/*
-	 * RIGHT To allow builtin-annotate to cycle thru multiple symbols by
-	 * examining the exit key for this function.
-	 */
-	int exit_keys[] = { 'H', NEWT_KEY_TAB, NEWT_KEY_UNTAB,
-			    NEWT_KEY_RIGHT, 0 };
+	struct map_symbol *ms = self->b.priv;
+	struct symbol *sym = ms->sym;
+	const char *help = "<-, ESC: exit, TAB/shift+TAB: cycle hottest lines, "
+			   "H: Hottest, -> Line action, S -> Toggle source "
+			   "code view";
 	int key;
 
-	if (ui_browser__show(&self->b, sym->name,
-			     "<-, -> or ESC: exit, TAB/shift+TAB: "
-			     "cycle hottest lines, H: Hottest") < 0)
+	if (ui_browser__show(&self->b, sym->name, help) < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&self->b, exit_keys);
 	annotate_browser__calc_percent(self, evidx);
 
 	if (self->curr_hot)
@@ -189,13 +251,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 
 	nd = self->curr_hot;
 
-	if (refresh != 0)
-		newtFormSetTimer(self->b.form, refresh);
-
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, delay_secs);
 
-		if (refresh != 0) {
+		if (delay_secs != 0) {
 			annotate_browser__calc_percent(self, evidx);
 			/*
 			 * Current line focus got out of the list of most active
@@ -207,15 +266,14 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		}
 
 		switch (key) {
-		case -1:
-			/*
- 			 * FIXME we need to check if it was
- 			 * es.reason == NEWT_EXIT_TIMER
- 			 */
-			if (refresh != 0)
+		case K_TIMER:
+			if (timer != NULL)
+				timer(arg);
+
+			if (delay_secs != 0)
 				symbol__annotate_decay_histogram(sym, evidx);
 			continue;
-		case NEWT_KEY_TAB:
+		case K_TAB:
 			if (nd != NULL) {
 				nd = rb_prev(nd);
 				if (nd == NULL)
@@ -223,7 +281,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			} else
 				nd = self->curr_hot;
 			break;
-		case NEWT_KEY_UNTAB:
+		case K_UNTAB:
 			if (nd != NULL)
 				nd = rb_next(nd);
 				if (nd == NULL)
@@ -234,8 +292,68 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'H':
 			nd = self->curr_hot;
 			break;
-		default:
+		case 'S':
+			if (annotate_browser__toggle_source(self))
+				ui_helpline__puts(help);
+			continue;
+		case K_ENTER:
+		case K_RIGHT:
+			if (self->selection == NULL) {
+				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
+				continue;
+			}
+
+			if (self->selection->offset == -1) {
+				ui_helpline__puts("Actions are only available for assembly lines.");
+				continue;
+			} else {
+				char *s = strstr(self->selection->line, "callq ");
+				struct annotation *notes;
+				struct symbol *target;
+				u64 ip;
+
+				if (s == NULL) {
+					ui_helpline__puts("Actions are only available for the 'callq' instruction.");
+					continue;
+				}
+
+				s = strchr(s, ' ');
+				if (s++ == NULL) {
+					ui_helpline__puts("Invallid callq instruction.");
+					continue;
+				}
+
+				ip = strtoull(s, NULL, 16);
+				ip = ms->map->map_ip(ms->map, ip);
+				target = map__find_symbol(ms->map, ip, NULL);
+				if (target == NULL) {
+					ui_helpline__puts("The called function was not found.");
+					continue;
+				}
+
+				notes = symbol__annotation(target);
+				pthread_mutex_lock(&notes->lock);
+
+				if (notes->src == NULL &&
+				    symbol__alloc_hist(target, nr_events) < 0) {
+					pthread_mutex_unlock(&notes->lock);
+					ui__warning("Not enough memory for annotating '%s' symbol!\n",
+						    target->name);
+					continue;
+				}
+
+				pthread_mutex_unlock(&notes->lock);
+				symbol__tui_annotate(target, ms->map, evidx, nr_events,
+						     timer, arg, delay_secs);
+			}
+			continue;
+		case K_LEFT:
+		case K_ESC:
+		case 'q':
+		case CTRL('c'):
 			goto out;
+		default:
+			continue;
 		}
 
 		if (nd != NULL)
@@ -246,22 +364,31 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx)
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
+			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, 0);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, nr_events,
+				    timer, arg, delay_secs);
 }
 
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int refresh)
+			 int nr_events, void(*timer)(void *arg), void *arg,
+			 int delay_secs)
 {
 	struct objdump_line *pos, *n;
 	struct annotation *notes;
+	struct map_symbol ms = {
+		.map = map,
+		.sym = sym,
+	};
 	struct annotate_browser browser = {
 		.b = {
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
-			.priv	 = sym,
+			.filter  = objdump_line__filter,
+			.priv	 = &ms,
+			.use_navkeypressed = true,
 		},
 	};
 	int ret;
@@ -288,12 +415,18 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
 		rbpos = objdump_line__rb(pos);
-		rbpos->idx = browser.b.nr_entries++;
+		rbpos->idx = browser.nr_entries++;
+		if (pos->offset != -1)
+			rbpos->idx_asm = browser.nr_asm_entries++;
+		else
+			rbpos->idx_asm = -1;
 	}
 
+	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser, evidx, refresh);
+	ret = annotate_browser__run(&browser, evidx, nr_events,
+				    timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 5d767c6..4663dcb 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -24,8 +24,12 @@ struct hist_browser {
 	struct hists	    *hists;
 	struct hist_entry   *he_selection;
 	struct map_symbol   *selection;
+	bool		     has_symbols;
 };
 
+static int hists__browser_title(struct hists *self, char *bf, size_t size,
+				const char *ev_name);
+
 static void hist_browser__refresh_dimensions(struct hist_browser *self)
 {
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
@@ -290,28 +294,34 @@ static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
 	ui_browser__reset_index(&self->b);
 }
 
-static int hist_browser__run(struct hist_browser *self, const char *title)
+static int hist_browser__run(struct hist_browser *self, const char *ev_name,
+			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int key;
-	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
-			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT,
-			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0, };
+	char title[160];
 
 	self->b.entries = &self->hists->entries;
 	self->b.nr_entries = self->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(self);
+	hists__browser_title(self->hists, title, sizeof(title), ev_name);
 
 	if (ui_browser__show(&self->b, title,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&self->b, exit_keys);
-
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, delay_secs);
 
 		switch (key) {
+		case -1:
+			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+			timer(arg);
+			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
+			hists__browser_title(self->hists, title, sizeof(title),
+					     ev_name);
+			ui_browser__show_title(&self->b, title);
+			continue;
 		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(self->b.top,
@@ -334,7 +344,7 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 			/* Expand the whole world. */
 			hist_browser__set_folding(self, true);
 			break;
-		case NEWT_KEY_ENTER:
+		case K_ENTER:
 			if (hist_browser__toggle_fold(self))
 				break;
 			/* fall thru */
@@ -532,7 +542,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	char s[256];
 	double percent;
 	int printed = 0;
-	int color, width = self->b.width;
+	int width = self->b.width - 6; /* The percentage */
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&self->b, row);
 	off_t row_offset = entry->row_offset;
@@ -548,26 +558,35 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), self->hists, NULL, false,
-				     0, false, self->hists->stats.total_period);
+		hist_entry__snprintf(entry, s, sizeof(s), self->hists);
 		percent = (entry->period * 100.0) / self->hists->stats.total_period;
 
-		color = HE_COLORSET_SELECTED;
-		if (!current_entry) {
-			if (percent >= MIN_RED)
-				color = HE_COLORSET_TOP;
-			else if (percent >= MIN_GREEN)
-				color = HE_COLORSET_MEDIUM;
-			else
-				color = HE_COLORSET_NORMAL;
-		}
-
-		ui_browser__set_color(&self->b, color);
+		ui_browser__set_percent_color(&self->b, percent, current_entry);
 		ui_browser__gotorc(&self->b, row, 0);
 		if (symbol_conf.use_callchain) {
 			slsmg_printf("%c ", folded_sign);
 			width -= 2;
 		}
+
+		slsmg_printf(" %5.2f%%", percent);
+
+		/* The scroll bar isn't being used */
+		if (!self->b.navkeypressed)
+			width += 1;
+
+		if (!current_entry || !self->b.navkeypressed)
+			ui_browser__set_color(&self->b, HE_COLORSET_NORMAL);
+
+		if (symbol_conf.show_nr_samples) {
+			slsmg_printf(" %11u", entry->nr_events);
+			width -= 12;
+		}
+
+		if (symbol_conf.show_total_period) {
+			slsmg_printf(" %12" PRIu64, entry->period);
+			width -= 13;
+		}
+
 		slsmg_write_nstring(s, width);
 		++row;
 		++printed;
@@ -585,14 +604,23 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	return printed;
 }
 
+static void ui_browser__hists_init_top(struct ui_browser *browser)
+{
+	if (browser->top == NULL) {
+		struct hist_browser *hb;
+
+		hb = container_of(browser, struct hist_browser, b);
+		browser->top = rb_first(&hb->hists->entries);
+	}
+}
+
 static unsigned int hist_browser__refresh(struct ui_browser *self)
 {
 	unsigned row = 0;
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(self, struct hist_browser, b);
 
-	if (self->top == NULL)
-		self->top = rb_first(&hb->hists->entries);
+	ui_browser__hists_init_top(self);
 
 	for (nd = self->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
@@ -644,6 +672,8 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	if (self->nr_entries == 0)
 		return;
 
+	ui_browser__hists_init_top(self);
+
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(self->entries));
@@ -761,6 +791,8 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		self->hists = hists;
 		self->b.refresh = hist_browser__refresh;
 		self->b.seek = ui_browser__hists_seek;
+		self->b.use_navkeypressed = true,
+		self->has_symbols = sort_sym.list.next != NULL;
 	}
 
 	return self;
@@ -782,11 +814,12 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 }
 
 static int hists__browser_title(struct hists *self, char *bf, size_t size,
-				const char *ev_name, const struct dso *dso,
-				const struct thread *thread)
+				const char *ev_name)
 {
 	char unit;
 	int printed;
+	const struct dso *dso = self->dso_filter;
+	const struct thread *thread = self->thread_filter;
 	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
 
 	nr_events = convert_unit(nr_events, &unit);
@@ -803,16 +836,15 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	return printed;
 }
 
-static int perf_evsel__hists_browse(struct perf_evsel *evsel,
+static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
-				    bool left_exits)
+				    bool left_exits,
+				    void(*timer)(void *arg), void *arg,
+				    int delay_secs)
 {
 	struct hists *self = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
-	const struct thread *thread_filter = NULL;
-	const struct dso *dso_filter = NULL;
-	char msg[160];
 	int key = -1;
 
 	if (browser == NULL)
@@ -824,8 +856,6 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 
 	ui_helpline__push(helpline);
 
-	hists__browser_title(self, msg, sizeof(msg), ev_name,
-			     dso_filter, thread_filter);
 	while (1) {
 		const struct thread *thread = NULL;
 		const struct dso *dso = NULL;
@@ -834,7 +864,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    browse_map = -2;
 
-		key = hist_browser__run(browser, msg);
+		key = hist_browser__run(browser, ev_name, timer, arg, delay_secs);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -842,14 +872,23 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 		}
 
 		switch (key) {
-		case NEWT_KEY_TAB:
-		case NEWT_KEY_UNTAB:
+		case K_TAB:
+		case K_UNTAB:
+			if (nr_events == 1)
+				continue;
 			/*
 			 * Exit the browser, let hists__browser_tree
 			 * go to the next or previous
 			 */
 			goto out_free_stack;
 		case 'a':
+			if (!browser->has_symbols) {
+				ui__warning(
+			"Annotation is only available for symbolic views, "
+			"include \"sym\" in --sort to use it.");
+				continue;
+			}
+
 			if (browser->selection == NULL ||
 			    browser->selection->sym == NULL ||
 			    browser->selection->map->dso->annotate_warned)
@@ -859,25 +898,29 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
-		case NEWT_KEY_F1:
+		case K_F1:
 		case 'h':
 		case '?':
-			ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
-					"<-        Zoom out\n"
-					"a         Annotate current symbol\n"
-					"h/?/F1    Show this window\n"
-					"C         Collapse all callchains\n"
-					"E         Expand all callchains\n"
-					"d         Zoom into current DSO\n"
-					"t         Zoom into current Thread\n"
-					"TAB/UNTAB Switch events\n"
-					"q/CTRL+C  Exit browser");
+			ui__help_window("h/?/F1        Show this window\n"
+					"UP/DOWN/PGUP\n"
+					"PGDN/SPACE    Navigate\n"
+					"q/ESC/CTRL+C  Exit browser\n\n"
+					"For multiple event sessions:\n\n"
+					"TAB/UNTAB Switch events\n\n"
+					"For symbolic views (--sort has sym):\n\n"
+					"->            Zoom into DSO/Threads & Annotate current symbol\n"
+					"<-            Zoom out\n"
+					"a             Annotate current symbol\n"
+					"C             Collapse all callchains\n"
+					"E             Expand all callchains\n"
+					"d             Zoom into current DSO\n"
+					"t             Zoom into current Thread\n");
 			continue;
-		case NEWT_KEY_ENTER:
-		case NEWT_KEY_RIGHT:
+		case K_ENTER:
+		case K_RIGHT:
 			/* menu */
 			break;
-		case NEWT_KEY_LEFT: {
+		case K_LEFT: {
 			const void *top;
 
 			if (pstack__empty(fstack)) {
@@ -889,21 +932,27 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 				continue;
 			}
 			top = pstack__pop(fstack);
-			if (top == &dso_filter)
+			if (top == &browser->hists->dso_filter)
 				goto zoom_out_dso;
-			if (top == &thread_filter)
+			if (top == &browser->hists->thread_filter)
 				goto zoom_out_thread;
 			continue;
 		}
-		case NEWT_KEY_ESCAPE:
+		case K_ESC:
 			if (!left_exits &&
 			    !ui__dialog_yesno("Do you really want to exit?"))
 				continue;
 			/* Fall thru */
-		default:
+		case 'q':
+		case CTRL('c'):
 			goto out_free_stack;
+		default:
+			continue;
 		}
 
+		if (!browser->has_symbols)
+			goto add_exit_option;
+
 		if (browser->selection != NULL &&
 		    browser->selection->sym != NULL &&
 		    !browser->selection->map->dso->annotate_warned &&
@@ -913,14 +962,14 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
-			     (thread_filter ? "out of" : "into"),
+			     (browser->hists->thread_filter ? "out of" : "into"),
 			     (thread->comm_set ? thread->comm : ""),
 			     thread->pid) > 0)
 			zoom_thread = nr_options++;
 
 		if (dso != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s DSO",
-			     (dso_filter ? "out of" : "into"),
+			     (browser->hists->dso_filter ? "out of" : "into"),
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
@@ -928,7 +977,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 		    browser->selection->map != NULL &&
 		    asprintf(&options[nr_options], "Browse map details") > 0)
 			browse_map = nr_options++;
-
+add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 
 		choice = ui__popup_menu(nr_options, options);
@@ -948,46 +997,52 @@ do_annotate:
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
 				continue;
-
-			hist_entry__tui_annotate(he, evsel->idx);
+			/*
+			 * Don't let this be freed, say, by hists__decay_entry.
+			 */
+			he->used = true;
+			hist_entry__tui_annotate(he, evsel->idx, nr_events,
+						 timer, arg, delay_secs);
+			he->used = false;
+			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
 zoom_dso:
-			if (dso_filter) {
-				pstack__remove(fstack, &dso_filter);
+			if (browser->hists->dso_filter) {
+				pstack__remove(fstack, &browser->hists->dso_filter);
 zoom_out_dso:
 				ui_helpline__pop();
-				dso_filter = NULL;
+				browser->hists->dso_filter = NULL;
+				sort_dso.elide = false;
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
-				dso_filter = dso;
-				pstack__push(fstack, &dso_filter);
+				browser->hists->dso_filter = dso;
+				sort_dso.elide = true;
+				pstack__push(fstack, &browser->hists->dso_filter);
 			}
-			hists__filter_by_dso(self, dso_filter);
-			hists__browser_title(self, msg, sizeof(msg), ev_name,
-					     dso_filter, thread_filter);
+			hists__filter_by_dso(self);
 			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
-			if (thread_filter) {
-				pstack__remove(fstack, &thread_filter);
+			if (browser->hists->thread_filter) {
+				pstack__remove(fstack, &browser->hists->thread_filter);
 zoom_out_thread:
 				ui_helpline__pop();
-				thread_filter = NULL;
+				browser->hists->thread_filter = NULL;
+				sort_thread.elide = false;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
 						   thread->pid);
-				thread_filter = thread;
-				pstack__push(fstack, &thread_filter);
+				browser->hists->thread_filter = thread;
+				sort_thread.elide = true;
+				pstack__push(fstack, &browser->hists->thread_filter);
 			}
-			hists__filter_by_thread(self, thread_filter);
-			hists__browser_title(self, msg, sizeof(msg), ev_name,
-					     dso_filter, thread_filter);
+			hists__filter_by_thread(self);
 			hist_browser__reset(browser);
 		}
 	}
@@ -1026,9 +1081,10 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		menu->selection = evsel;
 }
 
-static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help)
+static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
+				int nr_events, const char *help,
+				void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *ev_name, *title = "Available samples";
@@ -1038,50 +1094,65 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help)
 			     "ESC: exit, ENTER|->: Browse histograms") < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&menu->b, exit_keys);
-
 	while (1) {
-		key = ui_browser__run(&menu->b);
+		key = ui_browser__run(&menu->b, delay_secs);
 
 		switch (key) {
-		case NEWT_KEY_RIGHT:
-		case NEWT_KEY_ENTER:
+		case K_TIMER:
+			timer(arg);
+			continue;
+		case K_RIGHT:
+		case K_ENTER:
 			if (!menu->selection)
 				continue;
 			pos = menu->selection;
 browse_hists:
+			perf_evlist__set_selected(evlist, pos);
+			/*
+			 * Give the calling tool a chance to populate the non
+			 * default evsel resorted hists tree.
+			 */
+			if (timer)
+				timer(arg);
 			ev_name = event_name(pos);
-			key = perf_evsel__hists_browse(pos, help, ev_name, true);
+			key = perf_evsel__hists_browse(pos, nr_events, help,
+						       ev_name, true, timer,
+						       arg, delay_secs);
 			ui_browser__show_title(&menu->b, title);
-			break;
-		case NEWT_KEY_LEFT:
+			switch (key) {
+			case K_TAB:
+				if (pos->node.next == &evlist->entries)
+					pos = list_entry(evlist->entries.next, struct perf_evsel, node);
+				else
+					pos = list_entry(pos->node.next, struct perf_evsel, node);
+				goto browse_hists;
+			case K_UNTAB:
+				if (pos->node.prev == &evlist->entries)
+					pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
+				else
+					pos = list_entry(pos->node.prev, struct perf_evsel, node);
+				goto browse_hists;
+			case K_ESC:
+				if (!ui__dialog_yesno("Do you really want to exit?"))
+					continue;
+				/* Fall thru */
+			case 'q':
+			case CTRL('c'):
+				goto out;
+			default:
+				continue;
+			}
+		case K_LEFT:
 			continue;
-		case NEWT_KEY_ESCAPE:
+		case K_ESC:
 			if (!ui__dialog_yesno("Do you really want to exit?"))
 				continue;
 			/* Fall thru */
-		default:
-			goto out;
-		}
-
-		switch (key) {
-		case NEWT_KEY_TAB:
-			if (pos->node.next == &evlist->entries)
-				pos = list_entry(evlist->entries.next, struct perf_evsel, node);
-			else
-				pos = list_entry(pos->node.next, struct perf_evsel, node);
-			goto browse_hists;
-		case NEWT_KEY_UNTAB:
-			if (pos->node.prev == &evlist->entries)
-				pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
-			else
-				pos = list_entry(pos->node.prev, struct perf_evsel, node);
-			goto browse_hists;
 		case 'q':
 		case CTRL('c'):
 			goto out;
 		default:
-			break;
+			continue;
 		}
 	}
 
@@ -1091,7 +1162,9 @@ out:
 }
 
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
-					   const char *help)
+					   const char *help,
+					   void(*timer)(void *arg), void *arg,
+					   int delay_secs)
 {
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
@@ -1121,18 +1194,24 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			pos->name = strdup(ev_name);
 	}
 
-	return perf_evsel_menu__run(&menu, help);
+	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, timer,
+				    arg, delay_secs);
 }
 
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help)
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int delay_secs)
 {
 
 	if (evlist->nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = event_name(first);
-		return perf_evsel__hists_browse(first, help, ev_name, false);
+		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
+						ev_name, false, timer, arg,
+						delay_secs);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help);
+	return __perf_evlist__tui_browse_hists(evlist, help,
+					       timer, arg, delay_secs);
 }
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 8462bff..6905bcc 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -1,5 +1,6 @@
 #include "../libslang.h"
 #include <elf.h>
+#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <ctype.h>
@@ -108,11 +109,8 @@ static int map_browser__run(struct map_browser *self)
 			     verbose ? "" : "restart with -v to use") < 0)
 		return -1;
 
-	if (verbose)
-		ui_browser__add_exit_key(&self->b, '/');
-
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, 0);
 
 		if (verbose && key == '/')
 			map_browser__search(self);
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
deleted file mode 100644
index 88403cf..0000000
--- a/tools/perf/util/ui/browsers/top.c
+++ /dev/null
@@ -1,212 +0,0 @@
-/*
- * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
- *
- * Parts came from builtin-{top,stat,record}.c, see those files for further
- * copyright notes.
- *
- * Released under the GPL v2. (and only v2, not any later version)
- */
-#include "../browser.h"
-#include "../../annotate.h"
-#include "../helpline.h"
-#include "../libslang.h"
-#include "../util.h"
-#include "../../evlist.h"
-#include "../../hist.h"
-#include "../../sort.h"
-#include "../../symbol.h"
-#include "../../top.h"
-
-struct perf_top_browser {
-	struct ui_browser b;
-	struct rb_root	  root;
-	struct sym_entry  *selection;
-	float		  sum_ksamples;
-	int		  dso_width;
-	int		  dso_short_width;
-	int		  sym_width;
-};
-
-static void perf_top_browser__write(struct ui_browser *browser, void *entry, int row)
-{
-	struct perf_top_browser *top_browser = container_of(browser, struct perf_top_browser, b);
-	struct sym_entry *syme = rb_entry(entry, struct sym_entry, rb_node);
-	bool current_entry = ui_browser__is_current_entry(browser, row);
-	struct symbol *symbol = sym_entry__symbol(syme);
-	struct perf_top *top = browser->priv;
-	int width = browser->width;
-	double pcnt;
-
-	pcnt = 100.0 - (100.0 * ((top_browser->sum_ksamples - syme->snap_count) /
-				 top_browser->sum_ksamples));
-	ui_browser__set_percent_color(browser, pcnt, current_entry);
-
-	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
-		slsmg_printf("%20.2f ", syme->weight);
-		width -= 24;
-	} else {
-		slsmg_printf("%9.1f %10ld ", syme->weight, syme->snap_count);
-		width -= 23;
-	}
-
-	slsmg_printf("%4.1f%%", pcnt);
-	width -= 7;
-
-	if (verbose) {
-		slsmg_printf(" %016" PRIx64, symbol->start);
-		width -= 17;
-	}
-
-	slsmg_printf(" %-*.*s ", top_browser->sym_width, top_browser->sym_width,
-		     symbol->name);
-	width -= top_browser->sym_width;
-	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
-				syme->map->dso->long_name :
-				syme->map->dso->short_name, width);
-
-	if (current_entry)
-		top_browser->selection = syme;
-}
-
-static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
-{
-	struct perf_top *top = browser->b.priv;
-	u64 top_idx = browser->b.top_idx;
-
-	browser->root = RB_ROOT;
-	browser->b.top = NULL;
-	browser->sum_ksamples = perf_top__decay_samples(top, &browser->root);
-	/*
- 	 * No active symbols
- 	 */
-	if (top->rb_entries == 0)
-		return;
-
-	perf_top__find_widths(top, &browser->root, &browser->dso_width,
-			      &browser->dso_short_width,
-                              &browser->sym_width);
-	if (browser->sym_width + browser->dso_width > browser->b.width - 29) {
-		browser->dso_width = browser->dso_short_width;
-		if (browser->sym_width + browser->dso_width > browser->b.width - 29)
-			browser->sym_width = browser->b.width - browser->dso_width - 29;
-	}
-
-	/*
-	 * Adjust the ui_browser indexes since the entries in the browser->root
-	 * rb_tree may have changed, then seek it from start, so that we get a
-	 * possible new top of the screen.
- 	 */
-	browser->b.nr_entries = top->rb_entries;
-
-	if (top_idx >= browser->b.nr_entries) {
-		if (browser->b.height >= browser->b.nr_entries)
-			top_idx = browser->b.nr_entries - browser->b.height;
-		else
-			top_idx = 0;
-	}
-
-	if (browser->b.index >= top_idx + browser->b.height)
-		browser->b.index = top_idx + browser->b.index - browser->b.top_idx;
-
-	if (browser->b.index >= browser->b.nr_entries)
-		browser->b.index = browser->b.nr_entries - 1;
-
-	browser->b.top_idx = top_idx;
-	browser->b.seek(&browser->b, top_idx, SEEK_SET);
-}
-
-static void perf_top_browser__annotate(struct perf_top_browser *browser)
-{
-	struct sym_entry *syme = browser->selection;
-	struct symbol *sym = sym_entry__symbol(syme);
-	struct annotation *notes = symbol__annotation(sym);
-	struct perf_top *top = browser->b.priv;
-
-	if (notes->src != NULL)
-		goto do_annotation;
-
-	pthread_mutex_lock(&notes->lock);
-
-	top->sym_filter_entry = NULL;
-
-	if (symbol__alloc_hist(sym, top->evlist->nr_entries) < 0) {
-		pr_err("Not enough memory for annotating '%s' symbol!\n",
-		       sym->name);
-		pthread_mutex_unlock(&notes->lock);
-		return;
-	}
-
-	top->sym_filter_entry = syme;
-
-	pthread_mutex_unlock(&notes->lock);
-do_annotation:
-	symbol__tui_annotate(sym, syme->map, 0, top->delay_secs * 1000);
-}
-
-static int perf_top_browser__run(struct perf_top_browser *browser)
-{
-	int key;
-	char title[160];
-	struct perf_top *top = browser->b.priv;
-	int delay_msecs = top->delay_secs * 1000;
-	int exit_keys[] = { 'a', NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
-
-	perf_top_browser__update_rb_tree(browser);
-        perf_top__header_snprintf(top, title, sizeof(title));
-        perf_top__reset_sample_counters(top);
-
-	if (ui_browser__show(&browser->b, title,
-			     "ESC: exit, ENTER|->|a: Live Annotate") < 0)
-		return -1;
-
-	newtFormSetTimer(browser->b.form, delay_msecs);
-	ui_browser__add_exit_keys(&browser->b, exit_keys);
-
-	while (1) {
-		key = ui_browser__run(&browser->b);
-
-		switch (key) {
-		case -1:
-			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
-			perf_top_browser__update_rb_tree(browser);
-			perf_top__header_snprintf(top, title, sizeof(title));
-			perf_top__reset_sample_counters(top);
-			ui_browser__set_color(&browser->b, NEWT_COLORSET_ROOT);
-			SLsmg_gotorc(0, 0);
-			slsmg_write_nstring(title, browser->b.width);
-			break;
-		case 'a':
-		case NEWT_KEY_RIGHT:
-		case NEWT_KEY_ENTER:
-			if (browser->selection)
-				perf_top_browser__annotate(browser);
-			break;
-		case NEWT_KEY_LEFT:
-			continue;
-		case NEWT_KEY_ESCAPE:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
-				continue;
-			/* Fall thru */
-		default:
-			goto out;
-		}
-	}
-out:
-	ui_browser__hide(&browser->b);
-	return key;
-}
-
-int perf_top__tui_browser(struct perf_top *top)
-{
-	struct perf_top_browser browser = {
-		.b = {
-			.entries = &browser.root,
-			.refresh = ui_browser__rb_tree_refresh,
-			.seek	 = ui_browser__rb_tree_seek,
-			.write	 = perf_top_browser__write,
-			.priv	 = top,
-		},
-	};
-
-	return perf_top_browser__run(&browser);
-}
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index ab6028d..fdcbc02 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -1,6 +1,9 @@
 #ifndef _PERF_UI_HELPLINE_H_
 #define _PERF_UI_HELPLINE_H_ 1
 
+#include <stdio.h>
+#include <stdarg.h>
+
 void ui_helpline__init(void);
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/util/ui/keysyms.h
new file mode 100644
index 0000000..3458b19
--- /dev/null
+++ b/tools/perf/util/ui/keysyms.h
@@ -0,0 +1,25 @@
+#ifndef _PERF_KEYSYMS_H_
+#define _PERF_KEYSYMS_H_ 1
+
+#include "libslang.h"
+
+#define K_DOWN	SL_KEY_DOWN
+#define K_END	SL_KEY_END
+#define K_ENTER	'\r'
+#define K_ESC	033
+#define K_F1	SL_KEY_F(1)
+#define K_HOME	SL_KEY_HOME
+#define K_LEFT	SL_KEY_LEFT
+#define K_PGDN	SL_KEY_NPAGE
+#define K_PGUP	SL_KEY_PPAGE
+#define K_RIGHT	SL_KEY_RIGHT
+#define K_TAB	'\t'
+#define K_UNTAB	SL_KEY_UNTAB
+#define K_UP	SL_KEY_UP
+
+/* Not really keys */
+#define K_TIMER	 -1
+#define K_ERROR	 -2
+#define K_RESIZE -3
+
+#endif /* _PERF_KEYSYMS_H_ */
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/util/ui/libslang.h
index 2b63e1c..4d54b64 100644
--- a/tools/perf/util/ui/libslang.h
+++ b/tools/perf/util/ui/libslang.h
@@ -24,4 +24,6 @@
 #define sltt_set_color SLtt_set_color
 #endif
 
+#define SL_KEY_UNTAB 0x1000
+
 #endif /* _PERF_UI_SLANG_H_ */
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index ee46d67..1e6ba06 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -7,6 +7,7 @@
 #include "browser.h"
 #include "helpline.h"
 #include "ui.h"
+#include "libslang.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
@@ -17,6 +18,33 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
+static int ui__init(void)
+{
+	int err = SLkp_init();
+
+	if (err < 0)
+		goto out;
+
+	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
+out:
+	return err;
+}
+
+static void ui__exit(void)
+{
+	SLtt_set_cursor_visibility(1);
+	SLsmg_refresh();
+	SLsmg_reset_smg();
+	SLang_reset_tty();
+}
+
+static void ui__signal(int sig)
+{
+	ui__exit();
+	psignal(sig, "perf");
+	exit(0);
+}
+
 void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || !use_browser || dump_trace) {
@@ -28,10 +56,16 @@ void setup_browser(bool fallback_to_pager)
 
 	use_browser = 1;
 	newtInit();
-	newtCls();
+	ui__init();
 	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
+
+	signal(SIGSEGV, ui__signal);
+	signal(SIGFPE, ui__signal);
+	signal(SIGINT, ui__signal);
+	signal(SIGQUIT, ui__signal);
+	signal(SIGTERM, ui__signal);
 }
 
 void exit_browser(bool wait_for_ok)
@@ -41,6 +75,6 @@ void exit_browser(bool wait_for_ok)
 			char title[] = "Fatal Error", ok[] = "Ok";
 			newtWinMessage(title, ok, ui_helpline__last_msg);
 		}
-		newtFinished();
+		ui__exit();
 	}
 }
