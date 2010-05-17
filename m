Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0EQWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:03:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab0EQWDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:03:38 -0400
Date: Tue, 18 May 2010 00:02:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/core changes for v2.6.35
Message-ID: <20100517220251.GA13582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4997]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

In this cycle too there were lots of changes all 
around:

 - New Newt/Slang based TUI for perf report (can be
   disabled by using 'perf report | less' or via
   'make NO_NEWT=1')

 - New call-chain based zoom in/out workflow in the TUI
   perf report browser, a'la SysProf. This is activated
   automatically if 'perf record -g' call-chain 
   profiling is done.

 - New x86 P4 PMU driver - native perf hw PMU support 
   now is available for all Intel and AMD CPUs made 
   in the last 10 years, starting from the PPro and 
   the K7.

 - New 'perf kvm' tool that helps the co-profiling of
   KVM guests and hosts.

 - New PEBS (precise event sampling) support on Intel 
   CPUs that have this feature. The kernel will not just
   use PEBS but also eliminate skid (instruction offset
   in profile/annotation output skipping) using LBR 
   (last-branch-record).

   This feature can be activated via the ':p' and 
   ':pp' postfixes to events. For example:

     perf record -e cycles:pp ...

 - New 'live mode' feature for 'perf trace', which eliminates
   the perf.data middle man and streams trace data continuously
   and runs the script engine on records as they 
   arrive. This can be activated explicitly:

      perf trace record rwtop -o - | perf trace report rwtop 5 -i -

   And it also gets activated implicitly when a script is run:

     perf trace rwtop 5

 - New 'perf probe' feature: allow access to data 
   elements in probes, and other 'perf probe' improvements.

 - New 'perf inject' tool that allows the insertion of extra
   events into a live trace stream

 - New 'perf test' regression-test command

 - Various 'perf lock' improvements and performance 
   enhancements.

 - ... lots of other changes, improvements, speedups, 
   refinements.

 Thanks,

	Ingo

------------------>
Anton Blanchard (2):
      perf symbols: Fill in pgoff in mmap synthesized events
      perf: Fix performance issue with perf report

