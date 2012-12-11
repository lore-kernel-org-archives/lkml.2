Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2LKJJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:09:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52211 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:09:16 -0500
Date: Tue, 11 Dec 2012 10:09:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.8
Message-ID: <20121211090910.GA22985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   HEAD: cc1b39dbf9f55a438e8a21a694394c20e6a17129 Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core

Lots of activity:

   211 files changed, 8328 insertions(+), 4116 deletions(-)

most of it on the tooling side.

Main changes:
    
     * ftrace enhancements and fixes from Steve Rostedt.
    
     * uprobes fixes, cleanups and preparation for the ARM 
       port from Oleg Nesterov.
    
     * UAPI fixes, from David Howels - prepares the arch/x86 UAPI transition
    
     * Separate perf tests into multiple objects, one per test, from Jiri Olsa.
    
     * Make hardware event translations available in sysfs, from Jiri Olsa.

     * Fixes to /proc/pid/maps parsing, preparatory to supporting data maps,
       from Namhyung Kim
    
     * Implement ui_progress for GTK, from Namhyung Kim
    
     * Add framework for automated perf_event_attr tests, where tools with
       different command line options will be run from a 'perf test', via
       python glue, and the perf syscall will be intercepted to verify that
       the perf_event_attr fields set by the tool are those expected,
       from Jiri Olsa
    
     * Add a 'link' method for hists, so that we can have the leader with
       buckets for all the entries in all the hists.  This new method
       is now used in the default 'diff' output, making the sum of the 'baseline'
       column be 100%, eliminating blind spots.
    
     * libtraceevent fixes for compiler warnings trying to make perf it build
       on some distros, like fedora 14, 32-bit, some of the warnings really
       pointed to real bugs.
    
     * Add a browser for 'perf script' and make it available from the report
       and annotate browsers. It does filtering to find the scripts that
       handle events found in the perf.data file used. From Feng Tang
    
     * perf inject changes to allow showing where a task sleeps, from Andrew Vagin.
    
     * Makefile improvements from Namhyung Kim.
    
     * Add --pre and --post command hooks in 'stat', from Peter Zijlstra.
    
     * Don't stop synthesizing threads when one vanishes, this is for
       the existing threads when we start a tool like trace.
    
     * Use sched:sched_stat_runtime to provide a thread summary, this
       produces the same output as the 'trace summary' subcommand of
       tglx's original "trace" tool.
    
     * Support interrupted syscalls in 'trace'
    
     * Add an event duration column and filter in 'trace'.
    
     * There are references to the man pages in some tools, so try to build
       Documentation when installing, warning the user if that is not possible,
       from Borislav Petkov.
    
     * Give user better message if precise is not supported, from David Ahern.
    
     * Try to find cross-built objdump path by using the session environment
       information in the perf.data file header, from Irina Tirdea, original
       patch and idea by Namhyung Kim.
    
     * Diplays more output on features check for make V=1, so that one can figure
       out what is happening by looking at gcc output, etc. From Jiri Olsa.
    
     * Add on_exit implementation for systems without one, e.g. Android, from
       Bernhard Rosenkraenzer.
    
     * Only process events for vcpus of interest, helps handling large number
       of events, from David Ahern.
    
     * Cross compilation fixes for Android, from Irina Tirdea.
    
     * Add documentation on compiling for Android, from Irina Tirdea.
    
     * perf diff improvements from Jiri Olsa.
    
     * Target (task/user/cpu/syswide) handling improvements, from Namhyung Kim.
    
     * Add support in 'trace' for tracing workload given by command line, from
       Namhyung Kim.

     * ... and much more.
    
Thanks,

	Ingo

------------------>
Andi Kleen (3):
      perf tools: Move parse_events error printing to parse_events_options
      perf annotate: Handle XBEGIN like a jump
      perf tools: Add arbitary aliases and support names with -

Andrew Vagin (3):
      perf inject: Work with files
      perf inject: Merge sched_stat_* and sched_switch events
      perf inject: Mark a dso if it's used

