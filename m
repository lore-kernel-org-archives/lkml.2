Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2KNGtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:49:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2KNGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:49:54 -0500
Date: Tue, 13 Nov 2012 22:49:42 -0800
From: tip-bot for David Sharp <dhsharp@google.com>
Message-ID: <tip-01e3e710a9265fb7092efd67243d7b6dd6e2548a@git.kernel.org>
Cc: vnagarnaik@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vnagarnaik@google.com, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de
In-Reply-To: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Trivial cleanup
Git-Commit-ID: 01e3e710a9265fb7092efd67243d7b6dd6e2548a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:49:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01e3e710a9265fb7092efd67243d7b6dd6e2548a
Gitweb:     http://git.kernel.org/tip/01e3e710a9265fb7092efd67243d7b6dd6e2548a
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Thu, 7 Jun 2012 16:46:24 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:45:33 -0400

tracing: Trivial cleanup

Remove ftrace_format_syscall() declaration; it is neither defined nor
used. Also update a comment and formatting.

Link: http://lkml.kernel.org/r/1339112785-21806-1-git-send-email-vnagarnaik@google.com

Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 0ebeb1d..23a384b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1821,7 +1821,7 @@ rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
 }
 
 /**
- * ring_buffer_update_event - update event type and data
+ * rb_update_event - update event type and data
  * @event: the even to update
  * @type: the type of event
  * @length: the size of the event field in the ring buffer
@@ -2723,8 +2723,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
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
