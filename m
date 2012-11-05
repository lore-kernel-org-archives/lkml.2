Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab2KERYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:24:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2KERSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/32] perf/core improvements and fixes
Date: Mon,  5 Nov 2012 14:17:41 -0300
Message-Id: <1352135893-7564-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, on top of a previous pull request.

- Arnaldo

The following changes since commit ffadcf090d468e9c4938b718649f38dd10cfdb02:

  perf annotate: Handle XBEGIN like a jump (2012-10-31 12:18:26 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 8dfec403e39b7c37fd6e8813bacc01da1e1210ab:

  perf tests: Removing 'optional' field (2012-11-05 14:03:59 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Don't show scripts menu for 'perf top', fix from Feng Tang

. Add framework for automated perf_event_attr tests, where tools with different
  command line options will be run from a 'perf test', via python glue, and the
  perf syscall will be intercepted to verify that the perf_event_attr fields
  set by the tool are those expected, from Jiri Olsa

. Use normalized arch name for searching objdump path. This fixes cases
  where the system's objdump (e.g. x86_64) supports the architecture in
  the perf.data file (e.g. i686), but is not the same, fix from Namhyung Kim.

. Postpone objdump check until annotation requested, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Feng Tang (1):
      perf browser: Don't show scripts menu for 'perf top'

Jiri Olsa (28):
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

Namhyung Kim (3):
      perf tools: Use normalized arch name for searching objdump path
      perf tools: Introduce struct hist_browser_timer
      perf report: Postpone objdump check until annotation requested

 tools/perf/Makefile                                |   20 +-
 tools/perf/arch/common.c                           |   40 ++-
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-report.c                        |   11 +-
 tools/perf/builtin-top.c                           |   10 +-
 tools/perf/perf.c                                  |    2 +
 tools/perf/perf.h                                  |   17 +-
 tools/perf/tests/attr.c                            |  174 +++++++++++
 tools/perf/tests/attr.py                           |  320 ++++++++++++++++++++
 tools/perf/tests/attr/README                       |   64 ++++
 tools/perf/tests/attr/base-record                  |   39 +++
 tools/perf/tests/attr/base-stat                    |   39 +++
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
 tools/perf/tests/attr/test-record-group            |   17 ++
 tools/perf/tests/attr/test-record-group1           |   20 ++
 tools/perf/tests/attr/test-record-no-delay         |    9 +
 tools/perf/tests/attr/test-record-no-inherit       |    7 +
 tools/perf/tests/attr/test-record-no-samples       |    6 +
 tools/perf/tests/attr/test-record-period           |    7 +
 tools/perf/tests/attr/test-record-raw              |    7 +
 tools/perf/tests/attr/test-stat-basic              |    6 +
 tools/perf/tests/attr/test-stat-default            |   64 ++++
 tools/perf/tests/attr/test-stat-detailed-1         |  101 ++++++
 tools/perf/tests/attr/test-stat-detailed-2         |  155 ++++++++++
 tools/perf/tests/attr/test-stat-detailed-3         |  173 +++++++++++
 tools/perf/tests/attr/test-stat-group              |   15 +
 tools/perf/tests/attr/test-stat-group1             |   17 ++
 tools/perf/tests/attr/test-stat-no-inherit         |    7 +
 tools/perf/{ => tests}/builtin-test.c              |   12 +-
 .../{util/dso-test-data.c => tests/dso-data.c}     |    0
 .../parse-events-test.c => tests/parse-events.c}   |    0
 tools/perf/ui/browsers/annotate.c                  |   27 +-
 tools/perf/ui/browsers/hists.c                     |   63 ++--
 tools/perf/ui/gtk/browser.c                        |    4 +-
 tools/perf/util/annotate.h                         |    8 +-
 tools/perf/util/hist.h                             |   31 +-
 50 files changed, 1515 insertions(+), 92 deletions(-)
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
 rename tools/perf/{ => tests}/builtin-test.c (99%)
 rename tools/perf/{util/dso-test-data.c => tests/dso-data.c} (100%)
 rename tools/perf/{util/parse-events-test.c => tests/parse-events.c} (100%)
