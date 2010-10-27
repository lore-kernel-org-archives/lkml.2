Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0J0MGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:06:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab0J0MGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:06:50 -0400
Date: Wed, 27 Oct 2010 14:06:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates for v2.6.37, #2
Message-ID: <20101027120629.GA11857@elte.hu>
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

Please pull the latest perf git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

This includes a few late items as well - if it's still fine to you for this merge 
window.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (10):
      perf tools: Remove direct slang.h include
      perf probe: Fix format specified for Dwarf_Off parameter
      perf python scripting: Improve the failed-syscalls-by-pid script
      perf python scripting: Improve the syscalls-counts script
      perf python scripting: print the syscall name on sctop
      perf python scripting: Improve the syscalls-by-pid script
      perf python scripting: Support fedora 11 (audit 1.7.17)
      perf scripting: Shut up 'perf record' final status
      perf python scripting: Fixup cut'n'paste error in sctop script
      perf python scripting: Add futex-contention script

Ben Hutchings (2):
      perf trace: Use $PERF_EXEC_PATH in canned report scripts
      perf trace: Fix detection of script extension

Ingo Molnar (1):
      x86/oprofile: Fix uninitialized variable use in debug printk

Joe Perches (1):
      tracing: Fix 'faild' -> 'failed' typo

Masami Hiramatsu (8):
      perf probe: Fix type searching
      perf probe: Fix local variable searching loop
      perf probe: Support global variables
      perf probe: Show accessible local variables
      perf probe: Function style fix
      perf probe: Show accessible global variables
      perf probe: Add basic module support
      kprobes: Remove redundant text_mutex lock in optimize

Matt Fleming (1):
      perf record: Remove newline character from perror() argument

Peter Zijlstra (7):
      perf, x86: Extract PEBS/BTS buffer free routines
      perf, x86: Extract PEBS/BTS allocation functions
      perf, x86: Extract DS alloc/free functions
      perf, x86: Fixup the precise_ip computation
      perf, x86: Less disastrous PEBS/BTS buffer allocation failure
      perf, x86: Clean up reserve_ds_buffers() signature
      perf, x86: Use NUMA aware allocations for PEBS/BTS/DS allocations

Robert Richter (7):
      oprofile, x86: Add support for AMD family 12h
      oprofile, x86: Add support for AMD family 14h
      oprofile, x86: Check IBS capability bits 1 and 2
      oprofile, x86: Remove duplicate check for IBS_CAPS_OPCNT
      oprofile, x86: Introduce struct ibs_state
      oprofile, x86: Add support for IBS branch target address reporting
      oprofile, x86: Add support for IBS periodic op counter extension

Sonny Rao (1):
      perf tools: Document event modifiers

Stephane Eranian (2):
      perf_events: Revert: Fix transaction recovery in group_sched_in()
      perf_events: Fix for transaction recovery in group_sched_in()

Steven Rostedt (9):
      ring-buffer: Make write slow path out of line
      ring-buffer: Pass timestamp by value and not by reference
      ring-buffer: Pass delta by value and not by reference
      ring-buffer: Remove ring_buffer_event_time_delta()
      ring-buffer: Bind time extend and data events together
      ring-buffer: Remove condition to add timestamp in fast path
      ring-buffer: Micro-optimize with some strategic inlining
      ring-buffer: Remove unused macro RB_TIMESTAMPS_PER_PAGE
      tracing: Do not limit the size of the number of CPU buffers

Thomas Gleixner (1):
      tracing: Cleanup the convoluted softirq tracepoints


 arch/x86/include/asm/msr-index.h                   |    1 +
 arch/x86/include/asm/perf_event.h                  |   19 +-
 arch/x86/kernel/cpu/perf_event.c                   |   21 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  216 +++++--
 arch/x86/oprofile/nmi_int.c                        |    6 +
 arch/x86/oprofile/op_model_amd.c                   |  146 +++--
 include/linux/interrupt.h                          |    2 +-
 include/linux/ring_buffer.h                        |   12 -
 include/trace/events/irq.h                         |   54 +-
 kernel/kprobes.c                                   |    7 +-
 kernel/perf_event.c                                |   94 +--
 kernel/softirq.c                                   |   16 +-
 kernel/trace/ring_buffer.c                         |  335 ++++++-----
 kernel/trace/trace.c                               |    8 +-
 kernel/trace/trace_kprobe.c                        |    2 +-
 tools/perf/Documentation/perf-list.txt             |   17 +
 tools/perf/Documentation/perf-probe.txt            |   18 +-
 tools/perf/Documentation/perf-record.txt           |    4 +
 tools/perf/builtin-probe.c                         |   78 ++-
 tools/perf/builtin-record.c                        |    8 +-
 tools/perf/builtin-trace.c                         |   17 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   58 ++
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../scripts/python/bin/futex-contention-record     |    2 +
 .../scripts/python/bin/futex-contention-report     |    4 +
 tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   21 +-
 tools/perf/scripts/python/futex-contention.py      |   50 ++
 tools/perf/scripts/python/sctop.py                 |    9 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |   21 +-
 tools/perf/scripts/python/syscall-counts.py        |    5 +-
 tools/perf/util/debug.c                            |    4 +-
 tools/perf/util/debug.h                            |    2 +-
 tools/perf/util/map.h                              |   10 +
 tools/perf/util/probe-event.c                      |  189 +++++--
 tools/perf/util/probe-event.h                      |   16 +-
 tools/perf/util/probe-finder.c                     |  645 ++++++++++++++++----
 tools/perf/util/probe-finder.h                     |   31 +-
 tools/perf/util/ui/browser.c                       |    1 -
 49 files changed, 1502 insertions(+), 671 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-record
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-report
 create mode 100644 tools/perf/scripts/python/futex-contention.py

