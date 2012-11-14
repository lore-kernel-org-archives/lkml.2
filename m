Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2KNHV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:21:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2KNHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:21:56 -0500
Date: Tue, 13 Nov 2012 23:20:07 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-8a6408a04bf98c853a047412f20f9c73669058be@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-24-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-24-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat default test
Git-Commit-ID: 8a6408a04bf98c853a047412f20f9c73669058be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:20:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a6408a04bf98c853a047412f20f9c73669058be
Gitweb:     http://git.kernel.org/tip/8a6408a04bf98c853a047412f20f9c73669058be
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:57 -0300

perf tests: Add attr stat default test

Adding test to validate perf_event_attr data for commands:
  'stat -d'
  'stat -dd'
  'stat -ddd'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-24-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../{test-stat-default => test-stat-detailed-1}    |   39 +++++-
 tools/perf/tests/attr/test-stat-detailed-2         |  155 ++++++++++++++++++
 tools/perf/tests/attr/test-stat-detailed-3         |  173 ++++++++++++++++++++
 3 files changed, 366 insertions(+), 1 deletions(-)

diff --git a/tools/perf/tests/attr/test-stat-default b/tools/perf/tests/attr/test-stat-detailed-1
similarity index 51%
copy from tools/perf/tests/attr/test-stat-default
copy to tools/perf/tests/attr/test-stat-detailed-1
index 19270f5..51426b8 100644
--- a/tools/perf/tests/attr/test-stat-default
+++ b/tools/perf/tests/attr/test-stat-detailed-1
@@ -1,8 +1,9 @@
 [config]
 command = stat
-args    = kill >/dev/null 2>&1
+args    = -d kill >/dev/null 2>&1
 ret     = 1
 
+
 # PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK
 [event1:base-stat]
 fd=1
@@ -62,3 +63,39 @@ config=4
 fd=10
 type=0
 config=5
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
