Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab2J3WD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934865Ab2J3WDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/25] perf test: Add perf_event_attr tests
Date: Tue, 30 Oct 2012 23:01:41 +0100
Message-Id: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this code tests the link between perf stat/record command line
options and final perf_event_attr struct values. Also it tests
the group fd linkage.

Plus moving test related objects under 'test' directory.

Attached patches:
  01/25 perf tools: Remove BINDIR define from exec_cmd.o
  02/25 perf tests: Move test objects into 'tests' directory
  03/25 perf tests: Add framework for automated
  04/25 perf tests: Add attr record basic test
  05/25 perf tests: Add attr record group test
  06/25 perf tests: Add attr record event syntax group test
  07/25 perf tests: Add attr record freq test
  08/25 perf tests: Add attr record count test
  09/25 perf tests: Add attr record graph test
  10/25 perf tests: Add attr record period test
  11/25 perf tests: Add attr record no samples test
  12/25 perf tests: Add attr record no-inherit test
  13/25 perf tests: Add attr record data test
  14/25 perf tests: Add attr record raw test
  15/25 perf tests: Add attr record no delay test
  16/25 perf tests: Add attr record branch any test
  17/25 perf tests: Add attr record branch filter tests
  18/25 perf tests: Add attr stat basic test
  19/25 perf tests: Add attr stat no-inherit test
  20/25 perf tests: Add attr stat group test
  21/25 perf tests: Add attr stat event syntax group test
  22/25 perf tests: Add attr stat default test
  23/25 perf tests: Add attr stat default test
  24/25 perf tests: Add attr tests under builtin test command
  25/25 perf tests: Add documentation for attr tests

Also available here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/test4

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                                      |   20 +-
 tools/perf/builtin-test.c                                | 1559 ---------------------------------------------------------------------
 tools/perf/perf.c                                        |    2 +
 tools/perf/perf.h                                        |   17 +-
 tools/perf/tests/attr.c                                  |  171 ++++++++
 tools/perf/tests/attr.py                                 |  313 ++++++++++++++
 tools/perf/tests/attr/README                             |   64 +++
 tools/perf/tests/attr/base-record                        |   40 ++
 tools/perf/tests/attr/base-stat                          |   40 ++
 tools/perf/tests/attr/test-record-basic                  |    5 +
 tools/perf/tests/attr/test-record-branch-any             |    8 +
 tools/perf/tests/attr/test-record-branch-filter-any      |    8 +
 tools/perf/tests/attr/test-record-branch-filter-any_call |    8 +
 tools/perf/tests/attr/test-record-branch-filter-any_ret  |    8 +
 tools/perf/tests/attr/test-record-branch-filter-hv       |    8 +
 tools/perf/tests/attr/test-record-branch-filter-ind_call |    8 +
 tools/perf/tests/attr/test-record-branch-filter-k        |    8 +
 tools/perf/tests/attr/test-record-branch-filter-u        |    8 +
 tools/perf/tests/attr/test-record-count                  |    8 +
 tools/perf/tests/attr/test-record-data                   |    8 +
 tools/perf/tests/attr/test-record-freq                   |    6 +
 tools/perf/tests/attr/test-record-graph-default          |    6 +
 tools/perf/tests/attr/test-record-graph-dwarf            |   10 +
 tools/perf/tests/attr/test-record-graph-fp               |    6 +
 tools/perf/tests/attr/test-record-group                  |   17 +
 tools/perf/tests/attr/test-record-group1                 |   20 +
 tools/perf/tests/attr/test-record-no-delay               |    9 +
 tools/perf/tests/attr/test-record-no-inherit             |    7 +
 tools/perf/tests/attr/test-record-no-samples             |    6 +
 tools/perf/tests/attr/test-record-period                 |    7 +
 tools/perf/tests/attr/test-record-raw                    |    7 +
 tools/perf/tests/attr/test-stat-basic                    |    6 +
 tools/perf/tests/attr/test-stat-default                  |   64 +++
 tools/perf/tests/attr/test-stat-detailed-1               |  101 +++++
 tools/perf/tests/attr/test-stat-detailed-2               |  155 +++++++
 tools/perf/tests/attr/test-stat-detailed-3               |  173 ++++++++
 tools/perf/tests/attr/test-stat-group                    |   15 +
 tools/perf/tests/attr/test-stat-group1                   |   17 +
 tools/perf/tests/attr/test-stat-no-inherit               |    7 +
 tools/perf/tests/builtin-test.c                          | 1563 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/dso-data.c                              |  153 +++++++
 tools/perf/tests/parse-events.c                          | 1116 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso-test-data.c                          |  153 -------
 tools/perf/util/parse-events-test.c                      | 1116 --------------------------------------------------
 44 files changed, 4216 insertions(+), 2835 deletions(-)
