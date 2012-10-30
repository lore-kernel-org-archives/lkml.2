Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab2J3WEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2J3WDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 23/25] perf tests: Add attr stat default test
Date: Tue, 30 Oct 2012 23:02:04 +0100
Message-Id: <1351634526-1516-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

Adding test to validate perf_event_attr data for commands:
  'stat -d'
  'stat -dd'
  'stat -ddd'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-stat-detailed-1 | 101 +++++++++++++++++
 tools/perf/tests/attr/test-stat-detailed-2 | 155 ++++++++++++++++++++++++++
 tools/perf/tests/attr/test-stat-detailed-3 | 173 +++++++++++++++++++++++++++++
 3 files changed, 429 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-1
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-2
 create mode 100644 tools/perf/tests/attr/test-stat-detailed-3

diff --git a/tools/perf/tests/attr/test-stat-detailed-1 b/tools/perf/tests/attr/test-stat-detailed-1
new file mode 100644
index 0000000..51426b8
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-detailed-1
@@ -0,0 +1,101 @@
+[config]
+command = stat
+args    = -d kill >/dev/null 2>&1
+ret     = 1
+
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK
+[event1:base-stat]
+fd=1
+type=1
+config=1
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CONTEXT_SWITCHES
+[event2:base-stat]
+fd=2
+type=1
+config=3
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CPU_MIGRATIONS
+[event3:base-stat]
+fd=3
+type=1
+config=4
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_PAGE_FAULTS
+[event4:base-stat]
+fd=4
+type=1
+config=2
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_CPU_CYCLES
+[event5:base-stat]
+fd=5
+type=0
+config=0
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+[event6:base-stat]
+fd=6
+type=0
+config=7
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+[event7:base-stat]
+fd=7
+type=0
+config=8
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_INSTRUCTIONS
+[event8:base-stat]
+fd=8
+type=0
+config=1
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+[event9:base-stat]
+fd=9
+type=0
+config=4
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_MISSES
+[event10:base-stat]
+fd=10
+type=0
+config=5
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event11:base-stat]
+fd=11
+type=3
+config=0
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event12:base-stat]
+fd=12
+type=3
+config=65536
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event13:base-stat]
+fd=13
+type=3
+config=2
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event14:base-stat]
+fd=14
+type=3
+config=65538
diff --git a/tools/perf/tests/attr/test-stat-detailed-2 b/tools/perf/tests/attr/test-stat-detailed-2
new file mode 100644
index 0000000..8de5acc
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-detailed-2
@@ -0,0 +1,155 @@
+[config]
+command = stat
+args    = -dd kill >/dev/null 2>&1
+ret     = 1
+
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK
+[event1:base-stat]
+fd=1
+type=1
+config=1
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CONTEXT_SWITCHES
+[event2:base-stat]
+fd=2
+type=1
+config=3
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CPU_MIGRATIONS
+[event3:base-stat]
+fd=3
+type=1
+config=4
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_PAGE_FAULTS
+[event4:base-stat]
+fd=4
+type=1
+config=2
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_CPU_CYCLES
+[event5:base-stat]
+fd=5
+type=0
+config=0
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+[event6:base-stat]
+fd=6
+type=0
+config=7
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+[event7:base-stat]
+fd=7
+type=0
+config=8
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_INSTRUCTIONS
+[event8:base-stat]
+fd=8
+type=0
+config=1
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+[event9:base-stat]
+fd=9
+type=0
+config=4
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_MISSES
+[event10:base-stat]
+fd=10
+type=0
+config=5
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event11:base-stat]
+fd=11
+type=3
+config=0
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event12:base-stat]
+fd=12
+type=3
+config=65536
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event13:base-stat]
+fd=13
+type=3
+config=2
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event14:base-stat]
+fd=14
+type=3
+config=65538
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1I                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event15:base-stat]
+fd=15
+type=3
+config=1
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1I                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event16:base-stat]
+fd=16
+type=3
+config=65537
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event17:base-stat]
+fd=17
+type=3
+config=3
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event18:base-stat]
+fd=18
+type=3
+config=65539
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event19:base-stat]
+fd=19
+type=3
+config=4
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event20:base-stat]
+fd=20
+type=3
+config=65540
diff --git a/tools/perf/tests/attr/test-stat-detailed-3 b/tools/perf/tests/attr/test-stat-detailed-3
new file mode 100644
index 0000000..0a1f45b
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-detailed-3
@@ -0,0 +1,173 @@
+[config]
+command = stat
+args    = -ddd kill >/dev/null 2>&1
+ret     = 1
+
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK
+[event1:base-stat]
+fd=1
+type=1
+config=1
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CONTEXT_SWITCHES
+[event2:base-stat]
+fd=2
+type=1
+config=3
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_CPU_MIGRATIONS
+[event3:base-stat]
+fd=3
+type=1
+config=4
+
+# PERF_TYPE_SOFTWARE / PERF_COUNT_SW_PAGE_FAULTS
+[event4:base-stat]
+fd=4
+type=1
+config=2
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_CPU_CYCLES
+[event5:base-stat]
+fd=5
+type=0
+config=0
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+[event6:base-stat]
+fd=6
+type=0
+config=7
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+[event7:base-stat]
+fd=7
+type=0
+config=8
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_INSTRUCTIONS
+[event8:base-stat]
+fd=8
+type=0
+config=1
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+[event9:base-stat]
+fd=9
+type=0
+config=4
+
+# PERF_TYPE_HARDWARE / PERF_COUNT_HW_BRANCH_MISSES
+[event10:base-stat]
+fd=10
+type=0
+config=5
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event11:base-stat]
+fd=11
+type=3
+config=0
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event12:base-stat]
+fd=12
+type=3
+config=65536
+
+# PERF_TYPE_HW_CACHE /
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event13:base-stat]
+fd=13
+type=3
+config=2
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_LL                 <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event14:base-stat]
+fd=14
+type=3
+config=65538
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1I                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event15:base-stat]
+fd=15
+type=3
+config=1
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1I                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event16:base-stat]
+fd=16
+type=3
+config=65537
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event17:base-stat]
+fd=17
+type=3
+config=3
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event18:base-stat]
+fd=18
+type=3
+config=65539
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event19:base-stat]
+fd=19
+type=3
+config=4
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event20:base-stat]
+fd=20
+type=3
+config=65540
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_PREFETCH        <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
+[event21:base-stat]
+fd=21
+type=3
+config=512
+
+# PERF_TYPE_HW_CACHE,
+#  PERF_COUNT_HW_CACHE_L1D                <<  0  |
+# (PERF_COUNT_HW_CACHE_OP_PREFETCH        <<  8) |
+# (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
+[event22:base-stat]
+fd=22
+type=3
+config=66048
-- 
1.7.11.7

