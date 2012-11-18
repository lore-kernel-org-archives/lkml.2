Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2KRObA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:31:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:59398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2KROab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@amd64.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, David Howells <dhowells@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev@ozlabs.org, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, acme@ghostprotocols.net
Subject: [GIT PULL 00/32] perf/core improvements and fixes
Date: Sun, 18 Nov 2012 11:29:25 -0300
Message-Id: <1353248997-30763-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit ffadcf090d468e9c4938b718649f38dd10cfdb02:

  perf annotate: Handle XBEGIN like a jump (2012-10-31 12:18:26 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

for you to fetch changes up to 07ac002f2fcc74c5be47b656d9201d5de84dc53d:

  perf evsel: Introduce is_group_member method (2012-11-14 16:53:45 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. UAPI fixes, from David Howels

. Separate perf tests into multiple objects, one per test, from Jiri Olsa.

. Fixes to /proc/pid/maps parsing, preparatory to supporting data maps,
  from Namhyung Kim

. Fix compile error for non-NEWT builds, from Namhyung Kim

. Implement ui_progress for GTK, from Namhyung Kim

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf tools: Add arbitary aliases and support names with -

Arnaldo Carvalho de Melo (13):
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

Daniel Walter (1):
      tracing: Replace strict_strto* with kstrto*

David Howells (3):
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend

David Sharp (2):
      tracing: Trivial cleanup
      tracing: Reset ring buffer when changing trace_clocks

Feng Tang (1):
      perf browser: Don't show scripts menu for 'perf top'

Hiraku Toyooka (1):
      tracing: Change tracer's integer flags to bool

Ingo Molnar (2):
      Merge tag 'perf-core-for-mingo' of git://git.kernel.org/.../acme/linux into perf/core
      Merge branch 'tip/perf/core-2' of git://git.kernel.org/.../rostedt/linux-trace into perf/core

Jiri Olsa (47):
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

Michal Hocko (1):
      linux/kernel.h: Remove duplicate trace_printk declaration

Namhyung Kim (18):
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

Vaibhav Nagarnaik (1):
      tracing: Cleanup unnecessary function declarations

Yoshihiro YUNOMAE (1):
      ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts() to u64

Zheng Liu (1):
      perf test: fix a build error on builtin-test

 Documentation/kernel-parameters.txt                |   16 +
 Makefile                                           |    6 +-
 include/linux/ftrace_event.h                       |   14 +-
 include/linux/kernel.h                             |    7 +-
 include/linux/ring_buffer.h                        |    3 +-
 include/trace/ftrace.h                             |    3 +-
 include/trace/syscall.h                            |   23 -
 kernel/trace/Kconfig                               |    1 +
 kernel/trace/ftrace.c                              |    6 +-
 kernel/trace/ring_buffer.c                         |   51 +-
 kernel/trace/trace.c                               |  372 ++---
 kernel/trace/trace.h                               |   14 +-
 kernel/trace/trace_branch.c                        |    4 +-
 kernel/trace/trace_events.c                        |   51 +-
 kernel/trace/trace_events_filter.c                 |    4 +-
 kernel/trace/trace_functions.c                     |    5 +-
 kernel/trace/trace_functions_graph.c               |    6 +-
 kernel/trace/trace_irqsoff.c                       |   14 +-
 kernel/trace/trace_kprobe.c                        |   10 +-
 kernel/trace/trace_probe.c                         |   14 +-
 kernel/trace/trace_sched_switch.c                  |    4 +-
 kernel/trace/trace_sched_wakeup.c                  |   10 +-
 kernel/trace/trace_selftest.c                      |   13 +-
 kernel/trace/trace_syscalls.c                      |   61 +-
 kernel/trace/trace_uprobe.c                        |    2 +-
 tools/Makefile                                     |   24 +-
 tools/lib/traceevent/event-parse.c                 |   22 +-
 tools/perf/Makefile                                |   50 +-
 tools/perf/arch/common.c                           |   47 +-
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-diff.c                          |   48 +-
 tools/perf/builtin-record.c                        |   26 +-
 tools/perf/builtin-report.c                        |   11 +-
 tools/perf/builtin-stat.c                          |   12 +-
 tools/perf/builtin-test.c                          | 1559 --------------------
 tools/perf/builtin-top.c                           |   10 +-
 tools/perf/perf.c                                  |   17 +-
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
 .../parse-events-test.c => tests/parse-events.c}   |   23 +-
 tools/perf/tests/perf-record.c                     |  312 ++++
 tools/perf/tests/pmu.c                             |  178 +++
 tools/perf/tests/rdpmc.c                           |  175 +++
 tools/perf/tests/tests.h                           |   22 +
 tools/perf/tests/util.c                            |   30 +
 tools/perf/tests/vmlinux-kallsyms.c                |  230 +++
 tools/perf/ui/browsers/annotate.c                  |   39 +-
 tools/perf/ui/browsers/hists.c                     |   63 +-
 tools/perf/ui/gtk/browser.c                        |    4 +-
 tools/perf/ui/gtk/gtk.h                            |    1 +
 tools/perf/ui/gtk/progress.c                       |   59 +
 tools/perf/ui/gtk/setup.c                          |    2 +
 tools/perf/ui/gtk/util.c                           |   11 -
 tools/perf/ui/hist.c                               |   10 +-
 tools/perf/ui/progress.c                           |   44 +-
 tools/perf/ui/progress.h                           |   10 +
 tools/perf/ui/tui/progress.c                       |   42 +
 tools/perf/ui/tui/setup.c                          |    1 +
 tools/perf/ui/ui.h                                 |   28 +
 tools/perf/util/annotate.c                         |   69 +-
 tools/perf/util/annotate.h                         |    9 +-
 tools/perf/util/cache.h                            |   39 +-
 tools/perf/util/debug.h                            |    1 +
 tools/perf/util/dso.c                              |    1 +
 tools/perf/util/event.c                            |   74 +-
 tools/perf/util/evlist.c                           |   10 +-
 tools/perf/util/evsel.c                            |   52 +-
 tools/perf/util/evsel.h                            |    9 +-
 tools/perf/util/hist.c                             |   99 ++
 tools/perf/util/hist.h                             |   36 +-
 tools/perf/util/machine.c                          |  205 ++-
 tools/perf/util/machine.h                          |  131 +-
 tools/perf/util/map.c                              |  181 +--
 tools/perf/util/map.h                              |   93 --
 tools/perf/util/parse-events.c                     |   24 +
 tools/perf/util/parse-events.h                     |    1 -
 tools/perf/util/parse-events.l                     |    4 +-
 tools/perf/util/pmu.c                              |  185 +--
 tools/perf/util/pmu.h                              |    4 +
 tools/perf/util/pstack.c                           |   46 +-
 tools/perf/util/session.c                          |    1 +
 tools/perf/util/session.h                          |    5 +-
 tools/perf/util/sort.h                             |   27 +-
 tools/perf/util/symbol.c                           |    1 +
 tools/perf/util/symbol.h                           |   21 -
 tools/scripts/Makefile.include                     |   23 +-
 128 files changed, 4649 insertions(+), 2751 deletions(-)
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
 rename tools/perf/{util/parse-events-test.c => tests/parse-events.c} (97%)
 create mode 100644 tools/perf/tests/perf-record.c
 create mode 100644 tools/perf/tests/pmu.c
 create mode 100644 tools/perf/tests/rdpmc.c
 create mode 100644 tools/perf/tests/tests.h
 create mode 100644 tools/perf/tests/util.c
 create mode 100644 tools/perf/tests/vmlinux-kallsyms.c
 create mode 100644 tools/perf/ui/gtk/progress.c
 create mode 100644 tools/perf/ui/tui/progress.c
