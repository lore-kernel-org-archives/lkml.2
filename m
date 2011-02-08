Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1BHWR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:17:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1BHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:22 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=0HxJdLhi_30A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=hndguAEF1DTMlKmxKUwA:9 a=eF1J2t2c23kjM63qb8UZpMECY78A:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221720.824208364@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/10] tracing: Compile time initialization for event flags value
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Compile-time-initialization-for-event-flags-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
-- 
1.7.2.3