Arnaldo Carvalho de Melo (99):
      perf record: Mention paranoid sysctl when failing to create counter
      perf symbols: Bump plt synthesizing warning debug level
      perf top: Export get_window_dimensions
      perf tools: Use eprintf for pr_{err,warning,info} too
      perf tools: Add missing bytes printed in hist_entry__fprintf
      perf report: Implement initial UI using newt
      perf newt: Add 'Q', 'q' and Ctrl+C as ways to exit from forms
      perf newt: Use newtGetScreenSize
      perf hist: Don't fprintf the callgraph unconditionally
      perf tools: Fix non-newt build
      perf top: Properly notify the user that vmlinux is missing
      perf annotate: Properly notify the user that vmlinux is missing
      perf newt: Properly restore the screen when error exiting
      perf stat: Better report failure to collect system wide stats
      perf tools: Exit browser before printing usage when unkown option passed
      perf report: Implement Newt callgraphs
      perf archive: Explain how to use the generated tarball
      perf report: Add a popup menu to ask what operation is to be performed
      perf symbols: Avoid unnecessary symbol loading when dso list is specified
      perf annotate: Allow specifying DSOs where to look for symbol
      perf tools: Introduce struct map_symbol
      perf callchains: Store the map together with the symbol
      perf report: Pass the DSO to 'perf annotate'
      perf symbols: Pass the mmap parameters instead of using mmap_event
      perf symbols: Move map related routines to map.c
      perf tools: Move __used from perf.h to linux/compiler.h
      perf symbols: Move hex2u64 and strxfrchar to symbol.c
      perf symbols: Move more map_groups methods to map.c
      perf symbols: map_groups__find_symbol must return the map too
      perf report: Add progress bars
      perf tools: Use -o $(BITBUCKET) in one more case
      perf tools: Allow specifying O= to build files in a separate directory
      perf record: Add a fallback to the reference relocation symbol
      perf hist: Replace ->print() routines by ->snprintf() equivalents
      perf kmem: Resolve kernel symbols again
      perf kmem: Fixup the symbol address before using it
      perf hist: Only allocate callchain_node if processing callchains
      perf session: Remove one more exit() call from library code
      perf tools: sort_dimension__add shouldn't die
      perf tools: Move the prototypes in util/string.h to util.h
      perf newt: Remove useless column width calculation
      perf newt: Move the hist browser population bits to separare function
      perf newt: Pass the input_name to perf_session__browse_hists
      perf newt: Add a "Zoom into foo.so DSO" and reverse operations
      perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
      perf TUI: Show filters on the title and add help line about how to zoom out
      perf TUI: Move "Yes" button to before "No"
      perf tools: Reorganize some structs to save space
      perf trace: Ignore "overwrite" field if present in /events/header_page
      perf tools: Fix perl support installation when O= is used
      perf tools: Rename "kernel_info" to "machine"
      perf machine: Pass buffer size to machine__mmap_name
      perf machine: Adopt some map_groups functions
      perf machines: Make the machines class adopt the dsos__fprintf methods
      perf tools: Create $(OUTPUT)arch/$(ARCH)/util/ directory
      perf symbols: Add machine helper routines
      perf test: Initial regression testing command
      perf tools: Don't use code surrounded by __KERNEL__
      perf record: Don't exit in live mode when no tracepoints are enabled
      perf inject: Refactor read_buildid function
      perf inject: Add missing bits
      perf report: Make dso__calc_col_width agree with hist_entry__dso_snprintf
      perf list: Add explanation about raw hardware event descriptors
      perf tools: Fixup minor doc formatting issues
      perf list: Improve the raw hw event descriptor documentation
      perf callchain: Move validate_callchain to callchain lib
      perf report: Fix leak of resolved callchains array on error path
      perf hist: Simplify the insertion of new hist_entry instances
      perf symbols: Consider unresolved DSOs in the dso__col_widt calculation
      perf symbols: Check if a struct machine instance was found
      perf session: Embed the host machine data on perf_session
      perf report: Allow limiting the number of entries to print in callchains
      perf newt: Use newtAddComponent()
      perf callchains: Use zalloc to allocate objects
      perf session: create_kernel_maps should use ->host_machine
      perf hist: Introduce hists class and move lots of methods to it
      perf hist: Calculate max_sym name len and nr_entries
      perf hist: Adopt filter by dso and by thread methods from the newt browser
      perf ui: Add ui_helpline methods
      perf report: Librarize the annotation code and use it in the newt browser
      perf hist: Make event__totals per hists
      perf hist: Clarify events_stats fields usage
      perf report: Report number of events, not samples
      perf newt: Make <- zoom out filters
      perf newt: Make <- exit the ui_browser
      perf newt: Fix the 'A'/'a' shortcut for annotate
      perf newt: Exit browser unconditionally when CTRL+C, q or Q is pressed
      perf newt: Add single key shortcuts for zoom into DSO and threads
      perf tui: Make <- exit menus too
      perf tui: Add help window to show key associations
      perf options: Introduce OPT_U64
      perf tui: Add workaround for slang < 2.1.4
      perf options: Introduce OPT_UINTEGER
      perf options: Check v type in OPT_U?INTEGER
      perf options: Type check OPT_BOOLEAN and fix the offenders
      perf options: Type check all the remaining OPT_ variants
      perf tui: Add explicit -lslang option
      perf symbols: symbol inconsistency message should be done only at verbose=1
      perf tools: Add mode to build without newt support

Arnd Bergmann (1):
      perf_event: Make perf fd non seekable

Cyrill Gorcunov (14):
      perf, x86: Implement initial P4 PMU driver
      x86, perf: Fix NULL deref on not assigned x86_pmu
      x86, perf: Unmask LVTPC only if we have APIC supported
      perf, x86: Enable not tagged retired instruction counting on P4s
      x86, apic: Allow to use certain functions without APIC built-in support
      x86, perf: Use apic_write unconditionally
      x86, perf: Fix few cosmetic dabs for P4 pmu (comments and constantify)
      x86, perf: Add raw events support for the P4 PMU
      x86, perf: P4 PMU -- configure predefined events
      x86, perf: P4 PMU -- protect sensible procedures from preemption
      x86, perf: P4 PMU -- Get rid of redundant check for array index
      x86, perf: P4 PMU -- check for proper event index in RAW events
      x86, perf: P4 PMU -- use hash for p4_get_escr_idx()
      x86, perf: P4 PMU - fix counters management logic

