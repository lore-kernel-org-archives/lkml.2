Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab0HEHoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:44:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296Ab0HEHoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:44:00 -0400
Date: Thu, 5 Aug 2010 09:43:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Performance events updates for v2.6.36
Message-ID: <20100805074333.GA7786@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

Lots of updates. Note that it also includes the new generic soft/hard watchdog 
code and adds it for x86.

 Thanks,

	Ingo

------------------>
Américo Wang (1):
      tracing: Remove boot tracer

Andy Isaacson (2):
      perf debug: fix hex dump partial final line
      perf session: fix error message on failure to open perf.data

Arnaldo Carvalho de Melo (27):
      perf tools: Make target to generate self contained source tarball
      perf tools: Make event__preprocess_sample parse the sample
      perf tools: Allow building perf source tarballs on non-configured tree
      perf tools: Reorganize the Makefile feature tests
      perf ui: Introduce routine ui_browser__is_current_entry
      perf ui: Introduce ui_browser->seek to support multiple list structures
      perf ui: Separate showing the entries from running the browser
      perf ui: Move objdump_line specific stuff out of ui_browser
      perf ui: Make END go to the last entry, not the top of the last page
      perf ui: Make ui_browser__run exit on unhandled hot keys
      perf hists: Factor out duplicated code
      perf hists: Mark entries filtered by parent
      perf sort: Make column width code per hists instance
      perf ui: Restore SPACE as an alias to PGDN in annotate
      perf hist: Introduce routine to measure lenght of formatted entry
      perf ui: Consider the refreshed dimensions in ui_browser__show
      perf ui: Show the scroll bar over the left window frame
      perf ui: New hists tree widget
      perf man pages: Fix cut'n'paste error
      perf record: Release resources at exit
      perf symbols: Precisely specify if dso->{long,short}_name should be freed
      perf tui: Make CTRL+Z suspend perf
      perf tools: Release thread resources on PERF_RECORD_EXIT
      perf tools: Release session and symbol resources on exit
      perf session: Free the ref_reloc_sym memory at the right place
      perf session: Invalidate last_match when removing threads from rb_tree
      perf tools: Don't keep unreferenced maps when unmaps are detected

Arnd Bergmann (2):
      tracing: Use generic_file_llseek for debugfs
      oprofile: make event buffer nonseekable

Arun Sharma (1):
      perf report: Implement --sort cpu

Chase Douglas (2):
      perf probe: Add kernel source path option
      tracing/function-graph: Use correct string size for snprintf

Conny Seidel (1):
      perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available

Cyrill Gorcunov (2):
      perf, x86: Make a second write to performance counter if needed
      perf, x86: P4 PMU -- redesign cache events

Dan Carpenter (1):
      trace: strlen() return doesn't account for the NULL

Dave Martin (6):
      perf report: Don't abbreviate file paths relative to the cwd
      perf tools: Remove unneeded code for tracking the cwd in perf sessions
      perf tools: Factor out buildid reading and make it implicit in dso__load
      perf tools: remove extra build-id check factored into dso__load
      perf symbols: Improve debug image search when loading symbols
      perf events: Fix mmap offset determination

David Daney (1):
      tracing: Fix $mcount_regex for MIPS in recordmcount.pl

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Don Zickus (19):
      x86: Move notify_die from nmi.c to traps.c
      nmi_watchdog: Add new, generic implementation, using perf events
      nmi_watchdog: Config option to enable new nmi_watchdog
      nmi_watchdog: Use a boolean config flag for compiling
      nmi_watchdog: Compile and portability fixes
      nmi_watchdog: Fallback to software events when no hardware pmu detected
      nmi_watchdog: support for oprofile
      nmi_watchdog: Properly configure for software events
      nmi_watchdog: Fix undefined 'apic' build bug
      nmi_watchdog: Clean up various small details
      lockup_detector: Combine nmi_watchdog and softlockup detector
      lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
      lockup_detector: Remove old softlockup code
      lockup_detector: Remove nmi_watchdog.c file
      x86: Move trigger_all_cpu_backtrace to its own die_notifier
      x86: Cleanup hw_nmi.c cruft
      lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
      lockup_detector: Cross arch compile fixes
      lockup_detector: Convert per_cpu to __get_cpu_var for readability