Arnaldo Carvalho de Melo (31):
      perf tools: Have the page size value available for all tools
      perf machine: Introduce find_thread method
      perf event: No need to create a thread when handling PERF_RECORD_EXIT
      perf annotate: Handle PERF_RECORD_EXIT events
      perf sched: Handle PERF_RECORD_EXIT events
      perf machine: Carve up event processing specific from perf_tool
      perf tools: Remove noise in python version feature test
      perf test: Align the 'Ok'/'FAILED!' test results
      perf trace: Support interrupted syscalls
      perf trace: Add an event duration column
      perf trace: Add duration filter
      perf tools: Pretty print errno for some more functions
      perf trace: Print the name of a syscall when failing to read its info
      perf tools: Don't stop synthesizing threads when one vanishes
      perf trace: Count number of events for each thread and globally
      perf trace: Use sched:sched_stat_runtime to provide a thread summary
      perf python: Initialize 'page_size' variable
      perf tools: Handle --version string generation on machines without git
      perf diff: Start moving to support matching more than two hists
      perf diff: Move hists__match to the hists lib
      perf hists: Introduce hists__link
      perf diff: Use hists__link when not pairing just with baseline
      perf machine: Move more methods to machine.[ch]
      tools lib traceevent: Add __maybe_unused to unused parameters
      tools lib traceevent: Avoid comparisions between signed/unsigned
      tools lib traceevent: No need to check for < 0 on an unsigned enum
      tools lib traceevent: Handle INVALID_ARG_TYPE errno in pevent_strerror
      tools lib traceevent: Use 'const' in variables pointing to const strings
      perf tools: Stop using 'self' in pstack
      perf hists: Initialize all of he->stat with zeroes
      perf evsel: Introduce is_group_member method

Bernhard Rosenkraenzer (1):
      perf tools: Add on_exit implementation

Borislav Petkov (1):
      perf tools: Try to build Documentation when installing

Daniel Walter (1):
      tracing: Replace strict_strto* with kstrto*

David Ahern (5):
      perf kvm: Only process events for vcpus of interest
      perf kvm: Remove typecast in init_kvm_event_record
      perf kvm: Total count is a u64, print as so
      perf kvm: Add braces around multi-line statements
      perf tools: Give user better message if precise is not supported

David Howells (3):
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend

David Sharp (4):
      tracing: Trivial cleanup
      tracing: Reset ring buffer when changing trace_clocks
      tracing,x86: Add a TSC trace_clock
      tracing: Format non-nanosec times from tsc clock without a decimal point.

David Vrabel (1):
      x86: Allow tracing of functions in arch/x86/kernel/rtc.c

Feng Tang (7):
      perf tools: Add a global variable "const char *input_name"
      perf script: Add more filter to find_scripts()
      perf scripts browser: Add a browser for perf script
      perf annotate browser: Integrate script browser into annotation browser
      perf hists browser: Integrate script browser into main hists browser
      perf header: Add is_perf_magic() func
      perf browser: Don't show scripts menu for 'perf top'

Hiraku Toyooka (1):
      tracing: Change tracer's integer flags to bool

Ingo Molnar (2):
      perf tools: Speed up the perf build time by simplifying the perf --version string generation
      perf tools: Further speed up the perf build

Irina Tirdea (3):
      perf tools: Update Makefile for Android
      Documentation: add documentation on compiling for Android
      perf tools: Try to find cross-built objdump path

