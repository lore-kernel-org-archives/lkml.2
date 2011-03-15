Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab1COUB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:01:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517Ab1COUBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:01:23 -0400
Date: Tue, 15 Mar 2011 21:01:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v2.6.39
Message-ID: <20110315200103.GA3966@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
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
Andi Kleen (2):
      perf: Add support for supplementary event registers
      perf: Fix LLC-* events on Intel Nehalem/Westmere

Arnaldo Carvalho de Melo (77):
      perf evsel: Introduce perf_evlist
      perf evlist: Adopt the pollfd array
      perf evsel: Support event groups
      perf evsel: Allow specifying if the inherit bit should be set
      perf top: Use perf_evsel__open
      perf record: Use perf_evsel__open
      perf evsel: Introduce mmap support
      perf record: Use struct perf_mmap and helpers
      perf record: Move perf_mmap__write_tail to perf.h
      perf evlist: Move the mmap array from perf_evsel
      perf record: Use perf_evlist__mmap
      perf tools: Add missing cpu_map__delete()
      perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus
      perf evlist: Steal mmap reading routine from 'perf top'
      perf test: Add test for the evlist mmap routines
      perf top: Add native_safe_halt to skip symbols
      perf tools: Pass the struct opt to the wildcard parsing routine
      perf threads: Move thread_map to separate file
      perf tools: Move event__parse_sample to evsel.c
      perf evsel: Introduce perf_evsel__{in,ex}it
      perf record: No need to check for overwrites
      perf events: Account PERF_RECORD_LOST events in event__process
      perf evlist: Support non overwrite mode in perf_evlist__read_on_cpu
      perf top: Switch to non overwrite mode
      perf tools: Rename 'struct sample_data' to 'struct perf_sample'
      perf tools: Kill event_t typedef, use 'union perf_event' instead
      perf tools: Initial python binding
      perf evlist: Move evlist methods to evlist.c
      perf evlist: Store pointer to the cpu and thread maps
      perf top: Move display agnostic routines to util/top.[ch]
      perf tools: Don't fallback to setup_pager unconditionally
      perf top: Introduce slang based TUI
      perf probe: Use %td for pointer arithmetic result
      perf python: Fix build on 32-bit
      perf tools: Remove verbose build messages for the python binding
      perf tools: Fix up 'make clean' target
      perf stat: Fix up resource release order
      perf tools: Don't try to build python bindings if Python.h not available
      perf top: Remove superfluous name_len field
      perf annotate: Move annotate functions to util/
      perf annotate: Support multiple histograms in annotation
      perf annotate: Config options for symbol__tty_annotate
      perf annotate: Separate objdump parsing from actual screen rendering
      perf top: Ditch private annotation code, share perf annotate's
      perf annotate: Fix --stdio rendering
      perf annotate: Move locking to struct annotation
      perf annotate: Fix annotate context lines regression
      perf report: Fix initializion of annotate symbol priv area
      perf ui: Serialize screen updates
      perf annotate: Check if offset is less than symbol size
      perf annotate browser: Use the percent color for the whole line
      perf python: Add cgroup.c to setup.py to get it building again
      perf hists: Print number of samples, not the period sum
      perf record: Delay setting the header writing atexit call
      perf report: Tell the user when a perf.data file has no samples
      perf list: Allow filtering list of events
      perf probe: Fix error propagation leading to segfault
      perf evsel: Fix inverted test for fixing up attr.inherit flag
      perf probe: Remove redundant checks
      perf top: Live TUI Annotation
      perf top browser: Adjust the browser indexes when refreshing
      perf annotate: Show better message when no vmlinux is found
      perf top browser: Fix up exit keys
      perf ui browser: Introduce ui_browser__show_title
      perf symbols: Fix vmlinux path when not using --symfs
      perf top browser: Handle empty active symbols list
      perf tui: Make ui__warning modal
      perf top: Fix reporting of invalid --vmlinux
      perf top tui: Wait till the first sample to refresh the screen.
      perf report tui: Fix multi event switching
      perf hists: Remove needless global col lenght calcs
      perf hists browser: Handle browsing empty hists tree
      perf evlist: Split perf_evlist__id_hash
      perf tools: Improve support for sessions with multiple events
      perf report tui: Improve multi event session support
      perf session: Use evlist/evsel for managing perf.data attributes
      perf header: Stop using 'self'

