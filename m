Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2JAMyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:54:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49854 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2JAMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:54:13 -0400
Date: Mon, 1 Oct 2012 14:54:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.7
Message-ID: <20121001125407.GA22108@gmail.com>
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

   HEAD: 1d787d37c8ff6612b8151c6dff15bfa7347bcbdf Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core

Lots of changes in this cycle as well, with hundreds of commits 
from over 30 contributors. Most of the activity was on the 
tooling side.

Higher level changes:

     * New 'perf kvm' analysis tool, from Xiao Guangrong.
   
     * New 'perf trace' system-wide tracing tool

     * uprobes fixes + cleanups from Oleg Nesterov.
    
     * Lots of patches to make perf build on Android out of box, from Irina Tirdea

     * Extend ftrace function tracing utility to be
       more dynamic for its users. It allows for data passing to the callback
       functions, as well as reading regs as if a breakpoint were to trigger
       at function entry.
    
       The main goal of this patch series was to allow kprobes to use ftrace
       as an optimized probe point when a probe is placed on an ftrace nop.
       With lots of help from Masami Hiramatsu, and going through lots of
       iterations, we finally came up with a good solution.

     * Add cpumask for uncore pmu, use it in 'stat', from Yan, Zheng.
    
     * Various tracing updates from Steve Rostedt

     * Clean up and improve 'perf sched' performance by elliminating lots of
       needless calls to libtraceevent.
    
     * Event group parsing support, from Jiri Olsa
    
     * UI/gtk refactorings and improvements from Namhyung Kim
    
     * Add support for non-tracepoint events in perf script python, from Feng Tang
    
     * Add --symbols to 'script', similar to the one in 'report', from Feng Tang.
    
Infrastructure enhancements and fixes:

     * Convert the trace builtins to use the growing evsel/evlist
       tracepoint infrastructure, removing several open coded constructs
       like switch like series of strcmp to dispatch events, etc.
       Basically what had already been showcased in 'perf sched'.
    
     * Add evsel constructor for tracepoints, that uses libtraceevent
       just to parse the /format events file, use it in a new 'perf test'
       to make sure the libtraceevent format parsing regressions can
       be more readily caught.
    
     * Some strange errors were happening in some builds, but not on the
       next, reported by several people, problem was some parser related
       files, generated during the build, didn't had proper make deps,
       fix from Eric Sandeen.
    
     * Introduce struct and cache information about the environment where a
       perf.data file was captured, from Namhyung Kim.
    
     * Fix handling of unresolved samples when --symbols is used in 'report',
       from Feng Tang.
    
     * Add union member access support to 'probe', from Hyeoncheol Lee.
    
     * Fixups to die() removal, from Namhyung Kim.
    
     * Render fixes for the TUI, from Namhyung Kim.
    
     * Don't enable annotation in non symbolic view, from Namhyung Kim.
    
     * Fix pipe mode in 'report', from Namhyung Kim.
    
     * Move related stats code from stat to util/, will be used by the 'stat'
       kvm tool, from Xiao Guangrong.
    
     * Remove die()/exit() calls from several tools.
    
     * Resolve vdso callchains, from Jiri Olsa
    
     * Don't pass const char pointers to basename, so that we can unconditionally
       use libgen.h and thus avoid ifdef BIONIC lines, from David Ahern
    
     * Refactor hist formatting so that it can be reused with the GTK browser,
       From Namhyung Kim
    
     * Fix build for another rbtree.c change, from Adrian Hunter.
    
     * Make 'perf diff' command work with evsel hists, from Jiri Olsa.
    
     * Use the only field_sep var that is set up: symbol_conf.field_sep,
       fix from Jiri Olsa.
    
     * .gitignore compiled python binaries, from Namhyung Kim.
    
     * Get rid of die() in more libtraceevent places, from Namhyung Kim.
    
     * Rename libtraceevent 'private' struct member to 'priv' so that it works
       in C++, from Steven Rostedt
    
     * Remove lots of exit()/die() calls from tools so that the main perf exit
       routine can take place, from David Ahern
    
     * Fix x86 build on x86-64, from David Ahern.
    
     * {int,str,rb}list fixes from Suzuki K Poulose
    
     * perf.data header fixes from Namhyung Kim
    
     * Allow user to indicate objdump path, needed in cross environments, from
       Maciek Borzecki
    
     * Fix hardware cache event name generation, fix from Jiri Olsa
    
     * Add round trip test for sw, hw and cache event names, catching the
       problem Jiri fixed, after Jiri's patch, the test passes successfully.
    
     * Clean target should do clean for lib/traceevent too, fix from David Ahern
    
     * Check the right variable for allocation failure, fix from Namhyung Kim
    
     * Set up evsel->tp_format regardless of evsel->name being set already,
       fix from Namhyung Kim
    
     * Oprofile fixes from Robert Richter.
    
     * Remove perf_event_attr needless version inflation, from Jiri Olsa
    
     * Introduce libtraceevent strerror like error reporting facility, from Namhyung Kim
    
     * Add pmu mappings to perf.data header and use event names from cmd line, from Robert Richter
    
     * Fix include order for bison/flex-generated C files, from Ben Hutchings
    
     * Build fixes and documentation corrections from David Ahern
    
     * Assorted cleanups from Robert Richter
    
     * Let O= makes handle relative paths, from Steven Rostedt
    
     * perf script python fixes, from Feng Tang.
    
     * Initial bash completion support, from Frederic Weisbecker
    
     * Allow building without libelf, from Namhyung Kim.
    
     * Support DWARF CFI based unwind to have callchains when %bp
       based unwinding is not possible, from Jiri Olsa.
    
     * Symbol resolution fixes, while fixing support PPC64 files with an .opt ELF
       section was the end goal, several fixes for code that handles all
       architectures and cleanups are included, from Cody Schafer.
    
     * Assorted fixes for Documentation and build in 32 bit, from Robert Richter
    
     * Cache the libtraceevent event_format associated to each evsel early, so that we
       avoid relookups, i.e. calling pevent_find_event repeatedly when processing
       tracepoint events.
    
       [ This is to reduce the surface contact with libtraceevents and make clear what
         is that the perf tools needs from that lib: so far parsing the common and per
         event fields. ]
    
     * Don't stop the build if the audit libraries are not installed, fix from Namhyung Kim.
    
     * Fix bfd.h/libbfd detection with recent binutils, from Markus Trippelsdorf.
    
     * Improve warning message when libunwind devel packages not present, from Jiri Olsa

 Thanks,

	Ingo

