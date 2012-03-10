Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2CJRsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 12:48:39 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37007 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2CJRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 12:48:33 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Mar 2012 23:15:45 +0530
Message-Id: <20120310174545.19949.62868.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
References: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 4/7] x86/trivial: rename trap_no to trap_nr in thread struct.
x-cbid: 12031007-5490-0000-0000-000000EAFF28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

There are precedences of trap number being referred to as trap_nr.
However thread struct refers trap number as trap_no. Change it to trap_nr.

This is pure cleanup, no functional change intended.

Suggested-by: Ingo Molnar <mingo@eltu.hu>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32_signal.c      |    2 +-
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/dumpstack.c      |    2 +-
 arch/x86/kernel/ptrace.c         |    2 +-
 arch/x86/kernel/signal.c         |    2 +-
 arch/x86/kernel/traps.c          |   16 ++++++++--------
 arch/x86/kernel/vm86_32.c        |    2 +-
 arch/x86/kernel/vsyscall_64.c    |    2 +-
 arch/x86/math-emu/fpu_entry.c    |    4 ++--
 arch/x86/mm/fault.c              |   10 +++++-----
 10 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 7d4dba9..135cd12 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -346,7 +346,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 		put_user_ex(regs->dx, &sc->dx);
 		put_user_ex(regs->cx, &sc->cx);
 		put_user_ex(regs->ax, &sc->ax);
-		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.trap_nr, &sc->trapno);
 		put_user_ex(current->thread.error_code, &sc->err);
 		put_user_ex(regs->ip, &sc->ip);
 		put_user_ex(regs->cs, (unsigned int __user *)&sc->cs);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c59ff02..09ffc86 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -454,7 +454,7 @@ struct thread_struct {
 	unsigned long           ptrace_dr7;
 	/* Fault info: */
 	unsigned long		cr2;
-	unsigned long		trap_no;
+	unsigned long		trap_nr;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
 	struct fpu		fpu;
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4025fe4..28f9870 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -265,7 +265,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #endif
 	printk("\n");
 	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
 	show_registers(regs);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d14b3cd..f6f4c5d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1426,7 +1426,7 @@ static void fill_sigtrap_info(struct task_struct *tsk,
 				int error_code, int si_code,
 				struct siginfo *info)
 {
-	tsk->thread.trap_no = 1;
+	tsk->thread.trap_nr = 1;
 	tsk->thread.error_code = error_code;
 
 	memset(info, 0, sizeof(*info));
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 5134e17..115eac4 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -151,7 +151,7 @@ int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		put_user_ex(regs->r15, &sc->r15);
 #endif /* CONFIG_X86_64 */
 
-		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.trap_nr, &sc->trapno);
 		put_user_ex(current->thread.error_code, &sc->err);
 		put_user_ex(regs->ip, &sc->ip);
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ec61d4c..d47ed32 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -133,7 +133,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 trap_signal:
 #endif
 	/*
-	 * We want error_code and trap_no set for userspace faults and
+	 * We want error_code and trap_nr set for userspace faults and
 	 * kernelspace faults which result in die(), but not
 	 * kernelspace faults which are fixed up.  die() gives the
 	 * process no chance to handle the signal and notice the
@@ -142,7 +142,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	 * delivered, faults.  See also do_general_protection below.
 	 */
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
+	tsk->thread.trap_nr = trapnr;
 
 #ifdef CONFIG_X86_64
 	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
@@ -165,7 +165,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 kernel_trap:
 	if (!fixup_exception(regs)) {
 		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = trapnr;
+		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
 	}
 	return;
@@ -237,7 +237,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
+	tsk->thread.trap_nr = 8;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -265,7 +265,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_nr = 13;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -292,7 +292,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_nr = 13;
 	if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 		return;
@@ -471,7 +471,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	{
 		if (!fixup_exception(regs)) {
 			task->thread.error_code = error_code;
-			task->thread.trap_no = trapnr;
+			task->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
 		}
 		return;
@@ -481,7 +481,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	 * Save the info for the exception handler and clear the error.
 	 */
 	save_init_fpu(task);
-	task->thread.trap_no = trapnr;
+	task->thread.trap_nr = trapnr;
 	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index b466cab..a1315ab 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -567,7 +567,7 @@ int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
 	}
 	if (trapno != 1)
 		return 1; /* we let this handle by the calling routine */
-	current->thread.trap_no = trapno;
+	current->thread.trap_nr = trapno;
 	current->thread.error_code = error_code;
 	force_sig(SIGTRAP, current);
 	return 0;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b07ba93..db9b6db 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -153,7 +153,7 @@ static bool write_ok_or_segv(unsigned long ptr, size_t size)
 
 		thread->error_code	= 6;  /* user fault, no page, write */
 		thread->cr2		= ptr;
-		thread->trap_no		= 14;
+		thread->trap_nr		= 14;
 
 		memset(&info, 0, sizeof(info));
 		info.si_signo		= SIGSEGV;
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 7718541..f600d8b 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -269,7 +269,7 @@ void math_emulate(struct math_emu_info *info)
 			FPU_EIP = FPU_ORIG_EIP;	/* Point to current FPU instruction. */
 
 			RE_ENTRANT_CHECK_OFF;
-			current->thread.trap_no = 16;
+			current->thread.trap_nr = 16;
 			current->thread.error_code = 0;
 			send_sig(SIGFPE, current, 1);
 			return;
@@ -662,7 +662,7 @@ static int valid_prefix(u_char *Byte, u_char __user **fpu_eip,
 void math_abort(struct math_emu_info *info, unsigned int signal)
 {
 	FPU_EIP = FPU_ORIG_EIP;
-	current->thread.trap_no = 16;
+	current->thread.trap_nr = 16;
 	current->thread.error_code = 0;
 	send_sig(signal, current, 1);
 	RE_ENTRANT_CHECK_OFF;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0b4caf..c0e3391 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -615,7 +615,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 	dump_pagetable(address);
 
 	tsk->thread.cr2		= address;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= 14;
 	tsk->thread.error_code	= error_code;
 
 	if (__die("Bad pagetable", regs, error_code))
@@ -636,7 +636,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs)) {
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
-			tsk->thread.trap_no = 14;
+			tsk->thread.trap_nr = 14;
 			tsk->thread.error_code = error_code | PF_USER;
 			tsk->thread.cr2 = address;
 
@@ -676,7 +676,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= 14;
 	tsk->thread.error_code	= error_code;
 
 	sig = SIGKILL;
@@ -754,7 +754,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		/* Kernel addresses are always protection faults: */
 		tsk->thread.cr2		= address;
 		tsk->thread.error_code	= error_code | (address >= TASK_SIZE);
-		tsk->thread.trap_no	= 14;
+		tsk->thread.trap_nr	= 14;
 
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk, 0);
 
@@ -838,7 +838,7 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	tsk->thread.cr2		= address;
 	tsk->thread.error_code	= error_code;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= 14;
 
 #ifdef CONFIG_MEMORY_FAILURE
 	if (fault & (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE)) {


