Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2KNHT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab2KNHTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:55 -0500
Date: Tue, 13 Nov 2012 23:19:02 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-149960a0dd4222fbd6678876c005b8b1c85f8e6a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-23-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-23-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat default test
Git-Commit-ID: 149960a0dd4222fbd6678876c005b8b1c85f8e6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:19:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  149960a0dd4222fbd6678876c005b8b1c85f8e6a
Gitweb:     http://git.kernel.org/tip/149960a0dd4222fbd6678876c005b8b1c85f8e6a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:57 -0300

perf tests: Add attr stat default test

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
 1 files changed, 64 insertions(+), 0 deletions(-)

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
