Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1DWQ3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35106 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab1DWQ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:42 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/18] perf: Remove duplicate enum trace_flag_type
Date: Sat, 23 Apr 2011 18:28:10 +0200
Message-Id: <1303576100-425-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
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
index bf28476..8510207 100644
--- a/tools/lib/trace/trace-event.h
+++ b/tools/lib/trace/trace-event.h
@@ -275,7 +275,15 @@ unsigned long get_filesize(const char *file);
 char *get_tracing_file(const char *name);
 void put_tracing_file(char *file);
 
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
index aa26f4d..9782c9a 100644
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

