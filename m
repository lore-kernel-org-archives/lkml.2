Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2IQRSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:18:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2IQRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/18] perf scripts: Add event_analyzing_sample-record/report
Date: Mon, 17 Sep 2012 14:18:08 -0300
Message-Id: <1347902292-14536-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

So that event_analyzing_sample.py can be shown by "perf script -l"

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347007349-3102-4-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../python/bin/event_analyzing_sample-record       |    8 ++++++++
 .../python/bin/event_analyzing_sample-report       |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report

diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-record b/tools/perf/scripts/python/bin/event_analyzing_sample-record
new file mode 100644
index 0000000..5ce652d
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# event_analyzing_sample.py can cover all type of perf samples including
+# the tracepoints, so no special record requirements, just record what
+# you want to analyze.
+#
+perf record $@
diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-report b/tools/perf/scripts/python/bin/event_analyzing_sample-report
new file mode 100644
index 0000000..0941fc9
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-report
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: analyze all perf samples
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/event_analyzing_sample.py
-- 
1.7.1