Eric B Munson (2):
      perf: Add non-exec mmap() tracking
      perf symbols: Function descriptor symbol lookup

Frederic Weisbecker (28):
      lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
      lockup_detector: Fix forgotten config conversion
      lockup_detector: Update some config
      lockup_detector: Adapt CONFIG_PERF_EVENT_NMI to other archs
      lockup_detector: Introduce CONFIG_HARDLOCKUP_DETECTOR
      lockup_detector: Don't enable the lockup detector by default
      x86: Unify dumpstack.h and stacktrace.h
      perf: Drop the skip argument from perf_arch_fetch_regs_caller
      hw_breakpoints: Fix per task breakpoint tracking
      x86: Set resume bit before returning from breakpoint exception
      x86: Support for instruction breakpoints
      perf: Don't use 4 bytes as a default instruction breakpoint length
      perf: Don't print traces when debugging ordering
      perf: Report lost events in perf trace debug mode
      tracing: Update tracing branch url
      tracing: Remove ksym tracer
      tracing: Remove letfover markers section
      tracing: Remove sysprof ftrace plugin
      tracing: Remove special traces
      perf: Use tracepoint_synchronize_unregister() to flush any pending tracepoint call
      tracing: Drop cpparg() macro
      perf: New migration tool overview
      perf, sched migration: Handle ignored migrate out events
      perf, sched migration: Ignore unhandled task states
      perf, sched migration: Make it vertically scrollable
      perf, sched migration: Make the GUI class client agnostic
      perf, sched migration: Librarize the GUI class
      perf, sched migration: Librarize task states and event headers helpers

Gui Jianfeng (1):
      perf kvm: Get rid of unused guest_kallsyms

Ingo Molnar (4):
      nmi_watchdog: Only enable on x86 for now
      nmi_watchdog: Turn it off by default
      watchdog: Export touch_softlockup_watchdog
      x86, watchdog: Fix build error in hw_nmi.c

John Villalovos (1):
      Oprofile: Change CPUIDS from decimal to hex, and add some comments

KOSAKI Motohiro (1):
      tracing: Shrink max latency ringbuffer if unnecessary

Kirill Smelkov (1):
      perf tools: .gitignore += config.make config.make.autogen

Kulikov Vasiliy (1):
      kernel/watchdog: Initialize 'result'

Lai Jiangshan (1):
      tracing: Reduce latency and remove percpu trace_seq

Li Zefan (9):
      tracing: Remove kmemtrace ftrace plugin
      tracing: Use a global field list for all syscall exit events
      tracing: Don't allocate common fields for every trace events
      tracing: Convert some timer events to DEFINE_EVENT
      tracing: Convert more sched events to DEFINE_EVENT
      tracing: Remove test of NULL define_fields callback
      tracing: Remove redundant raw_init callbacks
      tracing: Remove open-coded __trace_add_event_call()
      tracing: Allow to disable cmdline recording

Livio Soares (1):
      perf, x86: Small fix to cpuid10_edx

Marcin Slusarz (1):
      x86,mmiotrace: Add support for tracing STOS instruction

Masami Hiramatsu (8):
      kprobes/x86: Fix kprobes to skip prefixes correctly
      tracing/kprobes: Support "string" type
      perf probe: Support "string" type
      perf probe: Support tracing an entry of array
      perf probe: Support static and global variables
      perf probe: Fix error message if get_real_path() failed
      perf probe: Support comp_dir to find an absolute source path
      perf probe: Fix the logic of die_compare_name

Matt Fleming (1):
      perf tools: Add DWARF register lookup for SH

Mike Frysinger (1):
      tracing/documentation: Document dynamic ftracer internals

