Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463Ab2JaLXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:23:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422778Ab2JaLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:22:57 -0400
Message-ID: <50910A0A.9010209@gmail.com>
Date: Wed, 31 Oct 2012 19:22:50 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: [PATCH 5/9] ftrace: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 include/trace/ftrace.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a763888..7c9fde7 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -638,7 +638,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
  *	struct trace_entry *ent;
  *	int __entry_size;
  *	int __data_size;
- *	int __cpu
  *	int pc;
  *
  *	pc = preempt_count();
@@ -654,7 +653,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
  *	// Protect the non nmi buffer
  *	// This also protects the rcu read side
  *	local_irq_save(irq_flags);
- *	__cpu = smp_processor_id();
  *
  *	if (in_nmi())
  *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
@@ -664,7 +662,7 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
  *	if (!trace_buf)
  *		goto end;
  *
- *	trace_buf = per_cpu_ptr(trace_buf, __cpu);
+ *	trace_buf = this_cpu_ptr(trace_buf);
  *
  * 	// Avoid recursion from perf that could mess up the buffer
  * 	if (trace_buf->recursion++)
-- 
1.7.1

