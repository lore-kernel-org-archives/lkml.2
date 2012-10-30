Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab2J3WCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab2J3WCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:02:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/25] perf tests: Add attr record graph test
Date: Tue, 30 Oct 2012 23:01:50 +0100
Message-Id: <1351634526-1516-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding tests to validate perf_event_attr data for commands:
  'record -g --'
  'record -g fp
  'record -g dwarf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-graph-default |  6 ++++++
 tools/perf/tests/attr/test-record-graph-dwarf   | 10 ++++++++++
 tools/perf/tests/attr/test-record-graph-fp      |  6 ++++++
 3 files changed, 22 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-graph-default
 create mode 100644 tools/perf/tests/attr/test-record-graph-dwarf
 create mode 100644 tools/perf/tests/attr/test-record-graph-fp

diff --git a/tools/perf/tests/attr/test-record-graph-default b/tools/perf/tests/attr/test-record-graph-default
new file mode 100644
index 0000000..833d184
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-default
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -g -- kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=295
diff --git a/tools/perf/tests/attr/test-record-graph-dwarf b/tools/perf/tests/attr/test-record-graph-dwarf
new file mode 100644
index 0000000..e93e082
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-dwarf
@@ -0,0 +1,10 @@
+[config]
+command = record
+args    = -g dwarf -- kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=12583
+exclude_callchain_user=1
+sample_stack_user=8192
+# TODO different for each arch, no support for that now
+sample_regs_user=*
diff --git a/tools/perf/tests/attr/test-record-graph-fp b/tools/perf/tests/attr/test-record-graph-fp
new file mode 100644
index 0000000..7cef374
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-fp
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -g fp kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=295
-- 
1.7.11.7

