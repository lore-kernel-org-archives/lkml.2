Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2KERS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:18:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab2KERSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/32] perf tests: Add attr record graph test
Date: Mon,  5 Nov 2012 14:17:52 -0300
Message-Id: <1352135893-7564-12-git-send-email-acme@infradead.org>
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

Adding tests to validate perf_event_attr data for commands:
  'record -g --'
  'record -g fp
  'record -g dwarf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-graph-default |    6 ++++++
 tools/perf/tests/attr/test-record-graph-dwarf   |   10 ++++++++++
 tools/perf/tests/attr/test-record-graph-fp      |    6 ++++++
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
1.7.9.2.358.g22243

