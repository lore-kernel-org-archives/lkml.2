Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938178Ab0CPRrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938166Ab0CPRrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:42 -0400
Date: Tue, 16 Mar 2010 13:47:11 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <7d18418ff4016d12dda4ea51bad19ff53307f6b1.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 13/14] cleanup: remove arg from TRACE_SYS_ENTER_PROFILE_INIT() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since TRACE_SYS_ENTER_PROFILE_INIT() and TRACE_SYS_EXIT_PROFILE_INIT() don't do
anything with their arguments, remove them. Also, TRACE_SYS_ENTER_PROFILE() and
TRACE_SYS_EXIT_PROFILE() don't appear to be used. remove them.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4cbc370..501cd46 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -101,18 +101,16 @@ struct perf_event_attr;
 
 #ifdef CONFIG_PERF_EVENTS
 
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
+#define TRACE_SYS_ENTER_PROFILE_INIT					       \
 	.profile_enable = prof_sysenter_enable,				       \
 	.profile_disable = prof_sysenter_disable,
 
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
+#define TRACE_SYS_EXIT_PROFILE_INIT					       \
 	.profile_enable = prof_sysexit_enable,				       \
 	.profile_disable = prof_sysexit_disable,
 #else
-#define TRACE_SYS_ENTER_PROFILE(sname)
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)
-#define TRACE_SYS_EXIT_PROFILE(sname)
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)
+#define TRACE_SYS_ENTER_PROFILE_INIT
+#define TRACE_SYS_EXIT_PROFILE_INIT
 #endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -149,7 +147,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
+		TRACE_SYS_ENTER_PROFILE_INIT				\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
@@ -171,7 +169,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
+		TRACE_SYS_EXIT_PROFILE_INIT				\
 	}
 
 #define SYSCALL_METADATA(rname, sname, nb)			\
-- 
1.6.5.1

