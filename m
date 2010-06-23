Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0FWKGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:06:08 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49620 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0FWKEo (ORCPT
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
Subject: [PATCH 37/40] trace syscalls: Print out unmapped syscalls at boot
Date: Wed, 23 Jun 2010 20:03:18 +1000
Message-Id: <1277287401-28571-38-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch will print out implemented but unmapped system calls at boot
to help quickly identify remaining unmapped system calls.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 58ef002..c0041e3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -102,6 +102,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 		if (start->name && arch_syscall_match_sym_name(str, start->name))
 			return start;
 	}
+	printk(KERN_DEBUG "ftrace syscalls: missing metadata for %s\n", str);
 	return NULL;
 }
 
-- 
1.7.1

