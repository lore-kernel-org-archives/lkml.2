Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2HTQ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:27:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:56655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2HTQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Ben Hutchings <ben@decadent.org.uk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/24] perf/core improvements and fixes
Date: Mon, 20 Aug 2012 13:26:01 -0300
Message-Id: <1345479985-18669-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, this is on top of my previous pull requests,

- Arnaldo

The following changes since commit 0fe7d7e9761ec7e23350b5543ddac470bb3cde1e:

  perf symbols: Add description of JIT interface (2012-08-13 14:55:02 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 000078bc3ee69efb1124b8478c7527389a826074:

  perf hists: Rename and move some functions (2012-08-20 09:47:31 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

 . Fix include order for bison/flex-generated C files, from Ben Hutchings

 . Build fixes and documentation corrections from David Ahern

 . Group parsing support, from Jiri Olsa

 . UI/gtk refactorings and improvements from Namhyung Kim

 . NULL deref fix for perf script, from Namhyung Kim

 . Assorted cleanups from Robert Richter

 . Let O= makes handle relative paths, from Steven Rostedt

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf tools: Add missing files to build the python binding
      perf evlist: Rename __group method to __set_leader
      perf evlist: Introduce evsel list accessors

Ben Hutchings (1):
      perf tools: Fix include order for bison/flex-generated C files

David Ahern (3):
      perf script perl/python: Fix libexec scripts path in Documentation
      perf: silence GTK2 probing errors
      perf symbols: Fix builds with NO_LIBELF set

Jiri Olsa (4):
      perf tools: Add support to parse event group syntax
      perf tools: Add support to update event modifier
      perf tools: Enable grouping logic for parsed events
      perf test: Add automated tests for event group parsing

Namhyung Kim (8):
      perf script: Fix a NULL pointer dereference
      perf ui: Introduce struct ui_helpline
      perf ui gtk: Implement helpline_fns
      perf ui/gtk: Use helpline API in browser
      perf ui gtk: Add perf_gtk__show_helpline() for pr_*
      perf ui gtk: Ensure not to call gtk_main_quit() twice
      perf hists: Separate out hist print functions
      perf hists: Rename and move some functions

Robert Richter (4):
      perf tools: Fix type for evsel->ids and add size check for ids
      perf tools: Report number of pmu type of unknown events
      perf tools: Rename some variables for better understanding
      perf tools: Rename global variable 'events' in util/header.c

Steven Rostedt (1):
      perf tools: Let O= makes handle relative paths

 tools/perf/Documentation/perf-script-perl.txt   |    4 +-
 tools/perf/Documentation/perf-script-python.txt |   10 +-
 tools/perf/Makefile                             |   20 +-
 tools/perf/builtin-record.c                     |   17 +-
 tools/perf/builtin-stat.c                       |   15 +-
 tools/perf/builtin-test.c                       |   10 +-
 tools/perf/builtin-top.c                        |   18 +-
 tools/perf/ui/browsers/hists.c                  |    4 +-
 tools/perf/ui/gtk/browser.c                     |    5 +-
 tools/perf/ui/gtk/gtk.h                         |    2 +
 tools/perf/ui/gtk/helpline.c                    |   56 ++
 tools/perf/ui/gtk/setup.c                       |    3 +
 tools/perf/ui/gtk/util.c                        |    5 -
 tools/perf/ui/helpline.c                        |   56 +-
 tools/perf/ui/helpline.h                        |   33 +-
 tools/perf/ui/setup.c                           |    4 +
 tools/perf/ui/stdio/hist.c                      |  653 ++++++++++++++++++++++
 tools/perf/ui/tui/helpline.c                    |   57 ++
 tools/perf/ui/tui/setup.c                       |    2 -
 tools/perf/util/debug.c                         |    4 +-
 tools/perf/util/debug.h                         |    8 +-
 tools/perf/util/evlist.c                        |   73 +--
 tools/perf/util/evlist.h                        |   27 +-
 tools/perf/util/evsel.c                         |   52 +-
 tools/perf/util/evsel.h                         |   20 +-
 tools/perf/util/header.c                        |   97 ++--
 tools/perf/util/header.h                        |    2 +-
 tools/perf/util/hist.c                          |  677 +----------------------
 tools/perf/util/hist.h                          |    6 +-
 tools/perf/util/parse-events-test.c             |  387 ++++++++++---
 tools/perf/util/parse-events.c                  |   93 +++-
 tools/perf/util/parse-events.h                  |    4 +-
 tools/perf/util/parse-events.l                  |    2 +
 tools/perf/util/parse-events.y                  |   93 +++-
 tools/perf/util/python-ext-sources              |    2 +
 tools/perf/util/python.c                        |    7 +-
 tools/perf/util/symbol-elf.c                    |    3 +
 tools/perf/util/symbol.c                        |    2 +-
 tools/perf/util/top.c                           |    3 +-
 tools/perf/util/trace-event-parse.c             |    2 +-
 tools/scripts/Makefile.include                  |    6 +-
 41 files changed, 1560 insertions(+), 984 deletions(-)
 create mode 100644 tools/perf/ui/gtk/helpline.c
 create mode 100644 tools/perf/ui/stdio/hist.c
 create mode 100644 tools/perf/ui/tui/helpline.c
