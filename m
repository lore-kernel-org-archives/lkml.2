Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0LGE33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:29:29 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38316 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0LGE30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:29:26 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] trace syscalls: Remove redundant syscall_nr checks
Date: Tue,  7 Dec 2010 15:29:07 +1100
Message-Id: <1291696151-4336-3-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

With the ftrace events now checking if the syscall_nr is valid upon
initialisation, there is no need to verify it when registering and
unregistering the events, so remove the check.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 14f4c02..5e34b49 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -367,8 +367,6 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
@@ -385,8 +383,6 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
 	clear_bit(num, enabled_enter_syscalls);
@@ -401,8 +397,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
+
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
@@ -419,8 +414,6 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
 	clear_bit(num, enabled_exit_syscalls);
-- 
1.7.2.3