Dan Carpenter (1):
      perf: Fix check at end of event search

Eric B Munson (1):
      perf record: Enable the enable_on_exec flag if record forks the target

Frederic Weisbecker (39):
      perf: Fix unexported generic perf_arch_fetch_caller_regs
      perf: Fix unexported generic perf_arch_fetch_caller_regs
      perf: Fix orphan callchain branches
      perf: Drop the frame reliablity check
      perf: Fetch hot regs from the template caller
      perf: Store active software events in a hashlist
      perf: Make clock software events consistent with general exclusion rules
      perf tools: Fix accidentally preprocessed snprintf callback
      perf: Fix hlist related build error
      perf: Make -f the default for perf record
      perf: Always record tracepoints raw samples from perf record
      perf: Make the trace events sample period default to 1
      perf: Fix perf probe build error
      perf: Generalize perf lock's sample event reordering to the session layer
      perf: Use generic sample reordering in perf sched
      perf: Use generic sample reordering in perf kmem
      perf: Use generic sample reordering in perf trace
      perf: Use generic sample reordering in perf timechart
      perf: Add a perf trace option to check samples ordering reliability
      perf: Remove leftover useless options to record trace events from scripts
      perf: Fix warning while reading ring buffer headers
      hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
      hw-breakpoints: Check disabled breakpoints again
      hw-breakpoints: Change/Enforce some breakpoints policies
      hw-breakpoints: Separate constraint space for data and instruction breakpoints
      hw-breakpoints: Handle breakpoint weight in allocation constraints
      hw-breakpoints: Get the number of available registers on boot dynamically
      hw_breakpoints: Fix percpu build failure
      perf: Introduce a new "round of buffers read" pseudo event
      perf: Provide a new deterministic events reordering algorithm
      perf: Cleanup perf lock broken states
      perf: Humanize lock flags in perf lock
      perf: Fix perf lock bad rate
      perf lock: Always check min AND max wait time
      tracing: Drop lock_acquired waittime field
      tracing: Drop the nested field from lock_release event
      tracing: Factorize lock events in a lock class
      perf hist: Fix hists__browse no-newt case
      perf hist: Fix missing getline declaration

Hitoshi Mitake (4):
      perf: Swap inclusion order of util.h and string.h in util/string.c
      perf lock: Fix state machine to recognize lock sequence
      perf lock: Add "info" subcommand for dumping misc information
      perf lock: Drop "-a" option from cmd_record() default arguments set

Ian Munsie (3):
      perf: Fix endianness argument compatibility with OPT_BOOLEAN() and introduce OPT_INCR()
      perf: Move arch specific code into separate arch directory
      perf probe: Add PowerPC DWARF register number mappings

Ingo Molnar (5):
      perf, x86: Add INSTRUCTION_DECODER config flag
      perf, x86: Fix the !CONFIG_CPU_SUP_INTEL build
      perf probe: Fix !dwarf build
      perf events: Fix false positive build warning with older GCC's
      Revert "perf: Fix exit() vs PERF_FORMAT_GROUP"

Kirill Smelkov (1):
      perf trace scripts: Fix typos in perf-trace-python.txt

Kyle McMartin (1):
      perf symbols: allow forcing use of cplus_demangle

Lin Ming (7):
      x86, perf: Fix comments in Pentium-4 PMU definitions
      perf, x86: Add a key to simplify template lookup in Pentium-4 PMU
      perf, x86: Add cache events for the Pentium-4 PMU
      perf, x86: Fix key indexing in Pentium-4 PMU
      perf: Add group scheduling transactional APIs
      perf, x86: implement group scheduling transactional APIs
      perf, powerpc: Implement group scheduling transactional APIs