Nikhil Rao (2):
      perf, sched migration: Fix key bindings
      perf, sched migration: Parameterize cpu height and spacing

Nobuhiro Iwamatsu (1):
      perf: Fix argument of perf_arch_fetch_caller_regs

Oleg Nesterov (2):
      x86: Make save_stack_address() !CONFIG_FRAME_POINTER friendly
      x86: Unify save_stack_address() and save_stack_address_nosched()

Peter Zijlstra (12):
      nmi_watchdog: Tell the world we're active
      perf, trace: Inline perf_swevent_put_recursion_context()
      perf, trace: Remove superfluous rcu_read_lock()
      perf: Cleanup {start,commit,cancel}_txn details
      perf: Rename perf_mmap_data to perf_buffer
      perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed
      arch: Implement local64_t
      perf: Add perf_event_count()
      perf: Add perf_event::child_count
      perf: Convert perf_event to local_t
      perf: Fix build breakage for architecutes without atomic64_t
      perf, powerpc: Convert the FSL driver to use local64_t

Richard Kennedy (1):
      trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit

Robert Schöne (1):
      x86, perf: Add power_end event to process_*.c cpu_idle routine

Scott Wood (1):
      perf, powerpc: fsl_emb: Restore setting perf_sample_data.period

Srikar Dronamraju (4):
      perf: Fix hist_entry__tui_annotate() build failure
      perf probe: Rename common fields/functions from kprobe to probe.
      perf: expose event__process function
      tracing/kprobes: unregister_trace_probe needs to be called under mutex

Stephane Eranian (6):
      perf report: Make -D print sampled CPU
      perf tools: Add the ability to specify list of cpus to monitor
      perf buildid: add perfconfig option to specify buildid cache dir
      perf annotate: Ask objdump to demangle symbols
      perf record: Avoid synthesizing mmap() for all processes in per-thread mode
      perf record: Add option to avoid updating buildid cache

Steven Rostedt (3):
      tracing/sched: Make preempt_schedule() notrace
      tracing: Remove ftrace_preempt_disable/enable
      tracing: Use class->reg() for all registering of events

Thomas Renninger (1):
      x86 cpufreq, perf: Make trace_power_frequency cpufreq driver independent

