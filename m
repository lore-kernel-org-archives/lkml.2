Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1AOPmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:42:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:37077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab1AOPlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 00/16] perf/core infrastructure improvements
Date: Sat, 15 Jan 2011 13:40:29 -0200
Message-Id: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/test

	There is more to do reduce complexity on using these APIs for
regression testing and for applications to do self monitoring/introspection
using an eventual libperf.so, but for now the focus is on regression testing
and coverage analysis.

	Now to process the backlog of patches from Frédéric, Masami, Franck,
etc. :-)

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (15):
  perf evsel: Introduce perf_evlist
  perf evlist: Adopt the pollfd array
  perf evsel: Support event groups
  perf evsel: Allow specifying if the inherit bit should be set
  perf top: Use perf_evsel__open
  perf record: Use perf_evsel__open
  perf evsel: Introduce mmap support
  perf record: Use struct perf_mmap and helpers
  perf record: Move perf_mmap__write_tail to perf.h
  perf evlist: Move the mmap array from perf_evsel
  perf record: Use perf_evlist__mmap
  perf tools: Add missing cpu_map__delete()
  perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus
  perf evlist: Steal mmap reading routine from 'perf top'
  perf test: Add test for the evlist mmap routines

Han Pingtian (1):
  perf test: check if cpu_map__new() return NULL

 tools/perf/Makefile                  |    2 +
 tools/perf/builtin-record.c          |  295 +++++++++++++---------------------
 tools/perf/builtin-stat.c            |   38 +++--
 tools/perf/builtin-test.c            |  193 +++++++++++++++++++++--
 tools/perf/builtin-top.c             |  281 ++++++++++-----------------------
 tools/perf/perf.h                    |   26 +++
 tools/perf/util/cpumap.c             |    5 +
 tools/perf/util/cpumap.h             |    2 +-
 tools/perf/util/evlist.c             |  159 ++++++++++++++++++
 tools/perf/util/evlist.h             |   39 +++++
 tools/perf/util/evsel.c              |  176 +++++++++++++++++++--
 tools/perf/util/evsel.h              |   30 +++-
 tools/perf/util/header.c             |   17 ++-
 tools/perf/util/header.h             |    7 +-
 tools/perf/util/include/linux/list.h |    1 +
 tools/perf/util/parse-events.c       |   51 +-----
 tools/perf/util/parse-events.h       |    7 -
 17 files changed, 849 insertions(+), 480 deletions(-)
 create mode 100644 tools/perf/util/evlist.c
 create mode 100644 tools/perf/util/evlist.h

