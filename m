Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab2KERTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:19:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44897 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab2KERSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/32] perf tests: Add missing attr stat basic test
Date: Mon,  5 Nov 2012 14:18:10 -0300
Message-Id: <1352135893-7564-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'stat -e cycles'

Reported-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352130579-13451-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-stat       |   40 +++++++++++++++++++++++++++++++++
 tools/perf/tests/attr/test-stat-basic |    6 +++++
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
1.7.9.2.358.g22243

