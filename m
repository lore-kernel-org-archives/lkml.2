Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2FLWzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:55:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2FLWy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:54:29 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=YQPsEM5QXWAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=GhwerxCL0HRgUY9Y1SwA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120612225426.961092717@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Jun 2012 18:43:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 11/13 v2] ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE
References: <20120612224327.426900129@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Make-ftrace_location-a-nop-on-DYNAMIC_FTRACE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When CONFIG_DYNAMIC_FTRACE is not set, ftrace_location() is not defined.
If a user (like kprobes) references this function, it will break
the compile when CONFIG_DYNAMIC_FTRACE is not set.

Add ftrace_location() as a nop (return 0) when DYNAMIC_FTRACE
is not defined.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 34ac110..271d006 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -500,7 +500,7 @@ extern int skip_trace(unsigned long ip);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
-#else
+#else /* CONFIG_DYNAMIC_FTRACE */
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
@@ -518,6 +518,10 @@ static inline int ftrace_text_reserved(void *start, void *end)
 {
 	return 0;
 }
+static inline unsigned long ftrace_location(unsigned long ip)
+{
+	return 0;
+}
 
 /*
  * Again users of functions that have ftrace_ops may not
-- 
1.7.10