Jiri Olsa (70):
      perf diff: Add -b option for perf diff to display paired entries only
      perf diff: Add ratio computation way to compare hist entries
      perf diff: Add option to sort entries based on diff computation
      perf diff: Add weighted diff computation way to compare hist entries
      perf diff: Add -p option to display period values for hist entries
      perf diff: Add -F option to display formula for computation
      perf diff: Include samples without symbol in overall stats
      perf diff: Display empty space for non paired samples
      perf/x86: Make hardware event translations available in sysfs
      perf/x86: Filter out undefined events from sysfs events attribute
      perf/x86: Add hardware events translations for Intel cpus
      perf/x86: Add hardware events translations for AMD cpus
      perf/x86: Add hardware events translations for Intel P6 cpus
      perf tools: Fix PMU object alias initialization
      perf tools: Add support to specify hw event as PMU event term
      perf test: Add automated tests for pmu sysfs translated events
      perf tools: Diplays more output on features check for make V=1
      perf tools: Move build_id__sprintf into build-id object
      perf tools: Move BUILD_ID_SIZE into build-id object
      perf tools: Move hex2u64 into util object
      perf tools: Move strxfrchar into string object
      perf tools: Move dso_* related functions into dso object
      perf record: Fix mmap error output condition
      perf tools: Remove BINDIR define from exec_cmd.o compilation
      perf tests: Move test objects into 'tests' directory
      perf tests: Add framework for automated perf_event_attr tests
      perf tests: Add attr record basic test
      perf tests: Add attr tests under builtin test command
      perf tests: Add attr record group test
      perf tests: Add attr record event syntax group test
      perf tests: Add attr record freq test
      perf tests: Add attr record count test
      perf tests: Add attr record graph test
      perf tests: Add attr record period test
      perf tests: Add attr record no samples test
      perf tests: Add attr record no-inherit test
      perf tests: Add attr record data test
      perf tests: Add attr record raw test
      perf tests: Add attr record no delay test
      perf tests: Add attr record branch any test
      perf tests: Add attr record branch filter tests
      perf tests: Add attr stat no-inherit test
      perf tests: Add attr stat group test
      perf tests: Add attr stat event syntax group test
      perf tests: Add attr stat default test
      perf tests: Add attr stat default test
      perf tests: Add documentation for attr tests
      perf tests: Add missing attr stat basic test
      perf tests: Factor attr tests WRITE_ASS macro
      perf tests: Fix attr watermark field name typo
      perf tests: Removing 'optional' field
      perf tests: Move attr.py temp dir cleanup into finally section
      perf tools: Add LIBDW_DIR Makefile variable to for alternate libdw
      perf tests: Move test__vmlinux_matches_kallsyms into separate object
      perf tests: Move test__open_syscall_event into separate object
      perf tests: Move test__open_syscall_event_on_all_cpus into separate object
      perf tests: Move test__basic_mmap into separate object
      perf tests: Move test__PERF_RECORD into separate object
      perf tests: Move test__rdpmc into separate object
      perf tests: Move perf_evsel__roundtrip_name_test into separate object
      perf tests: Move perf_evsel__tp_sched_test into separate object
      perf tests: Move test__syscall_open_tp_fields into separate object
      perf tests: Move pmu tests into separate object
      perf tests: Final cleanup for builtin-test move
      perf tests: Check for mkstemp return value in dso-data test
      perf tools: Fix attributes for '{}' defined event groups
      perf tools: Fix 'disabled' attribute config for record command
      perf tools: Ensure single disable call per event in record comand
      perf tools: Omit group members from perf_evlist__disable/enable
      perf tools: Add basic event modifier sanity check

Joonsoo Kim (1):
      perf tools: Add info about cross compiling for Android ARM

Jovi Zhang (1):
      uprobes: Fix misleading log entry

Michal Hocko (1):
      linux/kernel.h: Remove duplicate trace_printk declaration

