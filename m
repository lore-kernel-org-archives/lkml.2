Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab2CZSkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:40:51 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38982 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab2CZSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:33 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/6] trace: syscalls.h - cleanup and simplify SYSCALL_METADATA()
Date: Mon, 26 Mar 2012 11:39:23 -0700
Message-Id: <1332787168-20457-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Davidson <md@google.com>

Add 0 argument versions of the __SC_* macros so that system calls
with 0 arguments are no longer a special case.

Change SYSCALL_DEFINE0() to use SYSCALL_DEFINEx() like everything else.

Move the declarations of types_##sname and args_##sname into the
SYSCALL_METADATA() macro so that the changes to SYSCALL_DEFINEx()
when CONFIG_FTRACE_SYSCALLS is defined are all hidden inside of
SYSCALL_METADATA().

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/linux/syscalls.h |   51 ++++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8ec1153..ed0003c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -76,6 +76,7 @@ struct file_handle;
 #include <linux/key.h>
 #include <trace/syscall.h>
 
+#define __SC_DECL0()
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
 #define __SC_DECL3(t3, a3, ...) t3 a3, __SC_DECL2(__VA_ARGS__)
@@ -83,6 +84,7 @@ struct file_handle;
 #define __SC_DECL5(t5, a5, ...) t5 a5, __SC_DECL4(__VA_ARGS__)
 #define __SC_DECL6(t6, a6, ...) t6 a6, __SC_DECL5(__VA_ARGS__)
 
+#define __SC_LONG0()
 #define __SC_LONG1(t1, a1) 	long a1
 #define __SC_LONG2(t2, a2, ...) long a2, __SC_LONG1(__VA_ARGS__)
 #define __SC_LONG3(t3, a3, ...) long a3, __SC_LONG2(__VA_ARGS__)
@@ -90,6 +92,7 @@ struct file_handle;
 #define __SC_LONG5(t5, a5, ...) long a5, __SC_LONG4(__VA_ARGS__)
 #define __SC_LONG6(t6, a6, ...) long a6, __SC_LONG5(__VA_ARGS__)
 
+#define __SC_CAST0()
 #define __SC_CAST1(t1, a1)	(t1) a1
 #define __SC_CAST2(t2, a2, ...) (t2) a2, __SC_CAST1(__VA_ARGS__)
 #define __SC_CAST3(t3, a3, ...) (t3) a3, __SC_CAST2(__VA_ARGS__)
@@ -98,6 +101,7 @@ struct file_handle;
 #define __SC_CAST6(t6, a6, ...) (t6) a6, __SC_CAST5(__VA_ARGS__)
 
 #define __SC_TEST(type)		BUILD_BUG_ON(sizeof(type) > sizeof(long))
+#define __SC_TEST0()
 #define __SC_TEST1(t1, a1)	__SC_TEST(t1)
 #define __SC_TEST2(t2, a2, ...)	__SC_TEST(t2); __SC_TEST1(__VA_ARGS__)
 #define __SC_TEST3(t3, a3, ...)	__SC_TEST(t3); __SC_TEST2(__VA_ARGS__)
@@ -106,6 +110,7 @@ struct file_handle;
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
 #ifdef CONFIG_FTRACE_SYSCALLS
+#define __SC_STR_ADECL0()		(0)
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
 #define __SC_STR_ADECL3(t, a, ...)	#a, __SC_STR_ADECL2(__VA_ARGS__)
@@ -113,6 +118,7 @@ struct file_handle;
 #define __SC_STR_ADECL5(t, a, ...)	#a, __SC_STR_ADECL4(__VA_ARGS__)
 #define __SC_STR_ADECL6(t, a, ...)	#a, __SC_STR_ADECL5(__VA_ARGS__)
 
+#define __SC_STR_TDECL0()		(0)
 #define __SC_STR_TDECL1(t, a)		#t
 #define __SC_STR_TDECL2(t, a, ...)	#t, __SC_STR_TDECL1(__VA_ARGS__)
 #define __SC_STR_TDECL3(t, a, ...)	#t, __SC_STR_TDECL2(__VA_ARGS__)
@@ -153,14 +159,20 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("_ftrace_events")))			\
 	*__event_exit_##sname = &event_exit_##sname;
 
-#define SYSCALL_METADATA(sname, nb)				\
+#define SYSCALL_METADATAx(x, sname, ...)			\
+	static const char *types_##sname[] = {			\
+		__SC_STR_TDECL##x(__VA_ARGS__)			\
+	};							\
+	static const char *args_##sname[] = {			\
+		__SC_STR_ADECL##x(__VA_ARGS__)			\
+	};							\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
-		.nb_args 	= nb,				\
+		.nb_args 	= x,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
 		.enter_event	= &event_enter_##sname,		\
@@ -170,27 +182,11 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
-
-#define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
-	static struct syscall_metadata __used			\
-	  __syscall_meta__##sname = {				\
-		.name 		= "sys_"#sname,			\
-		.syscall_nr	= -1,	/* Filled in at boot */	\
-		.nb_args 	= 0,				\
-		.enter_event	= &event_enter__##sname,	\
-		.exit_event	= &event_exit__##sname,		\
-		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
-	};							\
-	static struct syscall_metadata __used			\
-	  __attribute__((section("__syscalls_metadata")))	\
-	 *__p_syscall_meta_##sname = &__syscall_meta__##sname;	\
-	asmlinkage long sys_##sname(void)
 #else
-#define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
-#endif
+#define SYSCALL_METADATAx(x, name, ...)
+#endif /* CONFIG_FTRACE_SYSCALLS */
 
+#define SYSCALL_DEFINE0(name, ...) SYSCALL_DEFINEx(0, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
@@ -212,20 +208,9 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #endif
 #endif
 
-#ifdef CONFIG_FTRACE_SYSCALLS
-#define SYSCALL_DEFINEx(x, sname, ...)				\
-	static const char *types_##sname[] = {			\
-		__SC_STR_TDECL##x(__VA_ARGS__)			\
-	};							\
-	static const char *args_##sname[] = {			\
-		__SC_STR_ADECL##x(__VA_ARGS__)			\
-	};							\
-	SYSCALL_METADATA(sname, x);				\
-	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
-#else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
+	SYSCALL_METADATAx(x, sname, __VA_ARGS__)			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
-#endif
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
-- 
1.7.7.3