------------------>
Adrian Hunter (1):
      perf tools: Fix build for another rbtree.c change

Andi Kleen (1):
      perf symbols: Add description of JIT interface

Arnaldo Carvalho de Melo (49):
      perf hists browser: Add verbose mode hotkey
      perf tools: Add dump_stack function
      perf header: Set the tracepoint names on PERF_RECORD_HEADER_TRACING_DATA
      perf evsel: Cache associated event_format
      perf kmem: Use evsel->tp_format and perf_sample
      perf lock: Use evsel->tp_format and perf_sample
      perf sched: Use perf_sample
      perf script: Stop using pevent directly
      perf tools: Add missing files to build the python binding
      perf evlist: Rename __group method to __set_leader
      perf evlist: Introduce evsel list accessors
      perf test: Add round trip test for sw and hw event names
      perf tools: Remove extraneous newline when parsing hardware cache events
      perf evlist: Add fprintf method
      perf test: Add roundtrip test for hardware cache events
      perf test: Remove die() calls
      perf sched: Remove die() calls
      perf kmem: Remove die() calls
      perf tools: Add missing perf_regs.h file to MANIFEST
      perf sched: Remove unused thread parameter
      perf sched: Use perf_tool as ancestor
      perf evsel: Introduce perf_evsel__{str,int}val methods
      perf sched: Use perf_evsel__{int,str}val
      perf sched: Don't read all tracepoint variables in advance
      tools lib traceevent: Define _GNU_SOURCE in Makefile
      perf kvm: Use perf_evsel__intval
      perf kmem: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
      perf lock: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
      perf timechart: Use zalloc and fix a couple leaks
      tools lib traceevent: Use asprintf were applicable
      tools lib traceevent: Use calloc were applicable
      tools lib traceevent: Fix afterlife gotos
      tools lib traceevent: Remove some die() calls
      tools lib traceevent: Carve out events format parsing routine
      perf evsel: Provide a new constructor for tracepoints
      perf test: Add test for the sched tracepoint format fields
      perf evsel: Improve tracepoint constructor setup
      perf tools: Allow handling a NULL cpu_map as meaning "all cpus"
      perf evsel: Know if byte swap is needed
      perf evsel: Handle endianity in intval method
      perf test: Add test to check we correctly parse and match syscall open parms
      perf evlist: Renane set_filters method to apply_filters
      perf evlist: Introduce set_filter() method
      perf evsel: The tracepoint constructor should store sys:name
      perf tools: Use perf_evsel__newtp in the event parser
      perf evsel: Introduce rawptr() method
      perf evsel: Export the event_format constructor
      perf trace: New tool
      perf trace: Add aliases for some syscalls

