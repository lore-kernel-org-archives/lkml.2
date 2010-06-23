Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0FWKE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:26 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49491 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0FWKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:18 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 09/40] tracing: move __start_ftrace_events and __stop_ftrace_events to header file
Date: Wed, 23 Jun 2010 20:02:50 +1000
Message-Id: <1277287401-28571-10-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

trace_syscalls.c uses __start_ftrace_events and __stop_ftrace_events in order
to prune compat syscall ftrace events that are not referenced by the compat
syscall table. So move the 'extern' definitions to a common header file.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/ftrace_event.h |    3 +++
 kernel/trace/trace_events.c  |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0af31cd..54b020b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -189,6 +189,9 @@ struct ftrace_event_call {
 #endif
 };
 
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
 #define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_PRED		32
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a594f9a..b03f82f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1260,9 +1260,6 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
-
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
 static __init int setup_trace_event(char *str)
-- 
1.7.1

