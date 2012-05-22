Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2EVK6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:58:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44964 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2EVK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:58:36 -0400
Date: Tue, 22 May 2012 12:58:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.5
Message-ID: <20120522105828.GA16031@gmail.com>
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

   HEAD: 73787190d04a34e6da745da893b3ae8bedde418f Merge branch 'perf/parse-events-4' of git://github.com/fweisbec/tracing into perf/core

Lots of changes:

 - (much) improved assembly annotation support in perf report,
   with jump visualization, searching, navigation, visual output
   improvements and more.

 - kernel support for AMD IBS PMU hardware features. Notably 
   'perf record -e cycles:p' and 'perf top -e cycles:p' should 
   work without skid now, like PEBS does on the Intel side, 
   because it takes advantage of IBS transparently.

 - the libtracevents library: it is the first step towards 
   unifying tracing tooling and perf, and it also gives a 
   tracing library for external tools like powertop to rely on.

 - infrastructure: various improvements and refactoring of the 
   UI modules and related code

 - infrastructure: cleanup and simplification of the profiling
   targets code (--uid, --pid, --tid, --cpu, --all-cpus, etc.)

 - tons of robustness fixes all around

 - various ftrace updates: speedups, cleanups, robustness 
   improvements.

 - typing 'make' in tools/ will now give you a menu of projects 
   to build and a short help text to explain what each does.

 - ... and lots of other changes I forgot to list.

The perf record make bzImage + perf report regression you 
reported should be fixed.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (54):
      perf ui browser: Return the current color when setting a new one
      perf annotate: Allow printing objdump line addr in different color
      perf ui annotate browser: Allow toggling addr offset view
      perf ui annotate browser: Move callq handling to separate function
      perf ui annotate browser: Add list based search for addr offset
      perf annotate browser: Initial support for navigating jump instructions
      perf annotate browser: string search: /?n
      perf annotate: Rename objdump_line to disasm_line
      perf annotate: Parse instruction
      perf annotate browser: Use the disasm_line instruction name and operand fields
      perf annotate: Disassembler instruction parsing
      perf annotate: Parse call targets earlier
      perf annotate: Introduce scnprintf ins_ops method
      perf annotate browser: Rename disasm_line_rb_node
      perf symbols: Introduce symbol__size method
      perf annotate browser: Hide non jump target addresses in offset mode
      perf annotate browser: Align jump labels
      perf annotate browser: Make lines more compact
      perf annotate browser: Use a vertical line as percentage separator
      perf annotate: Add missing jump variants
      perf annotate: Group operands members
      perf annotate browser: Bandaid offsets/jump label objdump ambiguity
      perf annotate browser: Suppress the callq address
      perf annotate browser: Add visual cues on jump lines
      perf annotate browser: Add visual cue for retq instruction
      perf annotate browser: Handle retq instructions
      ui browser: Add method to write graphical characters
      perf annotate browser: Initial loop detection
      perf annotate browser: Handle NULL jump targets
      perf annotate: Disambiguage offsets and addresses in operands
      perf annotate: Mark jump instructions with no offset
      perf annotate browser: Don't draw jump connectors for out of function jumps
      perf annotate browser: Add a right arrow before call instructions
      perf ui browser: Add method to draw up/down arrow line
      perf annotate browser: Show current jump, back or forward
      perf annotate browser: Remove the vertical line after the percentages
      perf annotate browser: Don't display 0.00 percentages
      perf test: Make the rdpmc test honour 'verbose' mode
      perf ui browser: Introduce routine to draw vertical line
      perf annotate browser: More clearly separate columns
      perf annotate browser: Don't change the asm line color when toggling source
      perf top: Set target.system_wide
      perf annotate browser: Do raw printing in 'o'ffset in a single place
      perf annotate browser: Compact 'nop' output
      perf top: Default to system wide using perf_target methods
      perf hists browser: Use '/' for search/filter instead of 's'
      perf annotate: Use raw form for register indirect call instructions
      perf annotate: Resolve symbols using objdump comment
      perf annotate: Resolve symbols using objdump comment for single op ins
      perf annotate: Augment lock instruction output
      perf annotate: Introduce ->free() method in ins_ops
      perf annotate browser: Count the numbers of jump sources to a target
      perf annotate browser: Show 'jumpy' functions
      perf annotate browser: Add key bindings help window