Ben Hutchings (1):
      perf tools: Fix include order for bison/flex-generated C files

Borislav Petkov (1):
      kprobes/x86: Move skip_singlestep up

Cody P Schafer (16):
      perf symbols: Only un-prelink non-zero symbols
      perf symbols: Remove unused function map__objdump_2ip
      perf symbols: Don't try to synthesize plt without dynstr
      perf symbols: Remove unneeded call to dso__set_long_name()
      perf symbols: Correct comment wrt kallsyms loading
      perf symbols: Remove unused 'end' arg in kallsyms parse cb
      perf symbols: Simplify out_fixup in kernel syms loading
      perf symbols: only set vmlinux longname & mark loaded if really loaded
      perf symbols: Avoid segfault in elf_strptr
      perf symbols: Track symtab_type of vmlinux
      perf symbols: Introduce symsrc structure.
      perf symbols: Set symtab_type in dso__load_sym
      perf symbols: Switch dso__synthesize_plt_symbols() to use symsrc
      perf symbols: Factor want_symtab out of dso__load_sym()
      perf symbols: Convert dso__load_syms to take 2 symsrc's
      perf symbols: Use both runtime and debug images

Dan Carpenter (1):
      perf: Fix off by one test in perf_reg_value()

David Ahern (17):
      perf lock record: improve message when tracepoints are not enabled
      perf script perl/python: Fix libexec scripts path in Documentation
      perf: silence GTK2 probing errors
      perf symbols: Fix builds with NO_LIBELF set
      perf session: flush_sample_queue needs to handle errors from handlers
      perf tool: handle errors in synthesized event functions
      perf lock: Remove use of die and handle errors
      perf stat: Remove use of die/exit and handle errors
      perf help: Remove use of die and handle errors
      perf script: Remove use of die/exit
      perf record: Remove use of die/exit
      perf tools: Fix x86 builds with ARCH specified on the command line
      perf tools: remove unneeded include of network header files
      perf tools: Clean target should do clean for lib/traceevent too
      perf annotate: Make a copy of filename for passing to basename
      perf probe: Make a copy of exec path for passing to basename
      perf symbols: Remove BIONIC wrapper around libgen.h

Eric Sandeen (1):
      perf tools: Fix parallel build

Ezequiel Garcia (1):
      trace: Move trace event enable from fs_initcall to core_initcall

Feng Tang (12):
      perf script: Add general python handler to process non-tracepoint events
      perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
      perf scripts python: Pass event/thread/dso name and symbol info to event handler in python
      perf scripts python: Add a python library EventClass.py
      perf scripts python: Add event_analyzing_sample.py as a sample for general event handling
      perf script python: Correct handler check and spelling errors
      perf symbols: Filter samples with unresolved symbol when "--symbols" option is used
      perf scripts: Add --symbols option to handle specific symbols
      perf scripts: Add event_analyzing_sample-record/report
      perf scripts: Export a find_scripts() function
      perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine
      perf tools: Fix a compiling error in util/map.c

Frederic Weisbecker (4):
      perf tools: Initial bash completion support
      perf tools: Support for events bash completion
      perf: Factor __output_copy to be usable with specific copy function
      perf: Add attribute to filter out callchains

Hyeoncheol Lee (2):
      perf probe: Add union member access support
      perf probe: Print an enum type variable in "enum variable-name" format when showing accessible variables

Irina Tirdea (16):
      perf tools: Replace mempcpy with memcpy
      perf tools: include basename for non-glibc systems
      perf tools: fix missing winsize definition
      perf tools: include missing pthread.h header
      perf tools: replace mkostemp with mkstemp
      tools lib traceevent: replace mempcpy with memcpy
      perf tools: add NO_BACKTRACE for application self-debugging
      perf bench: fix assert when NDEBUG is defined
      perf tools: include wrapper for magic.h
      perf tools: Update types definitions for Android
      perf tools: include __WORDSIZE definition
      perf tools: fix ALIGN redefinition in system headers
      perf tools: Use __maybe_used for unused variables
      perf archive: Remove -f from the rm command
      perf archive: Make 'f' the last parameter for tar
      perf tools: remove sscanf extension %as

