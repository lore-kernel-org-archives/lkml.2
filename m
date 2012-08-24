Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2HXJBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2HXJBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/13] perf test: Add perf_event_attr record graph test
Date: Fri, 24 Aug 2012 11:00:37 +0200
Message-Id: <1345798844-27423-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding tests to validate perf_event_attr data for commands:
  'record -g --'
  'record -g fp
  'record -g dwarf

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>

graph
---
 tools/perf/util/test-attr/test-record-graph-default | 6 ++++++
 tools/perf/util/test-attr/test-record-graph-dwarf   | 6 ++++++
 tools/perf/util/test-attr/test-record-graph-fp      | 6 ++++++
 3 files changed, 18 insertions(+)
 create mode 100644 tools/perf/util/test-attr/test-record-graph-default
 create mode 100644 tools/perf/util/test-attr/test-record-graph-dwarf
 create mode 100644 tools/perf/util/test-attr/test-record-graph-fp

diff --git a/tools/perf/util/test-attr/test-record-graph-default b/tools/perf/util/test-attr/test-record-graph-default
new file mode 100644
index 0000000..833d184
--- /dev/null
+++ b/tools/perf/util/test-attr/test-record-graph-default
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -g -- kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=295
diff --git a/tools/perf/util/test-attr/test-record-graph-dwarf b/tools/perf/util/test-attr/test-record-graph-dwarf
new file mode 100644
index 0000000..41f3f67
--- /dev/null
+++ b/tools/perf/util/test-attr/test-record-graph-dwarf
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -g dwarf -- kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=295
diff --git a/tools/perf/util/test-attr/test-record-graph-fp b/tools/perf/util/test-attr/test-record-graph-fp
new file mode 100644
index 0000000..7cef374
--- /dev/null
+++ b/tools/perf/util/test-attr/test-record-graph-fp
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -g fp kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=295
-- 
1.7.11.4