Namhyung Kim (27):
      perf trace: Validate target task/user/cpu argument
      perf trace: Explicitly enable system-wide mode if no option is given
      perf trace: Add support for tracing workload given by command line
      tools lib traceevent: Do not generate dependency for system header files
      perf tools: Cleanup doc related targets
      perf tools: Convert invocation of MAKE into SUBDIR
      perf tools: Always show CHK message when doing try-cc
      perf tools: Fix LIBELF_MMAP checking
      perf tools: Warn about missing libelf
      perf tools: Use normalized arch name for searching objdump path
      perf tools: Introduce struct hist_browser_timer
      perf report: Postpone objdump check until annotation requested
      perf machine: Set kernel data mapping length
      perf tools: Fix detection of stack area
      perf hists: Free branch_info when freeing hist_entry
      perf tools: Don't try to lookup objdump for live mode
      perf annotate: Whitespace fixups
      perf annotate: Don't try to follow jump target on PLT symbols
      perf annotate: Merge same lines in summary view
      perf tools: Fix compile error on NO_NEWT=1 build
      perf tools: Add gtk.<command> config option for launching GTK browser
      perf tools: Use sscanf for parsing /proc/pid/maps
      perf ui tui: Move progress.c under ui/tui directory
      perf ui: Introduce generic ui_progress helper
      perf ui gtk: Implement ui_progress functions
      perf ui: Add ui_progress__finish()
      perf ui: Always compile browser setup code

Oleg Nesterov (5):
      uprobes/powerpc: Don't clear TIF_UPROBE in do_notify_resume()
      uprobes/powerpc: Do not use arch_uprobe_*_step() helpers
      uprobes/x86: Cleanup the single-stepping code
      uprobes: Kill arch_uprobe_enable/disable_step() hooks
      uprobes: Use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race

Peter Huewe (1):
      perf/x86: Fix sparse warnings

Peter Zijlstra (1):
      perf stat: Add --pre and --post command

Rabin Vincent (1):
      uprobes: Flush cache after xol write

Shan Wei (1):
      tracing: Kill unused and puzzled sample code in ftrace.h

Slava Pestov (1):
      ring-buffer: Add a 'dropped events' counter

Steven Rostedt (11):
      tracing: Allow tracers to start at core initcall
      tracing: Expand ring buffer when trace_printk() is used
      tracing: Enable comm recording if trace_printk() is used
      tracing: Have tracing_sched_wakeup_trace() use standard unlock_commit
      tracing: Cache comms only after an event occurred
      tracing: Separate open function from set_event and available_events
      tracing: Remove unused function unregister_tracer()
      tracing: Make tracing_enabled be equal to tracing_on
      tracing: Remove deprecated tracing_enabled file
      tracing: Use irq_work for wake ups and remove *_nowake_*() functions
      tracing: Add trace_options kernel command line parameter

Sukadev Bhattiprolu (1):
      perf powerpc: Use uapi/unistd.h to fix build error

Suzuki K. Poulose (1):
      Account the nr_entries in rblist properly

Vaibhav Nagarnaik (1):
      tracing: Cleanup unnecessary function declarations

Wei Yongjun (1):
      perf tools: Remove duplicated include from trace-event-python.c

Yoshihiro YUNOMAE (2):
      ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts() to u64
      tracing: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock

