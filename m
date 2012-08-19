Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2HSC64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:59858 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2HSC53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="135817668"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/74] x86, lto: Add missing asmlinkages and __visible
Date: Sat, 18 Aug 2012 19:56:15 -0700
Message-Id: <1345345030-22211-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is an arch/x86 sweep to add asmlinkage or __visible
to all functions accessed by assembler code. A lot of
functions already had it, but not all.

This is needed for the LTO kernel so that these functions are
not optimized away.

I used asmlinkage for functions without arguments, and __visible
for functions with. This prevents any problems on x86-32 with
asmlinkage changing the calling convention to regparm(0)

I kept it all in a single patch for now. Please let me know
if you want it split up.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h           |  118 +++++++++++++++----------------
 arch/x86/include/asm/irq.h              |    2 +-
 arch/x86/include/asm/kprobes.h          |    2 +-
 arch/x86/include/asm/setup.h            |    8 ++-
 arch/x86/include/asm/signal.h           |    2 +-
 arch/x86/include/asm/switch_to.h        |    4 +-
 arch/x86/include/asm/syscalls.h         |   22 +++---
 arch/x86/kernel/apic/apic.c             |    6 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    1 +
 arch/x86/kernel/head32.c                |    2 +-
 arch/x86/kernel/head64.c                |    2 +-
 arch/x86/kernel/ioport.c                |    2 +-
 arch/x86/kernel/irq.c                   |    4 +-
 arch/x86/kernel/irq_work.c              |    2 +-
 arch/x86/kernel/kprobes.c               |    2 +-
 arch/x86/kernel/machine_kexec_32.c      |    2 +-
 arch/x86/kernel/process.c               |   10 ++--
 arch/x86/kernel/process_32.c            |    2 +-
 arch/x86/kernel/process_64.c            |    2 +-
 arch/x86/kernel/signal.c                |    8 +-
 arch/x86/kernel/smp.c                   |    6 +-
 arch/x86/kernel/syscall_64.c            |    2 +-
 arch/x86/kernel/vm86_32.c               |    3 +-
 arch/x86/lib/usercopy_64.c              |    2 +-
 24 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..a7cd10e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -26,55 +26,55 @@
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
+extern asmlinkage void apic_timer_interrupt(void);
+extern asmlinkage void x86_platform_ipi(void);
+extern asmlinkage void error_interrupt(void);
+extern asmlinkage void irq_work_interrupt(void);
+
+extern asmlinkage void spurious_interrupt(void);
+extern asmlinkage void thermal_interrupt(void);
+extern asmlinkage void reschedule_interrupt(void);
+
+extern asmlinkage void invalidate_interrupt(void);
+extern asmlinkage void invalidate_interrupt0(void);
+extern asmlinkage void invalidate_interrupt1(void);
+extern asmlinkage void invalidate_interrupt2(void);
+extern asmlinkage void invalidate_interrupt3(void);
+extern asmlinkage void invalidate_interrupt4(void);
+extern asmlinkage void invalidate_interrupt5(void);
+extern asmlinkage void invalidate_interrupt6(void);
+extern asmlinkage void invalidate_interrupt7(void);
+extern asmlinkage void invalidate_interrupt8(void);
+extern asmlinkage void invalidate_interrupt9(void);
+extern asmlinkage asmlinkage void invalidate_interrupt10(void);
+extern asmlinkage void invalidate_interrupt11(void);
+extern asmlinkage void invalidate_interrupt12(void);
+extern asmlinkage void invalidate_interrupt13(void);
+extern asmlinkage void invalidate_interrupt14(void);
+extern asmlinkage void invalidate_interrupt15(void);
+extern asmlinkage void invalidate_interrupt16(void);
+extern asmlinkage void invalidate_interrupt17(void);
+extern asmlinkage void invalidate_interrupt18(void);
+extern asmlinkage void invalidate_interrupt19(void);
+extern asmlinkage void invalidate_interrupt20(void);
+extern asmlinkage void invalidate_interrupt21(void);
+extern asmlinkage void invalidate_interrupt22(void);
+extern asmlinkage void invalidate_interrupt23(void);
+extern asmlinkage void invalidate_interrupt24(void);
+extern asmlinkage void invalidate_interrupt25(void);
+extern asmlinkage void invalidate_interrupt26(void);
+extern asmlinkage void invalidate_interrupt27(void);
+extern asmlinkage void invalidate_interrupt28(void);
+extern asmlinkage void invalidate_interrupt29(void);
+extern asmlinkage void invalidate_interrupt30(void);
+extern asmlinkage void invalidate_interrupt31(void);
+
+extern asmlinkage void irq_move_cleanup_interrupt(void);
+extern asmlinkage void reboot_interrupt(void);
+extern asmlinkage void threshold_interrupt(void);
+
+extern asmlinkage void call_function_interrupt(void);
+extern asmlinkage void call_function_single_interrupt(void);
 
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
@@ -143,22 +143,18 @@ extern atomic_t irq_mis_count;
 extern void eisa_set_level_irq(unsigned int irq);
 
 /* SMP */
