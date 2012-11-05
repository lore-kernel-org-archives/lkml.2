Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab2KER0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:26:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab2KERSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/32] perf tests: Add attr record event syntax group test
Date: Mon,  5 Nov 2012 14:17:49 -0300
Message-Id: <1352135893-7564-9-git-send-email-acme@infradead.org>
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
  'record group -e {cycles,instructions}'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-group1 |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-group1

diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
new file mode 100644
index 0000000..39bf860
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-group1
@@ -0,0 +1,20 @@
+[config]
+command = record
+args    = -e '{cycles,instructions}' kill >/tmp/krava 2>&1
+
+[event-1:base-record]
+fd=1
+group_fd=-1
+sample_type=327
+
+[event-2:base-record]
+fd=2
+group_fd=1
+type=0
+config=1
+sample_type=327
+mmap=0
+comm=0
+# TODO this is disabled for --group option, enabled otherwise
+#      check why..
+enable_on_exec=1
-- 
1.7.9.2.358.g22243