Borislav Petkov (1):
      perf annotate: Fix build error

David Sharp (8):
      tracing: Add an 'overwrite' trace_option.
      ring-buffer: Remove unused #include <linux/trace_irq.h>
      tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup
      tracing: Fix event alignment: module:module_request
      tracing: Fix event alignment: kvm:kvm_hv_hypercall
      tracing: Fix event alignment: mce:mce_record
      tracing: Fix event alignment: skb:kfree_skb
      tracing: Adjust conditional expression latency formatting.

Denis Kirjanov (1):
      perf top: Use pid_t for target_{pid|tid}

Franck Bui-Huu (2):
      perf record: auto detect when stdout is a pipe
      perf probe: Rewrite find_lazy_match_lines() by using getline(3)

Frederic Weisbecker (7):
      perf callchain: Feed callchains into a cursor
      perf callchain: Rename cumul_hits into callchain_cumul_hits
      perf callchain: Rename register_callchain_param into callchain_register_param
      perf callchain: Don't give arbitrary gender to callchain tree nodes
      perf: Set filters before mmaping events
      perf: Fix missing strndup declaration
      perf: Fix undefined PyVarObject_HEAD_INIT in python 2.5

Han Pingtian (2):
      perf test: check if cpu_map__new() return NULL
      perf test: Fix return values checking

Ian Munsie (5):
      tracing/syscalls: Don't add events for unmapped syscalls
      tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON
      tracing/syscalls: Make arch_syscall_addr weak
      tracing/syscalls: Allow arch specific syscall symbol matching
      tracing/syscalls: Early terminate search for sys_ni_syscall

Ingo Molnar (2):
      Revert "tracing: Add unstable sched clock note to the warning"
      perf probe: Clean up probe_point_lazy_walker() return value

Jan Beulich (1):
      x86: Remove die_nmi()

Jesse Brandeburg (1):
      perf tools: Update Makefile with some help

Jiri Olsa (6):
      tracing: Add unstable sched clock note to the warning
      x86: Separate out entry text section
      kprobes: Disabling optimized kprobes for entry text section
      perf top: Fix events overflow in top command
      perf top: Don't let events to eat up whole header line
      tracing: Explain about unstable clock on resume with ring buffer warning

Kyle McMartin (1):
      perf tool: Fix gcc 4.6.0 issues

Lai Jiangshan (1):
      tracing: Compile time initialization for event flags value

Li Zefan (4):
      perf cgroup: Fix leak of file reference count
      perf cgroup: Fix unmatched call to perf_detach_cgroup()
      perf cgroup: Clean up perf_cgroup_create()
      perf cgroup: Fix a typo in kernel config

Lin Ming (3):
      perf, x86: Add Intel SandyBridge CPU support
      perf: Fix the missing event initialization when pmu is found in idr
      perf: Avoid the percore allocations if the CPU is not HT capable

Marcin Slusarz (1):
      perf lock: Document valid sort keys

Masami Hiramatsu (13):
      perf probe: Introduce lines walker interface
      perf probe: Enable to put probe inline function call site
      perf probe: Add --funcs to show available functions in symtab
      perf tools: Add strfilter for general purpose string filter
      perf probe: Add variable filter support
      perf probe: Add filters support for available functions
      tracing/kprobes: Cleanup strict_strtol() using code
      tracing/kprobes: Support longer (>128 bytes) command
      tracing/kprobes: Add bitfield type
      perf probe: Add bitfield member support
      tracing/kprobe: Fix NULL pointer deref check
      perf probe: Support function@filename syntax for --line
      perf probe: Show filename which contains target function

