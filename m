Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab1LWVxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:53:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:50740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab1LWVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Nelson Elhage <nelhage@nelhage.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 00/15] perf/core improvements and fixes
Date: Fri, 23 Dec 2011 19:53:03 -0200
Message-Id: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

David Ahern (3):
  perf tools: Fix comm for processes with named threads
  perf tools: Look up thread names for system wide profiling
  perf script: look up thread using tid instead of pid

Ingo Molnar (1):
  perf tools: Fix truncated annotation

Namhyung Kim (1):
  perf report: Fix usage string

Nelson Elhage (2):
  perf: builtin-record: Provide advice if mmap'ing fails with EPERM.
  perf: builtin-record: Document and check that mmap_pages must be a power of two.

Robert Richter (8):
  perf tools: Improve macros for struct feature_ops
  perf tools: Continue processing header on unknown features
  perf tools: Fix out-of-bound access to struct perf_session
  perf tools: Moving code in some files
  perf report: Accept fifos as input file
  perf tools: Unify handling of features when writing feature section
  perf tools: Use for_each_set_bit() to iterate over feature flags
  perf script: Add generic perl handler to process events

 tools/perf/Documentation/perf-annotate.txt         |    2 +-
 tools/perf/Documentation/perf-buildid-list.txt     |    2 +-
 tools/perf/Documentation/perf-evlist.txt           |    2 +-
 tools/perf/Documentation/perf-kmem.txt             |    2 +-
 tools/perf/Documentation/perf-lock.txt             |    2 +-
 tools/perf/Documentation/perf-record.txt           |    2 +-
 tools/perf/Documentation/perf-report.txt           |    2 +-
 tools/perf/Documentation/perf-sched.txt            |    2 +-
 tools/perf/Documentation/perf-script.txt           |    2 +-
 tools/perf/Documentation/perf-timechart.txt        |    2 +-
 tools/perf/builtin-annotate.c                      |    3 +-
 tools/perf/builtin-buildid-list.c                  |   53 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-record.c                        |   19 +-
 tools/perf/builtin-report.c                        |   15 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-script.c                        |    6 +-
 tools/perf/builtin-timechart.c                     |    4 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/event.c                            |  112 +++-
 tools/perf/util/evlist.c                           |    2 +
 tools/perf/util/header.c                           |  663 +++++++++-----------
 tools/perf/util/header.h                           |    6 +-
 tools/perf/util/include/linux/bitops.h             |  118 ++++
 .../perf/util/scripting-engines/trace-event-perl.c |   73 ++-
 tools/perf/util/session.c                          |   15 +-
 tools/perf/util/session.h                          |    2 +-
 tools/perf/util/util.h                             |   11 +
 30 files changed, 676 insertions(+), 456 deletions(-)

-- 
1.7.8.rc0.35.gee6df

