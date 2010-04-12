Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0DLGEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:47 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40000 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0DLGEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:40 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwkurR7H+/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521365"
Date: Sun, 11 Apr 2010 23:04:39 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 19/23] Make register values available to SH panic notifiers
Message-ID: <20100412060439.GA24865@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() functions compiles cleanly for the pre-SH5 code, but has
not been tested. The SH5 code hasn't been compiled.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/sh/include/asm/ptrace.h |  298 ++++++++++++++++++++++++++++++++++++++++++
 arch/sh/kernel/traps_32.c    |    4 +-
 2 files changed, 300 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index 1dc12cb..2a18508 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -138,6 +138,304 @@ static inline unsigned long profile_pc(struct pt_regs *regs)
 
 	return pc;
 }
+
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+
+#include <linux/ptreg.h>
+#include <linux/compiler.h>
+
+/* Location of the TRAPA exception register */
+#define TRA 0xff000020
+
+#if defined(__SH5__)
+#define PTREG_SAVE(r, name)	"mov.l	" #r ", %[" #name "]\n"
+#else
+#define PTREG_SAVE(r, name)	"mov.l	" #r ", %[" #name "]\n"
+#endif
+
+#define STR(x)	#x
+#define VAL(x)	STR(x)
+
+#define PTREG_SAVE_REG(i)	_PTREG_SAVE_IDX(r, r, i)
+#define PTREG_SAVE_TREG(i)	_PTREG_SAVE_IDX(t, t, i)
+
+#define PTREG_OUT_REG(rp, i)	_PTREG_OUT_IDX(rp, regs, r, i)
+#define PTREG_OUT_TREG(rp, i)	_PTREG_OUT_IDX(rp, tregs, t, i)
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
+#if defined(__SH5__)
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE(sr, sr)
+			PTREG_SAVE(syscall_nr, syscall_nr)
+			PTREG_SAVE_REGS(0)
+			PTREG_SAVE_REGS(1)
+			PTREG_SAVE_REGS(2)
+			PTREG_SAVE_REGS(3)
+			PTREG_SAVE_REGS(4)
+			PTREG_SAVE_REGS(5)
+			PTREG_SAVE_REGS(6)
+			PTREG_SAVE_REGS(7)
+			PTREG_SAVE_REGS(8)
+			PTREG_SAVE_REGS(9)
+			PTREG_SAVE_REGS(10)
+			PTREG_SAVE_REGS(11)
+			PTREG_SAVE_REGS(12)
+			PTREG_SAVE_REGS(13)
+			PTREG_SAVE_REGS(14)
+			PTREG_SAVE_REGS(15)
+			PTREG_SAVE_REGS(16)
+			PTREG_SAVE_REGS(17)
+			PTREG_SAVE_REGS(18)
+			PTREG_SAVE_REGS(19)
+			PTREG_SAVE_REGS(20)
+			PTREG_SAVE_REGS(21)
+			PTREG_SAVE_REGS(22)
+			PTREG_SAVE_REGS(23)
+			PTREG_SAVE_REGS(24)
+			PTREG_SAVE_REGS(25)
+			PTREG_SAVE_REGS(26)
+			PTREG_SAVE_REGS(27)
+			PTREG_SAVE_REGS(28)
+			PTREG_SAVE_REGS(29)
+			PTREG_SAVE_REGS(30)
+			PTREG_SAVE_REGS(31)
+			PTREG_SAVE_REGS(32)
+			PTREG_SAVE_REGS(33)
+			PTREG_SAVE_REGS(34)
+			PTREG_SAVE_REGS(35)
+			PTREG_SAVE_REGS(36)
+			PTREG_SAVE_REGS(37)
+			PTREG_SAVE_REGS(38)
+			PTREG_SAVE_REGS(39)
+			PTREG_SAVE_REGS(40)
+			PTREG_SAVE_REGS(41)
+			PTREG_SAVE_REGS(42)
+			PTREG_SAVE_REGS(43)
+			PTREG_SAVE_REGS(44)
+			PTREG_SAVE_REGS(45)
+			PTREG_SAVE_REGS(46)
+			PTREG_SAVE_REGS(47)
+			PTREG_SAVE_REGS(48)
+			PTREG_SAVE_REGS(49)
+			PTREG_SAVE_REGS(50)
+			PTREG_SAVE_REGS(51)
+			PTREG_SAVE_REGS(52)
+			PTREG_SAVE_REGS(53)
+			PTREG_SAVE_REGS(54)
+			PTREG_SAVE_REGS(55)
+			PTREG_SAVE_REGS(56)
+			PTREG_SAVE_REGS(57)
+			PTREG_SAVE_REGS(58)
+			PTREG_SAVE_REGS(59)
+			PTREG_SAVE_REGS(60)
+			PTREG_SAVE_REGS(61)
+			PTREG_SAVE_REGS(62)
+			PTREG_SAVE_REGS(63)
+			PTREG_SAVE_TREGS(0)
+			PTREG_SAVE_TREGS(1)
+			PTREG_SAVE_TREGS(2)
+			PTREG_SAVE_TREGS(3)
+			PTREG_SAVE_TREGS(4)
+			PTREG_SAVE_TREGS(5)
+			PTREG_SAVE_TREGS(6)
+			PTREG_SAVE_TREGS(7)
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+			"mova	1f, r0\n"
+		"1:\n"
+			PTREG_SAVE(r0, pc)
+	:
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, sr, sr),
+		PTREG_OUT(regs, syscall_nr, syscall_nr),
+		PTREG_OUT_REGS(regs, 0),
+		PTREG_OUT_REGS(regs, 1),
+		PTREG_OUT_REGS(regs, 2),
+		PTREG_OUT_REGS(regs, 3),
+		PTREG_OUT_REGS(regs, 4),
+		PTREG_OUT_REGS(regs, 5),
+		PTREG_OUT_REGS(regs, 6),
+		PTREG_OUT_REGS(regs, 7),
+		PTREG_OUT_REGS(regs, 8),
+		PTREG_OUT_REGS(regs, 9),
+		PTREG_OUT_REGS(regs, 10),
+		PTREG_OUT_REGS(regs, 11),
+		PTREG_OUT_REGS(regs, 12),
+		PTREG_OUT_REGS(regs, 13),
+		PTREG_OUT_REGS(regs, 14),
+		PTREG_OUT_REGS(regs, 15),
+		PTREG_OUT_REGS(regs, 16),
+		PTREG_OUT_REGS(regs, 17),
+		PTREG_OUT_REGS(regs, 18),
+		PTREG_OUT_REGS(regs, 19),
+		PTREG_OUT_REGS(regs, 20),
+		PTREG_OUT_REGS(regs, 21),
+		PTREG_OUT_REGS(regs, 22),
+		PTREG_OUT_REGS(regs, 23),
+		PTREG_OUT_REGS(regs, 24),
+		PTREG_OUT_REGS(regs, 25),
+		PTREG_OUT_REGS(regs, 26),
+		PTREG_OUT_REGS(regs, 27),
+		PTREG_OUT_REGS(regs, 28),
+		PTREG_OUT_REGS(regs, 29),
+		PTREG_OUT_REGS(regs, 30),
+		PTREG_OUT_REGS(regs, 31),
+		PTREG_OUT_REGS(regs, 32),
+		PTREG_OUT_REGS(regs, 33),
+		PTREG_OUT_REGS(regs, 34),
+		PTREG_OUT_REGS(regs, 35),
+		PTREG_OUT_REGS(regs, 36),
+		PTREG_OUT_REGS(regs, 37),
+		PTREG_OUT_REGS(regs, 38),
+		PTREG_OUT_REGS(regs, 39),
+		PTREG_OUT_REGS(regs, 40),
+		PTREG_OUT_REGS(regs, 41),
+		PTREG_OUT_REGS(regs, 42),
+		PTREG_OUT_REGS(regs, 43),
+		PTREG_OUT_REGS(regs, 44),
+		PTREG_OUT_REGS(regs, 45),
+		PTREG_OUT_REGS(regs, 46),
+		PTREG_OUT_REGS(regs, 47),
+		PTREG_OUT_REGS(regs, 48),
+		PTREG_OUT_REGS(regs, 49),
+		PTREG_OUT_REGS(regs, 50),
+		PTREG_OUT_REGS(regs, 51),
+		PTREG_OUT_REGS(regs, 52),
+		PTREG_OUT_REGS(regs, 53),
+		PTREG_OUT_REGS(regs, 54),
+		PTREG_OUT_REGS(regs, 55),
+		PTREG_OUT_REGS(regs, 56),
+		PTREG_OUT_REGS(regs, 57),
+		PTREG_OUT_REGS(regs, 58),
+		PTREG_OUT_REGS(regs, 59),
+		PTREG_OUT_REGS(regs, 60),
+		PTREG_OUT_REGS(regs, 61),
+		PTREG_OUT_REGS(regs, 62),
+		PTREG_OUT_REGS(regs, 63),
+		PTREG_OUT_TREGS(regs, 0),
+		PTREG_OUT_TREGS(regs, 1),
+		PTREG_OUT_TREGS(regs, 2),
+		PTREG_OUT_TREGS(regs, 3),
+		PTREG_OUT_TREGS(regs, 4),
+		PTREG_OUT_TREGS(regs, 5),
+		PTREG_OUT_TREGS(regs, 6),
+		PTREG_OUT_TREGS(regs, 7)
+	:
+	:
+		"r0"
+	);
+
+	return regs;
+}
+#else
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE_REG(0)
+			PTREG_SAVE_REG(1)
+			PTREG_SAVE_REG(2)
+			PTREG_SAVE_REG(3)
+			PTREG_SAVE_REG(4)
+			PTREG_SAVE_REG(5)
+			PTREG_SAVE_REG(6)
+			PTREG_SAVE_REG(7)
+			PTREG_SAVE_REG(8)
+			PTREG_SAVE_REG(9)
+			PTREG_SAVE_REG(10)
+			PTREG_SAVE_REG(11)
+			PTREG_SAVE_REG(12)
+			PTREG_SAVE_REG(13)
+			PTREG_SAVE_REG(14)
+			PTREG_SAVE_REG(15)
+
+			"sts	pr, r0\n"
+			PTREG_SAVE(r0, pr)
+
+			"stc	sr, r0\n"
+			PTREG_SAVE(r0, sr)
+
+			"stc	gbr,r0\n"
+			PTREG_SAVE(r0, gbr)
+
+			"sts	mach, r0\n"
+			PTREG_SAVE(r0, mach)
+
+			"sts	macl, r0\n"
+			PTREG_SAVE(r0, macl)
+
+			"mova	1f, r0\n"
+			"mov.l	@r0, r0\n"
+			PTREG_SAVE(r0, tra)
+			"bra	2f\n"
+
+			".align	4\n"
+		"1:\n"
+			".long	" VAL(TRA) "\n"
+			".align 4\n"
+		"2:\n"
+
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+			"mova	1f, r0\n"
+			".align 4\n"
+		"1:\n"
+			PTREG_SAVE(r0, pc)
+	:
+		PTREG_OUT_REG(regs, 0),
+		PTREG_OUT_REG(regs, 1),
+		PTREG_OUT_REG(regs, 2),
+		PTREG_OUT_REG(regs, 3),
+		PTREG_OUT_REG(regs, 4),
+		PTREG_OUT_REG(regs, 5),
+		PTREG_OUT_REG(regs, 6),
+		PTREG_OUT_REG(regs, 7),
+		PTREG_OUT_REG(regs, 8),
+		PTREG_OUT_REG(regs, 9),
+		PTREG_OUT_REG(regs, 10),
+		PTREG_OUT_REG(regs, 11),
+		PTREG_OUT_REG(regs, 12),
+		PTREG_OUT_REG(regs, 13),
+		PTREG_OUT_REG(regs, 14),
+		PTREG_OUT_REG(regs, 15),
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, pr, pr),
+		PTREG_OUT(regs, sr, sr),
+		PTREG_OUT(regs, gbr, gbr),
+		PTREG_OUT(regs, mach, mach),
+		PTREG_OUT(regs, macl, macl),
+		PTREG_OUT(regs, tra, tra)
+	:
+	:
+		"r0"
+	);
+
+	return regs;
+}
+#endif
 #endif /* __KERNEL__ */
 
 #endif /* __ASM_SH_PTRACE_H */
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 86639be..791edcf 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -176,10 +176,10 @@ void die(const char * str, struct pt_regs * regs, long err)
 		crash_kexec(regs);
 
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 
 	if (panic_on_oops)
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 
 	do_exit(SIGSEGV);
 }