Jiri Olsa (24):
      tracing/filter: Add missing initialization
      perf: Unified API to record selective sets of arch registers
      perf: Add ability to attach user level registers dump to sample
      perf: Add perf_output_skip function to skip bytes in sample
      perf: Add ability to attach user stack dump to sample
      perf tools: Adding PERF_ATTR_SIZE_VER2 to the header swap check
      perf tools: Add interface to arch registers sets
      perf tools: Add libunwind dependency for DWARF CFI unwinding
      perf tools: Support user regs and stack in sample parsing
      perf tools: Support for DWARF CFI unwinding on post processing
      perf tools: Support for DWARF mode callchain
      perf tools: Add support to parse event group syntax
      perf tools: Add support to update event modifier
      perf tools: Enable grouping logic for parsed events
      perf test: Add automated tests for event group parsing
      perf tools: Fix 'No libunwind found' make warning message
      perf tools: Keep the perf_event_attr on version 3
      perf tools: Fix cache event name generation
      perf diff: Make diff command work with evsel hists
      perf tools: Replace sort's standalone field_sep with symbol_conf.field_sep
      perf tools: Do backtrace post unwind only if we regs and stack were captured
      perf tools: Add memdup function
      perf symbols: Make dsos__find function globally available
      perf tools: Back [vdso] DSO with real data

Josh Triplett (2):
      trace: Don't declare trace_*_rcuidle functions in modules
      trace: Stop compiling in trace_clock unconditionally

Maciek Borzecki (1):
      perf tools: Allow user to indicate path to objdump in command line

Mandeep Singh Baines (1):
      tracing: Add an option for disabling markers

Markus Trippelsdorf (1):
      perf tools: bfd.h/libbfd detection fails with recent binutils

Masami Hiramatsu (8):
      ftrace: add ftrace_set_filter_ip() for address based filter
      kprobes: cleanup to separate probe-able check
      kprobes: Move locks into appropriate functions
      kprobes: introduce ftrace based optimization
      kprobes/x86: ftrace based optimization for x86
      ftrace/x86: Adjust x86 regs.ip as like as x86-64
      kprobes/x86: Fix kprobes to collectly handle IP on ftrace
      kprobes/x86: Fix to support jprobes on ftrace-based kprobe

Namhyung Kim (54):
      perf tools: Fix /etc config related installation
      perf symbols: Introduce symbol__elf_init()
      perf symbols: Split out util/symbol-elf.c
      perf symbols: Support minimal build without libelf
      perf symbols: Implement poor man's ELF parser
      perf script: Fix a NULL pointer dereference
      perf ui: Introduce struct ui_helpline
      perf ui gtk: Implement helpline_fns
      perf ui/gtk: Use helpline API in browser
      perf ui gtk: Add perf_gtk__show_helpline() for pr_*
      perf ui gtk: Ensure not to call gtk_main_quit() twice
      perf hists: Separate out hist print functions
      perf hists: Rename and move some functions
      tools lib traceevent: Do not link broken field arg for an old ftrace event
      tools lib traceevent: Introduce pevent_errno
      tools lib traceevent: Introduce pevent_strerror
      tools lib traceevent: Fix strerror_r() use in pevent_strerror
      tools lib traceevent: Fix off-by-one bug in pevent_strerror()
      perf header: Use evlist->nr_entries on write_event_desc()
      perf header: Set tracepoint event name only if not set
      perf header: Swap pmu mapping numbers if needed
      perf header: Fix a typo on evsel
      perf header: Prepare tracepoint events regardless of name
      perf tools: Ignore compiled python binaries
      tools lib traceevent: Get rid of die() from pretty_print()
      tools lib traceevent: Get rid of die() from pevent_register_event_handler
      tools lib traceevent: Get rid of die() from pevent_register_print_function
      perf hists: Introduce perf_hpp for hist period printing
      perf hists: Handle field separator properly
      perf hists: Use perf_hpp__format->width to calculate the column widths
      perf hists browser: Use perf_hpp__format functions
      perf gtk/browser: Use perf_hpp__format functions
      perf test: Fixup for the die() removal
      perf sched: Fixup for the die() removal
      perf hists browser: Fix output for 100.00%
      perf hists browser: Fix first column printing
      perf tools: Add sort__has_sym
      perf report: Enable integrated annotation only if possible
      perf report: Add missing perf_hpp__init for pipe-mode
      perf header: Add struct perf_session_env
      perf header: Add ->process callbacks to most of features
      perf header: Use pre-processed session env when printing
      perf header: Remove unused @feat arg from ->process callback
      perf kvm: Use perf_session_env for reading cpuid
      perf header: Remove perf_header__read_feature
      tools lib traceevent: Fix error path on process_array()
      tools lib traceevent: Make sure that arg->op.right is set properly
      tools lib traceevent: Free field if an error occurs on process_fields
      tools lib traceevent: Free field if an error occurs on process_flags/symbols
      tools lib traceevent: Handle alloc_arg failure
      perf test: Fix build failure
      tools lib traceevent: Fix error path on pevent_parse_event
      perf hists: Add missing period_* fields when collapsing a hist entry
      perf tools: Check libaudit availability for perf-trace builtin

