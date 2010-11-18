Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0KRBdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:33:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0KRBc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=N3gr+si41zJ5KoruqIfm6WQzFmu6PAAsXWPkhCPLS7t5S405ZeAW59R9Gv9jYWQo/Y
         xDlf/PeAicW9mJT+0vXrgn5R35XQgVdqXu83NwIqSCH6eWAvfNOWrugd2z8fAdraL79o
         l+QiCdS7W9e1feEgeZMlopNLHALhmWVJ6j1+M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 5/5] tracing: Remove useless syscall ftrace_event_call declaration
Date: Thu, 18 Nov 2010 02:32:43 +0100
Message-Id: <1290043963-1480-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
References: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is defined right after, which makes the declaration completely
useless.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 13b9731..18cd068 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -127,8 +127,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
-	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -143,8 +141,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
-	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
-- 
1.6.2.3

