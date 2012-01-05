Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2AEOEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:04:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab2AEOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:04:36 -0500
Date: Thu, 5 Jan 2012 15:02:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.3
Message-ID: <20120105140234.GA31813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

 Thanks,

	Ingo

------------------>
Andreas Krebbel (1):
      oprofile, s390: Add event interface to the System z hardware sampling module

Andrew Vagin (3):
      events: Don't divide events if it has field period
      perf tools: Add ability to synthesize event according to a sample
      perf record: Add ability to record event period

Arnaldo Carvalho de Melo (28):
      perf tools: Eliminate duplicate code and use PATH_MAX consistently
      perf tools: Simplify debugfs mountpoint handling code
      perf evlist: Introduce perf_evlist__add_attrs
      perf evlist: Introduce add_tracepoints method
      perf evsel: Introduce config attr method
      perf evlist: Introduce {prepare,start}_workload refactored from 'perf record'
      perf evlist: Handle default value for 'pages' on mmap method
      perf record: Move mmap_pages to perf_record_opts
      perf session: Move threads to struct machine
      perf record: Move 'group' to perf_event_ops
      perf ui progress: Fix divide by zero
      perf symbols: Add nr_events to symbol_conf
      perf evlist: Introduce id_hdr_size method out of perf_session
      perf event: perf_event_ops->attr() manipulates only an evlist
      perf session: Remove superfluous callchain_cursor member
      perf tools: Use evsel->attr.sample_type instead of session->sample_type
      perf report: Group options in a struct
      perf annotate: Group options in a struct
      perf tools: Pass tool context in the the perf_event_ops functions
      perf tools: Resolve machine earlier and pass it to perf_event_ops
      perf tools: Rename perf_event_ops to perf_tool
      perf top: Stop using globals for tool state
      perf tools: Save some loops using perf_evlist__id2evsel
      perf evlist: Always do automatic allocation of pollfd and mmap structures
      perf test: Allow running just a subset of the available tests
      perf event: Introduce perf_event__fprintf
      perf test: Validate PERF_RECORD_ events and perf_sample fields
      perf test: Soft errors shouldn't stop the "Validate PERF_RECORD_" test

Borislav Petkov (1):
      perf: Carve out callchain functionality

David Ahern (5):
      perf tools: make -C consistent across commands (for cpu list arg)
      perf script: Add comm filtering option
      perf tools: Fix comm for processes with named threads
      perf tools: Look up thread names for system wide profiling
      perf script: look up thread using tid instead of pid

Gleb Natapov (4):
      jump_label: jump_label_inc may return before the code is patched
      perf, core: Rate limit perf_sched_events jump_label patching
      x86, perf: Disable non available architectural events
      perf, x86: Expose perf capability to other modules

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

Ingo Molnar (2):
      perf tools: Fix truncated annotation
      perf tools: Fix feature-bits rework fallout, remove unused variable

Jiri Olsa (2):
      tracing/latency: Fix header output for latency tracers
      perf test: Add more automated tests for event parsing

Joerg Roedel (1):
      perf kvm: Fix copy & paste error in description

Li Zefan (2):
      tracing: Restore system filter behavior
      tracing: update Documentation on max preds limit

Masami Hiramatsu (7):
      x86, perf: Add a build-time sanity test to the x86 decoder
      x86/tools: Fix Makefile to build all test tools
      x86: Fix instruction decoder to handle grouped AVX instructions
      x86/tools: Fix instruction decoder message output
      x86/tools: Fix insn_sanity message outputs
      x86: Update instruction decoder to support new AVX formats
      x86/tools: Add decoded instruction dump mode

Namhyung Kim (11):
      perf report: Document '--call-graph' for optional print_limit argument
      perf symbols: Get rid of duplicated snprintf()
      perf symbols: Fix error path on symbol__init()
      perf tools: Fix a memory leak on perf_read_values_destroy
      perf tools: Remove stale git headlines from top comment
      perf events: Tidy up perf_event__preprocess_sample
      perf report: Fix usage string
      perf session: Remove impossible condition check
      perf stat: Introduce get_ratio_color() helper
      perf top: Fix a memory leak
      perf script: Kill script_spec__delete

Nelson Elhage (3):
      perf evlist: Fix errno value reporting on failed mmap
      perf: builtin-record: Provide advice if mmap'ing fails with EPERM.
      perf: builtin-record: Document and check that mmap_pages must be a power of two.

