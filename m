Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1AHUQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:16:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1AHUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:46 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=E5FmnUEg8RgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=U9OQf257DlJnHMscr30A:9 a=ixLVnzB1dzO8oifloe-At7eQZWIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201644.606765771@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/7] tracing: Include module.h in define_trace.h
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Include-module.h-in-define_trace.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

While doing some developing, Peter Zijlstra and I have found
that if a CREATE_TRACE_POINTS include is done before module.h
is included, it can break the build.

We have been lucky so far that this has not broke the build
since module.h is included in almost everything.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_trace.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index b0b4eb2..da39b22 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -21,6 +21,16 @@
 #undef CREATE_TRACE_POINTS
 
 #include <linux/stringify.h>
+/*
+ * module.h includes tracepoints, and because ftrace.h
+ * pulls in module.h:
+ *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
+ *  linux/ftrace.h -> linux/module.h
+ * we must include module.h here before we play with any of
+ * the TRACE_EVENT() macros, otherwise the tracepoints included
+ * by module.h may break the build.
+ */
+#include <linux/module.h>
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-- 
1.7.2.3