Oleg Nesterov (16):
      uprobes: Kill uprobes_state->count
      uprobes: Kill dup_mmap()->uprobe_mmap(), simplify uprobe_mmap/munmap
      uprobes: Change uprobe_mmap() to ignore the errors but check fatal_signal_pending()
      uprobes: Do not use -EEXIST in install_breakpoint() paths
      uprobes: Introduce MMF_HAS_UPROBES
      uprobes: Fold uprobe_reset_state() into uprobe_dup_mmap()
      uprobes: Remove "verify" argument from set_orig_insn()
      uprobes: uprobes_treelock should not disable irqs
      uprobes: Introduce MMF_RECALC_UPROBES
      uprobes: Teach find_active_uprobe() to clear MMF_HAS_UPROBES
      ptrace/x86: Introduce set_task_blockstep() helper
      ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic
      uprobes/x86: Do not (ab)use TIF_SINGLESTEP/user_*_single_step() for single-stepping
      uprobes/x86: Xol should send SIGTRAP if X86_EFLAGS_TF was set
      uprobes/x86: Fix arch_uprobe_disable_step() && UTASK_SSTEP_TRAPPED interaction
      uprobes: Make arch_uprobe_task->saved_trap_nr "unsigned int"

Robert Richter (17):
      perf tools: Fix version file for perf documentation with OUTPUT variable set
      perf tools: Fix lib/traceevent build dir with OUTPUT variable set
      perf tools: Fix parsing of 64 bit raw config value for 32 bit
      tools lib traceevent: Fix cast from pointer to integer for 32 bit
      perf list: Update documentation about raw event setup
      perf list: Document precise event sampling for AMD IBS
      perf tools: Fix type for evsel->ids and add size check for ids
      perf tools: Report number of pmu type of unknown events
      perf tools: Rename some variables for better understanding
      perf tools: Rename global variable 'events' in util/header.c
      perf test: Do not abort tests on error
      perf tools: Catch event names from command line
      perf tools: Refactor print_event_desc()
      perf report: Update event names from header description
      perf tools: Add pmu mappings to header information
      oprofile, s390: Fix uninitialized memory access when writing to oprofilefs
      oprofile: Remove 'WQ on CPUx, prefer CPUy' warning

Sebastian Andrzej Siewior (4):
      uprobes: Remove check for uprobe variable in handle_swbp()
      uprobes: Don't put NULL pointer in uprobe_register()
      uprobes: Introduce arch_uprobe_enable/disable_step()
      uprobes/x86: Implement x86 specific arch_uprobe_*_step

Srikar Dronamraju (1):
      uprobes: Remove redundant lock_page/unlock_page

Stephane Eranian (2):
      perf/x86: Fix microcode revision check for SNB-PEBS
      perf record: Print event causing perf_event_open() to fail

Steven Rostedt (21):
      ftrace: Pass ftrace_ops as third parameter to function trace callback
      ftrace: Consolidate arch dependent functions with 'list' function
      ftrace: Return pt_regs to function trace callback
      ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer
      ftrace/x86: Add separate function to save regs
      ftrace/x86: Add save_regs for i386 function calls
      ftrace/x86: Remove function_trace_stop check from graph caller
      ftrace: Add default recursion protection for function tracing
      ftrace: Only compile ftrace selftest if selftests are enabled
      ftrace: Add selftest to test function trace recursion protection
      ftrace: Add selftest to test function save-regs support
      kprobes: Inverse taking of module_mutex with kprobe_mutex
      ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE
      tracing: Fix wakeup_rt self test on virtual machines
      perf tools: Let O= makes handle relative paths
      ftrace: Make recordmcount.c handle __fentry__
      ftrace: Add -mfentry to Makefile on function tracer
      ftrace: Do not test frame pointers if -mfentry is used
      ftrace/x86: Add support for -mfentry to x86_64
      tools lib traceevent: Modify header to work in C++ programs
      ftrace/x86-64: Allow to change RIP in handlers

Suzuki K. Poulose (2):
      perf tools: Fix intlist node removal
      perf tools: Remove the node from rblist in strlist__remove

Uros Bizjak (1):
      ftrace/x86_32: Simplify parameter setup for ftrace_regs_caller

Wang Tianhong (1):
      tracing/trivial: Fix some typos in kernel/trace

Xiao Guangrong (3):
      perf stat: Move stats related code to util/stat.c
      KVM: x86: Export svm/vmx exit code and vector code to userspace
      perf kvm: Events analysis tool

