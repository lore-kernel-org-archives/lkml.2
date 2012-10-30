Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852Ab2J3WDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:03:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab2J3WDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 18/25] perf tests: Add attr stat basic test
Date: Tue, 30 Oct 2012 23:01:59 +0100
Message-Id: <1351634526-1516-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'stat -e cycles'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/base-stat       | 40 +++++++++++++++++++++++++++++++++++
 tools/perf/tests/attr/test-stat-basic |  6 ++++++
 2 files changed, 46 insertions(+)
 create mode 100644 tools/perf/tests/attr/base-stat
 create mode 100644 tools/perf/tests/attr/test-stat-basic

diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
new file mode 100644
index 0000000..6e1bb8e
--- /dev/null
+++ b/tools/perf/tests/attr/base-stat
@@ -0,0 +1,40 @@
+[event]
+fd=1
+group_fd=-1
+flags=0
+type=0
+size=96
+config=0
+sample_period=0
+sample_type=0
+read_format=3
+disabled=1
+inherit=1
+pinned=0
+exclusive=0
+exclude_user=0
+exclude_kernel=0
+exclude_hv=0
+exclude_idle=0
+mmap=0
+comm=0
+freq=0
+inherit_stat=0
+enable_on_exec=1
+task=0
+watermask=0
+precise_ip=0
+mmap_data=0
+sample_id_all=0
+exclude_host=0
+exclude_guest=1
+exclude_callchain_kernel=0
+exclude_callchain_user=0
+wakeup_events=0
+bp_type=0
+config1=0
+config2=0
+branch_sample_type=0
+sample_regs_user=0
+sample_stack_user=0
+optional=0
diff --git a/tools/perf/tests/attr/test-stat-basic b/tools/perf/tests/attr/test-stat-basic
new file mode 100644
index 0000000..74e1788
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-basic
@@ -0,0 +1,6 @@
+[config]
+command = stat
+args    = -e cycles kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
-- 
1.7.11.7

