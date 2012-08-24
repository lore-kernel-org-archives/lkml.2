Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2HXJDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977Ab2HXJBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/13] perf test: Add perf_event_attr stat basic test
Date: Fri, 24 Aug 2012 11:00:41 +0200
Message-Id: <1345798844-27423-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'stat'

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/test-attr/base-stat       | 39 +++++++++++++++++++++++++++++++
 tools/perf/util/test-attr/test-stat-basic |  6 +++++
 2 files changed, 45 insertions(+)
 create mode 100644 tools/perf/util/test-attr/base-stat
 create mode 100644 tools/perf/util/test-attr/test-stat-basic

diff --git a/tools/perf/util/test-attr/base-stat b/tools/perf/util/test-attr/base-stat
new file mode 100644
index 0000000..f46db90
--- /dev/null
+++ b/tools/perf/util/test-attr/base-stat
@@ -0,0 +1,39 @@
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
diff --git a/tools/perf/util/test-attr/test-stat-basic b/tools/perf/util/test-attr/test-stat-basic
new file mode 100644
index 0000000..74e1788
--- /dev/null
+++ b/tools/perf/util/test-attr/test-stat-basic
@@ -0,0 +1,6 @@
+[config]
+command = stat
+args    = -e cycles kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
-- 
1.7.11.4

