Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1K1XOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:14:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:34287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 00/25] perf/core fixes and improvements
Date: Mon, 28 Nov 2011 21:14:01 -0200
Message-Id: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	Mostly infrastructure improvements/refactorings to ease the development
of tracepoint based tools and to avoid having to create a perf.data file or
using pipes when wanting to produce and consume events directly like in a
strace reimplementation using these libraries.

	More is needed to make all tools use what has changed but what is
present in this patchset should illustrate the goals I'm pursuing.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (23):
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

David Ahern (2):
  perf tools: make -C consistent across commands (for cpu list arg)
  perf script: Add comm filtering option

 tools/perf/Documentation/perf-annotate.txt         |    2 +-
 tools/perf/Documentation/perf-report.txt           |    4 +-
 tools/perf/Documentation/perf-script.txt           |    7 +-
 tools/perf/Makefile                                |    1 +
 tools/perf/builtin-annotate.c                      |  133 +++---
 tools/perf/builtin-diff.c                          |   21 +-
 tools/perf/builtin-inject.c                        |  118 +++--
 tools/perf/builtin-kmem.c                          |   14 +-
 tools/perf/builtin-lock.c                          |   10 +-
 tools/perf/builtin-probe.c                         |    1 -
 tools/perf/builtin-record.c                        |  579 ++++++++------------
 tools/perf/builtin-report.c                        |  225 ++++----
 tools/perf/builtin-sched.c                         |  198 ++++----
 tools/perf/builtin-script.c                        |   50 ++-
 tools/perf/builtin-stat.c                          |   40 +--
 tools/perf/builtin-test.c                          |    3 +-
 tools/perf/builtin-timechart.c                     |   34 +-
 tools/perf/builtin-top.c                           |  540 +++++++++---------
 tools/perf/perf.c                                  |   33 +-
 tools/perf/perf.h                                  |   23 +
 tools/perf/util/annotate.c                         |    6 +-
 tools/perf/util/annotate.h                         |    5 +-
 tools/perf/util/build-id.c                         |   26 +-
 tools/perf/util/build-id.h                         |    2 +-
 tools/perf/util/callchain.h                        |    3 +
 tools/perf/util/cgroup.c                           |   15 +-
 tools/perf/util/debugfs.c                          |   35 +-
 tools/perf/util/debugfs.h                          |   31 +-
 tools/perf/util/event.c                            |  189 +++----
 tools/perf/util/event.h                            |   59 ++-
 tools/perf/util/evlist.c                           |  289 ++++++++++-
 tools/perf/util/evlist.h                           |   41 ++-
 tools/perf/util/evsel.c                            |   70 +++
 tools/perf/util/evsel.h                            |    8 +
 tools/perf/util/header.c                           |   75 ++--
 tools/perf/util/header.h                           |   45 +-
 tools/perf/util/hist.h                             |    3 +-
 tools/perf/util/map.c                              |    4 +
 tools/perf/util/map.h                              |   19 +
 tools/perf/util/parse-events.c                     |   28 +-
 tools/perf/util/parse-events.h                     |    1 -
 tools/perf/util/probe-finder.h                     |    1 -
 .../perf/util/scripting-engines/trace-event-perl.c |    4 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |  326 +++++++-----
 tools/perf/util/session.h                          |   62 +--
 tools/perf/util/setup.py                           |    3 +-
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
 58 files changed, 1995 insertions(+), 1545 deletions(-)
 create mode 100644 tools/perf/util/tool.h

-- 
1.7.8.rc0.35.gee6df

