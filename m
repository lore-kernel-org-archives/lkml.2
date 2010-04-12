Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0DLGGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:06:48 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11334 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab0DLGGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:06:45 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVwkurR7Hu/2dsb2JhbACbM3GhN5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113732008"
Date: Sun, 11 Apr 2010 23:06:44 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 12/23] Make register values available to Microblaze panic
	notifiers
Message-ID: <20100412060644.GA25597@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() function has not been tested or even built. I will need
help to complete this.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/microblaze/include/asm/ptrace.h |  109 ++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
index d74dbfb..3ef4464 100644
--- a/arch/microblaze/include/asm/ptrace.h
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -76,6 +76,115 @@ void show_regs(struct pt_regs *);
 
 #endif /* __KERNEL */
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"swi	" #r ", %[" #r "]\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I(r, r, i)
+
+#define PTREG_OUT_R(regs, i)	PTREG_OUT_I(regs, r, r, i)
+
+#define arch_has_save_ptregs	1
+
+/**
+ * save_ptregs - save processor registers for backtracing
+ * @regs:	Pointer to &struct pt_regs structure in which to save the
+ *		registers
+ *
+ * Returns a constant pointer to @regs.
+ *
+ * This function must be called first in a function. There must be no
+ * auto variables defined that are initialized before calling this function.
+ */
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE_R(0)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(3)
+			PTREG_SAVE_R(4)
+			PTREG_SAVE_R(5)
+			PTREG_SAVE_R(6)
+			PTREG_SAVE_R(7)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE_R(13)
+			PTREG_SAVE_R(14)
+			PTREG_SAVE_R(15)
+			PTREG_SAVE_R(16)
+			PTREG_SAVE_R(17)
+			PTREG_SAVE_R(18)
+			PTREG_SAVE_R(19)
+			PTREG_SAVE_R(20)
+			PTREG_SAVE_R(21)
+			PTREG_SAVE_R(22)
+			PTREG_SAVE_R(23)
+			PTREG_SAVE_R(24)
+			PTREG_SAVE_R(25)
+			PTREG_SAVE_R(26)
+			PTREG_SAVE_R(27)
+			PTREG_SAVE_R(28)
+			PTREG_SAVE_R(29)
+			PTREG_SAVE_R(30)
+			PTREG_SAVE_R(31)
+			PTREG_SAVE(msr, msr)
+			PTREG_SAVE(ear, ear)
+			PTREG_SAVE(esr, esr)
+			PTREG_SAVE(fsr, fsr)
+			PTREG_SAVE(pt_mode, pt_mode)
+		"1:\n"
+			"la	r1, r0, 1b\n"
+			PTREG_SAVE(r0, pc)
+	:
+		PTREG_OUT_R(regs, 0)
+		PTREG_OUT_R(regs, 1)
+		PTREG_OUT_R(regs, 2)
+		PTREG_OUT_R(regs, 3)
+		PTREG_OUT_R(regs, 4)
+		PTREG_OUT_R(regs, 5)
+		PTREG_OUT_R(regs, 6)
+		PTREG_OUT_R(regs, 7)
+		PTREG_OUT_R(regs, 8)
+		PTREG_OUT_R(regs, 9)
+		PTREG_OUT_R(regs, 10)
+		PTREG_OUT_R(regs, 11)
+		PTREG_OUT_R(regs, 12)
+		PTREG_OUT_R(regs, 13)
+		PTREG_OUT_R(regs, 14)
+		PTREG_OUT_R(regs, 15)
+		PTREG_OUT_R(regs, 16)
+		PTREG_OUT_R(regs, 17)
+		PTREG_OUT_R(regs, 18)
+		PTREG_OUT_R(regs, 19)
+		PTREG_OUT_R(regs, 20)
+		PTREG_OUT_R(regs, 21)
+		PTREG_OUT_R(regs, 22)
+		PTREG_OUT_R(regs, 23)
+		PTREG_OUT_R(regs, 24)
+		PTREG_OUT_R(regs, 25)
+		PTREG_OUT_R(regs, 26)
+		PTREG_OUT_R(regs, 27)
+		PTREG_OUT_R(regs, 28)
+		PTREG_OUT_R(regs, 29)
+		PTREG_OUT_R(regs, 30)
+		PTREG_OUT_R(regs, 31)
+		PTREG_OUT(regs, pc, pc)
+		PTREG_OUT(regs, msr, msr)
+		PTREG_OUT(regs, ear, ear)
+		PTREG_OUT(regs, esr, esr)
+		PTREG_OUT(regs, fsr, fsr)
+		PTREG_OUT(regs, pt_mode, pt_mode)
+	:
+		"r1"
+	);
+
+	return regs;
+}
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_MICROBLAZE_PTRACE_H */
