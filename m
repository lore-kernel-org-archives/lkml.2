Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1FHBLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:11:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:48326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab1FHBLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:11:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="15280493"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 2/3] x86: Add missing asmlinkages/asmregparm
Date: Tue,  7 Jun 2011 18:10:00 -0700
Message-Id: <1307495401-2631-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Relies on the earlier patch to readd asmregparm.

This is an arch/x86 sweep to add asmlinkage or asmregparm
to all functions called by assembler code, including interrupt handlers,
syscalls and others.

I need this for a followon project that requires all functions
called by assembler to be marked in a special way.

The unmarked syscalls are marked asmregparm now. That's unusal
for syscalls -- normally they are all asmlinkage aka stack arguments.
I kept it at asmregparm to generate the same binary.

All calls with no argument are asmlinkage

All other functions that were unmarked before are asmregparm
now.

On 64bit it's all a nop currently.

I verified the patch generates the same binary as before.

I kept it all in a single patch for now. Please let me know
if you want it split up.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h   |  116 +++++++++++++++++++-------------------
 arch/x86/include/asm/irq.h      |    2 +-
 arch/x86/include/asm/kprobes.h  |    2 +-
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/include/asm/setup.h    |    6 +-
 arch/x86/include/asm/signal.h   |    2 +-
 arch/x86/include/asm/syscalls.h |   22 ++++----
 arch/x86/include/asm/system.h   |    3 +-
 arch/x86/kernel/apic/apic.c     |    6 +-
 arch/x86/kernel/head32.c        |    2 +-
 arch/x86/kernel/head64.c        |    2 +-
 arch/x86/kernel/ioport.c        |    2 +-
 arch/x86/kernel/irq.c           |    4 +-
 arch/x86/kernel/irq_work.c      |    2 +-
 arch/x86/kernel/kprobes.c       |    2 +-
 arch/x86/kernel/process.c       |   10 ++--
 arch/x86/kernel/process_32.c    |    2 +-
 arch/x86/kernel/process_64.c    |    2 +-
 arch/x86/kernel/signal.c        |    8 +-
 arch/x86/kernel/smp.c           |    6 +-
 arch/x86/kernel/syscall_64.c    |    2 +-
 arch/x86/kernel/vm86_32.c       |    3 +-
 arch/x86/mm/tlb.c               |    5 +-
 23 files changed, 106 insertions(+), 107 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..a7121a4 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -26,56 +26,56 @@
 #include <asm/sections.h>
 
 /* Interrupt handlers registered during init_IRQ */
