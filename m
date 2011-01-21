Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1AUPHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:07:41 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58472 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1AUPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:07:39 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/12] perf: Remove duplicate enum trace_flag_type
Date: Fri, 21 Jan 2011 16:09:29 +0100
Message-Id: <1295622575-18607-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Merge the two definitions.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/trace/trace-event.h  |   10 +++++++++-
 tools/perf/builtin-timechart.c |   21 ++-------------------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/tools/lib/trace/trace-event.h b/tools/lib/trace/trace-event.h
index 4be3d7a..0c06b5b 100644
--- a/tools/lib/trace/trace-event.h
+++ b/tools/lib/trace/trace-event.h
@@ -273,7 +273,15 @@ extern int event_read_format(struct event *event);
 unsigned long get_filesize(const char *file);
 char *get_tracing_file(const char *name);
 
-/* taken from kernel/trace/trace.h */
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF            - interrupts were disabled
+ *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
+ *  NEED_RESCED         - reschedule is requested
+ *  HARDIRQ             - inside an interrupt handler
+ *  SOFTIRQ             - inside a softirq handler
+ */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 746cf03..5333746 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -32,6 +32,8 @@
 #include "util/session.h"
 #include "util/svghelper.h"
 
+#include <trace/trace-event.h>
+
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
 
@@ -330,25 +332,6 @@ struct wakeup_entry {
 	int   success;
 };
 
-/*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF            - interrupts were disabled
- *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
- *  NEED_RESCED         - reschedule is requested
- *  HARDIRQ             - inside an interrupt handler
- *  SOFTIRQ             - inside a softirq handler
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
-	TRACE_FLAG_NEED_RESCHED		= 0x04,
-	TRACE_FLAG_HARDIRQ		= 0x08,
-	TRACE_FLAG_SOFTIRQ		= 0x10,
-};
-
-
-
 struct sched_switch {
 	struct trace_entry te;
 	char prev_comm[TASK_COMM_LEN];
-- 
1.7.4.rc2

