Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938055Ab0CPRqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938040Ab0CPRqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:46:44 -0400
Date: Tue, 16 Mar 2010 13:46:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <21d70133584d317469d79e5bec0ba03545dc9dd5.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 01/14] x86: add NR_syscalls_compat, make ia32 syscall table visible
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'NR_syscalls_compat' global for x86. Also, make 'ia32_sys_call_table' into a
global.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/ia32/ia32entry.S     |    3 +++
 arch/x86/include/asm/compat.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 53147ad..acc6fbf 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -503,6 +503,7 @@ END(ia32_ptregs_common)
 
 	.section .rodata,"a"
 	.align 8
+.globl ia32_sys_call_table
 ia32_sys_call_table:
 	.quad sys_restart_syscall
 	.quad sys_exit
@@ -843,3 +844,5 @@ ia32_sys_call_table:
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
 ia32_syscall_end:
+.globl NR_syscalls_compat
+NR_syscalls_compat: .int ((ia32_syscall_end - ia32_sys_call_table)/8)
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 9a9c7bd..b5b78e6 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -215,4 +215,6 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
 
+extern int NR_syscalls_compat;
+
 #endif /* _ASM_X86_COMPAT_H */
-- 
1.6.5.1

