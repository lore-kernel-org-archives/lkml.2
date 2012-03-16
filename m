Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2CPUDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:03:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2CPUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jan Beulich <jbeulich@suse.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/13] perf/core fixes and improvements
Date: Fri, 16 Mar 2012 17:01:57 -0300
Message-Id: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit bea95c152dee1791dd02cbc708afbb115bb00f9a:

  Merge branch 'perf/hw-branch-sampling' into perf/core (2012-03-12 20:47:05 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 6db6127c4dad634ab98709b81e2f2770890b0d53:

  perf report: Treat an argument as a symbol filter (2012-03-16 16:44:36 -0300)

----------------------------------------------------------------
The event parsing patches from Jiri Olsa plus the filter by symbol and group
fixes by Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Jan Beulich (1):
      perf tools: Adjust make rules

Jiri Olsa (5):
      perf: Adding sysfs group format attribute for pmu device
      perf tools: Add parser generator for events parsing
      perf tools: Add config options support for event parsing
      perf tools: Add perf pmu object to access pmu format definition
      perf tools: Add support to specify pmu style event

Namhyung Kim (7):
      perf stat: Fix event grouping on forked task
      perf tools: Do not disable members of group event
      perf hists: Add hists__filter_by_symbol
      perf ui browser: Introduce ui_browser__input_window
      perf ui browser: Add 's' key to filter by symbol name
      perf report: Add --symbol-filter option
      perf report: Treat an argument as a symbol filter

 .../testing/sysfs-bus-event_source-devices-format  |   14 +
 arch/x86/kernel/cpu/perf_event.c                   |    7 +
 arch/x86/kernel/cpu/perf_event.h                   |    1 +
 arch/x86/kernel/cpu/perf_event_amd.c               |   18 +
 arch/x86/kernel/cpu/perf_event_intel.c             |   36 +
 arch/x86/kernel/cpu/perf_event_p6.c                |   19 +
 include/linux/perf_event.h                         |   14 +
 tools/perf/Makefile                                |   35 +-
 tools/perf/builtin-report.c                        |   21 +-
 tools/perf/builtin-stat.c                          |    2 +-
 tools/perf/builtin-test.c                          |   58 +-
 tools/perf/util/evlist.c                           |    6 +-
 tools/perf/util/evsel.c                            |    6 +-
 tools/perf/util/evsel.h                            |    3 +-
 tools/perf/util/hist.c                             |   35 +
 tools/perf/util/hist.h                             |    2 +
 tools/perf/util/parse-events-bison.c               | 1852 ++++++++++++++++
 tools/perf/util/parse-events-bison.h               |   82 +
 tools/perf/util/parse-events-flex.c                | 2272 ++++++++++++++++++++
 tools/perf/util/parse-events-flex.h                |  316 +++
 tools/perf/util/parse-events.c                     |  590 +++--
 tools/perf/util/parse-events.h                     |   46 +
 tools/perf/util/parse-events.l                     |  126 ++
 tools/perf/util/parse-events.y                     |  217 ++
 tools/perf/util/pmu-bison.c                        | 1663 ++++++++++++++
 tools/perf/util/pmu-bison.h                        |   73 +
 tools/perf/util/pmu-flex.c                         | 1821 ++++++++++++++++
 tools/perf/util/pmu-flex.h                         |  316 +++
 tools/perf/util/pmu.c                              |  469 ++++
 tools/perf/util/pmu.h                              |   41 +
 tools/perf/util/pmu.l                              |   43 +
 tools/perf/util/pmu.y                              |   93 +
 tools/perf/util/ui/browser.h                       |    2 +
 tools/perf/util/ui/browsers/hists.c                |   14 +-
 tools/perf/util/ui/keysyms.h                       |    2 +
 tools/perf/util/ui/util.c                          |   78 +
 36 files changed, 10048 insertions(+), 345 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-format
 create mode 100644 tools/perf/util/parse-events-bison.c
 create mode 100644 tools/perf/util/parse-events-bison.h
 create mode 100644 tools/perf/util/parse-events-flex.c
 create mode 100644 tools/perf/util/parse-events-flex.h
 create mode 100644 tools/perf/util/parse-events.l
 create mode 100644 tools/perf/util/parse-events.y
 create mode 100644 tools/perf/util/pmu-bison.c
 create mode 100644 tools/perf/util/pmu-bison.h
 create mode 100644 tools/perf/util/pmu-flex.c
 create mode 100644 tools/perf/util/pmu-flex.h
 create mode 100644 tools/perf/util/pmu.c
 create mode 100644 tools/perf/util/pmu.h
 create mode 100644 tools/perf/util/pmu.l
 create mode 100644 tools/perf/util/pmu.y
