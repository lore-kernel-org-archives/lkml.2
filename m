Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab2IKXy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:54:59 -0400
Received: from [205.233.59.134] ([205.233.59.134]:37433 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2IKXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:54:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/20] perf/core improvements and fixes
Date: Tue, 11 Sep 2012 20:52:52 -0300
Message-Id: <1347407590-30960-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

Best Regards,

- Arnaldo

The following changes since commit d5cb2aef4fda355fbafe8db4f425b73ea94d2019:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-09-09 10:39:14 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 9ec3f4e437ede2f3b5087d412abe16a0219b3b99:

  perf sched: Don't read all tracepoint variables in advance (2012-09-11 20:39:19 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. Remove die()/exit() calls from several tools.

. Add missing perf_regs.h file to MANIFEST

. Clean up and improve 'perf sched' performance by elliminating lots of
  needless calls to libtraceevent.

. More patches to make perf build on Android, from Irina Tirdea

. Resolve vdso callchains, from Jiri Olsa

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (9):
      perf test: Remove die() calls
      perf sched: Remove die() calls
      perf kmem: Remove die() calls
      perf tools: Add missing perf_regs.h file to MANIFEST
      perf sched: Remove unused thread parameter
      perf sched: Use perf_tool as ancestor
      perf evsel: Introduce perf_evsel__{str,int}val methods
      perf sched: Use perf_evsel__{int,str}val
      perf sched: Don't read all tracepoint variables in advance

Irina Tirdea (5):
      perf tools: include wrapper for magic.h
      perf tools: Update types definitions for Android
      perf tools: include __WORDSIZE definition
      perf tools: fix ALIGN redefinition in system headers
      perf tools: Use __maybe_used for unused variables

Jiri Olsa (4):
      perf tools: Do backtrace post unwind only if we regs and stack were captured
      perf tools: Add memdup function
      perf symbols: Make dsos__find function globally available
      perf tools: Back [vdso] DSO with real data

 tools/lib/traceevent/event-parse.c                 |    8 +-
 tools/lib/traceevent/event-parse.h                 |    4 +-
 tools/perf/MANIFEST                                |    1 +
 tools/perf/Makefile                                |    3 +
 tools/perf/bench/bench.h                           |    3 +-
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/mem-memset.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |    6 +-
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-buildid-cache.c                 |   10 +-
 tools/perf/builtin-buildid-list.c                  |    3 +-
 tools/perf/builtin-diff.c                          |    4 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-help.c                          |    2 +-
 tools/perf/builtin-inject.c                        |   24 +-
 tools/perf/builtin-kmem.c                          |  130 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-list.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-probe.c                         |   24 +-
 tools/perf/builtin-record.c                        |   10 +-
 tools/perf/builtin-report.c                        |   11 +-
 tools/perf/builtin-sched.c                         | 1446 +++++++++-----------
 tools/perf/builtin-script.c                        |   29 +-
 tools/perf/builtin-stat.c                          |   40 +-
 tools/perf/builtin-test.c                          |   23 +-
 tools/perf/builtin-timechart.c                     |   30 +-
 tools/perf/builtin-top.c                           |    7 +-
 tools/perf/ui/browser.c                            |    7 +-
 tools/perf/ui/browsers/annotate.c                  |    6 +-
 tools/perf/ui/gtk/browser.c                        |    5 +-
 tools/perf/ui/gtk/setup.c                          |    2 +-
 tools/perf/ui/gtk/util.c                           |    4 +-
 tools/perf/ui/helpline.c                           |    2 +-
 tools/perf/ui/helpline.h                           |    8 +-
 tools/perf/ui/hist.c                               |   21 +-
 tools/perf/ui/tui/setup.c                          |    4 +-
 tools/perf/util/alias.c                            |    3 +-
 tools/perf/util/annotate.c                         |    6 +-
 tools/perf/util/annotate.h                         |   13 +-
 tools/perf/util/build-id.c                         |   11 +-
 tools/perf/util/cache.h                            |    6 +-
 tools/perf/util/callchain.c                        |    6 +-
 tools/perf/util/cgroup.c                           |    4 +-
 tools/perf/util/config.c                           |    6 +-
 tools/perf/util/debug.h                            |    9 +-
 tools/perf/util/event.c                            |   29 +-
 tools/perf/util/event.h                            |    2 +-
 tools/perf/util/evsel.c                            |   35 +
 tools/perf/util/evsel.h                            |    7 +
 tools/perf/util/header.c                           |  177 ++-
 tools/perf/util/header.h                           |    2 +-
 tools/perf/util/help.c                             |    3 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/hist.h                             |   32 +-
 tools/perf/util/include/linux/bitops.h             |    4 +
 tools/perf/util/include/linux/compiler.h           |    8 +-
 tools/perf/util/include/linux/kernel.h             |   13 +-
 tools/perf/util/include/linux/magic.h              |   12 +
 tools/perf/util/include/linux/string.h             |    2 +
 tools/perf/util/include/linux/types.h              |    8 +
 tools/perf/util/intlist.c                          |    4 +-
 tools/perf/util/map.c                              |   12 +-
 tools/perf/util/map.h                              |    2 +-
 tools/perf/util/parse-events-test.c                |    6 +-
 tools/perf/util/parse-events.c                     |    7 +-
 tools/perf/util/parse-events.l                     |    2 +-
 tools/perf/util/parse-events.y                     |    4 +-
 tools/perf/util/parse-options.c                    |    3 +-
 tools/perf/util/perf_regs.h                        |    2 +-
 tools/perf/util/pmu.y                              |    6 +-
 tools/perf/util/probe-event.c                      |   21 +-
 tools/perf/util/probe-finder.c                     |    4 +-
 tools/perf/util/python.c                           |    8 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    8 +-
 .../util/scripting-engines/trace-event-python.c    |   10 +-
 tools/perf/util/session.c                          |   61 +-
 tools/perf/util/sort.c                             |   14 +-
 tools/perf/util/string.c                           |   18 +-
 tools/perf/util/symbol-minimal.c                   |   28 +-
 tools/perf/util/symbol.c                           |    6 +-
 tools/perf/util/symbol.h                           |    8 +-
 tools/perf/util/trace-event-parse.c                |    4 +-
 tools/perf/util/trace-event-scripting.c            |   33 +-
 tools/perf/util/unwind.c                           |   36 +-
 tools/perf/util/unwind.h                           |   11 +-
 tools/perf/util/util.h                             |    2 +-
 tools/perf/util/vdso.c                             |  111 ++
 tools/perf/util/vdso.h                             |   18 +
 tools/perf/util/wrapper.c                          |    3 +-
 92 files changed, 1518 insertions(+), 1231 deletions(-)
 create mode 100644 tools/perf/util/include/linux/magic.h
 create mode 100644 tools/perf/util/vdso.c
 create mode 100644 tools/perf/util/vdso.h