Peter Zijlstra (7):
      perf: Avoid a useless pmu_disable() in the perf-tick
      perf, x86: Prefer fixed-purpose counters when scheduling
      perf: Remove superfluous arguments
      perf: Fix enable_on_exec for sibling events
      jump_label, x86: Fix section mismatch
      jump_label: Provide jump_label_key initializers
      perf, x86: Implement arch event mask as quirk

Robert Richter (17):
      oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
      oprofile: Remove exit function for timer mode
      oprofile, x86: Reimplement nmi timer mode using perf event
      perf, x86: Implement event scheduler helper functions
      perf, x86: Fix event scheduler for constraints with overlapping counters
      oprofile: Fix oprofile_timer_exit() breakage
      perf script: Fix mem leaks and NULL pointer checks around strdup()s
      perf script: Implement option for system-wide profiling
      perf evsel: Fix uninitialized memory access to struct perf_sample
      perf tools: Improve macros for struct feature_ops
      perf tools: Continue processing header on unknown features
      perf tools: Fix out-of-bound access to struct perf_session
      perf tools: Moving code in some files
      perf report: Accept fifos as input file
      perf tools: Unify handling of features when writing feature section
      perf tools: Use for_each_set_bit() to iterate over feature flags
      perf script: Add generic perl handler to process events

Stephane Eranian (4):
      perf events: Enable raw event support for Intel unhalted_reference_cycles event
      perf events: Add PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
      perf events: Add Intel x86 mapping for PERF_COUNT_HW_REF_CPU_CYCLES
      perf: Add support for PERF_HW_COUNT_REF_CPU_CYCLES

