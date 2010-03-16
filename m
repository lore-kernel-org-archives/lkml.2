Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938106Ab0CPRrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938093Ab0CPRrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:06 -0400
Date: Tue, 16 Mar 2010 13:46:30 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <9b9820c5d18a88a8a4f8ada7383ff92ce7d6c899.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 05/14] tracing: move __start_ftrace_events and __stop_ftrace_events to header file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_syscalls.c uses __start_ftrace_events and __stop_ftrace_events in order
to prune compat syscall ftrace events that are not referenced by the compat
syscall table. So move the 'extern' definitions to a common header file.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h |    3 +++
 kernel/trace/trace_events.c  |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 6b7c444..fb6ede1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -136,6 +136,9 @@ struct ftrace_event_call {
 	void			(*profile_disable)(struct ftrace_event_call *);
 };
 
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
 #define MAX_FILTER_PRED		32
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3f972ad..36d9787 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1222,9 +1222,6 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
-
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
 static __init int setup_trace_event(char *str)
-- 
1.6.5.1

