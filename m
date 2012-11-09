Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2KIVon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:44:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2KIVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Vinson Lee <vlee@twitter.com>,
        Zheng Liu <wenqing.lz@taobao.com>, acme@ghostprotocols.net,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/21] perf/core improvements and fixes
Date: Fri,  9 Nov 2012 18:42:49 -0300
Message-Id: <1352497390-17716-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

- Arnaldo

The following changes since commit 8dfec403e39b7c37fd6e8813bacc01da1e1210ab:

  perf tests: Removing 'optional' field (2012-11-05 14:03:59 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 27f94d52394003d444a383eaf8d4824daf32432e:

  tools lib traceevent: Use 'const' in variables pointing to const strings (2012-11-09 17:42:47 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Add a 'link' method for hists, so that we can have the leader with
  buckets for all the entries in all the hists.  This new method
  is now used in the default 'diff' output, making the sum of the 'baseline'
  column be 100%, eliminating blind spots. Now we need to use this
  for 'diff' with > 2 perf.data files and for multi event 'report' and
  'annotate'.

. libtraceevent fixes for compiler warnings trying to make perf it build
  on some distros, like fedora 14, 32-bit, some of the warnings really
  pointed to real bugs.

. Remove temp dir on failure in 'perf test', fix from Jiri Olsa.

. Fixes for handling data, stack mmaps, from Namhyung Kim.

. Fix live annotation bug related to recent objdump lookup patches, from
  Namhyung Kim

. Don't try to follow jump target on PLT symbols in the annotation browser,
  fix from Namhyung Kim.

. Fix leak on hist_entry delete, from Namhyung Kim.

. Fix a CPU_ALLOC related build error on builtin-test, from Zheng Liu.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf tools: Add arbitary aliases and support names with -

Arnaldo Carvalho de Melo (10):
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

Jiri Olsa (2):
      perf tests: Move attr.py temp dir cleanup into finally section
      perf tools: Add LIBDW_DIR Makefile variable to for alternate libdw

Namhyung Kim (7):
      perf machine: Set kernel data mapping length
      perf tools: Fix detection of stack area
      perf hists: Free branch_info when freeing hist_entry
      perf tools: Don't try to lookup objdump for live mode
      perf annotate: Whitespace fixups
      perf annotate: Don't try to follow jump target on PLT symbols
      perf annotate: Merge same lines in summary view

Zheng Liu (1):
      perf test: fix a build error on builtin-test

 tools/lib/traceevent/event-parse.c |   22 ++--
 tools/perf/Makefile                |   12 ++-
 tools/perf/arch/common.c           |    7 ++
 tools/perf/builtin-diff.c          |   48 ++-------
 tools/perf/tests/attr.py           |   30 +++---
 tools/perf/tests/builtin-test.c    |   39 +++----
 tools/perf/tests/dso-data.c        |    1 +
 tools/perf/ui/browsers/annotate.c  |   12 +++
 tools/perf/ui/hist.c               |   10 +-
 tools/perf/util/annotate.c         |   69 ++++++++++--
 tools/perf/util/annotate.h         |    1 +
 tools/perf/util/dso.c              |    1 +
 tools/perf/util/hist.c             |  100 ++++++++++++++++++
 tools/perf/util/hist.h             |    3 +
 tools/perf/util/machine.c          |  205 ++++++++++++++++++++++++++++++++++--
 tools/perf/util/machine.h          |  131 ++++++++++++++++++++++-
 tools/perf/util/map.c              |  181 +------------------------------
 tools/perf/util/map.h              |   93 ----------------
 tools/perf/util/parse-events.l     |    2 +
 tools/perf/util/session.h          |    5 +-
 tools/perf/util/sort.h             |   27 ++++-
 tools/perf/util/symbol.c           |    1 +
 tools/perf/util/symbol.h           |   20 ----
 23 files changed, 604 insertions(+), 416 deletions(-)
