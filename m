Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1FESEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:04:16 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:45921 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396Ab1FESC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:56 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-c8-4debc4c1d1e1
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 2/9] x86-64: Document some of entry_64.S
Date: Sun,  5 Jun 2011 13:50:18 -0400
Message-Id: <fc134867cc550977cc996866129e11a16ba0f9ea.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3VSa0hTcRT3v93dXYc3b1fLv1YaozItLbMP/0gs7Mv/Q4MoMJCkbu7qRnux
	OysNQogkLcwgIzVIpbJsNJuGGlTbXPnIV/koRLOy59J8jNAys11F+9S3c87vxeEcSsp+koVR
	WoOFNxs4nZJUEKw8MTLG6f6m2vruRSy6ZrOSqKDnqRy5+6bkqKSPRt7qPyRqd0Hk+PWRRGO9
	dSTqfniNRPUDPST6cOYVQLUvz8jQsPWzFI1fqiZRjb1Iit4XjMrRy7FxAk1XD8t2s3jqbAGB
	n7U1Atyf+1uKrzdMAHzj3LQcN5QMynHN7Wg899VN4ksjrwG2V+WR+HtHhxw3X50hcFPbHuy1
	h2NX3Qi5LzBFkaDmddrjvHlL4hGF5mJfIWlq33DyVm4OmQPuReQDfwoy22FleaVsoV4Ju97Y
	yHygoFjmMYBDL1rAQmMDsH9yhlhoPkrga0cxECUksw6eu/lWkg8oKpjZAnu98wIpc10G7c/P
	EyIniNkJH7nL5yMIZj3stU5JxJpm9sPW4UqpqIXMWthZZRTH/sxW2PWqfZ7O+ixdoy3k/+aF
	gCkDflVgjVqfHaPntDqBT4sR0jiDgTfHxMfqtZZYXp1pB+Lx/EOX1YMfTqULMBRQBtC07ZuK
	lXHHhSy9C4RSEuUKuqzRN1p21KjO0nCC5rA5U8cLLgApqTKYPh3sUbG0msvK5s3GRWgVRShD
	6OLQSBXLZHAW/hjPm3jzIrqaopSQHhJNl5v5DP5kulZn+QdLKH/RPMBnPityaMHE6QVtxgLe
	CuIpV4vHCagHzaNOwBIGo4EPC6E9IpURqZpMw5Lb4nt6QIhvuSC6XWQF+J53yc/ji5L4opqS
	xD0EC/cPCssB9oODcXcDL3fjzfUpURGzjrmxHVeCzpaGc03W3CdhyZ1ffm0PrWy803wi2pAq
	P5R2oLRmE13uV56Q3F32sxbvTCjcJjNFqCo2TtRF3ndqkvbm+RVZ3F+9/T2pa8K7FNEzKbMO
	6oJiIOjUrkNWbTaePLIh6nBNanHF+YaR4Yz02gElIWi4uGipWeD+AkKYH4N5AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/x86/entry_64.txt |   98 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S     |    2 +
 2 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/entry_64.txt

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
new file mode 100644
index 0000000..7869f14
--- /dev/null
+++ b/Documentation/x86/entry_64.txt
@@ -0,0 +1,98 @@
+This file documents some of the kernel entries in
+arch/x86/kernel/entry_64.S.  A lot of this explanation is adapted from
+an email from Ingo Molnar:
+
+http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
+
+The x86 architecture has quite a few different ways to jump into
+kernel code.  Most of these entry points are registered in
+arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
+and arch/x86/ia32/ia32entry.S.
+
+The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+
+Some of these entries are:
+
+ - system_call: syscall instruction from 64-bit code.
+
+ - ia32_syscall: int 0x80 from 32-bit or 64-bit code; compat syscall
+   either way.
+
+ - ia32_syscall, ia32_sysenter: syscall and sysenter from 32-bit
+   code
+
+ - interrupt: An array of entries.  Every IDT vector that doesn't
+   explicitly point somewhere else gets set to the corresponding
+   value in interrupts.  These point to a whole array of
+   magically-generated functions that make their way to do_IRQ with
+   the interrupt number as a parameter.
+
+ - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
+   vsyscall emulation.
+
+ - APIC interrupts: Various special-purpose interrupts for things
+   like TLB shootdown.
+
+ - Architecturally-defined exceptions like divide_error.
+
+There are a few complexities here.  The different x86-64 entries
+have different calling conventions.  The syscall and sysenter
+instructions have their own peculiar calling conventions.  Some of
+the IDT entries push an error code onto the stack; others don't.
+IDT entries using the IST alternative stack mechanism need their own
+magic to get the stack frames right.  (You can find some
+documentation in the AMD APM, Volume 2, Chapter 8 and the Intel SDM,
+Volume 3, Chapter 6.)
+
+Dealing with the swapgs instruction is especially tricky.  Swapgs
+toggles whether gs is the kernel gs or the user gs.  The swapgs
+instruction is rather fragile: it must nest perfectly and only in
+single depth, it should only be used if entering from user mode to
+kernel mode and then when returning to user-space, and precisely
+so. If we mess that up even slightly, we crash.
+
+So when we have a secondary entry, already in kernel mode, we *must
+not* use SWAPGS blindly - nor must we forget doing a SWAPGS when it's
+not switched/swapped yet.
+
+Now, there's a secondary complication: there's a cheap way to test
+which mode the CPU is in and an expensive way.
+
+The cheap way is to pick this info off the entry frame on the kernel
+stack, from the CS of the ptregs area of the kernel stack:
+
+	xorl %ebx,%ebx
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
+	SWAPGS
+
+The expensive (paranoid) way is to read back the MSR_GS_BASE value
+(which is what SWAPGS modifies):
+
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f   /* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+
+and the whole paranoid non-paranoid macro complexity is about whether
+to suffer that RDMSR cost.
+
+If we are at an interrupt or user-trap/gate-alike boundary then we can
+use the faster check: the stack will be a reliable indicator of
+whether SWAPGS was already done: if we see that we are a secondary
+entry interrupting kernel mode execution, then we know that the GS
+base has already been switched. If it says that we interrupted
+user-space execution then we must do the SWAPGS.
+
+But if we are in an NMI/MCE/DEBUG/whatever super-atomic entry context,
+which might have triggered right after a normal entry wrote CS to the
+stack but before we executed SWAPGS, then the only safe way to check
+for GS is the slower method: the RDMSR.
+
+So we try only to mark those entry methods 'paranoid' that absolutely
+need the more expensive check for the GS base - and we generate all
+'normal' entry points with the regular (faster) entry macros.
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..72c4a77 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -9,6 +9,8 @@
 /*
  * entry.S contains the system-call and fault low-level handling routines.
  *
+ * Some of this is documented in Documentation/x86/entry_64.txt
+ *
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
  *
-- 
1.7.5.2