Michael Witten (5):
      perf tools: Makefile: Use $(QUIET_GEN) for perf.so
      perf tools: Makefile: Remove vestigial git-specific cruft
      perf tools: Makefile: Remove platform-specific cruft
      perf tools: Makefile: Remove tool-specific cruft
      perf tools: Makefile: Remove various and sundry cruft

Peter Zijlstra (6):
      perf: Cure task_oncpu_function_call() races
      cgroup: Fix cgroup_subsys::exit callback
      perf: Optimize throttling code
      perf: Optimize hrtimer events
      perf: Simplify task_clock_event_read()
      perf: Fix cgroup vs jump_label problem

Robert Richter (5):
      perf, x86: Use helper function in x86_pmu_enable_all()
      perf, x86: Calculate perfctr msr addresses in helper functions
      perf, x86: Add new AMD family 15h msrs to perfctr reservation code
      perf, x86: Store perfctr msr addresses in config_base/event_base
      perf, x86: Add support for AMD family 15h core counters

Stephane Eranian (5):
      perf: Add cgroup support
      perf tool: Add cgroup support
      perf: make perf stat print user provided full event names
      perf_events: Fix rcu and locking issues with cgroup support
      perf_events: Update PEBS event constraints

Steven Rostedt (22):
      tracing/filter: Have no filter return a match
      tracing/filter: Move OR and AND logic out of fn() method
      tracing/filter: Dynamically allocate preds
      tracing/filter: Call synchronize_sched() just once for system filters
      tracing/filter: Allocate the preds in an array
      tracing/filter: Free pred array on disabling of filter
      tracing/filter: Use a tree instead of stack for filter_match_preds()
      tracing/filter: Optimize short ciruit check
      tracing/filter: Check the created pred tree
      tracing/filter: Optimize filter by folding the tree
      tracing/filter: Move MAX_FILTER_PRED to local tracing directory
      tracing/filter: Increase the max preds to 2^14
      tracing/filter: Swap entire filter of events
      tracing/filter: Remove synchronize_sched() from __alloc_preds()
      tracing: Remove obsolete sched_switch tracer
      tracing: Deprecate tracing_enabled for tracing_on
      ftrace: Fix memory leak with function graph and cpu hotplug
      tracing: Remove lock_depth from event entry
      ftrace: Add .ref.text as one of the safe areas to trace
      ftrace/graph: Trace function entry before updating index
      tracing: Align 4 byte ints together in struct tracer
      tracing: Fix irqoff selftest expanding max buffer

Uwe Kleine-König (1):
      trivial: Fix Steven's Copyright typos

Yinghai Lu (2):
      x86, perf: Change two init functions to static
      perf top: Fix TUI compilation

