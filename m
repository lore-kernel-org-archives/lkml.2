Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1AFJRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:17:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab1AFJRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:17:16 -0500
Date: Thu, 6 Jan 2011 10:16:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v2.6.38
Message-ID: <20110106091655.GA15853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

 Thanks,

	Ingo

------------------>
Akihiro Nagai (1):
      perf options: add OPT_CALLBACK_DEFAULT_NOOPT

Andi Kleen (1):
      x86: Set cpu masks before calling CPU_STARTING notifiers

Arnaldo Carvalho de Melo (32):
      perf tools: Change my maintainer address
      perf record: Add option to disable collecting build-ids
      perf events: Default to using event__process_lost
      perf tools: Fix lost and unknown events handling
      perf events: Precalculate the header space for PERF_SAMPLE_ fields
      perf debug: Simplify trace_event
      perf stat: Use --big-num format by default
      perf events: Separate the routines handling the PERF_SAMPLE_ identity fields
      perf events: Make sample_type identity fields available in all PERF_RECORD_ events
      perf session: Parse sample earlier
      perf tools: Ask for ID PERF_SAMPLE_ info on all PERF_RECORD_ events
      perf session: Remove unneeded dump_printf calls
      perf symbols: Improve kallsyms symbol end addr calculation
      perf test: Look forward for symbol aliases
      perf script: Finish the rename from trace to script
      perf record: Fix use of sample_id_all userspace with !sample_id_all kernels
      perf script: Fix event ordering settings to work with older kernels
      perf tools: Introduce event selectors
      perf evsel: Adopt MATCH_EVENT macro from 'stat'
      perf util: Move do_read from session to util
      perf evsel: Delete the event selectors at exit
      perf evsel: Steal the counter reading routines from stat
      perf evsel: Introduce per cpu and per thread open helpers
      perf tools: Refactor cpumap to hold nr and the map
      perf tools: Refactor all_tids to hold nr and the map
      perf evsel: Use {cpu,thread}_map to shorten list of parameters
      perf evsel: Auto allocate resources needed for some methods
      perf test: Add test for counting open syscalls
      perf test: Clarify some error reports in the open syscall test
      perf session: Warn about errors when processing pipe events too
      perf script: Use the default lost event handler
      perf script: Make some lists static

Chris Samuel (1):
      perf tools: Catch a few uncheck calloc/malloc's

Corey Ashford (2):
      perf stat: Change and clean up sys_perf_event_open error handling
      perf tools: fix event parsing of comma-separated tracepoint events

Cyrill Gorcunov (1):
      perf, x86: P4 PMU - describe config format

David Ahern (2):
      perf report: Allow user to specify path to kallsyms file
      perf symbols: Add symfs option for off-box analysis using specified tree

Don Zickus (8):
      x86, nmi_watchdog: Remove the old nmi_watchdog
      x86, nmi_watchdog: Remove all stub function calls from old nmi_watchdog
      perf packaging: add memcpy to perf MANIFEST
      lockup detector: Compile fixes from removing the old x86 nmi watchdog
      x86, NMI: Add back unknown_nmi_panic and nmi_watchdog sysctls
      x86, watchdog: Compile fix when CONFIG_LOCAL_APIC not enabled
      x86, nmi_watchdog: Remove ARCH_HAS_NMI_WATCHDOG and rely on CONFIG_HARDLOCKUP_DETECTOR
      x86: Only call smp_processor_id in non-preempt cases

Dongdong Deng (1):
      x86: Avoid calling arch_trigger_all_cpu_backtrace() at the same time

Franck Bui-Huu (11):
      perf: Introduce is_sampling_event()
      perf: Limit event refresh to sampling event
      perf: Don't bother to init the hrtimer for no SW sampling counters
      perf probe: Make -L display the absolute path of the dumped file
      perf probe: Rewrite show_one_line() to make it simpler
      perf probe: Clean up redundant tests in show_line_range()
      perf probe: Fix line range description since a single file is allowed
      perf probe: Don't always consider EOF as an error when listing source code
      perf probe: Handle gracefully some stupid and buggy line syntaxes
      perf probe: Fix wrong warning in __show_one_line() if read(1) errors happen
      perf probe: Fix short file name probe location reporting

Frederic Weisbecker (5):
      tracing: New flag to allow non privileged users to use a trace event
      tracing: New macro to set up initial event flags value
      tracing: Allow raw syscall trace events for non privileged users
      tracing: Allow syscall trace events for non privileged users
      tracing: Remove useless syscall ftrace_event_call declaration

