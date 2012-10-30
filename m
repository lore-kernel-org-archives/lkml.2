Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab2J3WEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934849Ab2J3WDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 22/25] perf tests: Add attr stat default test
Date: Tue, 30 Oct 2012 23:02:03 +0100
Message-Id: <1351634526-1516-23-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'stat'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-stat-default | 64 +++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-stat-default

diff --git a/tools/perf/tests/attr/test-stat-default b/tools/perf/tests/attr/test-stat-default
new file mode 100644
index 0000000..19270f5
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-default
@@ -0,0 +1,64 @@
+[config]
+command = stat
+args    = kill >/dev/null 2>&1
+ret     = 1
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
-- 
1.7.11.7

