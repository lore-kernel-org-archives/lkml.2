Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1E3DeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:34:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44581 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1E3DeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:34:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Subject: [PATCH] ptrace: unify show_regs() prototype
Date: Sun, 29 May 2011 23:39:13 -0400
Message-Id: <1306726753-16128-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1302759489-10645-1-git-send-email-vapier@gentoo.org>
References: <1302759489-10645-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
andrew: can you pick this up ?  sent a few months ago w/no love.

 arch/alpha/include/asm/ptrace.h          |    1 -
 arch/avr32/include/asm/ptrace.h          |    2 --
 arch/blackfin/include/asm/ptrace.h       |    1 -
 arch/cris/include/arch-v10/arch/ptrace.h |    1 -
 arch/cris/include/arch-v32/arch/ptrace.h |    1 -
 arch/frv/include/asm/ptrace.h            |    1 -
 arch/h8300/include/asm/ptrace.h          |    1 -
 arch/ia64/include/asm/ptrace.h           |    1 -
 arch/m32r/include/asm/ptrace.h           |    2 --
 arch/m68k/include/asm/ptrace.h           |    1 -
 arch/microblaze/include/asm/ptrace.h     |    2 --
 arch/mn10300/include/asm/ptrace.h        |    1 -
 arch/parisc/include/asm/ptrace.h         |    1 -
 arch/powerpc/include/asm/system.h        |    1 -
 arch/s390/include/asm/ptrace.h           |    1 -
 arch/sh/include/asm/ptrace.h             |    2 --
 arch/sparc/include/asm/ptrace.h          |    2 --
 arch/tile/include/asm/ptrace.h           |    2 --
 arch/um/include/asm/ptrace-generic.h     |    2 --
 arch/x86/include/asm/kdebug.h            |    1 -
 arch/xtensa/include/asm/ptrace.h         |    1 -
 include/linux/ptrace.h                   |    1 +
 22 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
