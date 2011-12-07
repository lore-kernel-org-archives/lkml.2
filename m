Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1LGJDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:03:15 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27822
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754140Ab1LGJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:03:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVTT50-01-ASJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v2 0/7] perf tools: cleanups, fixes, updates
Date: Wed, 7 Dec 2011 10:02:50 +0100
Message-ID: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set contains some cleanups, fixes and updates I found worth
to implement during code review. Some patches can be applied
independently.

v2:

* Rebased version to latest tip/perf/core.

* Removed patches #1 and #2 as they are already applied.

* Dropping patch "perf report: Setup browser if stdout is a pipe", the
  patch did not properly handle ^C to terminate profiling.

* perf record throws an error now if buildids may not be generated,
  which can be disabled with the --no-buildid option.

* Prevent potential null pointer access to input_name in
  builtin-report.c. Needed due to removal of patch "perf report: Setup
  browser if stdout is a pipe"

Robert Richter (7):
  perf tools: Continue processing header on unknown features
  perf tools: Fix out-of-bound access to struct perf_session
  perf tool: Moving code in some files
  perf report: Accept fifos as input file
  perf tool: Unify handling of features when writing feature section
  perf tools: Improve macros for struct feature_ops
  perf tools: Use for_each_set_bit() to iterate over feature flags

 tools/perf/Documentation/perf-annotate.txt     |    2 +-
 tools/perf/Documentation/perf-buildid-list.txt |    2 +-
 tools/perf/Documentation/perf-evlist.txt       |    2 +-
 tools/perf/Documentation/perf-kmem.txt         |    2 +-
 tools/perf/Documentation/perf-lock.txt         |    2 +-
 tools/perf/Documentation/perf-report.txt       |    2 +-
 tools/perf/Documentation/perf-sched.txt        |    2 +-
 tools/perf/Documentation/perf-script.txt       |    2 +-
 tools/perf/Documentation/perf-timechart.txt    |    2 +-
 tools/perf/builtin-annotate.c                  |    3 +-
 tools/perf/builtin-buildid-list.c              |   53 +-
 tools/perf/builtin-evlist.c                    |    2 +-
 tools/perf/builtin-kmem.c                      |    2 +-
 tools/perf/builtin-lock.c                      |    2 +-
 tools/perf/builtin-record.c                    |    7 +
 tools/perf/builtin-report.c                    |   13 +-
 tools/perf/builtin-sched.c                     |    2 +-
 tools/perf/builtin-script.c                    |    4 +-
 tools/perf/builtin-timechart.c                 |    4 +-
 tools/perf/util/header.c                       |  663 +++++++++++-------------
 tools/perf/util/header.h                       |    6 +-
 tools/perf/util/include/linux/bitops.h         |  118 +++++
 tools/perf/util/session.c                      |   15 +-
 tools/perf/util/session.h                      |    2 +-
 24 files changed, 496 insertions(+), 418 deletions(-)

-- 
1.7.7


