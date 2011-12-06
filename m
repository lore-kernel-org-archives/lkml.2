Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab1LFKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:51 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34575
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933273Ab1LFKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:49 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS2N5-02-F96-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 00/10] perf tools: cleanups, fixes, updates
Date: Tue, 6 Dec 2011 11:32:30 +0100
Message-ID: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
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

Patches #1 and #2 are a repost.

Robert Richter (10):
  perf script: Fix mem leaks and NULL pointer checks around strdup()s
  perf script: Implement option for system-wide profiling
  perf tools: Continue processing header on unknown features
  perf tools: Fix out-of-bound access to struct perf_session
  perf tool: Moving code in some files
  perf report: Setup browser if stdout is a pipe
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
 tools/perf/builtin-annotate.c                  |    4 +-
 tools/perf/builtin-buildid-list.c              |   53 +-
 tools/perf/builtin-evlist.c                    |    2 +-
 tools/perf/builtin-kmem.c                      |    2 +-
 tools/perf/builtin-lock.c                      |    2 +-
 tools/perf/builtin-report.c                    |   13 +-
 tools/perf/builtin-sched.c                     |    2 +-
 tools/perf/builtin-script.c                    |   67 ++-
 tools/perf/builtin-timechart.c                 |    4 +-
 tools/perf/util/header.c                       |  663 +++++++++++-------------
 tools/perf/util/header.h                       |    6 +-
 tools/perf/util/include/linux/bitops.h         |  118 +++++
 tools/perf/util/session.c                      |   15 +-
 tools/perf/util/session.h                      |    2 +-
 23 files changed, 527 insertions(+), 444 deletions(-)

-- 
1.7.7


