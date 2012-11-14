Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2KNHQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:16:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2KNHQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:16:18 -0500
Date: Tue, 13 Nov 2012 23:14:56 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9c90178412813368b7f040793c4af2fdfed3634d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-18-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-18-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record branch filter tests
Git-Commit-ID: 9c90178412813368b7f040793c4af2fdfed3634d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:15:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c90178412813368b7f040793c4af2fdfed3634d
Gitweb:     http://git.kernel.org/tip/9c90178412813368b7f040793c4af2fdfed3634d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:58 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:02:21 -0300

perf tests: Add attr record branch filter tests

Adding test to validate perf_event_attr data for command:
  'record -j any'
  'record -j any_call'
  'record -j any_ret'
  'record -j hv'
  'record -j ind_call'
  'record -j k'
  'record -j u'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-18-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/tests/attr/test-record-branch-filter-any  |    8 ++++++++
 .../tests/attr/test-record-branch-filter-any_call  |    8 ++++++++
 .../tests/attr/test-record-branch-filter-any_ret   |    8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-hv |    8 ++++++++
 .../tests/attr/test-record-branch-filter-ind_call  |    8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-k  |    8 ++++++++
 tools/perf/tests/attr/test-record-branch-filter-u  |    8 ++++++++
 7 files changed, 56 insertions(+), 0 deletions(-)

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
