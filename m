Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1ANJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:59:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1ANJ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:59:03 -0500
Message-ID: <4D301C0E.8090408@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 17:49:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: remove syscall_exit_fields
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 17:48:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 17:58:27,
	Serialize complete at 2011-01-14 17:58:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use event_class_syscall_exit.fields instead.
Remove syscall_exit_fields.
Remove  syscall_get_enter_fields()
Add event_class_syscall_exit.fields initialization.

Indentation has to be changed also, otherwise the line
".fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),"
I added will exceed 80 characters.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index bac752f..b706529 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -23,9 +23,6 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
 
-/* All syscall exit events have the same fields */
-static LIST_HEAD(syscall_exit_fields);
-
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -34,34 +31,28 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 	return &entry->enter_fields;
 }
 
-static struct list_head *
-syscall_get_exit_fields(struct ftrace_event_call *call)
-{
-	return &syscall_exit_fields;
-}
-
 struct trace_event_functions enter_syscall_print_funcs = {
-	.trace                  = print_syscall_enter,
+	.trace		= print_syscall_enter,
 };
 
 struct trace_event_functions exit_syscall_print_funcs = {
-	.trace                  = print_syscall_exit,
+	.trace		= print_syscall_exit,
 };
 
 struct ftrace_event_class event_class_syscall_enter = {
-	.system			= "syscalls",
-	.reg			= syscall_enter_register,
-	.define_fields		= syscall_enter_define_fields,
-	.get_fields		= syscall_get_enter_fields,
-	.raw_init		= init_syscall_trace,
+	.system		= "syscalls",
+	.reg		= syscall_enter_register,
+	.define_fields	= syscall_enter_define_fields,
+	.get_fields	= syscall_get_enter_fields,
+	.raw_init	= init_syscall_trace,
 };
 
 struct ftrace_event_class event_class_syscall_exit = {
-	.system			= "syscalls",
-	.reg			= syscall_exit_register,
-	.define_fields		= syscall_exit_define_fields,
-	.get_fields		= syscall_get_exit_fields,
-	.raw_init		= init_syscall_trace,
+	.system		= "syscalls",
+	.reg		= syscall_exit_register,
+	.define_fields	= syscall_exit_define_fields,
+	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
+	.raw_init	= init_syscall_trace,
 };
 
 extern unsigned long __start_syscalls_metadata[];