Masami Hiramatsu (39):
      kprobes: Hide CONFIG_OPTPROBES and set if arch supports optimized kprobes
      perf tools: Introduce xzalloc() for detecting out of memory conditions
      perf probe: Use wrapper functions
      perf probe: Move add-probe routine to util/
      perf probe: Rename session to param
      perf probe: Rename some die_get_* functions
      perf probe: Introduce die_find_child() function
      perf probe: Add --dry-run option
      perf probe: Introduce kprobe_trace_event and perf_probe_event
      perf probe: List probes with line number and file name
      perf probe: Add data structure member access support
      perf probe: Cleanup debuginfo related code
      perf probe: Add NO_DWARF make option
      perf probe: Fix --line syntax help and document
      perf probe: Fix not to return non-matched file
      perf probe: Correct error message for non-structure type
      perf probe: Fix to close dwarf when failing to analyze it
      perf probe: Support argument name
      perf probe: Use the last field name as the argument name
      tracing/kprobes: Support basic types on dynamic events
      perf probe: Query basic types from debuginfo
      perf probe: Support basic type casting
      perf probe: Support DW_OP_call_frame_cfa in debuginfo
      perf probe: Remove die() from probe-finder code
      perf probe: Remove die() from probe-event code
      perf probe: Remove xzalloc() from util/probe-{event, finder}.c
      perf probe: Remove xstrdup()/xstrndup() from util/probe-{event, finder}.c
      perf probe: Fix to use correct debugfs path finder
      perf probe: Fix mis-estimation for shortening filename
      perf probe: Fix a bug that --line range can be overflow
      perf probe: Fix line range to show end line
      perf probe: Support DW_OP_plus_uconst in DW_AT_data_member_location
      perf probe: Show function entry line as probe-able
      perf tools: Initialize dso->node member in dso__new
      perf probe: Fix to use symtab only if no debuginfo
      perf probe: Fix to exit callback soon after finding too many probe points
      perf probe: Add --max-probes option
      kprobes: Move enable/disable_kprobe() out from debugfs code
      perf probe: Check older elfutils and set NO_DWARF

Paul Mackerras (1):
      perf_event: Make software events work again

Pekka Enberg (1):
      perf report: Document '--call-graph' better for usage

Peter Zijlstra (37):
      perf, x86: Add PEBS infrastructure
      perf: Add attr->precise support to raw event parsing
      perf, x86: Implement simple LBR support
      perf, x86: use LBR for PEBS IP+1 fixup
      perf-top: Show the percentage of successfull PEBS-fixups
      perf, x86: Clean up IA32_PERF_CAPABILITIES usage
      perf, x86: Expose the full PEBS record using PERF_SAMPLE_RAW
      x86: Move MAX_INSN_SIZE into asm/insn.h
      perf, x86: Fix silly bug in data store buffer allocation
      perf, x86: Disable PEBS on clovertown chips
      perf, x86: Clear the LBRs on init
      perf, x86: Robustify PEBS fixup
      perf, x86: Avoid double disable on throttle vs ioctl(PERF_IOC_DISABLE)
      perf, x86: Fix pebs drains
      perf, x86: Fix PEBS enable/disable vs cpuc->enabled
      perf, x86: Fix LBR enable/disable vs cpuc->enabled
      perf, x86: Reorder intel_pmu_enable_all()
      perf, x86: Deal with multiple state bits for pebs-fmt1
      perf, x86: Fix silly bug in intel_pmu_pebs_{enable,disable}
      perf, x86: Don't reset the LBR as frequently
      perf, x86: Remove checking_{wr,rd}msr() usage
      perf, x86: Fixup the PEBS handler for Core2 cpus
      perf, x86: Fix LBR read-out
      perf, x86: Clean up debugctlmsr bit definitions
      x86, perf, bts, mm: Delete the never used BTS-ptrace code
      x86, ptrace: Fix block-step
      perf, x86: Add Nehelem PMU programming errata workaround
      perf, x86: Fix up the ANY flag stuff
      perf, x86: Fix __initconst vs const
      perf, x86: Add Nehalem programming quirk to Westmere
      perf: Fix exit() vs PERF_FORMAT_GROUP
      perf: Annotate perf_event_read_group() vs perf_event_release_kernel()
      perf, x86: Remove PEBS SAMPLE_RAW support
      perf, x86: Consolidate some code repetition
      perf, x86: Improve the PEBS ABI
      perf: Fix exit() vs PERF_FORMAT_GROUP
      perf: Fix exit() vs event-groups

Randy Dunlap (2):
      perf bench: fix spello
      perf: cleanup some Documentation

