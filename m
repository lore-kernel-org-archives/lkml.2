Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1HRTMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:12:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1HRTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:10 -0400
Date: Thu, 18 Aug 2011 20:12:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 79/91] um: unify KSTK_...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80f-00083z-Uy@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and switch get_thread_register() to HOST_... for register numbers

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/asm/processor.h      |    4 ++++
 arch/x86/um/asm/processor_32.h   |    4 ----
 arch/x86/um/asm/processor_64.h   |    3 ---
 arch/x86/um/os-Linux/registers.c |   12 ++++++------
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/um/asm/processor.h b/arch/x86/um/asm/processor.h
index f34c4b2..118c143 100644
--- a/arch/x86/um/asm/processor.h
+++ b/arch/x86/um/asm/processor.h
@@ -10,6 +10,10 @@
 # include "processor_64.h"
 #endif
 
+#define KSTK_EIP(tsk) KSTK_REG(tsk, HOST_IP)
+#define KSTK_ESP(tsk) KSTK_REG(tsk, HOST_IP)
+#define KSTK_EBP(tsk) KSTK_REG(tsk, HOST_BP)
+
 #define ARCH_IS_STACKGROW(address) \
        (address + 65536 + 32 * sizeof(unsigned long) >= UPT_SP(&current->thread.regs.regs))
 
diff --git a/arch/x86/um/asm/processor_32.h b/arch/x86/um/asm/processor_32.h
index c4078b5..018f732 100644
--- a/arch/x86/um/asm/processor_32.h
+++ b/arch/x86/um/asm/processor_32.h
@@ -63,8 +63,4 @@ static inline void rep_nop(void)
 #define current_text_addr() \
 	({ void *pc; __asm__("movl $1f,%0\n1:":"=g" (pc)); pc; })
 
-#define KSTK_EIP(tsk) KSTK_REG(tsk, EIP)
-#define KSTK_ESP(tsk) KSTK_REG(tsk, UESP)
-#define KSTK_EBP(tsk) KSTK_REG(tsk, EBP)
-
 #endif
diff --git a/arch/x86/um/asm/processor_64.h b/arch/x86/um/asm/processor_64.h
index 0186c61..61de92d 100644
--- a/arch/x86/um/asm/processor_64.h
+++ b/arch/x86/um/asm/processor_64.h
@@ -42,7 +42,4 @@ static inline void arch_copy_thread(struct arch_thread *from,
 #define current_text_addr() \
 	({ void *pc; __asm__("movq $1f,%0\n1:":"=g" (pc)); pc; })
 
-#define KSTK_EIP(tsk) KSTK_REG(tsk, RIP)
-#define KSTK_ESP(tsk) KSTK_REG(tsk, RSP)
-
 #endif
diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 3a9b624..fa2e5a6 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -89,18 +89,18 @@ unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
 	switch (reg) {
 #ifdef __i386__
-	case EIP:
+	case HOST_IP:
 		return buf[0]->__eip;
-	case UESP:
+	case HOST_SP:
 		return buf[0]->__esp;
-	case EBP:
+	case HOST_BP:
 		return buf[0]->__ebp;
 #else
-	case RIP:
+	case HOST_IP:
 		return buf[0]->__rip;
-	case RSP:
+	case HOST_SP:
 		return buf[0]->__rsp;
-	case RBP:
+	case HOST_BP:
 		return buf[0]->__rbp;
 #endif
 	default:
-- 
1.7.2.5