Ashay Rane (1):
      perf report: Correct display of samples and events in header

Borislav Petkov (5):
      tools: Add Makefile.include
      tools: Cleanup EXTRA_WARNINGS
      tools: Add a toplevel Makefile
      tools: Add a help target
      tools: Connect to the kernel build system

Dan Carpenter (1):
      tracing: Remove an unneeded check in trace_seq_buffer()

David Ahern (6):
      perf record: Fix fallback to cpu-clock on ppc
      perf stat: handle ENXIO error for perf_event_open
      perf top: Update event name when falling back to cpu-clock
      perf record: Reset event name when falling back to cpu-clock
      perf annotate: shorten helpline so it fits in visible space
      perf evsel: Create events initially disabled -- again

Ingo Molnar (1):
      perf/x86: Clean up register_nmi_handler() usage

Jiri Olsa (6):
      perf tools: Fix parsers' rules to dependencies
      perf session: Fail on processing event with unknown size
      tracing: Use seq_*_private interface for some seq files
      perf report: Fix format string for x86-32 compilation
      perf hists: Fix callchain ip printf format
      perf tools: Split term type into value type and term type

Julia Lawall (1):
      perf/events: Correct size given to memset

Minho Ban (1):
      tracing: Prevent wasting time evaluating parameters in trace_preempt_on/off

Namhyung Kim (26):
      perf tools: Ignore auto-generated bison/flex files
      perf annotate: Fix a build error
      perf tools: Move UI bits to tools/perf/ui directory
      perf tools: Move GTK+ bits to tools/perf/ui/gtk directory
      perf tools: Introduce struct perf_target
      perf stat: Convert to struct perf_target
      perf top: Convert to struct perf_target
      perf tools: Introduce perf_target__validate() helper
      perf evlist: Make create_maps() take struct perf_target
      perf tools: Check more combinations of PID/TID, UID and CPU switches
      perf target: Split out perf_target handling code
      perf ui: Make setup_browser() generic
      perf ui gtk: Drop arg[cv] arguments from perf_gtk_setup_browser()
      perf ui gtk: Rename functions for consistency
      perf ui: Add gtk2 support into setup_browser()
      perf ui: Change fallback policy of setup_browser()
      perf evlist: Fix creation of cpu map
      perf target: Introduce perf_target_errno
      perf target: Introduce perf_target__parse_uid()
      perf tools: Introduce perf_target__strerror()
      perf target: Consolidate target task/cpu checking
      perf stat: Use perf_evlist__create_maps
      perf target: Rename functions to avoid double negation
      Revert 'perf evlist: Fix creation of cpu map'
      tracing: Check return value of tracing_dentry_percpu()
      perf target: Add uses_mmap field

Peter Zijlstra (1):
      sched, perf: Use a single callback into the scheduler

Richard Weinberger (1):
      tracing: Remove kernel_lock annotations

