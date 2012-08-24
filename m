Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2HXJFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2HXJBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/13] perf test: Add perf_event_attr record basic test
Date: Fri, 24 Aug 2012 11:00:33 +0200
Message-Id: <1345798844-27423-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record'

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/test-attr/base-record       | 39 +++++++++++++++++++++++++++++
 tools/perf/util/test-attr/test-record-basic |  5 ++++
 2 files changed, 44 insertions(+)
 create mode 100644 tools/perf/util/test-attr/base-record
 create mode 100644 tools/perf/util/test-attr/test-record-basic

diff --git a/tools/perf/util/test-attr/base-record b/tools/perf/util/test-attr/base-record
new file mode 100644
index 0000000..ea2d3c5
--- /dev/null
+++ b/tools/perf/util/test-attr/base-record
@@ -0,0 +1,39 @@
+[event]
+fd=1
+group_fd=-1
+flags=0
+type=0
+size=96
+config=0
+sample_period=4000
+sample_type=263
+read_format=7
+disabled=1
+inherit=1
+pinned=0
+exclusive=0
+exclude_user=0
+exclude_kernel=0
+exclude_hv=0
+exclude_idle=0
+mmap=1
+comm=1
+freq=1
+inherit_stat=0
+enable_on_exec=1
+task=0
+watermask=0
+precise_ip=0
+mmap_data=0
+sample_id_all=1
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
diff --git a/tools/perf/util/test-attr/test-record-basic b/tools/perf/util/test-attr/test-record-basic
new file mode 100644
index 0000000..55c0428
--- /dev/null
+++ b/tools/perf/util/test-attr/test-record-basic
@@ -0,0 +1,5 @@
+[config]
+command = record
+args    = kill >/dev/null 2>&1
+
+[event:base-record]
-- 
1.7.11.4

