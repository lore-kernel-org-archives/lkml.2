Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0EJDVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:21:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0EJDVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:21:13 -0400
Message-ID: <4BE77C14.5010806@cn.fujitsu.com>
Date: Mon, 10 May 2010 11:23:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Fix function declarations if !CONFIG_STACKTRACE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_trace_stack() and frace_trace_userstacke() take a
struct ring_buffer argument, not struct trace_array. Commit
e77405ad("tracing: pass around ring buffer instead of tracer")
made this change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d1ce0be..58f6896 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -405,12 +405,12 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
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
1.6.3