Hitoshi Mitake (2):
      perf bench: Print both of prefaulted and no prefaulted results by default
      perf bench: Add feature that measures the performance of the arch/x86/lib/memcpy_64.S memcpy routines via 'perf bench mem'

Huang Ying (1):
      x86, NMI: Add touch_nmi_watchdog to io_check_error delay

Ian Munsie (5):
      perf symbols: Correct final kernel map guesses
      perf hist: Better displaying of unresolved DSOs and symbols
      perf makefile: Allow strong and weak functions in LIB_OBJS
      perf session: Fallback to unordered processing if no sample_id_all
      perf record,report,annotate,diff: Process events in order

Ingo Molnar (2):
      perf: Rename 'perf trace' to 'perf script'
      perf, sparc: Fix CONFIG_PERF_EVENTS=y build error

Jean Pihet (2):
      perf: Add calls to suspend trace point
      tools, perf: Documentation for the power events API

Masami Hiramatsu (9):
      kprobes: Rename old_p to more appropriate name
      kprobes: Cleanup disabling and unregistering path
      kprobes: Separate kprobe optimizing code from optimizer
      kprobes: Support delayed unoptimizing
      kprobes: Reuse unused kprobe
      x86: Introduce text_poke_smp_batch() for batch-code modifying
      kprobes: Use text_poke_smp_batch for optimizing
      kprobes: Use text_poke_smp_batch for unoptimizing
      perf probe: Cleanup messages

Peter Zijlstra (11):
      scripts/tags.sh: Add magic for trace-events
      perf: Ignore non-sampling overflows
      perf, arch: Cleanup perf-pmu init vs lockup-detector
      perf, amd: Remove the nb lock
      perf: Stop all counters on reboot
      perf, x86: Detect broken BIOSes that corrupt the PMU
      perf: Move perf_event_init() into main.c
      init: Initialized IDR earlier
      perf: Dynamic pmu types
      perf: Sysfs enumeration
      perf, x86: Provide a PEBS capable cycle event

Rakib Mullick (1):
      x86: Address 'unused' warning in hw_nmi.c again

Robert Morell (1):
      perf tools: Remove hardcoded include paths for elfutils

Robert Richter (2):
      oprofile, x86: Add support for AMD family 15h
      oprofile, x86: Add support for 6 counters (AMD family 15h)

Shawn Bohrer (15):
      perf trace: Handle DT_UNKNOWN on filesystems that don't support d_type
      perf annotate: Document missing options.
      perf buildid-list: Document missing options
      perf diff: Fix displacement and modules options short flag
      perf diff: Document missing options
      perf kvm: Document missing options
      perf lock: Document missing options
      perf probe: Fix spelling mistake in documentation
      perf record: Document missing options
      perf report: Document missing options
      perf sched: Document missing options
      perf top: Document missing options
      perf trace: Document missing options
      perf test: Fix spelling mistake in documentation
      perf stat: Document missing options

Soeren Sandmann Pedersen (1):
      x86: Eliminate bp argument from the stack tracing routines

Stephane Eranian (4):
      perf stat: Add no-aggregation mode to -a
      perf stat: Add csv-style output
      perf script: Fix compiler warning in builtin_script.c:is_top_script()
      perf tools: Fix perf_event.h header usage

Steven Rostedt (2):
      tracing/events: Show real number in array fields
      tracing: Add TRACE_EVENT_CONDITIONAL()

Thomas Gleixner (19):
      perf session: Fix list sort algorithm
      perf session: Use appropriate pointer type instead of silly typecasting
      perf session: Cleanup __perf_session__process_events()
      perf session: Move ui_progress_update in __perf_session__process_events()
      perf session: Simplify termination checks
      perf session: Use sensible mmap size
      perf session: Keep file mmaped instead of malloc/memcpy
      perf session: Cache sample objects
      perf session: Allocate chunks of sample objects
      perf events: Fix event inherit fallout of precalculated headers
      perf session: Sort all events if ordered_samples=true
      perf event: Prevent unbound event__name array access
      perf session: Dont queue events w/o timestamps
      perf session: Consolidate the dump code
      perf session: Store file offset in sample_queue
      perf session: Add file_offset to event delivery function
      perf session: Move dump code to event delivery path
      perf session: Split out sample preprocessing
      perf session: Split out user event processing

