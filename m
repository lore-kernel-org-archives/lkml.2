Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1BQO7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:59:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab1BQO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:59:21 -0500
Date: Thu, 17 Feb 2011 14:59:03 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1296703645-18718-3-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-3-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON
Message-ID: <tip-3773b389b6927595512558594d040c1edba46f36@git.kernel.org>
Git-Commit-ID: 3773b389b6927595512558594d040c1edba46f36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 14:59:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3773b389b6927595512558594d040c1edba46f36
Gitweb:     http://git.kernel.org/tip/3773b389b6927595512558594d040c1edba46f36
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 3 Feb 2011 14:27:21 +1100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Feb 2011 21:25:52 -0500

tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON

With the ftrace events now checking if the syscall_nr is valid upon
initialisation it should no longer be possible to register or unregister
a syscall event without a valid syscall_nr since they should not be
created. This adds a WARN_ON_ONCE in the register and unregister
functions to locate potential regressions in the future.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
LKML-Reference: <1296703645-18718-3-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a9ceabd..4230942 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -359,7 +359,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -377,7 +377,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -393,7 +393,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -411,7 +411,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
