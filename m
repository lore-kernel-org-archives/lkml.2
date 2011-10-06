Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1JFRXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:23:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab1JFRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:23:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: [GIT PULL 00/15] perf/core improvements
Date: Thu,  6 Oct 2011 14:22:23 -0300
Message-Id: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	It makes 'perf top' use the abstractions in 'perf report', allowing it
to:

1. Have total consistency with 'report'

2. Allow --sort to be used to have more views than just 'dso, symbol'
   Try 'perf top --sort comm' or 'pid' for instance

3. All the goodies in the TUI, like zooming in/out threads, dsos, etc

4. Integration with Live Annotation

5. In the live annotation window, navigate to functions called by the one
   being annotated (x86_64 only right now). This is just an experimentation
   in increasing the integration of the multiple perf tools, more of this
   kind to come.

6. Initial callchain support, not yet decaying it over time as the main
   view.

	Also in this batch is the work Stephane did on including information
about the machine where the perf.data file was collected.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (13):
  perf hists: Stop using 'self' for struct hists
  perf hists: Allow limiting the number of rows and columns in fprintf
  perf report: Add option to show total period
  perf hists: Threaded addition and sorting of entries
  perf browsers: Add live mode to the hists, annotate browsers
  perf top: Reuse the 'report' hist_entry/hists classes
  perf top: Add callgraph support
  perf annotate browser: Allow navigation to called functions
  perf top: Use the TUI interface by default
  perf annotate browser: Use -> to navigate on assembly lines
  perf hists browser: Don't offer symbol actions when symbols not on --sort
  perf hists browser: Fix TAB/UNTAB use with multiple events
  perf hists browser: Update the browser.nr_entries after the timer

Stephane Eranian (2):
  perf tools: Fix broken number of samples for perf report -n
  perf tools: Make perf.data more self-descriptive (v8)

 tools/perf/Documentation/perf-report.txt |    8 +
 tools/perf/Documentation/perf-script.txt |    7 +
 tools/perf/Documentation/perf-top.txt    |   38 +-
 tools/perf/Makefile                      |    4 -
 tools/perf/arch/powerpc/Makefile         |    1 +
 tools/perf/arch/powerpc/util/header.c    |   36 +
 tools/perf/arch/x86/Makefile             |    1 +
 tools/perf/arch/x86/util/header.c        |   59 ++
 tools/perf/builtin-annotate.c            |    9 +-
 tools/perf/builtin-diff.c                |    2 +-
 tools/perf/builtin-record.c              |   15 +
 tools/perf/builtin-report.c              |   17 +-
 tools/perf/builtin-script.c              |    6 +-
 tools/perf/builtin-top.c                 |  430 +++++++-----
 tools/perf/builtin.h                     |    1 -
 tools/perf/perf.h                        |   11 +
 tools/perf/util/annotate.h               |    7 +-
 tools/perf/util/evlist.c                 |    6 +
 tools/perf/util/evlist.h                 |    4 +
 tools/perf/util/evsel.c                  |    1 +
 tools/perf/util/header.c                 | 1145 +++++++++++++++++++++++++++++-
 tools/perf/util/header.h                 |   29 +-
 tools/perf/util/hist.c                   |  338 +++++++---
 tools/perf/util/hist.h                   |   33 +-
 tools/perf/util/session.c                |   19 +
 tools/perf/util/session.h                |    1 +
 tools/perf/util/sort.h                   |    1 +
 tools/perf/util/symbol.h                 |    1 +
 tools/perf/util/top.c                    |  141 +----
 tools/perf/util/top.h                    |   36 +-
 tools/perf/util/ui/browsers/annotate.c   |   99 +++-
 tools/perf/util/ui/browsers/hists.c      |  146 +++--
 tools/perf/util/ui/browsers/top.c        |  236 ------
 33 files changed, 2091 insertions(+), 797 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/header.c
 create mode 100644 tools/perf/arch/x86/util/header.c
 delete mode 100644 tools/perf/util/ui/browsers/top.c

