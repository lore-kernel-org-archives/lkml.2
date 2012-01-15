Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2AOO0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 09:26:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2AOO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 09:26:16 -0500
Date: Sun, 15 Jan 2012 15:26:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates for v3.3
Message-ID: <20120115142602.GA28590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   HEAD: 172d1b0b73256551f100fc00c69e356d047103f5 perf tools: Fix compile error on x86_64 Ubuntu

These are the final perf bits for this merge window. The 
'x86/core' NMI bits didnt make it into the first perf/core pull 
request because they looked dangerous and i wanted them to have 
more testing. There's also some late ftrace bits. Beyond that 
it's mostly fixes.

[ Note, the diffstat is hand-generated, because git-request-pull
  could not generate the right diffstat. ]

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf hists: Rename total_session to total_period
      perf hists: Stop using 'self' for struct hist_entry
      perf top: Don't update total_period on process_sample

David Daney (1):
      recordmcount: Fix handling of elf64 big-endian objects.

Jiri Olsa (1):
      ftrace: Fix unregister ftrace_ops accounting

Joerg Roedel (2):
      perf kvm: Do guest-only counting by default
      perf tools: Add support for guest/host-only profiling

Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Namhyung Kim (9):
      perf script: Add missing closedir() calls
      perf test: Change type of '-v' option to INCR
      perf top: Add error message for EMFILE
      perf kmem: Add missing closedir() calls
      perf kmem: Fix a memory leak
      perf annotate: Fix usage string
      perf annotate: Get rid of field_sep check
      perf report: Fix --stdio output alignment when --showcpuutilization used
      perf tools: Fix compile error on x86_64 Ubuntu

Sebastian Andrzej Siewior (1):
      perf tools: Add const.h to MANIFEST to make perf-tar-src-pkg work again

Steven Rostedt (20):
      ftrace: Do not function trace inlined functions
      ftrace: Allow archs to modify code without stop machine
      ftrace: Remove usage of "freed" records
      ftrace: Allocate the mcount record pages as groups
      ftrace: Replace record newlist with record page list
      ftrace: Sort the mcount records on each page
      ftrace: Use bsearch to find record ip
      ftrace: Fix ftrace hash record update with notrace
      ftrace: Create ftrace_hash_empty() helper routine
      ftrace: Allow other users of function tracing to use the output listing
      ftrace: Decouple hash items from showing filtered functions
      tracing: Have stack_tracer use a separate list of functions
      ftrace: Allow access to the boot time function enabling
      tracing: Have stack tracing set filtered functions at boot
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes
      x86: Keep current stack in NMI breakpoints
      x86: Allow NMIs to hit breakpoints in i386
      x86: Add counter when debug stack is used with interrupts enabled
      tracing: Fix compile error when static ftrace is enabled

Tejun Heo (1):
      tracing: Factorize filter creation

 [ Note: hand-generated diffstat ]

 Documentation/kernel-parameters.txt    |    8 +
 arch/x86/include/asm/debugreg.h        |   22 +
 arch/x86/include/asm/desc.h            |   12 +
 arch/x86/kernel/cpu/common.c           |   24 +
 arch/x86/kernel/entry_64.S             |  218 ++++++++--
 arch/x86/kernel/head_64.S              |    4 +
 arch/x86/kernel/nmi.c                  |  102 +++++
 arch/x86/kernel/traps.c                |   20 +
 include/linux/compiler-gcc.h           |    5 +
 include/linux/ftrace.h                 |   77 ++++-
 kernel/trace/ftrace.c                  |  715 +++++++++++++++++++++++---------
 kernel/trace/trace_events_filter.c     |  283 +++++++-------
 kernel/trace/trace_stack.c             |   30 ++-
 scripts/recordmcount.h                 |    2 +-
 tools/perf/Documentation/perf-list.txt |    2 +
 tools/perf/MANIFEST                    |    1 +
 tools/perf/builtin-annotate.c          |    7 +-
 tools/perf/builtin-kmem.c              |    3 +
 tools/perf/builtin-kvm.c               |    6 +-
 tools/perf/builtin-script.c            |    4 +
 tools/perf/builtin-test.c              |    2 +-
 tools/perf/builtin-top.c               |    5 +-
 tools/perf/util/evlist.c               |    5 +-
 tools/perf/util/hist.c                 |  131 +++---
 tools/perf/util/hist.h                 |    7 +-
 tools/perf/util/parse-events.c         |   15 +-
 tools/perf/util/trace-event-info.c     |    1 -
 tools/perf/util/util.c                 |   15 +
 tools/perf/util/util.h                 |    4 +
 29 files changed, 1262 insertions(+), 468 deletions(-)