-extern void apic_timer_interrupt(void);
-extern void x86_platform_ipi(void);
-extern void error_interrupt(void);
-extern void irq_work_interrupt(void);
-
-extern void spurious_interrupt(void);
-extern void thermal_interrupt(void);
-extern void reschedule_interrupt(void);
-extern void mce_self_interrupt(void);
-
-extern void invalidate_interrupt(void);
-extern void invalidate_interrupt0(void);
-extern void invalidate_interrupt1(void);
-extern void invalidate_interrupt2(void);
-extern void invalidate_interrupt3(void);
-extern void invalidate_interrupt4(void);
-extern void invalidate_interrupt5(void);
-extern void invalidate_interrupt6(void);
-extern void invalidate_interrupt7(void);
-extern void invalidate_interrupt8(void);
-extern void invalidate_interrupt9(void);
-extern void invalidate_interrupt10(void);
-extern void invalidate_interrupt11(void);
-extern void invalidate_interrupt12(void);
-extern void invalidate_interrupt13(void);
-extern void invalidate_interrupt14(void);
-extern void invalidate_interrupt15(void);
-extern void invalidate_interrupt16(void);
-extern void invalidate_interrupt17(void);
-extern void invalidate_interrupt18(void);
-extern void invalidate_interrupt19(void);
-extern void invalidate_interrupt20(void);
-extern void invalidate_interrupt21(void);
-extern void invalidate_interrupt22(void);
-extern void invalidate_interrupt23(void);
-extern void invalidate_interrupt24(void);
-extern void invalidate_interrupt25(void);
-extern void invalidate_interrupt26(void);
-extern void invalidate_interrupt27(void);
-extern void invalidate_interrupt28(void);
-extern void invalidate_interrupt29(void);
-extern void invalidate_interrupt30(void);
-extern void invalidate_interrupt31(void);
-
-extern void irq_move_cleanup_interrupt(void);
-extern void reboot_interrupt(void);
-extern void threshold_interrupt(void);
-
-extern void call_function_interrupt(void);
-extern void call_function_single_interrupt(void);
+asmlinkage extern void apic_timer_interrupt(void);
+asmlinkage extern void x86_platform_ipi(void);
+asmlinkage extern void error_interrupt(void);
+asmlinkage extern void irq_work_interrupt(void);
+
+asmlinkage extern void spurious_interrupt(void);
+asmlinkage extern void thermal_interrupt(void);
+asmlinkage extern void reschedule_interrupt(void);
+asmlinkage extern void mce_self_interrupt(void);
+
+asmlinkage extern void invalidate_interrupt(void);
+asmlinkage extern void invalidate_interrupt0(void);
+asmlinkage extern void invalidate_interrupt1(void);
+asmlinkage extern void invalidate_interrupt2(void);
+asmlinkage extern void invalidate_interrupt3(void);
+asmlinkage extern void invalidate_interrupt4(void);
+asmlinkage extern void invalidate_interrupt5(void);
+asmlinkage extern void invalidate_interrupt6(void);
+asmlinkage extern void invalidate_interrupt7(void);
+asmlinkage extern void invalidate_interrupt8(void);
+asmlinkage extern void invalidate_interrupt9(void);
+asmlinkage extern void invalidate_interrupt10(void);
+asmlinkage extern void invalidate_interrupt11(void);
+asmlinkage extern void invalidate_interrupt12(void);
+asmlinkage extern void invalidate_interrupt13(void);
+asmlinkage extern void invalidate_interrupt14(void);
+asmlinkage extern void invalidate_interrupt15(void);
+asmlinkage extern void invalidate_interrupt16(void);
+asmlinkage extern void invalidate_interrupt17(void);
+asmlinkage extern void invalidate_interrupt18(void);
+asmlinkage extern void invalidate_interrupt19(void);
+asmlinkage extern void invalidate_interrupt20(void);
+asmlinkage extern void invalidate_interrupt21(void);
+asmlinkage extern void invalidate_interrupt22(void);
+asmlinkage extern void invalidate_interrupt23(void);
+asmlinkage extern void invalidate_interrupt24(void);
+asmlinkage extern void invalidate_interrupt25(void);
+asmlinkage extern void invalidate_interrupt26(void);
+asmlinkage extern void invalidate_interrupt27(void);
+asmlinkage extern void invalidate_interrupt28(void);
+asmlinkage extern void invalidate_interrupt29(void);
+asmlinkage extern void invalidate_interrupt30(void);
+asmlinkage extern void invalidate_interrupt31(void);
+
+asmlinkage extern void irq_move_cleanup_interrupt(void);
+asmlinkage extern void reboot_interrupt(void);
+asmlinkage extern void threshold_interrupt(void);
+
+asmlinkage extern void call_function_interrupt(void);
+asmlinkage extern void call_function_single_interrupt(void);
 
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
@@ -144,19 +144,19 @@ extern atomic_t irq_mis_count;
 extern void eisa_set_level_irq(unsigned int irq);
 
 /* SMP */
-extern void smp_apic_timer_interrupt(struct pt_regs *);
-extern void smp_spurious_interrupt(struct pt_regs *);
-extern void smp_x86_platform_ipi(struct pt_regs *);
-extern void smp_error_interrupt(struct pt_regs *);
+extern asmregparm void smp_apic_timer_interrupt(struct pt_regs *);
+extern asmregparm void smp_spurious_interrupt(struct pt_regs *);
+extern asmregparm void smp_x86_platform_ipi(struct pt_regs *);
+extern asmregparm void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
 extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
-extern void smp_reschedule_interrupt(struct pt_regs *);
-extern void smp_call_function_interrupt(struct pt_regs *);
-extern void smp_call_function_single_interrupt(struct pt_regs *);
+extern asmregparm void smp_reschedule_interrupt(struct pt_regs *);
+extern asmregparm void smp_call_function_interrupt(struct pt_regs *);
+extern asmregparm void smp_call_function_single_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_32
-extern void smp_invalidate_interrupt(struct pt_regs *);
+extern asmregparm void smp_invalidate_interrupt(struct pt_regs *);
 #else
 extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..a027dc5 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -33,7 +33,7 @@ extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
