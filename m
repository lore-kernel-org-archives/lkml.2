Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2KER2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:28:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab2KERSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/32] perf tests: Add attr stat default test
Date: Mon,  5 Nov 2012 14:18:04 -0300
Message-Id: <1352135893-7564-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'stat'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-23-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-stat-default |   64 +++++++++++++++++++++++++++++++
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
1.7.9.2.358.g22243

