Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab2HXJBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220Ab2HXJBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/13] perf test: Add perf_event_attr stat group test
Date: Fri, 24 Aug 2012 11:00:43 +0200
Message-Id: <1345798844-27423-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'stat --group -e cycles,instructions'

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/test-attr/test-stat-group | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 tools/perf/util/test-attr/test-stat-group

diff --git a/tools/perf/util/test-attr/test-stat-group b/tools/perf/util/test-attr/test-stat-group
new file mode 100644
index 0000000..fdc1596
--- /dev/null
+++ b/tools/perf/util/test-attr/test-stat-group
@@ -0,0 +1,15 @@
+[config]
+command = stat
+args    = --group -e cycles,instructions kill >/dev/null 2>&1
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
+disabled=0
+enable_on_exec=0
-- 
1.7.11.4

