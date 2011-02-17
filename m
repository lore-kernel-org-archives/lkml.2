Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1BQPCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:02:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:38006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1BQPBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:01:49 -0500
Date: Thu, 17 Feb 2011 15:01:29 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <4D3FDFFC.6030304@cn.fujitsu.com>
References: <4D3FDFFC.6030304@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Compile time initialization for event flags value
Message-ID: <tip-f4d5c029bd6731baac0937324cef0f746e7d5ea7@git.kernel.org>
Git-Commit-ID: f4d5c029bd6731baac0937324cef0f746e7d5ea7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:01:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4d5c029bd6731baac0937324cef0f746e7d5ea7
Gitweb:     http://git.kernel.org/tip/f4d5c029bd6731baac0937324cef0f746e7d5ea7
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 26 Jan 2011 16:49:00 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 8 Feb 2011 17:14:54 -0500

tracing: Compile time initialization for event flags value

Compile time initialization is better than runtime initialization.

Remove many early_initcall()s and many trace_init_flags_##name()s.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D3FDFFC.6030304@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8e8968e..a17fcea 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -132,11 +132,11 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
+		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
-	 *__event_enter_##sname = &event_enter_##sname;			\
-	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
+	 *__event_enter_##sname = &event_enter_##sname;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata __syscall_meta_##sname;		\
@@ -146,11 +146,11 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
+		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
-	*__event_exit_##sname = &event_exit_##sname;			\
-	__TRACE_EVENT_FLAGS(exit_##sname, TRACE_EVENT_FL_CAP_ANY)
+	*__event_exit_##sname = &event_exit_##sname;
 
 #define SYSCALL_METADATA(sname, nb)				\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
