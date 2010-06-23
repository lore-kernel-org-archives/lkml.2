Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0FWKGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:06:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55599 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0FWKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:44 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 38/40] trace syscalls: Remove redundant test for unmapped compat syscalls
Date: Wed, 23 Jun 2010 20:03:19 +1000
Message-Id: <1277287401-28571-39-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Since the ftrace event initialisation routine now verifies that either
the syscall number or the compat syscall number is valid and will not
create events for unmapped syscalls, it is unnecessary to explicitly
search for them, so remove it.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c0041e3..108c2eb 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -528,26 +528,6 @@ int __init init_ftrace_syscalls(void)
 			meta->compat_syscall_nr = i;
 			compat_syscalls_metadata[i] = meta;
 		}
-		/* now check if any compat_syscalls are not referenced */
-		for (ftrace_event = __start_ftrace_events;
-			(unsigned long)ftrace_event <
-			(unsigned long)__stop_ftrace_events; ftrace_event++) {
-
-			match = 0;
-			if (!ftrace_event->name)
-				continue;
-			if (strcmp(ftrace_event->class->system, "compat_syscalls"))
-				continue;
-			for (i = 0; i < NR_syscalls_compat; i++) {
-				if (ftrace_event->data ==
-						compat_syscalls_metadata[i]) {
-					match = 1;
-					break;
-				}
-			}
-			if (!match)
-				ftrace_event->name = NULL;
-		}
 	}
 #endif
 	return 0;
-- 
1.7.1