-extern unsigned int do_IRQ(struct pt_regs *regs);
+extern asmregparm unsigned int do_IRQ(struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 2b3ccf7..fa2d12e 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -61,7 +61,7 @@ extern __visible kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-void kretprobe_trampoline(void);
+asmlinkage void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ebbc4d8..74c752f 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -829,7 +829,7 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
  * functions.
  */
 #define PV_CALLEE_SAVE_REGS_THUNK(func)					\
-	extern typeof(func) __raw_callee_save_##func;			\
+	extern asmregparm typeof(func) __raw_callee_save_##func;			\
 	static void *__##func##__ __used = func;			\
 									\
 	asm(".pushsection .text;"					\
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9756551..c4daddc 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -107,11 +107,11 @@ void *extend_brk(size_t size, size_t align);
 extern void probe_roms(void);
 #ifdef __i386__
 
-void __init i386_start_kernel(void);
+asmlinkage void __init i386_start_kernel(void);
 
 #else
-void __init x86_64_start_kernel(char *real_mode);
-void __init x86_64_start_reservations(char *real_mode_data);
+asmlinkage void __init x86_64_start_kernel(char *real_mode);
+asmlinkage void __init x86_64_start_reservations(char *real_mode_data);
 
 #endif /* __i386__ */
 #endif /* _SETUP */
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..a687c37 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -122,7 +122,7 @@ typedef unsigned long sigset_t;
 #ifndef __ASSEMBLY__
 
 # ifdef __KERNEL__
-extern void do_notify_resume(struct pt_regs *, void *, __u32);
+extern asmregparm void do_notify_resume(struct pt_regs *, void *, __u32);
 # endif /* __KERNEL__ */
 
 #ifdef __i386__
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index f1d8b44..d3c9ebe 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,23 +18,23 @@
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
-long sys_iopl(unsigned int, struct pt_regs *);
+asmregparm long sys_iopl(unsigned int, struct pt_regs *);
 
 /* kernel/process.c */
-int sys_fork(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
-long sys_execve(const char __user *,
+asmregparm int sys_fork(struct pt_regs *);
+asmregparm int sys_vfork(struct pt_regs *);
+asmregparm long sys_execve(const char __user *,
 		const char __user *const __user *,
 		const char __user *const __user *, struct pt_regs *);
-long sys_clone(unsigned long, unsigned long, void __user *,
+asmregparm long sys_clone(unsigned long, unsigned long, void __user *,
 	       void __user *, struct pt_regs *);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
 /* kernel/signal.c */
-long sys_rt_sigreturn(struct pt_regs *);
-long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+asmregparm long sys_rt_sigreturn(struct pt_regs *);
+asmregparm long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 		     struct pt_regs *);
 
 
@@ -49,17 +49,17 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-unsigned long sys_sigreturn(struct pt_regs *);
+asmregparm unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/vm86_32.c */
-int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
-int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
+asmregparm int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
+asmregparm int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
 
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
 /* kernel/process_64.c */
-long sys_arch_prctl(int, unsigned long);
+asmlinkage long sys_arch_prctl(int, unsigned long);
 
 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c2ff2a1..8358217 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -18,6 +18,7 @@
 #endif
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
+asmregparm
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 struct tss_struct;
@@ -148,7 +149,7 @@ do {									\
 
 #ifdef __KERNEL__
 
-extern void native_load_gs_index(unsigned);
+extern asmlinkage void native_load_gs_index(unsigned);
 
 /*
  * Load a segment. Fall back on loading the zero
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..6a8f8aa 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -841,7 +841,7 @@ static void local_apic_timer_interrupt(void)
  * [ if a single-CPU system runs an SMP kernel then we call the local
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
-void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
+asmregparm void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -1785,7 +1785,7 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-void smp_spurious_interrupt(struct pt_regs *regs)
+asmregparm void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
@@ -1811,7 +1811,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-void smp_error_interrupt(struct pt_regs *regs)
+asmregparm void smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v0, v1;
 	u32 i = 0;
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3bb0850..6647d53 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,7 +29,7 @@ static void __init i386_default_early_setup(void)
 	reserve_ebda_region();
 }
 
-void __init i386_start_kernel(void)
+asmlinkage void __init i386_start_kernel(void)
 {
 	memblock_init();
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5655c22..512dcf3 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -53,7 +53,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8c96897..5345f97 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -93,7 +93,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-long sys_iopl(unsigned int level, struct pt_regs *regs)
+asmregparm long sys_iopl(unsigned int level, struct pt_regs *regs)
 {
 	unsigned int old = (regs->flags >> 12) & 3;
 	struct thread_struct *t = &current->thread;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..b46ee95 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -172,7 +172,7 @@ u64 arch_irq_stat(void)
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
+asmregparm unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -202,7 +202,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 /*
  * Handler for X86_PLATFORM_IPI_VECTOR.
  */
-void smp_x86_platform_ipi(struct pt_regs *regs)
+asmregparm void smp_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..011ef48 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -9,7 +9,7 @@
 #include <linux/hardirq.h>
 #include <asm/apic.h>
 
-void smp_irq_work_interrupt(struct pt_regs *regs)
+asmregparm void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 63de894..f4141cf 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -696,7 +696,7 @@ asm(
 /*
  * Called from kretprobe_trampoline
  */
-static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+asmregparm __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2e4928d..b8bb4c3 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -232,7 +232,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	propagate_user_return_notify(prev_p, next_p);
 }
 
-int sys_fork(struct pt_regs *regs)
+asmregparm int sys_fork(struct pt_regs *regs)
 {
 	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
@@ -247,13 +247,13 @@ int sys_fork(struct pt_regs *regs)
  * do not have enough call-clobbered registers to hold all
  * the information you need.
  */
-int sys_vfork(struct pt_regs *regs)
+asmregparm int sys_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
 		       NULL, NULL);
 }
 
-long
+asmregparm long
 sys_clone(unsigned long clone_flags, unsigned long newsp,
 	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
 {
@@ -267,7 +267,7 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
  * function to call, and %di containing
  * the "args".
  */
-extern void kernel_thread_helper(void);
+asmregparm extern void kernel_thread_helper(void);
 
 /*
  * Create a kernel thread
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(kernel_thread);
 /*
  * sys_execve() executes a new program.
  */
-long sys_execve(const char __user *name,
+asmregparm long sys_execve(const char __user *name,
 		const char __user *const __user *argv,
 		const char __user *const __user *envp, struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..bdfa8c6 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(start_thread);
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-__notrace_funcgraph struct task_struct *
+asmregparm __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d10b887..7ded2c7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -370,7 +370,7 @@ void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
  * Kprobes not supported here. Set the probe on schedule instead.
  * Function graph tracer not supported too.
  */
-__notrace_funcgraph struct task_struct *
+asmregparm __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40a2493..b304743 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -545,7 +545,7 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 }
 #endif /* CONFIG_X86_32 */
 
-long
+asmregparm long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
@@ -556,7 +556,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-unsigned long sys_sigreturn(struct pt_regs *regs)
+asmregparm unsigned long sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long ax;
@@ -588,7 +588,7 @@ badframe:
 }
 #endif /* CONFIG_X86_32 */
 
-long sys_rt_sigreturn(struct pt_regs *regs)
+asmregparm long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
@@ -831,7 +831,7 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void
+asmregparm void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 013e7eb..bfcb964 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -196,7 +196,7 @@ static void native_stop_other_cpus(int wait)
 /*
  * Reschedule call back.
  */
-void smp_reschedule_interrupt(struct pt_regs *regs)
+asmregparm void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
@@ -206,7 +206,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
-void smp_call_function_interrupt(struct pt_regs *regs)
+asmregparm void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
@@ -215,7 +215,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
+asmregparm void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index de87d60..a576626 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -19,7 +19,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	*Smells like a like a compiler bug -- it doesn't work
 	*when the & below is removed.
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 863f875..431060f 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -198,7 +198,7 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
+asmregparm int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -227,6 +227,7 @@ out:
 }
 
 
+asmregparm
 int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..4a9194e 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -124,10 +124,7 @@ EXPORT_SYMBOL_GPL(leave_mm);
  * entry calls in with the first parameter in %eax.  Maybe define
  * intrlinkage?
  */
-#ifdef CONFIG_X86_64
-asmlinkage
-#endif
-void smp_invalidate_interrupt(struct pt_regs *regs)
+asmregparm void smp_invalidate_interrupt(struct pt_regs *regs)
 {
 	unsigned int cpu;
 	unsigned int sender;
-- 
1.7.4.4