-extern void smp_apic_timer_interrupt(struct pt_regs *);
-extern void smp_spurious_interrupt(struct pt_regs *);
-extern void smp_x86_platform_ipi(struct pt_regs *);
-extern void smp_error_interrupt(struct pt_regs *);
+extern __visible void smp_apic_timer_interrupt(struct pt_regs *);
+extern __visible void smp_spurious_interrupt(struct pt_regs *);
+extern __visible void smp_x86_platform_ipi(struct pt_regs *);
+extern __visible void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
 extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
-extern void smp_reschedule_interrupt(struct pt_regs *);
-extern void smp_call_function_interrupt(struct pt_regs *);
-extern void smp_call_function_single_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_32
-extern void smp_invalidate_interrupt(struct pt_regs *);
-#else
-extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
-#endif
+extern __visible void smp_reschedule_interrupt(struct pt_regs *);
+extern __visible void smp_call_function_interrupt(struct pt_regs *);
+extern __visible void smp_call_function_single_interrupt(struct pt_regs *);
+extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..c996357 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -33,7 +33,7 @@ extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
-extern unsigned int do_IRQ(struct pt_regs *regs);
+extern __visible unsigned int do_IRQ(struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..a967173 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -61,7 +61,7 @@ extern kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-void kretprobe_trampoline(void);
+asmlinkage void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index d0f19f9..4575ffb 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -5,6 +5,8 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#include <linux/linkage.h>
+
 #ifdef __i386__
 
 #include <linux/pfn.h>
@@ -107,11 +109,11 @@ void *extend_brk(size_t size, size_t align);
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
index 598457c..4937d72 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -122,7 +122,7 @@ typedef unsigned long sigset_t;
 #ifndef __ASSEMBLY__
 
 # ifdef __KERNEL__
-extern void do_notify_resume(struct pt_regs *, void *, __u32);
+extern __visible void do_notify_resume(struct pt_regs *, void *, __u32);
 # endif /* __KERNEL__ */
 
 #ifdef __i386__
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 4ec45b3..a7ad95a 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -2,8 +2,8 @@
 #define _ASM_X86_SWITCH_TO_H
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
-struct task_struct *__switch_to(struct task_struct *prev,
-				struct task_struct *next);
+__visible struct task_struct *__switch_to(struct task_struct *prev,
+	 				   struct task_struct *next);
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index f1d8b44..de299c8 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,23 +18,23 @@
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
-long sys_iopl(unsigned int, struct pt_regs *);
+__visible long sys_iopl(unsigned int, struct pt_regs *);
 
 /* kernel/process.c */
-int sys_fork(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
-long sys_execve(const char __user *,
+__visible int sys_fork(struct pt_regs *);
+__visible int sys_vfork(struct pt_regs *);
+__visible long sys_execve(const char __user *,
 		const char __user *const __user *,
 		const char __user *const __user *, struct pt_regs *);
-long sys_clone(unsigned long, unsigned long, void __user *,
+__visible long sys_clone(unsigned long, unsigned long, void __user *,
 	       void __user *, struct pt_regs *);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
 /* kernel/signal.c */
-long sys_rt_sigreturn(struct pt_regs *);
-long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+__visible long sys_rt_sigreturn(struct pt_regs *);
+__visible long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 		     struct pt_regs *);
 
 
@@ -49,17 +49,17 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-unsigned long sys_sigreturn(struct pt_regs *);
+__visible unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/vm86_32.c */
-int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
-int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
+__visible int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
+__visible int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
 
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
 /* kernel/process_64.c */
-long sys_arch_prctl(int, unsigned long);
+asmlinkage long sys_arch_prctl(int, unsigned long);
 
 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..71f1284 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -879,7 +879,7 @@ static void local_apic_timer_interrupt(void)
  * [ if a single-CPU system runs an SMP kernel then we call the local
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
-void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
+__visible void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -1875,7 +1875,7 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-void smp_spurious_interrupt(struct pt_regs *regs)
+__visible void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
@@ -1901,7 +1901,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-void smp_error_interrupt(struct pt_regs *regs)
+__visible void smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v0, v1;
 	u32 i = 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index fc4beb3..ccfcf1c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -27,6 +27,7 @@
 #include <asm/mce.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
+#include <asm/traps.h>
 
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index c18f59d..1b04fb8 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -28,7 +28,7 @@ static void __init i386_default_early_setup(void)
 	reserve_ebda_region();
 }
 
-void __init i386_start_kernel(void)
+asmlinkage void __init i386_start_kernel(void)
 {
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..ded14c3 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -52,7 +52,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8c96897..e828193 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -93,7 +93,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-long sys_iopl(unsigned int level, struct pt_regs *regs)
+__visible long sys_iopl(unsigned int level, struct pt_regs *regs)
 {
 	unsigned int old = (regs->flags >> 12) & 3;
 	struct thread_struct *t = &current->thread;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7ad683d..69c4ace 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -178,7 +178,7 @@ u64 arch_irq_stat(void)
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
+__visible unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -208,7 +208,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 /*
  * Handler for X86_PLATFORM_IPI_VECTOR.
  */
-void smp_x86_platform_ipi(struct pt_regs *regs)
+__visible void smp_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..f95694b 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -9,7 +9,7 @@
 #include <linux/hardirq.h>
 #include <asm/apic.h>
 
-void smp_irq_work_interrupt(struct pt_regs *regs)
+__visible void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e2f751e..86d828b 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -647,7 +647,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 5b19e4d..7048960 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -184,7 +184,7 @@ void machine_kexec(struct kimage *image)
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 	int save_ftrace_enabled;
-	asmlinkage unsigned long
+	unsigned long
 		(*relocate_kernel_ptr)(unsigned long indirection_page,
 				       unsigned long control_page,
 				       unsigned long start_address,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ef6a845..0d099ca3 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -268,7 +268,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	propagate_user_return_notify(prev_p, next_p);
 }
 
-int sys_fork(struct pt_regs *regs)
+__visible int sys_fork(struct pt_regs *regs)
 {
 	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
@@ -283,13 +283,13 @@ int sys_fork(struct pt_regs *regs)
  * do not have enough call-clobbered registers to hold all
  * the information you need.
  */
-int sys_vfork(struct pt_regs *regs)
+__visible int sys_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
 		       NULL, NULL);
 }
 
-long
+__visible long
 sys_clone(unsigned long clone_flags, unsigned long newsp,
 	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
 {
@@ -303,7 +303,7 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
  * function to call, and %di containing
  * the "args".
  */
-extern void kernel_thread_helper(void);
+__visible extern void kernel_thread_helper(void);
 
 /*
  * Create a kernel thread
@@ -339,7 +339,7 @@ EXPORT_SYMBOL(kernel_thread);
 /*
  * sys_execve() executes a new program.
  */
-long sys_execve(const char __user *name,
+__visible long sys_execve(const char __user *name,
 		const char __user *const __user *argv,
 		const char __user *const __user *envp, struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 516fa18..4826bd1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -225,7 +225,7 @@ EXPORT_SYMBOL_GPL(start_thread);
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0a980c9..a5720ed 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -265,7 +265,7 @@ void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
  * Kprobes not supported here. Set the probe on schedule instead.
  * Function graph tracer not supported too.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..b3c241d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -532,7 +532,7 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 }
 #endif /* CONFIG_X86_32 */
 
-long
+__visible long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
@@ -543,7 +543,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-unsigned long sys_sigreturn(struct pt_regs *regs)
+__visible unsigned long sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long ax;
@@ -571,7 +571,7 @@ badframe:
 }
 #endif /* CONFIG_X86_32 */
 
-long sys_rt_sigreturn(struct pt_regs *regs)
+__visible long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
@@ -776,7 +776,7 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void
+__visible void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..d6bfa11 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -249,7 +249,7 @@ finish:
 /*
  * Reschedule call back.
  */
-void smp_reschedule_interrupt(struct pt_regs *regs)
+__visible void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
@@ -259,7 +259,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
-void smp_call_function_interrupt(struct pt_regs *regs)
+__visible void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
@@ -268,7 +268,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
+__visible void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 5c7f8c2..3967318 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -23,7 +23,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 54abcc0..5c1a188 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -202,7 +202,7 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
+__visible int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -231,6 +231,7 @@ out:
 }
 
 
+__visible
 int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index e5b130b..a28bddf 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(copy_in_user);
  * Since protection fault in copy_from/to_user is not a normal situation,
  * it is not necessary to optimize tail handling.
  */
-unsigned long
+__visible unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 {
 	char c;
-- 
1.7.7.6

