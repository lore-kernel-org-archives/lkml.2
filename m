Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0FWKEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:20 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59744 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0FWKEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:13 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/40] x86: add NR_syscalls_compat, make ia32 syscall table visible
Date: Wed, 23 Jun 2010 20:02:46 +1000
Message-Id: <1277287401-28571-6-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add 'NR_syscalls_compat' global for x86. Also, make 'ia32_sys_call_table' into a
global.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/x86/ia32/ia32entry.S     |    3 +++
 arch/x86/include/asm/compat.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e790bc1..94b9022 100644
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
index 306160e..55109f8 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -216,4 +216,6 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
 
+extern int NR_syscalls_compat;
+
 #endif /* _ASM_X86_COMPAT_H */
-- 
1.7.1

