Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2KNG7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:59:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2KNG7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:59:09 -0500
Date: Tue, 13 Nov 2012 22:58:49 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-8b96829468123431f925223f94a62b3372d8fd5e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-10-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record graph test
Git-Commit-ID: 8b96829468123431f925223f94a62b3372d8fd5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:58:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b96829468123431f925223f94a62b3372d8fd5e
Gitweb:     http://git.kernel.org/tip/8b96829468123431f925223f94a62b3372d8fd5e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:07:56 -0300

perf tests: Add attr record graph test

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
 3 files changed, 22 insertions(+), 0 deletions(-)

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
