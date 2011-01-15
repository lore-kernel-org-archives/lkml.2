Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1AOOzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:55:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:44679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1AOOzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:55:19 -0500
Date: Sat, 15 Jan 2011 14:55:03 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <4D301C0E.8090408@cn.fujitsu.com>
References: <4D301C0E.8090408@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Remove syscall_exit_fields
Message-ID: <tip-7f85803a26f304e698c673838aab06cc6d4d6e59@git.kernel.org>
Git-Commit-ID: 7f85803a26f304e698c673838aab06cc6d4d6e59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 Jan 2011 14:55:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f85803a26f304e698c673838aab06cc6d4d6e59
Gitweb:     http://git.kernel.org/tip/7f85803a26f304e698c673838aab06cc6d4d6e59
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 14 Jan 2011 17:49:02 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 14 Jan 2011 18:06:35 -0500

tracing: Remove syscall_exit_fields

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
