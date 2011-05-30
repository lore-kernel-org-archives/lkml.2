Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1E3DuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:50:07 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:43323 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269Ab1E3Dtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:53 -0400
X-AuditID: 12074424-b7bc6ae000005a77-8b-4de313e1d97a
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 10/10] x86-64: Document some of entry_64.S
Date: Sun, 29 May 2011 23:48:47 -0400
Message-Id: <dbaa4069dec9bae213e136ff6e045236b3396b87.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsUixCmqrPtQ+LGvwZQObos569ewWfRdOcpu
	Mesar8XnDf/YLA78espm8f7qdjaLy7vmsFk8ab7OaLHlUjOrxYeJG9gsNm+aymzxqO8tu8WP
	DY9ZHXg9vrf2sXgcO3OY0eNW2x9mj52z7rJ7bF6h5fH/5RE2j02rOtk83p07x+5xYsZvFo/j
	Z5w9Pm+SC+CO4rJJSc3JLEst0rdL4Mo4tPoCW0GjWsXvU8dYGhg/ynUxcnJICJhIbF+0gR3C
	FpO4cG89WxcjF4eQwD5GiUnnLjJCOBsYJRra5kM5z5gkbm57zAbSwiagItGx9AFTFyMHh4iA
	vsTVz2A1zALPmSUePNzFClIjLGArsWTzarAVLAKqEneXHAaL8woESfR/7GOFWK0gceXKPBYQ
	m1PAQOLknXtgthDQzHm33rLhEp/AKLCAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqRrrlebmaJ
	XmpK6SZGUIywu6jsYGw+pHSIUYCDUYmH16zoka8Qa2JZcWXuIUZJDiYlUd5Hgo99hfiS8lMq
	MxKLM+KLSnNSiw8xSnAwK4nwqv8CKudNSaysSi3Kh0lJc7AoifPOk1T3FRJITyxJzU5NLUgt
	gsnKcHAoSfA+EAIaKliUmp5akZaZU4KQZuLgBBnOAzRcH2Qxb3FBYm5xZjpE/hSjMcf1tVsP
	MnI0rt1xkFGIJS8/L1VKnPcOyDgBkNKM0jy4abA094pRHOg5Yd4rIFU8wBQJN+8V0ComoFW9
	7x6CrCpJREhJNTD6Ou7/uS4gYJl4TbPjq/K7n44ZxW3iPrzeu+NqcfoOmZivYat/iwtcsw/0
	93l272B4b94dTuZIT85dc1ad7clnEuvZ7DKbJyM+SfPe2tsds3luLb7wf/ZnfqaSiIPd4s7+
	1fIMcTu/3v7gPXMCU4treqT+9iXfZlSJcpWGqGifuWl/+IbIeyclluKMREMt5qLiRAA6E3Qu
	TgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/x86/entry_64.txt |   95 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S     |    2 +
 2 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/entry_64.txt

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
new file mode 100644
index 0000000..081c405
--- /dev/null
+++ b/Documentation/x86/entry_64.txt
@@ -0,0 +1,95 @@
+This file documents some of the kernel entries in
+arch/x86/kernel/entry_64.S.  A lot of this explanation is adapted from
+an email from Ingo Molnar:
+
+http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
+
+The x86 architecture has quite a few different ways to jump into
+kernel code.  Most of these entry points are registered in
+arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S.
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
+ - ia32_syscall, ia32_sysenter: syscall and sysenter from 32-bit code
+
+ - interrupt: An array of entries.  Every IDT vector that doesn't
+   explicitly point somewhere else gets set to the corresponding value
+   in interrupts.  These point to a whole array of magically-generated
+   functions that make their way to do_IRQ with the interrupt number
+   as a parameter.
+
+ - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
+   vsyscall emulation.
+
+ - APIC interrupts: Various special-purpose interrupts for things like
+   TLB shootdown.
+
+ - Architecturally-defined exceptions like divide_error.
+
+There are a few complexities here.  The different x86-64 entries have
+different calling conventions.  The syscall and sysenter instructions
+have their own peculiar calling conventions.  Some of the IDT entries
+push an error code onto the stack; others don't.  IDT entries using
+the IST alternative stack mechanism need their own magic to get the
+stack frames right.  (You can find some documentation in the Intel
+SDM, Volume 3, Chapter 6.)
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
index bee7e81..e949793 100644
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
1.7.5.1

