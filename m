Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1HRTKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47565 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:20 -0400
Date: Thu, 18 Aug 2011 20:10:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 68/91] um: increase stack growth cushion in
 pagefault
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7yt-0007xO-Rm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


analog of [PATCH] i386: let usermode execute the "enter" instruction from
circa 2006.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/asm/processor.h    |    3 +++
 arch/x86/um/asm/processor_32.h |    3 ---
 arch/x86/um/asm/processor_64.h |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/um/asm/processor.h b/arch/x86/um/asm/processor.h
index d3ac1ce..f34c4b2 100644
--- a/arch/x86/um/asm/processor.h
+++ b/arch/x86/um/asm/processor.h
@@ -10,6 +10,9 @@
 # include "processor_64.h"
 #endif
 
+#define ARCH_IS_STACKGROW(address) \
+       (address + 65536 + 32 * sizeof(unsigned long) >= UPT_SP(&current->thread.regs.regs))
+
 #include <asm/processor-generic.h>
 
 #endif
diff --git a/arch/x86/um/asm/processor_32.h b/arch/x86/um/asm/processor_32.h
index ae0d189..e5b72fa 100644
--- a/arch/x86/um/asm/processor_32.h
+++ b/arch/x86/um/asm/processor_32.h
@@ -63,9 +63,6 @@ static inline void rep_nop(void)
 #define current_text_addr() \
 	({ void *pc; __asm__("movl $1f,%0\n1:":"=g" (pc)); pc; })
 
-#define ARCH_IS_STACKGROW(address) \
-       (address + 32 >= UPT_SP(&current->thread.regs.regs))
-
 #define KSTK_EIP(tsk) KSTK_REG(tsk, EIP)
 #define KSTK_ESP(tsk) KSTK_REG(tsk, UESP)
 #define KSTK_EBP(tsk) KSTK_REG(tsk, EBP)
diff --git a/arch/x86/um/asm/processor_64.h b/arch/x86/um/asm/processor_64.h
index 6db812b..0186c61 100644
--- a/arch/x86/um/asm/processor_64.h
+++ b/arch/x86/um/asm/processor_64.h
@@ -42,9 +42,6 @@ static inline void arch_copy_thread(struct arch_thread *from,
 #define current_text_addr() \
 	({ void *pc; __asm__("movq $1f,%0\n1:":"=g" (pc)); pc; })
 
-#define ARCH_IS_STACKGROW(address) \
-        (address + 128 >= UPT_SP(&current->thread.regs.regs))
-
 #define KSTK_EIP(tsk) KSTK_REG(tsk, RIP)
 #define KSTK_ESP(tsk) KSTK_REG(tsk, RSP)
 
-- 
1.7.2.5