Robert Richter (25):
      perf/x86: Implement IBS event configuration
      perf/x86: Implement IBS interrupt handler
      perf/x86: Implement IBS pmu control ops
      perf/x86: Implement 64-bit counter support for IBS
      perf stat: Declare some references static
      perf tools: Fix thread map that is type pid_t
      perf record: Use sw counter only if hw pmu is not detected
      perf: Trivial cleanup of duplicate code
      perf/x86: Fix cmpxchg() usage in amd_put_event_constraints()
      perf: Use static variant of perf_event_overflow in core.c
      perf: Remove PERF_COUNTERS config option
      perf tools: Fix include header files in util/parse-events.h
      perf/x86-ibs: Fix update of period
      perf: Pass last sampling period to perf_sample_data_init()
      perf/x86-ibs: Enable ibs op micro-ops counting mode
      perf/x86-ibs: Fix frequency profiling
      perf/x86-ibs: Take instruction pointer from ibs sample
      perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
      perf/x86-ibs: Rename some variables
      perf/x86-ibs: Trigger overflow if remaining period is too small
      perf/x86-ibs: Extend hw period that triggers overflow
      perf/x86-ibs: Implement workaround for IBS erratum #420
      perf/x86-ibs: Catch spurious interrupts after stopping IBS
      perf/x86-ibs: Fix usage of IBS op current count
      perf/x86/ibs: Fix undefined reference to `get_ibs_caps'

Steven Rostedt (26):
      tracing: Add percpu buffers for trace_printk()
      perf: Separate out trace-cmd parse-events from perf files
      tools/events: Add files to create libtraceevent.a
      perf: Build libtraceevent.a
      events: Update tools/lib/traceevent to work with perf
      perf: Have perf use the new libtraceevent.a library
      perf/events: Add flag to produce nsec output
      parse-events: Let pevent_free() take a NULL pointer
      parse-events: Allow '*' and '/' operations in TP_printk
      parse-event: Fix memset pointer size bug in handle
      parse-events: Rename struct record to struct pevent_record
      ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
      ftrace/x86: Remove the complex ftrace NMI handling code
      ftrace/x86: Use asm/kprobes.h instead of linux/kprobes.h
      tracing: Remove ftrace_disable/enable_cpu()
      tracing: Clean up tracing_mark_write()
      ring-buffer: Add integrity check at end of iter read
      ring-buffer: Reset head page before running self test
      ftrace: Sort all function addresses, not just per page
      ftrace: Remove extra helper functions
      ftrace: Speed up search by skipping pages by address
      ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
      ftrace: Return record ip addr for ftrace_location()
      ftrace: Make ftrace_modify_all_code() global for archs to use
      ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
      ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER

Tom Zanussi (1):
      perf/events: Add flag/symbol format_flags

Ulrich Drepper (1):
      perf tools: Cleanup realloc use

Vaibhav Nagarnaik (9):
      ring-buffer: Add per_cpu ring buffer control files
      parse-events: Handle invalid opcode parsing gracefully
      parse-events: Handle opcode parsing error
      parse-events: Support '+' opcode in print format
      ring-buffer: Make removal of ring buffer pages atomic
      ring-buffer: Make addition of pages in ring buffer atomic
      tracing: change CPU ring buffer state from tracing_cpumask
      ring-buffer: Merge separate resize loops
      tracing: Fix initial buffer_size_kb state


 Makefile                                           |    7 +
 arch/alpha/kernel/perf_event.c                     |    3 +-
 arch/arm/configs/bcmring_defconfig                 |    2 +-
 arch/arm/kernel/perf_event_v6.c                    |    4 +-
 arch/arm/kernel/perf_event_v7.c                    |    4 +-
 arch/arm/kernel/perf_event_xscale.c                |    8 +-
 arch/mips/kernel/perf_event_mipsxx.c               |    2 +-
 arch/powerpc/configs/chroma_defconfig              |    2 +-
 arch/powerpc/configs/gamecube_defconfig            |    2 +-
 arch/powerpc/configs/wii_defconfig                 |    2 +-
 arch/powerpc/perf/core-book3s.c                    |    3 +-
 arch/powerpc/perf/core-fsl-emb.c                   |    3 +-
 arch/sh/configs/sh7785lcr_32bit_defconfig          |    2 +-
 arch/sparc/configs/sparc64_defconfig               |    2 +-
 arch/sparc/kernel/perf_event.c                     |    4 +-
 arch/x86/Kconfig                                   |    1 -
 arch/x86/include/asm/ftrace.h                      |    3 +
 arch/x86/include/asm/msr-index.h                   |    5 +
 arch/x86/include/asm/perf_event.h                  |   12 +-
 arch/x86/kernel/cpu/perf_event.c                   |    7 +-
 arch/x86/kernel/cpu/perf_event_amd.c               |   11 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |  570 +++-
 arch/x86/kernel/cpu/perf_event_intel.c             |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    6 +-
 arch/x86/kernel/cpu/perf_event_p4.c                |    6 +-
 arch/x86/kernel/ftrace.c                           |  500 ++-
 arch/x86/kernel/nmi.c                              |   10 +-
 arch/x86/kernel/traps.c                            |    8 +-
 include/asm-generic/vmlinux.lds.h                  |    2 +-
 include/linux/ftrace.h                             |   19 +-
 include/linux/kernel.h                             |   13 +-
 include/linux/perf_event.h                         |   29 +-
 include/linux/ring_buffer.h                        |    6 +-
 init/Kconfig                                       |   14 +-
 kernel/events/core.c                               |   25 +-
 kernel/sched/core.c                                |    9 +-
 kernel/trace/Kconfig                               |    1 -
 kernel/trace/ftrace.c                              |  242 +-
 kernel/trace/ring_buffer.c                         |  585 ++-
 kernel/trace/trace.c                               |  503 ++-
 kernel/trace/trace.h                               |    4 +-
 kernel/trace/trace_printk.c                        |    4 +
 tools/Makefile                                     |   77 +
 tools/lib/traceevent/Makefile                      |  303 ++
 tools/lib/traceevent/event-parse.c                 | 5065 ++++++++++++++++++++
 tools/lib/traceevent/event-parse.h                 |  804 ++++
 tools/lib/traceevent/event-utils.h                 |   80 +
 tools/lib/traceevent/parse-filter.c                | 2262 +++++++++
 tools/lib/traceevent/parse-utils.c                 |  110 +
 tools/lib/traceevent/trace-seq.c                   |  200 +
 tools/perf/Documentation/perfconfig.example        |    1 +
 tools/perf/Makefile                                |  117 +-
 tools/perf/builtin-kmem.c                          |    6 +-
 tools/perf/builtin-lock.c                          |   26 +-
 tools/perf/builtin-record.c                        |   63 +-
 tools/perf/builtin-report.c                        |   21 +-
 tools/perf/builtin-sched.c                         |   42 +-
 tools/perf/builtin-script.c                        |    2 +-
 tools/perf/builtin-stat.c                          |   86 +-
 tools/perf/builtin-test.c                          |   13 +-
 tools/perf/builtin-top.c                           |   54 +-
 tools/perf/perf.h                                  |    8 +-
 tools/perf/{util => }/ui/browser.c                 |  116 +-
 tools/perf/{util => }/ui/browser.h                 |    9 +-
 tools/perf/ui/browsers/annotate.c                  |  867 ++++
 tools/perf/{util => }/ui/browsers/hists.c          |   26 +-
 tools/perf/{util => }/ui/browsers/map.c            |    6 +-
 tools/perf/{util => }/ui/browsers/map.h            |    0
 tools/perf/{util => ui}/gtk/browser.c              |   31 +-
 tools/perf/{util => ui}/gtk/gtk.h                  |    0
 tools/perf/ui/gtk/setup.c                          |   12 +
 tools/perf/{util => }/ui/helpline.c                |    0
 tools/perf/{util => }/ui/helpline.h                |    0
 tools/perf/{util => }/ui/keysyms.h                 |    0
 tools/perf/{util => }/ui/libslang.h                |    0
 tools/perf/{util => }/ui/progress.c                |    0
 tools/perf/{util => }/ui/progress.h                |    0
 tools/perf/ui/setup.c                              |   45 +
 tools/perf/{util/ui => ui/tui}/setup.c             |   77 +-
 tools/perf/{util => }/ui/ui.h                      |    0
 tools/perf/{util => }/ui/util.c                    |    0
 tools/perf/{util => }/ui/util.h                    |    0
 tools/perf/util/annotate.c                         |  599 +++-
 tools/perf/util/annotate.h                         |   67 +-
 tools/perf/util/cache.h                            |   24 +-
 tools/perf/util/debug.c                            |    1 +
 tools/perf/util/debug.h                            |    2 +-
 tools/perf/util/evlist.c                           |   16 +-
 tools/perf/util/evlist.h                           |    4 +-
 tools/perf/util/evsel.c                            |   11 +-
 tools/perf/util/header.c                           |   17 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/hist.h                             |    2 +-
 tools/perf/util/parse-events.c                     |   45 +-
 tools/perf/util/parse-events.h                     |   23 +-
 tools/perf/util/parse-events.y                     |   16 +-
 tools/perf/util/pmu.c                              |   70 +-
 .../util/scripting-engines/trace-event-python.c    |   16 +-
 tools/perf/util/session.c                          |   30 +-
 tools/perf/util/symbol.h                           |    5 +
 tools/perf/util/target.c                           |  142 +
 tools/perf/util/target.h                           |   65 +
 tools/perf/util/thread_map.h                       |    2 +-
 tools/perf/util/top.c                              |   19 +-
 tools/perf/util/top.h                              |    6 +-
 tools/perf/util/trace-event-info.c                 |    4 +-
 tools/perf/util/trace-event-parse.c                | 3220 +------------
 tools/perf/util/trace-event-read.c                 |   44 +-
 tools/perf/util/trace-event.h                      |  269 +-
 tools/perf/util/ui/browsers/annotate.c             |  433 --
 tools/perf/util/usage.c                            |   38 -
 tools/perf/util/util.c                             |   10 +
 tools/perf/util/util.h                             |    5 +-
 tools/scripts/Makefile.include                     |   58 +
 114 files changed, 13439 insertions(+), 5004 deletions(-)
 create mode 100644 tools/Makefile
 create mode 100644 tools/lib/traceevent/Makefile
 create mode 100644 tools/lib/traceevent/event-parse.c
 create mode 100644 tools/lib/traceevent/event-parse.h
 create mode 100644 tools/lib/traceevent/event-utils.h
 create mode 100644 tools/lib/traceevent/parse-filter.c
 create mode 100644 tools/lib/traceevent/parse-utils.c
 create mode 100644 tools/lib/traceevent/trace-seq.c
 rename tools/perf/{util => }/ui/browser.c (81%)
 rename tools/perf/{util => }/ui/browser.h (86%)
 create mode 100644 tools/perf/ui/browsers/annotate.c
 rename tools/perf/{util => }/ui/browsers/hists.c (98%)
 rename tools/perf/{util => }/ui/browsers/map.c (97%)
 rename tools/perf/{util => }/ui/browsers/map.h (100%)
 rename tools/perf/{util => ui}/gtk/browser.c (85%)
 rename tools/perf/{util => ui}/gtk/gtk.h (100%)
 create mode 100644 tools/perf/ui/gtk/setup.c
 rename tools/perf/{util => }/ui/helpline.c (100%)
 rename tools/perf/{util => }/ui/helpline.h (100%)
 rename tools/perf/{util => }/ui/keysyms.h (100%)
 rename tools/perf/{util => }/ui/libslang.h (100%)
 rename tools/perf/{util => }/ui/progress.c (100%)
 rename tools/perf/{util => }/ui/progress.h (100%)
 create mode 100644 tools/perf/ui/setup.c
 rename tools/perf/{util/ui => ui/tui}/setup.c (74%)
 rename tools/perf/{util => }/ui/ui.h (100%)
 rename tools/perf/{util => }/ui/util.c (100%)
 rename tools/perf/{util => }/ui/util.h (100%)
 create mode 100644 tools/perf/util/target.c
 create mode 100644 tools/perf/util/target.h
 delete mode 100644 tools/perf/util/ui/browsers/annotate.c
 create mode 100644 tools/scripts/Makefile.include