Zheng Liu (1):
      perf test: fix a build error on builtin-test


 Documentation/kernel-parameters.txt                |   16 +
 arch/alpha/include/asm/Kbuild                      |    1 +
 arch/arm/include/asm/Kbuild                        |    1 +
 arch/arm64/include/asm/Kbuild                      |    1 +
 arch/avr32/include/asm/Kbuild                      |    1 +
 arch/blackfin/include/asm/Kbuild                   |    1 +
 arch/c6x/include/asm/Kbuild                        |    1 +
 arch/cris/include/asm/Kbuild                       |    1 +
 arch/frv/include/asm/Kbuild                        |    1 +
 arch/h8300/include/asm/Kbuild                      |    1 +
 arch/hexagon/include/asm/Kbuild                    |    1 +
 arch/ia64/include/asm/Kbuild                       |    1 +
 arch/m32r/include/asm/Kbuild                       |    1 +
 arch/m68k/include/asm/Kbuild                       |    1 +
 arch/microblaze/include/asm/Kbuild                 |    1 +
 arch/mips/include/asm/Kbuild                       |    1 +
 arch/mn10300/include/asm/Kbuild                    |    1 +
 arch/openrisc/include/asm/Kbuild                   |    1 +
 arch/parisc/include/asm/Kbuild                     |    1 +
 arch/powerpc/include/asm/Kbuild                    |    1 +
 arch/powerpc/kernel/signal.c                       |    4 +-
 arch/powerpc/kernel/uprobes.c                      |    6 +
 arch/s390/include/asm/Kbuild                       |    1 +
 arch/score/include/asm/Kbuild                      |    1 +
 arch/sh/include/asm/Kbuild                         |    1 +
 arch/sparc/include/asm/Kbuild                      |    1 +
 arch/tile/include/asm/Kbuild                       |    1 +
 arch/um/include/asm/Kbuild                         |    1 +
 arch/unicore32/include/asm/Kbuild                  |    1 +
 arch/x86/include/asm/trace_clock.h                 |   20 +
 arch/x86/kernel/Makefile                           |    2 +-
 arch/x86/kernel/cpu/perf_event.c                   |  121 ++
 arch/x86/kernel/cpu/perf_event.h                   |    5 +
 arch/x86/kernel/cpu/perf_event_amd.c               |    9 +
 arch/x86/kernel/cpu/perf_event_intel.c             |    9 +
 arch/x86/kernel/cpu/perf_event_p6.c                |    2 +
 arch/x86/kernel/rtc.c                              |    6 -
 arch/x86/kernel/trace_clock.c                      |   21 +
 arch/x86/kernel/tsc.c                              |    6 +
 arch/x86/kernel/uprobes.c                          |   54 +-
 arch/xtensa/include/asm/Kbuild                     |    1 +
 include/asm-generic/trace_clock.h                  |   16 +
 include/linux/ftrace_event.h                       |   20 +-
 include/linux/kernel.h                             |    7 +-
 include/linux/ring_buffer.h                        |    3 +-
 include/linux/trace_clock.h                        |    2 +
 include/linux/uprobes.h                            |   10 +-
 include/trace/ftrace.h                             |   76 +-
 include/trace/syscall.h                            |   23 -
 kernel/events/uprobes.c                            |   43 +-
 kernel/fork.c                                      |    2 +
 kernel/trace/Kconfig                               |    1 +
 kernel/trace/ftrace.c                              |    6 +-
 kernel/trace/ring_buffer.c                         |   51 +-
 kernel/trace/trace.c                               |  411 +++---
 kernel/trace/trace.h                               |   18 +-
 kernel/trace/trace_branch.c                        |    4 +-
 kernel/trace/trace_events.c                        |   51 +-
 kernel/trace/trace_events_filter.c                 |    4 +-
 kernel/trace/trace_functions.c                     |    5 +-
 kernel/trace/trace_functions_graph.c               |    6 +-
 kernel/trace/trace_irqsoff.c                       |   14 +-
 kernel/trace/trace_kprobe.c                        |   10 +-
 kernel/trace/trace_output.c                        |   78 +-
 kernel/trace/trace_probe.c                         |   14 +-
 kernel/trace/trace_sched_switch.c                  |    4 +-
 kernel/trace/trace_sched_wakeup.c                  |   10 +-
 kernel/trace/trace_selftest.c                      |   13 +-
 kernel/trace/trace_syscalls.c                      |   61 +-
 kernel/trace/trace_uprobe.c                        |    4 +-
 tools/lib/traceevent/Makefile                      |    2 +-
 tools/lib/traceevent/event-parse.c                 |   22 +-
 tools/perf/Documentation/Makefile                  |   31 +-
 tools/perf/Documentation/android.txt               |   78 +
 tools/perf/Documentation/perf-diff.txt             |   60 +
 tools/perf/Documentation/perf-inject.txt           |   11 +
 tools/perf/Documentation/perf-stat.txt             |    5 +
 tools/perf/Documentation/perf-trace.txt            |    6 +
 tools/perf/Makefile                                |  174 ++-
 tools/perf/arch/common.c                           |  211 +++
 tools/perf/arch/common.h                           |   10 +
 tools/perf/builtin-annotate.c                      |   17 +-
 tools/perf/builtin-buildid-cache.c                 |    1 +
 tools/perf/builtin-buildid-list.c                  |    6 +-
 tools/perf/builtin-diff.c                          |  437 +++++-
 tools/perf/builtin-evlist.c                        |    5 +-
 tools/perf/builtin-inject.c                        |  195 ++-
 tools/perf/builtin-kmem.c                          |    5 +-
 tools/perf/builtin-kvm.c                           |   35 +-
 tools/perf/builtin-lock.c                          |    2 -
 tools/perf/builtin-record.c                        |   66 +-
 tools/perf/builtin-report.c                        |   23 +-
 tools/perf/builtin-sched.c                         |    8 +-
 tools/perf/builtin-script.c                        |   87 +-
 tools/perf/builtin-stat.c                          |   54 +-
 tools/perf/builtin-test.c                          | 1547 --------------------
 tools/perf/builtin-timechart.c                     |    5 +-
 tools/perf/builtin-top.c                           |   17 +-
 tools/perf/builtin-trace.c                         |  403 ++++-
 tools/perf/config/feature-tests.mak                |   25 +-
 tools/perf/config/utilities.mak                    |   10 +-
 tools/perf/perf.c                                  |   20 +-
 tools/perf/perf.h                                  |   18 +-
 tools/perf/tests/attr.c                            |  175 +++
 tools/perf/tests/attr.py                           |  322 ++++
 tools/perf/tests/attr/README                       |   64 +
 tools/perf/tests/attr/base-record                  |   39 +
 tools/perf/tests/attr/base-stat                    |   39 +
 tools/perf/tests/attr/test-record-basic            |    5 +
 tools/perf/tests/attr/test-record-branch-any       |    8 +
 .../perf/tests/attr/test-record-branch-filter-any  |    8 +
 .../tests/attr/test-record-branch-filter-any_call  |    8 +
 .../tests/attr/test-record-branch-filter-any_ret   |    8 +
 tools/perf/tests/attr/test-record-branch-filter-hv |    8 +
 .../tests/attr/test-record-branch-filter-ind_call  |    8 +
 tools/perf/tests/attr/test-record-branch-filter-k  |    8 +
 tools/perf/tests/attr/test-record-branch-filter-u  |    8 +
 tools/perf/tests/attr/test-record-count            |    8 +
 tools/perf/tests/attr/test-record-data             |    8 +
 tools/perf/tests/attr/test-record-freq             |    6 +
 tools/perf/tests/attr/test-record-graph-default    |    6 +
 tools/perf/tests/attr/test-record-graph-dwarf      |   10 +
 tools/perf/tests/attr/test-record-graph-fp         |    6 +
 tools/perf/tests/attr/test-record-group            |   18 +
 tools/perf/tests/attr/test-record-group1           |   19 +
 tools/perf/tests/attr/test-record-no-delay         |    9 +
 tools/perf/tests/attr/test-record-no-inherit       |    7 +
 tools/perf/tests/attr/test-record-no-samples       |    6 +
 tools/perf/tests/attr/test-record-period           |    7 +
 tools/perf/tests/attr/test-record-raw              |    7 +
 tools/perf/tests/attr/test-stat-basic              |    6 +
 tools/perf/tests/attr/test-stat-default            |   64 +
 tools/perf/tests/attr/test-stat-detailed-1         |  101 ++
 tools/perf/tests/attr/test-stat-detailed-2         |  155 ++
 tools/perf/tests/attr/test-stat-detailed-3         |  173 +++
 tools/perf/tests/attr/test-stat-group              |   15 +
 tools/perf/tests/attr/test-stat-group1             |   15 +
 tools/perf/tests/attr/test-stat-no-inherit         |    7 +
 tools/perf/tests/builtin-test.c                    |  173 +++
 .../{util/dso-test-data.c => tests/dso-data.c}     |    8 +-
 tools/perf/tests/evsel-roundtrip-name.c            |  114 ++
 tools/perf/tests/evsel-tp-sched.c                  |   84 ++
 tools/perf/tests/mmap-basic.c                      |  162 ++
 tools/perf/tests/open-syscall-all-cpus.c           |  120 ++
 tools/perf/tests/open-syscall-tp-fields.c          |  117 ++
 tools/perf/tests/open-syscall.c                    |   66 +
 .../parse-events-test.c => tests/parse-events.c}   |   91 +-
 tools/perf/tests/perf-record.c                     |  312 ++++
 tools/perf/tests/pmu.c                             |  178 +++
 tools/perf/tests/rdpmc.c                           |  175 +++
 tools/perf/tests/tests.h                           |   22 +
 tools/perf/tests/util.c                            |   30 +
 tools/perf/tests/vmlinux-kallsyms.c                |  230 +++
 tools/perf/ui/browsers/annotate.c                  |   45 +-
 tools/perf/ui/browsers/hists.c                     |   97 +-
 tools/perf/ui/browsers/scripts.c                   |  189 +++
 tools/perf/ui/gtk/browser.c                        |    4 +-
 tools/perf/ui/gtk/gtk.h                            |    1 +
 tools/perf/ui/gtk/progress.c                       |   59 +
 tools/perf/ui/gtk/setup.c                          |    2 +
 tools/perf/ui/gtk/util.c                           |   11 -
 tools/perf/ui/hist.c                               |  138 +-
 tools/perf/ui/progress.c                           |   44 +-
 tools/perf/ui/progress.h                           |   10 +
 tools/perf/ui/stdio/hist.c                         |    2 +-
 tools/perf/ui/tui/progress.c                       |   42 +
 tools/perf/ui/tui/setup.c                          |    1 +
 tools/perf/ui/ui.h                                 |   28 +
 tools/perf/util/PERF-VERSION-GEN                   |   14 +-
 tools/perf/util/annotate.c                         |   72 +-
 tools/perf/util/annotate.h                         |   10 +-
 tools/perf/util/build-id.c                         |   27 +-
 tools/perf/util/build-id.h                         |   11 +-
 tools/perf/util/cache.h                            |   39 +-
 tools/perf/util/debug.h                            |    1 +
 tools/perf/util/dso.c                              |  595 ++++++++
 tools/perf/util/dso.h                              |  148 ++
 tools/perf/util/event.c                            |  302 +---
 tools/perf/util/event.h                            |    9 +-
 tools/perf/util/evlist.c                           |   13 +-
 tools/perf/util/evsel.c                            |   52 +-
 tools/perf/util/evsel.h                            |    8 +-
 tools/perf/util/header.c                           |   11 +
 tools/perf/util/header.h                           |    1 +
 tools/perf/util/hist.c                             |   99 ++
 tools/perf/util/hist.h                             |   49 +-
 tools/perf/util/machine.c                          |  464 ++++++
 tools/perf/util/machine.h                          |  148 ++
 tools/perf/util/map.c                              |  182 +--
 tools/perf/util/map.h                              |   93 --
 tools/perf/util/parse-events.c                     |   54 +-
 tools/perf/util/parse-events.h                     |    3 +-
 tools/perf/util/parse-events.l                     |    4 +-
 tools/perf/util/parse-events.y                     |   18 +
 tools/perf/util/pmu.c                              |  192 +--
 tools/perf/util/pmu.h                              |    4 +
 tools/perf/util/pstack.c                           |   46 +-
 tools/perf/util/python.c                           |    2 +
 tools/perf/util/rblist.c                           |    4 +-
 .../util/scripting-engines/trace-event-python.c    |    1 -
 tools/perf/util/session.c                          |    5 +-
 tools/perf/util/session.h                          |    5 +-
 tools/perf/util/sort.h                             |   45 +-
 tools/perf/util/string.c                           |   18 +
 tools/perf/util/symbol.c                           |  658 +--------
 tools/perf/util/symbol.h                           |  162 +-
 tools/perf/util/thread.c                           |   41 +-
 tools/perf/util/thread.h                           |    2 +
 tools/perf/util/trace-event-read.c                 |    2 -
 tools/perf/util/util.c                             |   35 +
 tools/perf/util/util.h                             |    8 +
 211 files changed, 8328 insertions(+), 4116 deletions(-)
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 include/asm-generic/trace_clock.h
 create mode 100644 tools/perf/Documentation/android.txt
 create mode 100644 tools/perf/arch/common.c
 create mode 100644 tools/perf/arch/common.h
 delete mode 100644 tools/perf/builtin-test.c
 create mode 100644 tools/perf/tests/attr.c
 create mode 100644 tools/perf/tests/attr.py
 create mode 100644 tools/perf/tests/attr/README
 create mode 100644 tools/perf/tests/attr/base-record
 create mode 100644 tools/perf/tests/attr/base-stat
 create mode 100644 tools/perf/tests/attr/test-record-basic
 create mode 100644 tools/perf/tests/attr/test-record-branch-any
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any_call
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any_ret
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-hv
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-ind_call
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-k
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-u
 create mode 100644 tools/perf/tests/attr/test-record-count
 create mode 100644 tools/perf/tests/attr/test-record-data
 create mode 100644 tools/perf/tests/attr/test-record-freq
 create mode 100644 tools/perf/tests/attr/test-record-graph-default
 create mode 100644 tools/perf/tests/attr/test-record-graph-dwarf
 create mode 100644 tools/perf/tests/attr/test-record-graph-fp
 create mode 100644 tools/perf/tests/attr/test-record-group
 create mode 100644 tools/perf/tests/attr/test-record-group1
 create mode 100644 tools/perf/tests/attr/test-record-no-delay
 create mode 100644 tools/perf/tests/attr/test-record-no-inherit
 create mode 100644 tools/perf/tests/attr/test-record-no-samples
 create mode 100644 tools/perf/tests/attr/test-record-period
 create mode 100644 tools/perf/tests/attr/test-record-raw
 create mode 100644 tools/perf/tests/attr/test-stat-basic
 create mode 100644 tools/perf/tests/attr/test-stat-default
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-1
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-2
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-3
 create mode 100644 tools/perf/tests/attr/test-stat-group
 create mode 100644 tools/perf/tests/attr/test-stat-group1
 create mode 100644 tools/perf/tests/attr/test-stat-no-inherit
 create mode 100644 tools/perf/tests/builtin-test.c
 rename tools/perf/{util/dso-test-data.c => tests/dso-data.c} (95%)
 create mode 100644 tools/perf/tests/evsel-roundtrip-name.c
 create mode 100644 tools/perf/tests/evsel-tp-sched.c
 create mode 100644 tools/perf/tests/mmap-basic.c
 create mode 100644 tools/perf/tests/open-syscall-all-cpus.c
 create mode 100644 tools/perf/tests/open-syscall-tp-fields.c
 create mode 100644 tools/perf/tests/open-syscall.c
 rename tools/perf/{util/parse-events-test.c => tests/parse-events.c} (94%)
 create mode 100644 tools/perf/tests/perf-record.c
 create mode 100644 tools/perf/tests/pmu.c
 create mode 100644 tools/perf/tests/rdpmc.c
 create mode 100644 tools/perf/tests/tests.h
 create mode 100644 tools/perf/tests/util.c
 create mode 100644 tools/perf/tests/vmlinux-kallsyms.c
 create mode 100644 tools/perf/ui/browsers/scripts.c
 create mode 100644 tools/perf/ui/gtk/progress.c
 create mode 100644 tools/perf/ui/tui/progress.c
 create mode 100644 tools/perf/util/dso.c
 create mode 100644 tools/perf/util/dso.h
 create mode 100644 tools/perf/util/machine.c
 create mode 100644 tools/perf/util/machine.h

[ ... half a meg diff omitted due to lkml limits ... ]
