Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2CZTEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:04:35 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36257 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2CZTEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:04:32 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 3/6] trace: Refactor ftrace syscall macros to make them more readable
Date: Mon, 26 Mar 2012 11:39:25 -0700
Message-Id: <1332787168-20457-4-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions and structures defined for syscall tracepoints have
underscores added at different places in their names. It is a bit
difficult to read and understand where an underscore is added and what
the final name of the element will be.

This patch makes sure that all the underscores that are added to the
name are at the declaration for the variables and functions to make it
more readable. It is also clearer what the final name would be.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/linux/syscalls.h |   84 +++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a5b0cae..fd4d37d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -132,73 +132,73 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta__##sname;		\
 	static struct ftrace_event_call __used				\
-	  event_enter_##sname = {					\
-		.name                   = "sys_enter"#sname,		\
+	  event_enter__##sname = {					\
+		.name                   = "sys_enter_"#sname,		\
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
-		.data			= (void *)&__syscall_meta_##sname,\
+		.data			= (void *)&__syscall_meta__##sname,\
 		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
-	 *__event_enter_##sname = &event_enter_##sname;
+	 *__event_enter__##sname = &event_enter__##sname;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta__##sname;		\
 	static struct ftrace_event_call __used				\
-	  event_exit_##sname = {					\
-		.name                   = "sys_exit"#sname,		\
+	  event_exit__##sname = {					\
+		.name                   = "sys_exit_"#sname,		\
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
-		.data			= (void *)&__syscall_meta_##sname,\
+		.data			= (void *)&__syscall_meta__##sname,\
 		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
-	*__event_exit_##sname = &event_exit_##sname;
+	*__event_exit__##sname = &event_exit__##sname;
 
 #define _SYSCALL_METADATAx(x, mname, sname, _compat, ...)	\
-	static const char *types_##sname[] = {			\
+	static const char *types__##sname[] = {			\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
-	static const char *args_##sname[] = {			\
+	static const char *args__##sname[] = {			\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __syscall_meta_##sname = {				\
+	  __syscall_meta__##sname = {				\
 		.name 		= mname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= x,				\
-		.types		= types_##sname,		\
-		.args		= args_##sname,			\
+		.types		= types__##sname,		\
+		.args		= args__##sname,		\
 		.compat		= _compat,			\
-		.enter_event	= &event_enter_##sname,		\
-		.exit_event	= &event_exit_##sname,		\
-		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
+		.enter_event	= &event_enter__##sname,	\
+		.exit_event	= &event_exit__##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
 	};							\
 	static struct syscall_metadata __used			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
+	 *__p_syscall_meta__##sname = &__syscall_meta__##sname;
 
 #define SYSCALL_METADATAx(x, sname, ...)		\
-	_SYSCALL_METADATAx(x, "sys"#sname, sname, 0, __VA_ARGS__)
+	_SYSCALL_METADATAx(x, "sys_"#sname, sname, 0, __VA_ARGS__)
 
 #ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
 
 #define COMPAT_SYSCALL_METADATAx(x, sname, ...)			\
-	_SYSCALL_METADATAx(x, "compat"#sname, _compat##sname, 1, __VA_ARGS__)
+	_SYSCALL_METADATAx(x, "compat_"#sname, compat_##sname, 1, __VA_ARGS__)
 
-#define COMPAT_SYSCALL_METADATA0(name, ...) COMPAT_SYSCALL_METADATAx(0, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA1(name, ...) COMPAT_SYSCALL_METADATAx(1, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA2(name, ...) COMPAT_SYSCALL_METADATAx(2, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA3(name, ...) COMPAT_SYSCALL_METADATAx(3, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA4(name, ...) COMPAT_SYSCALL_METADATAx(4, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA5(name, ...) COMPAT_SYSCALL_METADATAx(5, _##name, __VA_ARGS__)
-#define COMPAT_SYSCALL_METADATA6(name, ...) COMPAT_SYSCALL_METADATAx(6, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA0(name, ...) COMPAT_SYSCALL_METADATAx(0, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA1(name, ...) COMPAT_SYSCALL_METADATAx(1, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA2(name, ...) COMPAT_SYSCALL_METADATAx(2, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA3(name, ...) COMPAT_SYSCALL_METADATAx(3, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA4(name, ...) COMPAT_SYSCALL_METADATAx(4, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA5(name, ...) COMPAT_SYSCALL_METADATAx(5, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA6(name, ...) COMPAT_SYSCALL_METADATAx(6, name, __VA_ARGS__)
 
 #endif /* CONFIG_FTRACE_COMPAT_SYSCALLS */
 
@@ -206,13 +206,13 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_METADATAx(x, name, ...)
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#define SYSCALL_DEFINE0(name, ...) SYSCALL_DEFINEx(0, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE0(name, ...) SYSCALL_DEFINEx(0, name, __VA_ARGS__)
+#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, name, __VA_ARGS__)
+#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, name, __VA_ARGS__)
+#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, name, __VA_ARGS__)
+#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, name, __VA_ARGS__)
+#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, name, __VA_ARGS__)
+#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, name, __VA_ARGS__)
 
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
@@ -237,21 +237,21 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
 
 #define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
+	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage long SyS_##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(sys##name, SyS##name);				\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
+	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
+	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
 #define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
+	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-- 
1.7.7.3