index 65cf3e2..fd698a1 100644
--- a/arch/alpha/include/asm/ptrace.h
+++ b/arch/alpha/include/asm/ptrace.h
@@ -72,7 +72,6 @@ struct switch_stack {
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #define task_pt_regs(task) \
   ((struct pt_regs *) (task_stack_page(task) + 2*PAGE_SIZE) - 1)
diff --git a/arch/avr32/include/asm/ptrace.h b/arch/avr32/include/asm/ptrace.h
index e53dd0d..c67a007 100644
--- a/arch/avr32/include/asm/ptrace.h
+++ b/arch/avr32/include/asm/ptrace.h
@@ -132,8 +132,6 @@ struct pt_regs {
 #define instruction_pointer(regs)       ((regs)->pc)
 #define profile_pc(regs)                instruction_pointer(regs)
 
-extern void show_regs (struct pt_regs *);
-
 static __inline__ int valid_user_regs(struct pt_regs *regs)
 {
 	/*
diff --git a/arch/blackfin/include/asm/ptrace.h b/arch/blackfin/include/asm/ptrace.h
index 7854d43..10d8641 100644
--- a/arch/blackfin/include/asm/ptrace.h
+++ b/arch/blackfin/include/asm/ptrace.h
@@ -102,7 +102,6 @@ struct pt_regs {
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 /* common code demands this function */
diff --git a/arch/cris/include/arch-v10/arch/ptrace.h b/arch/cris/include/arch-v10/arch/ptrace.h
index 2f464ea..1a23273 100644
--- a/arch/cris/include/arch-v10/arch/ptrace.h
+++ b/arch/cris/include/arch-v10/arch/ptrace.h
@@ -112,7 +112,6 @@ struct switch_stack {
 #define user_mode(regs) (((regs)->dccr & 0x100) != 0)
 #define instruction_pointer(regs) ((regs)->irp)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/cris/include/arch-v32/arch/ptrace.h b/arch/cris/include/arch-v32/arch/ptrace.h
index ffca8d0..19773d3 100644
--- a/arch/cris/include/arch-v32/arch/ptrace.h
+++ b/arch/cris/include/arch-v32/arch/ptrace.h
@@ -111,7 +111,6 @@ struct switch_stack {
 #define arch_has_single_step() (1)
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
-extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) instruction_pointer(regs)
 
 #endif  /*  __KERNEL__  */
diff --git a/arch/frv/include/asm/ptrace.h b/arch/frv/include/asm/ptrace.h
index 6bfad4c..ef6635c 100644
--- a/arch/frv/include/asm/ptrace.h
+++ b/arch/frv/include/asm/ptrace.h
@@ -78,7 +78,6 @@ register struct pt_regs *__frame asm("gr28");
 #define user_stack_pointer(regs)	((regs)->sp)
 
 extern unsigned long user_stack(const struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
 
 #define task_pt_regs(task) ((task)->thread.frame0)
diff --git a/arch/h8300/include/asm/ptrace.h b/arch/h8300/include/asm/ptrace.h
index d866c0e..d09c440 100644
--- a/arch/h8300/include/asm/ptrace.h
+++ b/arch/h8300/include/asm/ptrace.h
@@ -60,7 +60,6 @@ struct pt_regs {
 #define user_mode(regs) (!((regs)->ccr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _H8300_PTRACE_H */
diff --git a/arch/ia64/include/asm/ptrace.h b/arch/ia64/include/asm/ptrace.h
index 7ae9c3f..f5cb276 100644
--- a/arch/ia64/include/asm/ptrace.h
+++ b/arch/ia64/include/asm/ptrace.h
@@ -286,7 +286,6 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
   struct task_struct;			/* forward decl */
   struct unw_frame_info;		/* forward decl */
 
-  extern void show_regs (struct pt_regs *);
   extern void ia64_do_show_stack (struct unw_frame_info *, void *);
   extern unsigned long ia64_get_user_rbs_end (struct task_struct *, struct pt_regs *,
 					      unsigned long *);
diff --git a/arch/m32r/include/asm/ptrace.h b/arch/m32r/include/asm/ptrace.h
index 840a123..5275275 100644
--- a/arch/m32r/include/asm/ptrace.h
+++ b/arch/m32r/include/asm/ptrace.h
@@ -138,8 +138,6 @@ extern void init_debug_traps(struct task_struct *);
 #define instruction_pointer(regs) ((regs)->bpc)
 #define profile_pc(regs) instruction_pointer(regs)
 
-extern void show_regs(struct pt_regs *);
-
 extern void withdraw_debug_trap(struct pt_regs *regs);
 
 #define task_pt_regs(task) \
diff --git a/arch/m68k/include/asm/ptrace.h b/arch/m68k/include/asm/ptrace.h
index 6e6e3ac..65322b1 100644
--- a/arch/m68k/include/asm/ptrace.h
+++ b/arch/m68k/include/asm/ptrace.h
@@ -85,7 +85,6 @@ struct switch_stack {
 #define user_mode(regs) (!((regs)->sr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
index d9b6630..816bee6 100644
--- a/arch/microblaze/include/asm/ptrace.h
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -61,8 +61,6 @@ struct pt_regs {
 #define instruction_pointer(regs)	((regs)->pc)
 #define profile_pc(regs)		instruction_pointer(regs)
 
-void show_regs(struct pt_regs *);
-
 #else /* __KERNEL__ */
 
 /* pt_regs offsets used by gdbserver etc in ptrace syscalls */
diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index b696181..55b79ef 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -89,7 +89,6 @@ struct pt_regs {
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
 #define user_stack_pointer(regs)	((regs)->sp)
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
diff --git a/arch/parisc/include/asm/ptrace.h b/arch/parisc/include/asm/ptrace.h
index 7f09533..250ae35 100644
--- a/arch/parisc/include/asm/ptrace.h
+++ b/arch/parisc/include/asm/ptrace.h
@@ -56,7 +56,6 @@ struct pt_regs {
 #define instruction_pointer(regs)	((regs)->iaoq[0] & ~3)
 #define user_stack_pointer(regs)	((regs)->gr[30])
 unsigned long profile_pc(struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index 2dc595d..e30a13d 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -120,7 +120,6 @@ extern void do_dabr(struct pt_regs *regs, unsigned long address,
 		    unsigned long error_code);
 #endif
 extern void print_backtrace(unsigned long *);
-extern void show_regs(struct pt_regs * regs);
 extern void flush_instruction_cache(void);
 extern void hard_reset_now(void);
 extern void poweroff_now(void);
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 9ad628a..62fd80c 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -539,7 +539,6 @@ struct user_regs_struct
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-extern void show_regs(struct pt_regs * regs);
 
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index 40725b4..3f2a6e7 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -43,8 +43,6 @@
 #define kernel_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
 #define GET_USP(regs) ((regs)->regs[15])
 
-extern void show_regs(struct pt_regs *);
-
 #define arch_has_single_step()	(1)
 
 /*
diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrace.h
index c7ad3fe..45d9a6a 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -212,7 +212,6 @@ extern unsigned long profile_pc(struct pt_regs *);
 #else
 #define profile_pc(regs) instruction_pointer(regs)
 #endif
-extern void show_regs(struct pt_regs *);
 #endif /* (__KERNEL__) */
 
 #else /* __ASSEMBLY__ */
@@ -256,7 +255,6 @@ static inline bool pt_regs_clear_syscall(struct pt_regs *regs)
 #define instruction_pointer(regs) ((regs)->pc)
 #define user_stack_pointer(regs) ((regs)->u_regs[UREG_FP])
 unsigned long profile_pc(struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 #endif /* (__KERNEL__) */
 
 #else /* (!__ASSEMBLY__) */
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 6be2246..c6cddd7 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -112,8 +112,6 @@ struct pt_regs *get_pt_regs(struct pt_regs *);
 /* Trace the current syscall. */
 extern void do_syscall_trace(void);
 
-extern void show_regs(struct pt_regs *);
-
 #define arch_has_single_step()	(1)
 
 /*
diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index b7c5bab..ae084ad 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -47,8 +47,6 @@ extern int get_fpregs(struct user_i387_struct __user *buf,
 extern int set_fpregs(struct user_i387_struct __user *buf,
 		      struct task_struct *child);
 
-extern void show_regs(struct pt_regs *regs);
-
 extern int arch_copy_tls(struct task_struct *new);
 extern void clear_flushed_tls(struct task_struct *task);
 
diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fe2cc6e..d73f157 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -28,7 +28,6 @@ extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
-extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 #ifdef CONFIG_KEXEC
diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index 0d42c93..d85d38d 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -120,7 +120,6 @@ struct pt_regs {
   (task_stack_page(tsk) + KERNEL_STACK_SIZE - (XCHAL_NUM_AREGS-16)*4) - 1)
 # define user_mode(regs) (((regs)->ps & 0x00000020)!=0)
 # define instruction_pointer(regs) ((regs)->pc)
-extern void show_regs(struct pt_regs *);
 
 # ifndef CONFIG_SMP
 #  define profile_pc(regs) instruction_pointer(regs)
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 9178d5c..65cb6bc 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -100,6 +100,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
+extern void show_regs(struct pt_regs *);
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
-- 
1.7.5.rc3

