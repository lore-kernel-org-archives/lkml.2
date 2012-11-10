Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2KJBi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:38:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KJBiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:38:25 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 00/12] perf tests: Move tests from builtin-test
Date: Sat, 10 Nov 2012 01:46:40 +0100
Message-Id: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I discussed with Arnaldo of moving tests from builtin-test
into separated objects.. here it is. I swear not to touch
test code for a while after this one ;-)

Attached patches:
  01/12 perf tests: Move test__vmlinux_matches_kallsyms into separate object
  02/12 perf tests: Move test__open_syscall_event into separate object
  03/12 perf tests: Move test__open_syscall_event_on_all_cpus into separate object
  04/12 perf tests: Move test__basic_mmap into separate object
  05/12 perf tests: Move test__PERF_RECORD into separate object
  06/12 perf tests: Move test__rdpmc into separate object
  07/12 perf tests: Move perf_evsel__roundtrip_name_test into separate object
  08/12 perf tests: Move perf_evsel__tp_sched_test into separate object
  09/12 perf tests: Move test__syscall_open_tp_fields into separate object
  10/12 perf tests: Move pmu tests into separate object
  11/12 perf tests: Final cleanup for builtin-test move
  12/12 perf tests: Check for mkstemp return value in dso-data test

Also available here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
  perf/tests

thanks,
jirka

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                       |   11 +
 tools/perf/perf.h                         |    1 -
 tools/perf/tests/attr.c                   |    3 +-
 tools/perf/tests/builtin-test.c           | 1399 +----------------------------------------------------------
 tools/perf/tests/dso-data.c               |    7 +-
 tools/perf/tests/evsel-roundtrip-name.c   |  114 +++++
 tools/perf/tests/evsel-tp-sched.c         |   84 ++++
 tools/perf/tests/mmap-basic.c             |  162 +++++++
 tools/perf/tests/open-syscall-all-cpus.c  |  120 +++++
 tools/perf/tests/open-syscall-tp-fields.c |  117 +++++
 tools/perf/tests/open-syscall.c           |   66 +++
 tools/perf/tests/parse-events.c           |    3 +-
 tools/perf/tests/perf-record.c            |  314 ++++++++++++++
 tools/perf/tests/pmu.c                    |  178 ++++++++
 tools/perf/tests/rdpmc.c                  |  175 ++++++++
 tools/perf/tests/tests.h                  |   22 +
 tools/perf/tests/util.c                   |   30 ++
 tools/perf/tests/vmlinux-kallsyms.c       |  230 ++++++++++
 tools/perf/util/parse-events.h            |    1 -
 tools/perf/util/pmu.c                     |  185 +-------
 tools/perf/util/pmu.h                     |    4 +
 tools/perf/util/symbol.h                  |    1 -
 22 files changed, 1654 insertions(+), 1573 deletions(-)