Robert Richter (12):
      perf, x86: Report error code that returned from x86_pmu.hw_config()
      perf/core, x86: Reduce number of CONFIG_X86_LOCAL_APIC macros
      perf/core: Correct files in MAINTAINERS entry
      perf/core, x86: Remove cpu_hw_events.interrupts
      perf/core, x86: Remove duplicate perf_event_mask variable
      perf, x86: Undo some some *_counter* -> *_event* renames
      perf, x86: implement ARCH_PERFMON_EVENTSEL bit masks
      perf, x86: Move perfctr init code to x86_setup_perfctr()
      perf, x86: Move x86_setup_perfctr()
      perf, x86: Call x86_setup_perfctr() from .hw_config()
      perf, x86: Pass enable bit mask to __x86_pmu_enable_event()
      perf, x86: Use weight instead of cmask in for_each_event_constraint()

Stefan Hajnoczi (1):
      perf tools: Fix libdw-dev package name in error message

Stephane Eranian (4):
      perf_events: Fix resource leak in x86 __hw_perf_event_init()
      perf: Fix initialization bug in parse_single_tracepoint_event()
      perf tools: change event inheritance logic in stat and record
      perf record: Fix bug mismatch with -c option definition

Thomas Gleixner (1):
      perf: Fix dynamic field detection

Tom Zanussi (25):
      perf: Add pipe-specific header read/write and event processing code
      perf record: Introduce special handling for pipe output
      perf report: Introduce special handling for pipe input
      perf trace: Introduce special handling for pipe input
      perf: Convert perf header attrs into attr events
      perf: Convert perf event types into event type events
      perf: Convert perf tracing data into a tracing_data event
      perf: Convert perf header build_ids into build_id events
      perf trace/scripting: Add rwtop and sctop scripts
      perf trace/scripting: Enable scripting shell scripts for live mode
      perf trace: Invoke live mode automatically if record/report not specified
      perf/live: don't synthesize build ids at the end of a live mode trace
      perf: add perf-inject builtin
      perf: record TRACE_INFO only if using tracepoints and SAMPLE_RAW
      perf/record: simplify TRACE_INFO tracepoint check
      perf/live-mode: Handle payload-less events
      perf/trace/scripting: failed-syscalls script cleanup
      perf/trace/scripting: rw-by-pid script cleanup
      perf/trace/scripting: rwtop script cleanup
      perf/trace/scripting: wakeup-latency script cleanup
      perf/trace/scripting: workqueue-stats script cleanup
      perf/trace/scripting: don't show script start/stop messages by default
      perf/trace/scripting: failed-syscalls-by-pid script cleanup
      perf/trace/scripting: syscall-counts-by-pid script cleanup
      perf/trace/scripting: syscall-counts script cleanup

William Cohen (1):
      perf: Some perf-kvm documentation edits

Zhang, Yanmin (8):
      perf stat: Enable counters when collecting process-wide or system-wide data
      perf record: Enable counters only when kernel is execing subcommand
      perf events: Change perf parameter --pid to process-wide collection instead of thread-wide
      perf record: Zero out mmap_array to fix segfault
      perf: Enhance perf to allow for guest statistic collection from host
      KVM: Implement perf callbacks for guest sampling
      perf: 'perf kvm' tool for monitoring guest performance from host
      perf & kvm: Clean up some of the guest profiling callback API details