Thomas Renninger (3):
      perf: Do not export power_frequency, but power_start event
      perf: Clean up power events by introducing new, more generic ones
      perf timechart: Adjust perf timechart to the new power events

Wu Zhangjin (1):
      ftrace: Speed up recordmcount


 CREDITS                                            |    2 -
 Documentation/kernel-parameters.txt                |   10 +-
 Documentation/trace/events-power.txt               |   90 +++
 MAINTAINERS                                        |    2 +-
 arch/alpha/include/asm/perf_event.h                |    6 -
 arch/alpha/kernel/irq_alpha.c                      |    2 -
 arch/alpha/kernel/perf_event.c                     |   11 +-
 arch/arm/kernel/perf_event.c                       |    4 +-
 arch/mips/kernel/perf_event_mipsxx.c               |    2 +-
 arch/powerpc/kernel/e500-pmu.c                     |    2 +-
 arch/powerpc/kernel/mpc7450-pmu.c                  |    2 +-
 arch/powerpc/kernel/perf_event.c                   |    2 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c           |    2 +-
 arch/powerpc/kernel/power4-pmu.c                   |    2 +-
 arch/powerpc/kernel/power5+-pmu.c                  |    2 +-
 arch/powerpc/kernel/power5-pmu.c                   |    2 +-
 arch/powerpc/kernel/power6-pmu.c                   |    2 +-
 arch/powerpc/kernel/power7-pmu.c                   |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c                   |    2 +-
 arch/sh/kernel/cpu/sh4/perf_event.c                |    2 +-
 arch/sh/kernel/cpu/sh4a/perf_event.c               |    2 +-
 arch/sh/kernel/perf_event.c                        |    2 +-
 arch/sparc/include/asm/perf_event.h                |    4 -
 arch/sparc/kernel/nmi.c                            |    2 -
 arch/sparc/kernel/perf_event.c                     |    9 +-
 arch/x86/include/asm/alternative.h                 |    7 +
 arch/x86/include/asm/irq.h                         |    4 -
 arch/x86/include/asm/kdebug.h                      |    2 +-
 arch/x86/include/asm/msr-index.h                   |    4 +
 arch/x86/include/asm/nmi.h                         |   53 +--
 arch/x86/include/asm/perf_event.h                  |    2 -
 arch/x86/include/asm/perf_event_p4.h               |   63 ++-
 arch/x86/include/asm/smpboot_hooks.h               |    1 -
 arch/x86/include/asm/stacktrace.h                  |   33 +-
 arch/x86/include/asm/timer.h                       |    6 -
 arch/x86/kernel/alternative.c                      |   49 ++-
 arch/x86/kernel/apic/Makefile                      |    5 +-
 arch/x86/kernel/apic/apic.c                        |   15 +-
 arch/x86/kernel/apic/hw_nmi.c                      |   36 +-
 arch/x86/kernel/apic/io_apic.c                     |   46 --
 arch/x86/kernel/apic/nmi.c                         |  567 -----------------
 arch/x86/kernel/cpu/common.c                       |    1 -
 arch/x86/kernel/cpu/perf_event.c                   |   74 ++-
 arch/x86/kernel/cpu/perf_event_amd.c               |   16 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   26 +
 arch/x86/kernel/cpu/perfctr-watchdog.c             |  644 +-------------------
 arch/x86/kernel/dumpstack.c                        |   12 +-
 arch/x86/kernel/dumpstack_32.c                     |   25 +-
 arch/x86/kernel/dumpstack_64.c                     |   24 +-
 arch/x86/kernel/kprobes.c                          |  113 ++++-
 arch/x86/kernel/process.c                          |   10 +-
 arch/x86/kernel/process_32.c                       |    2 +-
 arch/x86/kernel/process_64.c                       |    2 +
 arch/x86/kernel/smpboot.c                          |   22 +-
 arch/x86/kernel/stacktrace.c                       |    8 +-
 arch/x86/kernel/time.c                             |   18 -
 arch/x86/kernel/traps.c                            |   35 +-
 arch/x86/mm/kmemcheck/error.c                      |    2 +-
 arch/x86/oprofile/backtrace.c                      |    2 +-
 arch/x86/oprofile/nmi_int.c                        |    3 +
 arch/x86/oprofile/nmi_timer_int.c                  |    3 -
 arch/x86/oprofile/op_model_amd.c                   |   54 ++-
 arch/x86/oprofile/op_model_p4.c                    |    2 +-
 drivers/acpi/acpica/nsinit.c                       |    2 -
 drivers/cpufreq/cpufreq.c                          |    1 +
 drivers/cpuidle/cpuidle.c                          |    1 +
 drivers/idle/intel_idle.c                          |    3 +-
 drivers/watchdog/hpwdt.c                           |   11 +-
 include/linux/ftrace_event.h                       |   14 +
 include/linux/kprobes.h                            |    4 +-
 include/linux/nmi.h                                |   10 +-
 include/linux/perf_event.h                         |   26 +-
 include/linux/sched.h                              |    4 +
 include/linux/stacktrace.h                         |    4 +-
 include/linux/syscalls.h                           |   10 +-
 include/linux/tracepoint.h                         |   33 +-
 include/trace/define_trace.h                       |   15 +
 include/trace/events/power.h                       |   98 +++-
 include/trace/events/syscalls.h                    |    4 +
 include/trace/ftrace.h                             |   21 +-
 init/main.c                                        |    5 +-
 kernel/hw_breakpoint.c                             |    2 +-
 kernel/kprobes.c                                   |  565 ++++++++++++------
 kernel/perf_event.c                                |  573 +++++++++++++-----
 kernel/power/suspend.c                             |    3 +
 kernel/sched.c                                     |    2 -
 kernel/sysctl.c                                    |   16 +-
 kernel/sysctl_binary.c                             |    1 -
 kernel/trace/Kconfig                               |   15 +
 kernel/trace/power-traces.c                        |    5 +-
 kernel/trace/trace_event_perf.c                    |   31 +-
 kernel/trace/trace_events.c                        |    6 +
 kernel/trace/trace_export.c                        |   14 +-
 kernel/watchdog.c                                  |    9 +-
 lib/Kconfig.debug                                  |    3 +-
 scripts/Makefile.build                             |   13 +-
 tools/perf/Documentation/perf-annotate.txt         |   37 ++-
 tools/perf/Documentation/perf-buildid-list.txt     |    3 +
 tools/perf/Documentation/perf-diff.txt             |   21 +-
 tools/perf/Documentation/perf-kvm.txt              |    8 +-
 tools/perf/Documentation/perf-lock.txt             |   15 +
 tools/perf/Documentation/perf-probe.txt            |    4 +-
 tools/perf/Documentation/perf-record.txt           |   22 +-
 tools/perf/Documentation/perf-report.txt           |   55 ++-
 tools/perf/Documentation/perf-sched.txt            |   18 +-
 .../{perf-trace-perl.txt => perf-script-perl.txt}  |   28 +-
 ...erf-trace-python.txt => perf-script-python.txt} |   88 ++--
 .../{perf-trace.txt => perf-script.txt}            |   61 +-
 tools/perf/Documentation/perf-stat.txt             |   44 ++-
 tools/perf/Documentation/perf-test.txt             |    2 +-
 tools/perf/Documentation/perf-timechart.txt        |    2 +
 tools/perf/Documentation/perf-top.txt              |   28 +-
 tools/perf/MANIFEST                                |    1 +
 tools/perf/Makefile                                |   23 +-
 tools/perf/bench/mem-memcpy-arch.h                 |   12 +
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h       |    4 +
 tools/perf/bench/mem-memcpy-x86-64-asm.S           |    2 +
 tools/perf/bench/mem-memcpy.c                      |  219 +++++--
 tools/perf/builtin-annotate.c                      |   10 +-
 tools/perf/builtin-buildid-list.c                  |    3 +-
 tools/perf/builtin-diff.c                          |   21 +-
 tools/perf/builtin-inject.c                        |   41 +-
 tools/perf/builtin-kmem.c                          |   27 +-
 tools/perf/builtin-lock.c                          |   23 +-
 tools/perf/builtin-record.c                        |  210 ++++---
 tools/perf/builtin-report.c                        |   23 +-
 tools/perf/builtin-sched.c                         |   33 +-
 tools/perf/{builtin-trace.c => builtin-script.c}   |  135 ++---
 tools/perf/builtin-stat.c                          |  531 ++++++++++------
 tools/perf/builtin-test.c                          |  110 ++++-
 tools/perf/builtin-timechart.c                     |  132 +++-
 tools/perf/builtin-top.c                           |  237 ++++----
 tools/perf/builtin.h                               |    2 +-
 tools/perf/command-list.txt                        |    2 +-
 tools/perf/feature-tests.mak                       |    4 +-
 tools/perf/perf.c                                  |    4 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    4 +-
 tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |    4 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    4 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +-
 tools/perf/scripts/perl/bin/rwtop-report           |    5 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    6 +-
 tools/perf/scripts/perl/check-perf-trace.pl        |    2 +-
 tools/perf/scripts/perl/rw-by-file.pl              |    2 +-
 tools/perf/scripts/perl/workqueue-stats.pl         |    2 +-
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |    2 +-
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../scripts/python/bin/futex-contention-report     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 tools/perf/scripts/python/check-perf-trace.py      |    2 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |    2 +-
 tools/perf/scripts/python/sched-migration.py       |    2 +-
 tools/perf/scripts/python/sctop.py                 |    2 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |    2 +-
 tools/perf/scripts/python/syscall-counts.py        |    2 +-
 tools/perf/util/build-id.c                         |    7 +-
 tools/perf/util/cpumap.c                           |  123 +++-
 tools/perf/util/cpumap.h                           |   10 +-
 tools/perf/util/debug.c                            |   42 +-
 tools/perf/util/debug.h                            |    2 +
 tools/perf/util/event.c                            |  358 +++++++----
 tools/perf/util/event.h                            |   30 +-
 tools/perf/util/evsel.c                            |  186 ++++++
 tools/perf/util/evsel.h                            |  115 ++++
 tools/perf/util/header.c                           |   58 ++-
 tools/perf/util/header.h                           |    5 +-
 tools/perf/util/hist.c                             |   23 +-
 tools/perf/util/hist.h                             |    2 +
 tools/perf/util/include/asm/cpufeature.h           |    9 +
 tools/perf/util/include/asm/dwarf2.h               |   11 +
 tools/perf/util/include/linux/bitops.h             |    5 +
 tools/perf/util/include/linux/linkage.h            |   13 +
 tools/perf/util/parse-events.c                     |  111 +++-
 tools/perf/util/parse-events.h                     |   19 +-
 tools/perf/util/parse-options.h                    |    4 +
 tools/perf/util/probe-event.c                      |  234 +++++---
 tools/perf/util/probe-finder.c                     |   42 +-
 tools/perf/util/probe-finder.h                     |    6 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    6 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |  579 ++++++++++++------
 tools/perf/util/session.h                          |   26 +-
 tools/perf/util/sort.c                             |    6 +-
 tools/perf/util/symbol.c                           |  139 ++++-
 tools/perf/util/symbol.h                           |    4 +-
 tools/perf/util/thread.c                           |   43 +-
 tools/perf/util/thread.h                           |   15 +-
 tools/perf/util/trace-event-info.c                 |   30 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/ui/util.c                          |   16 +-
 tools/perf/util/util.c                             |   17 +
 tools/perf/util/util.h                             |    1 +
 tools/perf/util/xyarray.c                          |   20 +
 tools/perf/util/xyarray.h                          |   20 +
 207 files changed, 4917 insertions(+), 3447 deletions(-)
 create mode 100644 Documentation/trace/events-power.txt
 delete mode 100644 arch/x86/kernel/apic/nmi.c
 rename tools/perf/Documentation/{perf-trace-perl.txt => perf-script-perl.txt} (90%)
 rename tools/perf/Documentation/{perf-trace-python.txt => perf-script-python.txt} (89%)
 rename tools/perf/Documentation/{perf-trace.txt => perf-script.txt} (62%)
 create mode 100644 tools/perf/bench/mem-memcpy-arch.h
 create mode 100644 tools/perf/bench/mem-memcpy-x86-64-asm-def.h
 create mode 100644 tools/perf/bench/mem-memcpy-x86-64-asm.S
 rename tools/perf/{builtin-trace.c => builtin-script.c} (83%)
 create mode 100644 tools/perf/util/evsel.c
 create mode 100644 tools/perf/util/evsel.h
 create mode 100644 tools/perf/util/include/asm/cpufeature.h
 create mode 100644 tools/perf/util/include/asm/dwarf2.h
 create mode 100644 tools/perf/util/include/linux/linkage.h
 create mode 100644 tools/perf/util/xyarray.c
 create mode 100644 tools/perf/util/xyarray.h

 [ combo patch omitted for mail size reasons. ]
