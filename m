Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0EMWNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:13:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab0EMWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:12:57 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=rc7PfmPFBPQA:10 a=Lw_SFsgOoS4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=ouCqjlswqEbYyPwJsesA:9 a=KuXRWup53SR2YJ7-HnsA:7 a=9YtNRmgByIuaeroxGnRlQNSgWQYA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513221249.828023731@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 May 2010 18:10:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 11/12 v2] tracing: Fix function declarations if !CONFIG_STACKTRACE
References: <20100513221004.765293881@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Fix-function-declarations-if-CONFIG_STACKTRA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

ftrace_trace_stack() and frace_trace_userstacke() take a
struct ring_buffer argument, not struct trace_array. Commit
e77405ad("tracing: pass around ring buffer instead of tracer")
made this change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BE77C14.5010806@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6356259..40cd171 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -419,12 +419,12 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc);
 #else
-static inline void ftrace_trace_stack(struct trace_array *tr,
+static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 				      unsigned long flags, int skip, int pc)
 {
 }
 
-static inline void ftrace_trace_userstack(struct trace_array *tr,
+static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
 }
-- 
1.7.0