Steven Rostedt (7):
      tracing: Add boiler plate for subsystem filter
      lockdep: Show subclass in pretty print of lockdep output
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()
      ftrace: Fix hash record accounting bug
      tracing: Add irq, preempt-count and need resched info to default trace output
      tracing: Add entries in buffer and total entries to default output header


 Documentation/kernel-parameters.txt                |    5 +
 Documentation/trace/events.txt                     |    2 -
 arch/Kconfig                                       |    4 +
 arch/s390/oprofile/hwsampler.c                     |    7 +-
 arch/s390/oprofile/init.c                          |  373 +++++++++-
 arch/s390/oprofile/op_counter.h                    |   23 +
 arch/x86/include/asm/insn.h                        |    7 +
 arch/x86/include/asm/perf_event.h                  |   44 +-
 arch/x86/kernel/cpu/perf_event.c                   |  262 ++++++--
 arch/x86/kernel/cpu/perf_event.h                   |   51 ++-
 arch/x86/kernel/cpu/perf_event_amd.c               |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   88 ++-
 arch/x86/kernel/jump_label.c                       |    2 +-
 arch/x86/lib/inat.c                                |    9 +-
 arch/x86/lib/insn.c                                |    4 +-
 arch/x86/lib/x86-opcode-map.txt                    |  606 +++++++++-------
 arch/x86/oprofile/Makefile                         |    3 +-
 arch/x86/oprofile/init.c                           |   30 +-
 arch/x86/oprofile/nmi_int.c                        |   27 +-
 arch/x86/oprofile/nmi_timer_int.c                  |   50 --
 arch/x86/tools/Makefile                            |   11 +-
 arch/x86/tools/gen-insn-attr-x86.awk               |   21 +-
 arch/x86/tools/insn_sanity.c                       |  275 ++++++++
 drivers/oprofile/nmi_timer_int.c                   |  173 +++++
 drivers/oprofile/oprof.c                           |   30 +-
 drivers/oprofile/oprof.h                           |   10 +-
 drivers/oprofile/timer_int.c                       |   30 +-
 include/linux/bitops.h                             |   10 +-
 include/linux/jump_label.h                         |   27 +
 include/linux/perf_event.h                         |    8 +-
 kernel/events/Makefile                             |    2 +-
 kernel/events/callchain.c                          |  191 +++++
 kernel/events/core.c                               |  296 ++-------
 kernel/events/internal.h                           |   39 +-
 kernel/jump_label.c                                |   49 ++-
 kernel/lockdep.c                                   |   30 +-
 kernel/trace/trace.c                               |  105 +++-
 kernel/trace/trace.h                               |    2 +
 kernel/trace/trace_events_filter.c                 |   26 +-
 kernel/trace/trace_irqsoff.c                       |   13 +-
 kernel/trace/trace_output.c                        |   16 +-
 kernel/trace/trace_sched_wakeup.c                  |   13 +-
 tools/perf/Documentation/perf-annotate.txt         |    4 +-
 tools/perf/Documentation/perf-buildid-list.txt     |    2 +-
 tools/perf/Documentation/perf-evlist.txt           |    2 +-
 tools/perf/Documentation/perf-kmem.txt             |    2 +-
 tools/perf/Documentation/perf-lock.txt             |    2 +-
 tools/perf/Documentation/perf-record.txt           |    2 +-
 tools/perf/Documentation/perf-report.txt           |   11 +-
 tools/perf/Documentation/perf-sched.txt            |    2 +-
 tools/perf/Documentation/perf-script.txt           |    9 +-
 tools/perf/Documentation/perf-test.txt             |    8 +-
 tools/perf/Documentation/perf-timechart.txt        |    2 +-
 tools/perf/Makefile                                |    1 +
 tools/perf/builtin-annotate.c                      |  132 ++--
 tools/perf/builtin-buildid-list.c                  |   53 +-
 tools/perf/builtin-diff.c                          |   21 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-inject.c                        |  118 ++--
 tools/perf/builtin-kmem.c                          |   16 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |   12 +-
 tools/perf/builtin-probe.c                         |    1 -
 tools/perf/builtin-record.c                        |  603 +++++++---------
 tools/perf/builtin-report.c                        |  236 ++++---
 tools/perf/builtin-sched.c                         |  200 +++---
 tools/perf/builtin-script.c                        |  130 ++--
 tools/perf/builtin-stat.c                          |  134 ++---
 tools/perf/builtin-test.c                          |  545 ++++++++++++++-
 tools/perf/builtin-timechart.c                     |   38 +-
 tools/perf/builtin-top.c                           |  558 +++++++--------
 tools/perf/perf.c                                  |   33 +-
 tools/perf/perf.h                                  |   24 +
 tools/perf/util/annotate.c                         |    8 +-
 tools/perf/util/annotate.h                         |    5 +-
 tools/perf/util/build-id.c                         |   26 +-
 tools/perf/util/build-id.h                         |    2 +-
 tools/perf/util/callchain.h                        |    3 +
 tools/perf/util/cgroup.c                           |   15 +-
 tools/perf/util/config.c                           |    5 +-
 tools/perf/util/debugfs.c                          |   35 +-
 tools/perf/util/debugfs.h                          |   31 +-
 tools/perf/util/event.c                            |  360 ++++++----
 tools/perf/util/event.h                            |   68 ++-
 tools/perf/util/evlist.c                           |  299 ++++++++-
 tools/perf/util/evlist.h                           |   43 ++-
 tools/perf/util/evsel.c                            |  154 ++++-
 tools/perf/util/evsel.h                            |    8 +
 tools/perf/util/header.c                           |  741 +++++++++-----------
 tools/perf/util/header.h                           |   51 +-
 tools/perf/util/hist.h                             |    3 +-
 tools/perf/util/include/linux/bitops.h             |  118 ++++
 tools/perf/util/map.c                              |    4 +
 tools/perf/util/map.h                              |   19 +
 tools/perf/util/parse-events.c                     |   30 +-
 tools/perf/util/parse-events.h                     |    1 -
 tools/perf/util/probe-finder.h                     |    1 -
 .../perf/util/scripting-engines/trace-event-perl.c |   75 ++-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |  342 ++++++----
 tools/perf/util/session.h                          |   72 +--
 tools/perf/util/setup.py                           |    3 +-
 tools/perf/util/symbol.c                           |   11 +-
 tools/perf/util/symbol.h                           |    1 +
 tools/perf/util/thread.c                           |    6 +-
 tools/perf/util/thread.h                           |   14 +-
 tools/perf/util/tool.h                             |   50 ++
 tools/perf/util/top.h                              |   20 +-
 tools/perf/util/trace-event-info.c                 |   28 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    8 +-
 tools/perf/util/ui/browsers/annotate.c             |   16 +-
 tools/perf/util/ui/browsers/hists.c                |    2 +-
 tools/perf/util/ui/progress.c                      |    3 +
 tools/perf/util/usage.c                            |    5 +-
 tools/perf/util/util.h                             |   11 +
 tools/perf/util/values.c                           |    1 +
 117 files changed, 5582 insertions(+), 3003 deletions(-)
 create mode 100644 arch/s390/oprofile/op_counter.h
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 arch/x86/tools/insn_sanity.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c
 create mode 100644 kernel/events/callchain.c
 create mode 100644 tools/perf/util/tool.h

[ patch body snipped due to lkml size limits ]
