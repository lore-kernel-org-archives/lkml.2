Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab2J3WF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934807Ab2J3WDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/25] perf tests: Add attr record branch filter tests
Date: Tue, 30 Oct 2012 23:01:58 +0100
Message-Id: <1351634526-1516-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'record -j any'
  'record -j any_call'
  'record -j any_ret'
  'record -j hv'
  'record -j ind_call'
  'record -j k'
  'record -j u'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-branch-filter-any      | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-any_call | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-any_ret  | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-hv       | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-ind_call | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-k        | 8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-u        | 8 ++++++++
 7 files changed, 56 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any_call
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-any_ret
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-hv
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-ind_call
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-k
 create mode 100644 tools/perf/tests/attr/test-record-branch-filter-u

diff --git a/tools/perf/tests/attr/test-record-branch-filter-any b/tools/perf/tests/attr/test-record-branch-filter-any
new file mode 100644
index 0000000..915c4df
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-any
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j any kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=8
diff --git a/tools/perf/tests/attr/test-record-branch-filter-any_call b/tools/perf/tests/attr/test-record-branch-filter-any_call
new file mode 100644
index 0000000..8708dbd
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-any_call
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j any_call kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=16
diff --git a/tools/perf/tests/attr/test-record-branch-filter-any_ret b/tools/perf/tests/attr/test-record-branch-filter-any_ret
new file mode 100644
index 0000000..0d3607a
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-any_ret
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j any_ret kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=32
diff --git a/tools/perf/tests/attr/test-record-branch-filter-hv b/tools/perf/tests/attr/test-record-branch-filter-hv
new file mode 100644
index 0000000..f255267
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-hv
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j hv kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=8
diff --git a/tools/perf/tests/attr/test-record-branch-filter-ind_call b/tools/perf/tests/attr/test-record-branch-filter-ind_call
new file mode 100644
index 0000000..e862dd1
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-ind_call
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j ind_call kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=64
diff --git a/tools/perf/tests/attr/test-record-branch-filter-k b/tools/perf/tests/attr/test-record-branch-filter-k
new file mode 100644
index 0000000..182971e
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-k
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j k kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=8
diff --git a/tools/perf/tests/attr/test-record-branch-filter-u b/tools/perf/tests/attr/test-record-branch-filter-u
new file mode 100644
index 0000000..83449ef
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-filter-u
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -j u kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=8
-- 
1.7.11.7