Yan, Zheng (2):
      perf/x86: Add cpumask for uncore pmu
      perf stat: Check PMU cpumask file

Yuanhan Liu (1):
      tracing: Skip printing "OK" if failed to disable event


 Makefile                                           |    6 +-
 arch/Kconfig                                       |   13 +
 arch/s390/oprofile/init.c                          |   10 +-
 arch/x86/Kconfig                                   |    3 +
 arch/x86/include/asm/ftrace.h                      |   56 +-
 arch/x86/include/asm/kprobes.h                     |    1 +
 arch/x86/include/asm/kvm.h                         |   16 +
 arch/x86/include/asm/kvm_host.h                    |   16 -
 arch/x86/include/asm/perf_event.h                  |    2 +
 arch/x86/include/asm/perf_regs.h                   |   33 +
 arch/x86/include/asm/processor.h                   |    2 +
 arch/x86/include/asm/svm.h                         |  205 ++-
 arch/x86/include/asm/uprobes.h                     |    3 +-
 arch/x86/include/asm/vmx.h                         |  127 +-
 arch/x86/kernel/Makefile                           |    2 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   28 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |    6 +-
 arch/x86/kernel/entry_32.S                         |   74 +-
 arch/x86/kernel/entry_64.S                         |  130 +-
 arch/x86/kernel/ftrace.c                           |   73 +-
 arch/x86/kernel/kprobes.c                          |   67 +
 arch/x86/kernel/microcode_core.c                   |    3 +
 arch/x86/kernel/perf_regs.c                        |  105 ++
 arch/x86/kernel/step.c                             |   53 +-
 arch/x86/kernel/uprobes.c                          |   52 +-
 arch/x86/kernel/x8664_ksyms_64.c                   |    6 +-
 arch/x86/kvm/trace.h                               |   89 --
 drivers/oprofile/cpu_buffer.c                      |   11 +-
 include/linux/ftrace.h                             |  158 +-
 include/linux/kprobes.h                            |   27 +
 include/linux/perf_event.h                         |   60 +-
 include/linux/perf_regs.h                          |   25 +
 include/linux/sched.h                              |    3 +
 include/linux/tracepoint.h                         |   28 +-
 include/linux/uprobes.h                            |   15 +-
 kernel/Makefile                                    |    2 +-
 kernel/events/callchain.c                          |   38 +-
 kernel/events/core.c                               |  214 +++
 kernel/events/internal.h                           |   82 +-
 kernel/events/ring_buffer.c                        |   10 +-
 kernel/events/uprobes.c                            |  248 ++--
 kernel/fork.c                                      |    6 +-
 kernel/kprobes.c                                   |  247 +++-
 kernel/trace/Kconfig                               |   10 +
 kernel/trace/Makefile                              |    8 +-
 kernel/trace/ftrace.c                              |  322 ++++-
 kernel/trace/ring_buffer.c                         |    4 +-
 kernel/trace/trace.c                               |   12 +-
 kernel/trace/trace.h                               |    3 +-
 kernel/trace/trace_event_perf.c                    |    3 +-
 kernel/trace/trace_events.c                        |  116 +-
 kernel/trace/trace_events_filter.c                 |    2 +-
 kernel/trace/trace_functions.c                     |   14 +-
 kernel/trace/trace_functions_graph.c               |    5 +-
 kernel/trace/trace_irqsoff.c                       |    5 +-
 kernel/trace/trace_sched_wakeup.c                  |    5 +-
 kernel/trace/trace_selftest.c                      |  304 +++-
 kernel/trace/trace_stack.c                         |    4 +-
 kernel/trace/trace_syscalls.c                      |    2 +-
 scripts/recordmcount.h                             |    4 +-
 tools/lib/traceevent/Makefile                      |    2 +-
 tools/lib/traceevent/event-parse.c                 |  754 +++++++---
 tools/lib/traceevent/event-parse.h                 |   46 +-
 tools/lib/traceevent/event-utils.h                 |    6 +
 tools/perf/.gitignore                              |    2 +
 tools/perf/Documentation/Makefile                  |    6 +-
 tools/perf/Documentation/jit-interface.txt         |   15 +
 tools/perf/Documentation/perf-annotate.txt         |    3 +
 tools/perf/Documentation/perf-diff.txt             |    3 +
 tools/perf/Documentation/perf-kvm.txt              |   30 +-
 tools/perf/Documentation/perf-list.txt             |   48 +-
 tools/perf/Documentation/perf-report.txt           |    3 +
 tools/perf/Documentation/perf-script-perl.txt      |    4 +-
 tools/perf/Documentation/perf-script-python.txt    |   10 +-
 tools/perf/Documentation/perf-trace.txt            |   53 +
 tools/perf/MANIFEST                                |    4 +
 tools/perf/Makefile                                |  173 ++-
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/include/perf_regs.h            |   80 +
 tools/perf/arch/x86/util/unwind.c                  |  111 ++
 tools/perf/bash_completion                         |   26 +
 tools/perf/bench/bench.h                           |    3 +-
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/mem-memset.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |   10 +-
 tools/perf/builtin-annotate.c                      |    4 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-buildid-cache.c                 |   10 +-
 tools/perf/builtin-buildid-list.c                  |    7 +-
 tools/perf/builtin-diff.c                          |   96 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-help.c                          |   50 +-
 tools/perf/builtin-inject.c                        |   29 +-
 tools/perf/builtin-kmem.c                          |  234 +--
 tools/perf/builtin-kvm.c                           |  838 ++++++++++-
 tools/perf/builtin-list.c                          |   16 +-
 tools/perf/builtin-lock.c                          |  414 +++---
 tools/perf/builtin-probe.c                         |   24 +-
 tools/perf/builtin-record.c                        |  305 +++-
 tools/perf/builtin-report.c                        |   47 +-
 tools/perf/builtin-sched.c                         | 1522 +++++++++-----------
 tools/perf/builtin-script.c                        |  229 +--
 tools/perf/builtin-stat.c                          |  136 +-
 tools/perf/builtin-test.c                          |  353 ++++-
 tools/perf/builtin-timechart.c                     |   70 +-
 tools/perf/builtin-top.c                           |   33 +-
 tools/perf/builtin-trace.c                         |  310 ++++
 tools/perf/builtin.h                               |    2 +
 tools/perf/command-list.txt                        |    3 +-
 tools/perf/config/feature-tests.mak                |   50 +
 tools/perf/perf-archive.sh                         |    6 +-
 tools/perf/perf.c                                  |   75 +-
 tools/perf/perf.h                                  |    9 +-
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |   94 ++
 .../python/bin/event_analyzing_sample-record       |    8 +
 .../python/bin/event_analyzing_sample-report       |    3 +
 .../perf/scripts/python/event_analyzing_sample.py  |  189 +++
 tools/perf/ui/browser.c                            |    7 +-
 tools/perf/ui/browsers/annotate.c                  |    6 +-
 tools/perf/ui/browsers/hists.c                     |  133 +-
 tools/perf/ui/gtk/browser.c                        |  111 +-
 tools/perf/ui/gtk/gtk.h                            |    3 +
 tools/perf/ui/gtk/helpline.c                       |   56 +
 tools/perf/ui/gtk/setup.c                          |    6 +-
 tools/perf/ui/gtk/util.c                           |    9 +-
 tools/perf/ui/helpline.c                           |   56 +-
 tools/perf/ui/helpline.h                           |   33 +-
 tools/perf/ui/hist.c                               |  390 +++++
 tools/perf/ui/setup.c                              |   10 +-
 tools/perf/ui/stdio/hist.c                         |  498 +++++++
 tools/perf/ui/tui/helpline.c                       |   57 +
 tools/perf/ui/tui/setup.c                          |   10 +-
 tools/perf/util/alias.c                            |    3 +-
 tools/perf/util/annotate.c                         |   19 +-
 tools/perf/util/annotate.h                         |   15 +-
 tools/perf/util/build-id.c                         |   11 +-
 tools/perf/util/cache.h                            |    6 +-
 tools/perf/util/callchain.c                        |    6 +-
 tools/perf/util/cgroup.c                           |    4 +-
 tools/perf/util/config.c                           |    6 +-
 tools/perf/util/cpumap.c                           |   22 +-
 tools/perf/util/cpumap.h                           |   13 +-
 tools/perf/util/debug.c                            |    4 +-
 tools/perf/util/debug.h                            |   17 +-
 tools/perf/util/dso-test-data.c                    |    2 +-
 tools/perf/util/dwarf-aux.c                        |    2 +
 tools/perf/util/event.c                            |   71 +-
 tools/perf/util/event.h                            |   14 +-
 tools/perf/util/evlist.c                           |  143 +-
 tools/perf/util/evlist.h                           |   35 +-
 tools/perf/util/evsel.c                            |  276 +++-
 tools/perf/util/evsel.h                            |   63 +-
 tools/perf/util/generate-cmdlist.sh                |   15 +
 tools/perf/util/header.c                           | 1063 ++++++++++----
 tools/perf/util/header.h                           |   29 +-
 tools/perf/util/help.c                             |    4 +-
 tools/perf/util/hist.c                             |  721 +---------
 tools/perf/util/hist.h                             |   75 +-
 tools/perf/util/include/linux/bitops.h             |    4 +
 tools/perf/util/include/linux/compiler.h           |    9 +-
 tools/perf/util/include/linux/kernel.h             |   17 +-
 tools/perf/util/include/linux/magic.h              |   12 +
 tools/perf/util/include/linux/rbtree.h             |    1 +
 tools/perf/util/include/linux/string.h             |    2 +
 tools/perf/util/include/linux/types.h              |    8 +
 tools/perf/util/intlist.c                          |    8 +-
 tools/perf/util/map.c                              |   47 +-
 tools/perf/util/map.h                              |    9 +-
 tools/perf/util/parse-events-test.c                |  424 +++++-
 tools/perf/util/parse-events.c                     |  254 ++--
 tools/perf/util/parse-events.h                     |   18 +-
 tools/perf/util/parse-events.l                     |   56 +-
 tools/perf/util/parse-events.y                     |  125 +-
 tools/perf/util/parse-options.c                    |    3 +-
 tools/perf/util/perf_regs.h                        |   14 +
 tools/perf/util/pmu.c                              |   80 +-
 tools/perf/util/pmu.h                              |    3 +
 tools/perf/util/pmu.y                              |    6 +-
 tools/perf/util/probe-event.c                      |   69 +-
 tools/perf/util/probe-finder.c                     |   28 +-
 tools/perf/util/python.c                           |   17 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   50 +-
 .../util/scripting-engines/trace-event-python.c    |  113 +-
 tools/perf/util/session.c                          |  198 ++-
 tools/perf/util/session.h                          |   10 +-
 tools/perf/util/sort.c                             |   25 +-
 tools/perf/util/sort.h                             |    2 +-
 tools/perf/util/stat.c                             |   57 +
 tools/perf/util/stat.h                             |   16 +
 tools/perf/util/string.c                           |   18 +-
 tools/perf/util/strlist.c                          |    2 +-
 tools/perf/util/symbol-elf.c                       |  841 +++++++++++
 tools/perf/util/symbol-minimal.c                   |  307 ++++
 tools/perf/util/symbol.c                           |  942 ++----------
 tools/perf/util/symbol.h                           |   67 +-
 tools/perf/util/target.c                           |    4 +-
 tools/perf/util/thread.h                           |    2 +
 tools/perf/util/top.c                              |    3 +-
 tools/perf/util/top.h                              |    1 +
 tools/perf/util/trace-event-parse.c                |   54 +-
 tools/perf/util/trace-event-scripting.c            |   34 +-
 tools/perf/util/trace-event.h                      |   12 +-
 tools/perf/util/unwind.c                           |  571 ++++++++
 tools/perf/util/unwind.h                           |   35 +
 tools/perf/util/util.c                             |   25 +
 tools/perf/util/util.h                             |    9 +-
 tools/perf/util/vdso.c                             |  111 ++
 tools/perf/util/vdso.h                             |   18 +
 tools/perf/util/wrapper.c                          |    3 +-
 tools/scripts/Makefile.include                     |    6 +-
 211 files changed, 13268 insertions(+), 5255 deletions(-)
 create mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/kernel/perf_regs.c
 create mode 100644 include/linux/perf_regs.h
 create mode 100644 tools/perf/Documentation/jit-interface.txt
 create mode 100644 tools/perf/Documentation/perf-trace.txt
 create mode 100644 tools/perf/arch/x86/include/perf_regs.h
 create mode 100644 tools/perf/arch/x86/util/unwind.c
 create mode 100644 tools/perf/bash_completion
 create mode 100644 tools/perf/builtin-trace.c
 create mode 100755 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report
 create mode 100644 tools/perf/scripts/python/event_analyzing_sample.py
 create mode 100644 tools/perf/ui/gtk/helpline.c
 create mode 100644 tools/perf/ui/hist.c
 create mode 100644 tools/perf/ui/stdio/hist.c
 create mode 100644 tools/perf/ui/tui/helpline.c
 create mode 100644 tools/perf/util/include/linux/magic.h
 create mode 100644 tools/perf/util/perf_regs.h
 create mode 100644 tools/perf/util/stat.c
 create mode 100644 tools/perf/util/stat.h
 create mode 100644 tools/perf/util/symbol-elf.c
 create mode 100644 tools/perf/util/symbol-minimal.c
 create mode 100644 tools/perf/util/unwind.c
 create mode 100644 tools/perf/util/unwind.h
 create mode 100644 tools/perf/util/vdso.c
 create mode 100644 tools/perf/util/vdso.h

[ combo patch way too large to include. ]

