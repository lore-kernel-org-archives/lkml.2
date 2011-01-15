Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1AOBFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 20:05:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1AOBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 20:05:19 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=94tF0hse47sA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=jbxWPBGwfxv4CJFqUS0A:9 a=nR1fb5lmrmhLJdbACdib-zS8D3sA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110115010518.243223435@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 20:04:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: Remove syscall_exit_fields
References: <20110115010442.446174852@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Remove-syscall_exit_fields.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

There is no need for syscall_exit_fields as the syscall
exit event class can already host the fields in its structure,
like most other trace events do by default. Use that
default behavior instead.

Following this scheme, we don't need anymore to override the
get_fields() callback of the syscall exit event class either.

Hence both syscall_exit_fields and syscall_get_exit_fields() can
be removed.

Also changed some indentation to keep the following under 80
characters:

".fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),"

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D301C0E.8090408@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

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
-- 
1.7.2.3


