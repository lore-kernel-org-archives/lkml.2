Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab2J3WIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249Ab2J3WCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:02:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/25] perf tests: Add attr record group test
Date: Tue, 30 Oct 2012 23:01:46 +0100
Message-Id: <1351634526-1516-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record --group -e cycles,instructions'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-group | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-group

diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-record-group
new file mode 100644
index 0000000..b945f77
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-group
@@ -0,0 +1,17 @@
+[config]
+command = record
+args    = --group -e cycles,instructions kill >/dev/null 2>&1
+
+[event-1:base-record]
+fd=1
+group_fd=-1
+sample_type=327
+
+[event-2:base-record]
+fd=2
+group_fd=1
+config=1
+sample_type=327
+mmap=0
+comm=0
+enable_on_exec=0
-- 
1.7.11.7

