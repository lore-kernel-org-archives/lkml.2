Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2DMIxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:53:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932720Ab2DMIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:53:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Date: Fri, 13 Apr 2012 09:52:59 +0100
Message-Id: <1334307179-21255-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -next fails to link for me:

kernel/built-in.o:(.data+0x178e50): undefined reference to `perf_ftrace_event_register'

It looks like multiple fixes have been merged for the issue fixed by
commit fa73dc9 (tracing: Fix build breakage without CONFIG_PERF_EVENTS)
though I can't identify the other changes that have gone in at the
minute, it's possible that the changes which caused the breakage fixed
by the previous commit got dropped but the fix made it in.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/trace/trace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..f95d65d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,11 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_FUNCTION_TRACER
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
-#endif /* CONFIG_FUNCTION_TRACER */
+#endif
 
 #endif /* _LINUX_KERNEL_TRACE_H */
-- 
1.7.9.1