eranian@google.com (1):
      perf_events: Improve task_sched_in()


 Documentation/kprobes.txt                          |   10 +-
 Documentation/trace/kprobetrace.txt                |    4 +-
 MAINTAINERS                                        |   10 +-
 arch/Kconfig                                       |   20 +-
 arch/powerpc/kernel/perf_event.c                   |  129 +-
 arch/sh/Kconfig                                    |    1 +
 arch/sh/include/asm/hw_breakpoint.h                |   10 +-
 arch/sh/kernel/hw_breakpoint.c                     |   34 +-
 arch/sh/kernel/ptrace_32.c                         |    2 +-
 arch/x86/Kconfig                                   |    4 +
 arch/x86/Kconfig.cpu                               |   20 -
 arch/x86/Kconfig.debug                             |    9 -
 arch/x86/include/asm/apic.h                        |   13 +-
 arch/x86/include/asm/ds.h                          |  302 ----
 arch/x86/include/asm/hw_breakpoint.h               |   10 +-
 arch/x86/include/asm/insn.h                        |    2 +
 arch/x86/include/asm/kprobes.h                     |    2 +-
 arch/x86/include/asm/msr-index.h                   |   15 +-
 arch/x86/include/asm/perf_event.h                  |   76 +-
 arch/x86/include/asm/perf_event_p4.h               |  794 ++++++++++
 arch/x86/include/asm/processor.h                   |   35 +-
 arch/x86/include/asm/ptrace-abi.h                  |   57 +-
 arch/x86/include/asm/ptrace.h                      |    6 -
 arch/x86/include/asm/thread_info.h                 |    8 +-
 arch/x86/kernel/Makefile                           |    2 -
 arch/x86/kernel/cpu/intel.c                        |    2 -
 arch/x86/kernel/cpu/perf_event.c                   |  815 +++++-----
 arch/x86/kernel/cpu/perf_event_amd.c               |   46 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |  357 +++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  641 ++++++++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |  218 +++
 arch/x86/kernel/cpu/perf_event_p4.c                |  857 +++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c                |   31 +-
 arch/x86/kernel/ds.c                               | 1437 ------------------
 arch/x86/kernel/ds_selftest.c                      |  408 -----
 arch/x86/kernel/ds_selftest.h                      |   15 -
 arch/x86/kernel/dumpstack.c                        |    5 -
 arch/x86/kernel/hw_breakpoint.c                    |   41 +-
 arch/x86/kernel/kprobes.c                          |   16 +-
 arch/x86/kernel/process.c                          |   18 +-
 arch/x86/kernel/process_32.c                       |    8 -
 arch/x86/kernel/process_64.c                       |    8 -
 arch/x86/kernel/ptrace.c                           |  384 +-----
 arch/x86/kernel/step.c                             |   46 +-
 arch/x86/kernel/traps.c                            |    4 +-
 arch/x86/kvm/vmx.c                                 |    5 +-
 arch/x86/kvm/x86.c                                 |   50 +
 arch/x86/kvm/x86.h                                 |    3 +
 arch/x86/lib/Makefile                              |    2 +-
 arch/x86/oprofile/op_model_ppro.c                  |    4 +-
 include/linux/ftrace.h                             |   12 -
 include/linux/hw_breakpoint.h                      |   25 +-
 include/linux/mm.h                                 |    4 -
 include/linux/perf_event.h                         |   83 +-
 include/linux/ptrace.h                             |   12 -
 include/linux/sched.h                              |    9 -
 include/trace/events/lock.h                        |   55 +-
 include/trace/ftrace.h                             |   23 +-
 kernel/fork.c                                      |    3 -
 kernel/hw_breakpoint.c                             |  196 ++-
 kernel/kprobes.c                                   |  132 +-
 kernel/lockdep.c                                   |    4 +-
 kernel/perf_event.c                                |  377 ++++--
 kernel/ptrace.c                                    |    1 -
 kernel/sched.c                                     |   43 -
 kernel/trace/Kconfig                               |   11 -
 kernel/trace/Makefile                              |    1 -
 kernel/trace/trace.h                               |   20 +-
 kernel/trace/trace_entries.h                       |   12 -
 kernel/trace/trace_events_filter.c                 |    2 +-
 kernel/trace/trace_hw_branches.c                   |  312 ----
 kernel/trace/trace_kprobe.c                        |  535 ++++---
 kernel/trace/trace_ksym.c                          |   26 +-
 kernel/trace/trace_selftest.c                      |   57 -
 mm/mlock.c                                         |   41 -
 tools/perf/Documentation/perf-annotate.txt         |    2 +-
 tools/perf/Documentation/perf-bench.txt            |    8 +-
 tools/perf/Documentation/perf-buildid-cache.txt    |    4 +-
 tools/perf/Documentation/perf-diff.txt             |    2 +-
 tools/perf/Documentation/perf-inject.txt           |   35 +
 tools/perf/Documentation/perf-kmem.txt             |    2 +-
 tools/perf/Documentation/perf-kvm.txt              |   68 +
 tools/perf/Documentation/perf-list.txt             |   33 +-
 tools/perf/Documentation/perf-probe.txt            |   21 +-
 tools/perf/Documentation/perf-record.txt           |    8 +-
 tools/perf/Documentation/perf-sched.txt            |    4 +-
 tools/perf/Documentation/perf-stat.txt             |    4 +-
 tools/perf/Documentation/perf-test.txt             |   22 +
 tools/perf/Documentation/perf-trace-perl.txt       |    6 +-
 tools/perf/Documentation/perf-trace-python.txt     |   16 +-
 tools/perf/Documentation/perf-trace.txt            |    2 +-
 tools/perf/Makefile                                |  388 +++---
 tools/perf/arch/powerpc/Makefile                   |    4 +
 tools/perf/arch/powerpc/util/dwarf-regs.c          |   88 ++
 tools/perf/arch/x86/Makefile                       |    4 +
 tools/perf/arch/x86/util/dwarf-regs.c              |   75 +
 tools/perf/bench/mem-memcpy.c                      |    3 +-
 tools/perf/bench/sched-messaging.c                 |   10 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-annotate.c                      |  245 +---
 tools/perf/builtin-bench.c                         |    4 +-
 tools/perf/builtin-buildid-cache.c                 |    2 +-
 tools/perf/builtin-buildid-list.c                  |    8 +-
 tools/perf/builtin-diff.c                          |   76 +-
 tools/perf/builtin-help.c                          |    8 +-
 tools/perf/builtin-inject.c                        |  228 +++
 tools/perf/builtin-kmem.c                          |   22 +-
 tools/perf/builtin-kvm.c                           |  144 ++
 tools/perf/builtin-lock.c                          |  693 ++++++----
 tools/perf/builtin-probe.c                         |  286 ++---
 tools/perf/builtin-record.c                        |  547 +++++---
 tools/perf/builtin-report.c                        |  228 ++--
 tools/perf/builtin-sched.c                         |   41 +-
 tools/perf/builtin-stat.c                          |  161 ++-
 tools/perf/builtin-test.c                          |  281 ++++
 tools/perf/builtin-timechart.c                     |  119 +--
 tools/perf/builtin-top.c                           |  298 +++--
 tools/perf/builtin-trace.c                         |   97 ++-
 tools/perf/builtin.h                               |    3 +
 tools/perf/command-list.txt                        |    3 +
 tools/perf/perf-archive.sh                         |    3 +
 tools/perf/perf.c                                  |    8 +-
 tools/perf/perf.h                                  |    9 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    6 +
 .../perf/scripts/perl/bin/check-perf-trace-record  |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    8 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    3 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    8 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +
 tools/perf/scripts/perl/bin/rwtop-report           |   23 +
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |    6 +-
 tools/perf/scripts/perl/rw-by-pid.pl               |   60 +-
 tools/perf/scripts/perl/rwtop.pl                   |  199 +++
 tools/perf/scripts/perl/wakeup-latency.pl          |   12 +-
 tools/perf/scripts/perl/workqueue-stats.pl         |   12 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    3 +
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    8 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +
 tools/perf/scripts/python/bin/sctop-report         |   24 +
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    8 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    8 +-
 tools/perf/scripts/python/sctop.py                 |   78 +
 tools/perf/util/PERF-VERSION-GEN                   |    6 +-
 tools/perf/util/bitmap.c                           |   21 +
 tools/perf/util/build-id.c                         |    2 +-
 tools/perf/util/cache.h                            |   14 +
 tools/perf/util/callchain.c                        |  121 ++-
 tools/perf/util/callchain.h                        |   10 +-
 tools/perf/util/color.c                            |   48 +
 tools/perf/util/color.h                            |    4 +
 tools/perf/util/debug.c                            |    8 +-
 tools/perf/util/debug.h                            |   30 +-
 tools/perf/util/event.c                            |  368 ++++--
 tools/perf/util/event.h                            |   66 +-
 tools/perf/util/header.c                           |  489 ++++++-
 tools/perf/util/header.h                           |   39 +-
 tools/perf/util/hist.c                             |  613 +++++++--
 tools/perf/util/hist.h                             |  102 ++-
 tools/perf/util/hweight.c                          |   31 +
 tools/perf/util/include/asm/bitops.h               |   18 -
 tools/perf/util/include/asm/hweight.h              |    8 +
 tools/perf/util/include/dwarf-regs.h               |    8 +
 tools/perf/util/include/linux/bitmap.h             |   38 +-
 tools/perf/util/include/linux/bitops.h             |   20 +-
 tools/perf/util/include/linux/compiler.h           |    2 +
 tools/perf/util/include/linux/kernel.h             |   11 +-
 tools/perf/util/map.c                              |  409 +++++-
 tools/perf/util/map.h                              |  131 ++-
 tools/perf/util/newt.c                             | 1084 ++++++++++++++
 tools/perf/util/parse-events.c                     |   44 +-
 tools/perf/util/parse-events.h                     |    1 +
 tools/perf/util/parse-options.c                    |   55 +-
 tools/perf/util/parse-options.h                    |   29 +-
 tools/perf/util/probe-event.c                      | 1580 +++++++++++++++-----
 tools/perf/util/probe-event.h                      |  130 ++-
 tools/perf/util/probe-finder.c                     | 1046 ++++++++++----
 tools/perf/util/probe-finder.h                     |   67 +-
 tools/perf/util/pstack.c                           |   75 +
 tools/perf/util/pstack.h                           |   12 +
 .../perf/util/scripting-engines/trace-event-perl.c |    3 -
 .../util/scripting-engines/trace-event-python.c    |    4 -
 tools/perf/util/session.c                          |  568 ++++++--
 tools/perf/util/session.h                          |  126 ++-
 tools/perf/util/sort.c                             |  153 +-
 tools/perf/util/sort.h                             |   35 +-
 tools/perf/util/string.c                           |   45 +-
 tools/perf/util/string.h                           |   18 -
 tools/perf/util/symbol.c                           |  564 ++++++--
 tools/perf/util/symbol.h                           |   80 +-
 tools/perf/util/thread.c                           |  242 +---
 tools/perf/util/thread.h                           |   53 +-
 tools/perf/util/trace-event-info.c                 |   35 +
 tools/perf/util/trace-event-parse.c                |  118 +--
 tools/perf/util/trace-event-read.c                 |  116 +-
 tools/perf/util/trace-event.h                      |    8 +-
 tools/perf/util/util.c                             |   22 +
 tools/perf/util/util.h                             |   22 +
 207 files changed, 14651 insertions(+), 8110 deletions(-)
 delete mode 100644 arch/x86/include/asm/ds.h
 create mode 100644 arch/x86/include/asm/perf_event_p4.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_ds.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_lbr.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_p4.c
 delete mode 100644 arch/x86/kernel/ds.c
 delete mode 100644 arch/x86/kernel/ds_selftest.c
 delete mode 100644 arch/x86/kernel/ds_selftest.h
 delete mode 100644 kernel/trace/trace_hw_branches.c
 create mode 100644 tools/perf/Documentation/perf-inject.txt
 create mode 100644 tools/perf/Documentation/perf-kvm.txt
 create mode 100644 tools/perf/Documentation/perf-test.txt
 create mode 100644 tools/perf/arch/powerpc/Makefile
 create mode 100644 tools/perf/arch/powerpc/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/x86/Makefile
 create mode 100644 tools/perf/arch/x86/util/dwarf-regs.c
 create mode 100644 tools/perf/builtin-inject.c
 create mode 100644 tools/perf/builtin-kvm.c
 create mode 100644 tools/perf/builtin-test.c
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
 create mode 100644 tools/perf/scripts/perl/rwtop.pl
 create mode 100644 tools/perf/scripts/python/bin/sctop-record
 create mode 100644 tools/perf/scripts/python/bin/sctop-report
 create mode 100644 tools/perf/scripts/python/sctop.py
 create mode 100644 tools/perf/util/bitmap.c
 create mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/bitops.h
 create mode 100644 tools/perf/util/include/asm/hweight.h
 create mode 100644 tools/perf/util/include/dwarf-regs.h
 create mode 100644 tools/perf/util/newt.c
 create mode 100644 tools/perf/util/pstack.c
 create mode 100644 tools/perf/util/pstack.h
 delete mode 100644 tools/perf/util/string.h

[ ~1MB patch omitted due to lkml limits ]