Tom Zanussi (1):
      perf scripts perl: Makefile fix


 Documentation/ABI/testing/debugfs-kmemtrace        |   71 --
 Documentation/kernel-parameters.txt                |    2 +
 Documentation/trace/ftrace-design.txt              |  153 +++-
 Documentation/trace/kmemtrace.txt                  |  126 ---
 Documentation/trace/kprobetrace.txt                |    2 +-
 MAINTAINERS                                        |    9 +-
 Makefile                                           |    4 +-
 arch/Kconfig                                       |    7 +
 arch/alpha/include/asm/local64.h                   |    1 +
 arch/arm/include/asm/local64.h                     |    1 +
 arch/arm/kernel/perf_event.c                       |   18 +-
 arch/avr32/include/asm/local64.h                   |    1 +
 arch/blackfin/include/asm/local64.h                |    1 +
 arch/cris/include/asm/local64.h                    |    1 +
 arch/frv/include/asm/local64.h                     |    1 +
 arch/frv/kernel/local64.h                          |    1 +
 arch/h8300/include/asm/local64.h                   |    1 +
 arch/ia64/include/asm/local64.h                    |    1 +
 arch/m32r/include/asm/local64.h                    |    1 +
 arch/m68k/include/asm/local64.h                    |    1 +
 arch/microblaze/include/asm/local64.h              |    1 +
 arch/mips/include/asm/local64.h                    |    1 +
 arch/mn10300/include/asm/local64.h                 |    1 +
 arch/parisc/include/asm/local64.h                  |    1 +
 arch/powerpc/include/asm/local64.h                 |    1 +
 arch/powerpc/include/asm/perf_event.h              |   12 +
 arch/powerpc/kernel/misc.S                         |   26 -
 arch/powerpc/kernel/perf_event.c                   |   41 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c           |   29 +-
 arch/s390/include/asm/local64.h                    |    1 +
 arch/score/include/asm/local64.h                   |    1 +
 arch/sh/include/asm/local64.h                      |    1 +
 arch/sh/kernel/perf_event.c                        |    6 +-
 arch/sparc/include/asm/local64.h                   |    1 +
 arch/sparc/include/asm/perf_event.h                |    8 +
 arch/sparc/kernel/helpers.S                        |    6 +-
 arch/sparc/kernel/perf_event.c                     |   25 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/hw_breakpoint.h               |    2 +-
 arch/x86/include/asm/local64.h                     |    1 +
 arch/x86/include/asm/nmi.h                         |    2 +
 arch/x86/include/asm/perf_event.h                  |   18 +-
 arch/x86/include/asm/perf_event_p4.h               |   99 +-
 arch/x86/include/asm/stacktrace.h                  |   49 +
 arch/x86/kernel/apic/Makefile                      |    7 +-
 arch/x86/kernel/apic/hw_nmi.c                      |  107 ++
 arch/x86/kernel/apic/nmi.c                         |    7 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c         |    3 -
 arch/x86/kernel/cpu/perf_event.c                   |   62 +-
 arch/x86/kernel/cpu/perf_event_p4.c                |  156 ++-
 arch/x86/kernel/dumpstack.c                        |    1 -
 arch/x86/kernel/dumpstack.h                        |   56 -
 arch/x86/kernel/dumpstack_32.c                     |    2 -
 arch/x86/kernel/dumpstack_64.c                     |    1 -
 arch/x86/kernel/hw_breakpoint.c                    |   51 +-
 arch/x86/kernel/kprobes.c                          |   33 +-
 arch/x86/kernel/process.c                          |    8 +-
 arch/x86/kernel/process_32.c                       |    4 +
 arch/x86/kernel/process_64.c                       |    5 +
 arch/x86/kernel/stacktrace.c                       |   31 +-
 arch/x86/kernel/traps.c                            |    7 +
 arch/x86/mm/pf_in.c                                |   30 +-
 arch/x86/oprofile/nmi_int.c                        |   16 +-
 arch/xtensa/include/asm/local64.h                  |    1 +
 drivers/cpufreq/cpufreq.c                          |    3 +
 drivers/cpuidle/cpuidle.c                          |    2 +-
 drivers/idle/intel_idle.c                          |    2 +-
 drivers/oprofile/event_buffer.c                    |    3 +-
 fs/exec.c                                          |    1 +
 include/asm-generic/local64.h                      |   96 ++
 include/asm-generic/vmlinux.lds.h                  |    4 -
 include/linux/ftrace.h                             |    5 +
 include/linux/ftrace_event.h                       |   18 +-
 include/linux/kernel.h                             |    5 -
 include/linux/kmemtrace.h                          |   25 -
 include/linux/nmi.h                                |   13 +
 include/linux/perf_event.h                         |   95 +-
 include/linux/sched.h                              |   24 +-
 include/linux/slab_def.h                           |    3 +-
 include/linux/slub_def.h                           |    3 +-
 include/linux/syscalls.h                           |    2 -
 include/trace/boot.h                               |   60 -
 include/trace/events/power.h                       |   27 +-
 include/trace/events/sched.h                       |   32 +-
 include/trace/events/timer.h                       |   80 +-
 include/trace/ftrace.h                             |   23 +-
 include/trace/syscall.h                            |    1 -
 init/main.c                                        |   29 +-
 kernel/Makefile                                    |    2 +-
 kernel/hw_breakpoint.c                             |   78 +-
 kernel/perf_event.c                                |  458 ++++----
 kernel/sched.c                                     |    6 +-
 kernel/softlockup.c                                |  293 -----
 kernel/sysctl.c                                    |   55 +-
 kernel/timer.c                                     |    1 -
 kernel/trace/Kconfig                               |   68 --
 kernel/trace/Makefile                              |    4 -
 kernel/trace/ftrace.c                              |    5 +-
 kernel/trace/kmemtrace.c                           |  529 ---------
 kernel/trace/ring_buffer.c                         |   40 +-
 kernel/trace/trace.c                               |  127 +--
 kernel/trace/trace.h                               |   90 +--
 kernel/trace/trace_boot.c                          |  185 ----
 kernel/trace/trace_clock.c                         |    5 +-
 kernel/trace/trace_entries.h                       |   94 --
 kernel/trace/trace_event_perf.c                    |   27 +-
 kernel/trace/trace_events.c                        |  299 +++---
 kernel/trace/trace_events_filter.c                 |   27 +-
 kernel/trace/trace_export.c                        |    8 +-
 kernel/trace/trace_functions.c                     |    6 +-
 kernel/trace/trace_functions_graph.c               |    3 +-
 kernel/trace/trace_irqsoff.c                       |    3 +
 kernel/trace/trace_kprobe.c                        |  383 +++++--
 kernel/trace/trace_ksym.c                          |  508 ---------
 kernel/trace/trace_output.c                        |   69 --
 kernel/trace/trace_sched_wakeup.c                  |    7 +-
 kernel/trace/trace_selftest.c                      |   87 --
 kernel/trace/trace_stack.c                         |    6 +-
 kernel/trace/trace_syscalls.c                      |    7 +-
 kernel/trace/trace_sysprof.c                       |  329 ------
 kernel/watchdog.c                                  |  567 ++++++++++
 lib/Kconfig.debug                                  |   35 +-
 mm/mmap.c                                          |    6 +-
 mm/slab.c                                          |    1 -
 mm/slob.c                                          |    4 +-
 mm/slub.c                                          |    1 -
 scripts/package/Makefile                           |   37 +-
 scripts/recordmcount.pl                            |    2 +-
 tools/perf/.gitignore                              |    2 +
 tools/perf/Documentation/perf-buildid-cache.txt    |    8 +-
 tools/perf/Documentation/perf-probe.txt            |    8 +-
 tools/perf/Documentation/perf-record.txt           |   13 +
 tools/perf/Documentation/perf-stat.txt             |    7 +
 tools/perf/Documentation/perf-top.txt              |    8 +-
 tools/perf/MANIFEST                                |   12 +
 tools/perf/Makefile                                |  113 +-
 tools/perf/arch/sh/Makefile                        |    4 +
 tools/perf/arch/sh/util/dwarf-regs.c               |   55 +
 tools/perf/builtin-annotate.c                      |    6 +-
 tools/perf/builtin-buildid-cache.c                 |    3 +-
 tools/perf/builtin-buildid-list.c                  |    4 +-
 tools/perf/builtin-diff.c                          |    9 +-
 tools/perf/builtin-probe.c                         |    3 +-
 tools/perf/builtin-record.c                        |   81 +-
 tools/perf/builtin-report.c                        |   27 +-
 tools/perf/builtin-stat.c                          |   14 +-
 tools/perf/builtin-timechart.c                     |   11 +-
 tools/perf/builtin-top.c                           |   40 +-
 tools/perf/builtin-trace.c                         |   32 +-
 tools/perf/feature-tests.mak                       |  119 ++
 tools/perf/perf-archive.sh                         |   20 +-
 tools/perf/perf.c                                  |    2 +
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   30 +
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |  184 +++
 .../perf/scripts/python/bin/sched-migration-record |    2 +
 .../perf/scripts/python/bin/sched-migration-report |    3 +
 tools/perf/scripts/python/sched-migration.py       |  461 ++++++++
 tools/perf/util/build-id.c                         |   28 +-
 tools/perf/util/cache.h                            |    1 +
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/callchain.h                        |    2 +-
 tools/perf/util/config.c                           |   64 ++-
 tools/perf/util/cpumap.c                           |   57 +-
 tools/perf/util/cpumap.h                           |    2 +-
 tools/perf/util/debug.c                            |   10 +-
 tools/perf/util/event.c                            |  107 ++-
 tools/perf/util/event.h                            |    6 +-
 tools/perf/util/header.c                           |   13 +-
 tools/perf/util/hist.c                             |  214 +++--
 tools/perf/util/hist.h                             |   30 +-
 tools/perf/util/map.c                              |  116 ++-
 tools/perf/util/map.h                              |   14 +-
 tools/perf/util/newt.c                             | 1164 +++++++++++++-------
 tools/perf/util/parse-events.c                     |   11 +-
 tools/perf/util/probe-event.c                      |  271 ++++--
 tools/perf/util/probe-event.h                      |   29 +-
 tools/perf/util/probe-finder.c                     |  248 ++++-
 tools/perf/util/probe-finder.h                     |   10 +-
 tools/perf/util/session.c                          |   62 +-
 tools/perf/util/sort.c                             |   40 +-
 tools/perf/util/sort.h                             |   22 +-
 tools/perf/util/symbol.c                           |  299 ++++--
 tools/perf/util/symbol.h                           |   18 +-
 tools/perf/util/thread.c                           |    7 +
 tools/perf/util/thread.h                           |    2 +
 tools/perf/util/util.h                             |    3 +
 186 files changed, 5641 insertions(+), 4835 deletions(-)
 delete mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
 delete mode 100644 Documentation/trace/kmemtrace.txt
 create mode 100644 arch/alpha/include/asm/local64.h
 create mode 100644 arch/arm/include/asm/local64.h
 create mode 100644 arch/avr32/include/asm/local64.h
 create mode 100644 arch/blackfin/include/asm/local64.h
 create mode 100644 arch/cris/include/asm/local64.h
 create mode 100644 arch/frv/include/asm/local64.h
 create mode 100644 arch/frv/kernel/local64.h
 create mode 100644 arch/h8300/include/asm/local64.h
 create mode 100644 arch/ia64/include/asm/local64.h
 create mode 100644 arch/m32r/include/asm/local64.h
 create mode 100644 arch/m68k/include/asm/local64.h
 create mode 100644 arch/microblaze/include/asm/local64.h
 create mode 100644 arch/mips/include/asm/local64.h
 create mode 100644 arch/mn10300/include/asm/local64.h
 create mode 100644 arch/parisc/include/asm/local64.h
 create mode 100644 arch/powerpc/include/asm/local64.h
 create mode 100644 arch/s390/include/asm/local64.h
 create mode 100644 arch/score/include/asm/local64.h
 create mode 100644 arch/sh/include/asm/local64.h
 create mode 100644 arch/sparc/include/asm/local64.h
 create mode 100644 arch/x86/include/asm/local64.h
 create mode 100644 arch/x86/kernel/apic/hw_nmi.c
 delete mode 100644 arch/x86/kernel/dumpstack.h
 create mode 100644 arch/xtensa/include/asm/local64.h
 create mode 100644 include/asm-generic/local64.h
 delete mode 100644 include/linux/kmemtrace.h
 delete mode 100644 include/trace/boot.h
 delete mode 100644 kernel/softlockup.c
 delete mode 100644 kernel/trace/kmemtrace.c
 delete mode 100644 kernel/trace/trace_boot.c
 delete mode 100644 kernel/trace/trace_ksym.c
 delete mode 100644 kernel/trace/trace_sysprof.c
 create mode 100644 kernel/watchdog.c
 create mode 100644 tools/perf/MANIFEST
 create mode 100644 tools/perf/arch/sh/Makefile
 create mode 100644 tools/perf/arch/sh/util/dwarf-regs.c
 create mode 100644 tools/perf/feature-tests.mak
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
 create mode 100644 tools/perf/scripts/python/bin/sched-migration-record
 create mode 100644 tools/perf/scripts/python/bin/sched-migration-report
 create mode 100644 tools/perf/scripts/python/sched-migration.py

 [ full diff omitted due to lkml mail size limits ]
