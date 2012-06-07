Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2FGXqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:46:51 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41689 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2FGXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:46:48 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/2] tracing: trivial cleanup
Date: Thu,  7 Jun 2012 16:46:24 -0700
Message-Id: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Remove ftrace_format_syscall() declaration; it is neither defined nor
used. Also update a comment and formatting.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/syscall.h    |    2 --
 kernel/trace/ring_buffer.c |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..0c95796 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -39,8 +39,6 @@ extern int reg_event_syscall_enter(struct ftrace_event_call *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
 extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
-extern int
-ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
 				      struct trace_event *event);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..96c2dd1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1816,7 +1816,7 @@ rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
 }
 
 /**
- * ring_buffer_update_event - update event type and data
+ * rb_update_event - update event type and data
  * @event: the even to update
  * @type: the type of event
  * @length: the size of the event field in the ring buffer
@@ -2716,8 +2716,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
  * and not the length of the event which would hold the header.
  */
 int ring_buffer_write(struct ring_buffer *buffer,
-			unsigned long length,
-			void *data)
+		      unsigned long length,
+		      void *data)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-- 
1.7.7.3

