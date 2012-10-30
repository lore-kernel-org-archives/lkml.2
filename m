Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab2J3WDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:03:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934841Ab2J3WDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 21/25] perf tests: Add attr stat event syntax group test
Date: Tue, 30 Oct 2012 23:02:02 +0100
Message-Id: <1351634526-1516-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'stat -e {cycles,instructions}'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-stat-group1 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-stat-group1

diff --git a/tools/perf/tests/attr/test-stat-group1 b/tools/perf/tests/attr/test-stat-group1
new file mode 100644
index 0000000..5ae2718
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-group1
@@ -0,0 +1,17 @@
+[config]
+command = stat
+args    = -e '{cycles,instructions}' kill >/dev/null 2>&1
+ret     = 1
+
+[event-1:base-stat]
+fd=1
+group_fd=-1
+
+[event-2:base-stat]
+fd=2
+group_fd=1
+config=1
+# TODO both disabled and enable_on_exec are disabled for --group option,
+#      enabled otherwise, check why..
+disabled=1
+enable_on_exec=1
-- 
1.7.11.7