Yuanhan Liu (1):
      tracing: Export trace_set_clr_event()


 Documentation/trace/ftrace-design.txt              |    7 +
 Documentation/trace/ftrace.txt                     |  151 +---
 Documentation/trace/kprobetrace.txt                |   16 +-
 arch/x86/ia32/ia32entry.S                          |    2 +
 arch/x86/include/asm/cpufeature.h                  |    2 +
 arch/x86/include/asm/kdebug.h                      |    1 -
 arch/x86/include/asm/msr-index.h                   |    3 +
 arch/x86/include/asm/nmi.h                         |    1 -
 arch/x86/include/asm/smp.h                         |   10 +
 arch/x86/kernel/cpu/perf_event.c                   |  170 +++-
 arch/x86/kernel/cpu/perf_event_amd.c               |  175 ++++-
 arch/x86/kernel/cpu/perf_event_intel.c             |  417 ++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |   97 ++-
 arch/x86/kernel/cpu/perf_event_p4.c                |    8 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |    4 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c             |    4 +
 arch/x86/kernel/dumpstack.c                        |   25 -
 arch/x86/kernel/entry_32.S                         |    6 +-
 arch/x86/kernel/entry_64.S                         |    6 +-
 arch/x86/kernel/ftrace.c                           |   15 +-
 arch/x86/kernel/kgdb.c                             |    9 -
 arch/x86/kernel/kprobes.c                          |    8 +
 arch/x86/kernel/vmlinux.lds.S                      |    1 +
 arch/x86/kvm/trace.h                               |    8 +-
 include/asm-generic/sections.h                     |    1 +
 include/asm-generic/vmlinux.lds.h                  |    6 +
 include/linux/cgroup.h                             |    4 +-
 include/linux/cgroup_subsys.h                      |    4 +
 include/linux/ftrace.h                             |    2 +
 include/linux/ftrace_event.h                       |    2 -
 include/linux/perf_event.h                         |   50 +-
 include/linux/ring_buffer.h                        |    2 +
 include/linux/sched.h                              |    7 -
 include/linux/syscalls.h                           |   10 +-
 include/trace/events/mce.h                         |    8 +-
 include/trace/events/module.h                      |    5 +-
 include/trace/events/skb.h                         |    4 +-
 init/Kconfig                                       |   10 +
 kernel/cgroup.c                                    |   54 +-
 kernel/perf_event.c                                | 1004 ++++++++++++++++---
 kernel/sched.c                                     |   37 +-
 kernel/sysctl.c                                    |    2 +-
 kernel/trace/ftrace.c                              |   52 +-
 kernel/trace/ring_buffer.c                         |   24 +-
 kernel/trace/trace.c                               |   38 +-
 kernel/trace/trace.h                               |   41 +-
 kernel/trace/trace_entries.h                       |    6 +-
 kernel/trace/trace_events.c                        |    2 +-
 kernel/trace/trace_events_filter.c                 |  885 ++++++++++++++---
 kernel/trace/trace_kprobe.c                        |  111 ++-
 kernel/trace/trace_output.c                        |   36 +-
 kernel/trace/trace_sched_switch.c                  |   48 -
 kernel/trace/trace_syscalls.c                      |   42 +-
 scripts/kconfig/streamline_config.pl               |    2 +-
 scripts/recordmcount.c                             |    3 +-
 scripts/recordmcount.pl                            |    1 +
 tools/perf/.gitignore                              |    1 -
 tools/perf/Documentation/Makefile                  |   19 +-
 tools/perf/Documentation/perf-list.txt             |   23 +-
 tools/perf/Documentation/perf-lock.txt             |   12 +-
 tools/perf/Documentation/perf-probe.txt            |   26 +-
 tools/perf/Documentation/perf-record.txt           |   11 +
 tools/perf/Documentation/perf-stat.txt             |   11 +
 tools/perf/Makefile                                |  649 ++-----------
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-annotate.c                      |  351 ++-----
 tools/perf/builtin-diff.c                          |   16 +-
 tools/perf/builtin-inject.c                        |   82 +-
 tools/perf/builtin-kmem.c                          |   10 +-
 tools/perf/builtin-list.c                          |   43 +-
 tools/perf/builtin-lock.c                          |    8 +-
 tools/perf/builtin-probe.c                         |   70 ++-
 tools/perf/builtin-record.c                        |  450 ++++------
 tools/perf/builtin-report.c                        |  225 ++---
 tools/perf/builtin-sched.c                         |   27 +-
 tools/perf/builtin-script.c                        |   17 +-
 tools/perf/builtin-stat.c                          |  118 ++-
 tools/perf/builtin-test.c                          |  184 ++++-
 tools/perf/builtin-timechart.c                     |   13 +-
 tools/perf/builtin-top.c                           | 1029 ++++++--------------
 tools/perf/perf.h                                  |   26 +
 tools/perf/python/twatch.py                        |   41 +
 tools/perf/util/annotate.c                         |  605 ++++++++++++
 tools/perf/util/annotate.h                         |  103 ++
 tools/perf/util/build-id.c                         |   21 +-
 tools/perf/util/cache.h                            |    7 +-
 tools/perf/util/callchain.c                        |  227 +++---
 tools/perf/util/callchain.h                        |   76 ++-
 tools/perf/util/cgroup.c                           |  178 ++++
 tools/perf/util/cgroup.h                           |   17 +
 tools/perf/util/cpumap.c                           |    5 +
 tools/perf/util/cpumap.h                           |    2 +-
 tools/perf/util/debug.c                            |    2 +-
 tools/perf/util/debug.h                            |    2 +-
 tools/perf/util/event.c                            |  374 ++-----
 tools/perf/util/event.h                            |   78 +-
 tools/perf/util/evlist.c                           |  394 ++++++++
 tools/perf/util/evlist.h                           |   68 ++
 tools/perf/util/evsel.c                            |  234 ++++-
 tools/perf/util/evsel.h                            |   47 +-
 tools/perf/util/exec_cmd.c                         |   19 -
 tools/perf/util/header.c                           |  535 +++++------
 tools/perf/util/header.h                           |   95 +--
 tools/perf/util/hist.c                             |  250 +-----
 tools/perf/util/hist.h                             |   60 +-
 tools/perf/util/include/linux/list.h               |    1 +
 tools/perf/util/parse-events.c                     |  175 ++--
 tools/perf/util/parse-events.h                     |   12 +-
 tools/perf/util/probe-event.c                      |  159 +++-
 tools/perf/util/probe-event.h                      |    4 +-
 tools/perf/util/probe-finder.c                     |  531 ++++++-----
 tools/perf/util/python.c                           |  896 +++++++++++++++++
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  266 +++---
 tools/perf/util/session.h                          |   41 +-
 tools/perf/util/setup.py                           |   19 +
 tools/perf/util/strfilter.c                        |  199 ++++
 tools/perf/util/strfilter.h                        |   48 +
 tools/perf/util/symbol.c                           |    7 +-
 tools/perf/util/symbol.h                           |    1 -
 tools/perf/util/thread.c                           |   55 -
 tools/perf/util/thread.h                           |   14 -
 tools/perf/util/thread_map.c                       |   64 ++
 tools/perf/util/thread_map.h                       |   15 +
 tools/perf/util/top.c                              |  238 +++++
 tools/perf/util/top.h                              |   66 ++
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/ui/browser.c                       |   25 +-
 tools/perf/util/ui/browser.h                       |    3 +-
 tools/perf/util/ui/browsers/annotate.c             |  178 +++--
 tools/perf/util/ui/browsers/hists.c                |  197 +++-
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 tools/perf/util/ui/browsers/top.c                  |  213 ++++
 tools/perf/util/ui/helpline.c                      |    5 +-
 tools/perf/util/ui/libslang.h                      |    6 +-
 tools/perf/util/ui/setup.c                         |    8 +-
 tools/perf/util/ui/ui.h                            |    8 +
 tools/perf/util/ui/util.c                          |    7 +-
 tools/perf/util/util.h                             |   26 -
 tools/testing/ktest/ktest.pl                       |    2 +-
 140 files changed, 9295 insertions(+), 4713 deletions(-)
 create mode 100755 tools/perf/python/twatch.py
 create mode 100644 tools/perf/util/annotate.c
 create mode 100644 tools/perf/util/annotate.h
 create mode 100644 tools/perf/util/cgroup.c
 create mode 100644 tools/perf/util/cgroup.h
 create mode 100644 tools/perf/util/evlist.c
 create mode 100644 tools/perf/util/evlist.h
 create mode 100644 tools/perf/util/python.c
 create mode 100644 tools/perf/util/setup.py
 create mode 100644 tools/perf/util/strfilter.c
 create mode 100644 tools/perf/util/strfilter.h
 create mode 100644 tools/perf/util/thread_map.c
 create mode 100644 tools/perf/util/thread_map.h
 create mode 100644 tools/perf/util/top.c
 create mode 100644 tools/perf/util/top.h
 create mode 100644 tools/perf/util/ui/browsers/top.c
 create mode 100644 tools/perf/util/ui/ui.h

[ ... 650K patch file omitted ... ]
