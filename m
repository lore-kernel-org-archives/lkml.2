Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0KIJMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:12:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:38892 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0KIJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855641152"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        chris@chris-wilson.co.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/4] tracing: introduce for_each_token macro
Date: Tue,  9 Nov 2010 17:12:44 +0800
Message-Id: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce for_each_token macro to parse the trace event list.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/trace/trace_events.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..fe15b7c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1218,6 +1218,11 @@ void trace_remove_event_call(struct ftrace_event_call *call)
 	mutex_unlock(&event_mutex);
 }
 
+#define for_each_token(token, buf) 				\
+	for (token = strsep(&buf, ","); 			\
+	     token && *token; 					\
+	     token = strsep(&buf, ","))
+
 #define for_each_event(event, start, end)			\
 	for (event = start;					\
 	     (unsigned long)event < (unsigned long)end;		\
@@ -1430,14 +1435,7 @@ static __init int event_trace_init(void)
 				       &ftrace_event_format_fops);
 	}
 
-	while (true) {
-		token = strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
-
+	for_each_token(token, buf) {
 		ret = ftrace_set_clr_event(token, 1);
 		if (ret)
 			pr_warning("Failed to enable trace event: %s\n", token);
-- 
1.7.2.3

