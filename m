Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2EWITY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:19:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33906 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2EWITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:19:19 -0400
Date: Wed, 23 May 2012 10:19:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v3.5
Message-ID: <20120523081910.GA16298@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fpu-for-linus

   HEAD: 1dcc8d7ba235a316a056f993e88f0d18b92c60d9 x86, fpu: drop the fpu state during thread exit

This tree streamlines further aspects of FPU handling by 
eliminating the prepare_to_copy() complication and moving that 
logic to arch_dup_task_struct(). It also fixes the FPU dumps in 
threaded core dumps, removes and old (and now invalid) 
assumption plus micro-optimizes the exit path by avoiding an FPU 
save for dead tasks.

out-of-topic modifications in x86-fpu-for-linus:
------------------------------------------------
arch/alpha/include/asm/processor.h # 55ccf3f: fork: move the real prepare_to_co
arch/arm/include/asm/processor.h   # 55ccf3f: fork: move the real prepare_to_co
arch/avr32/include/asm/processor.h # 55ccf3f: fork: move the real prepare_to_co
arch/blackfin/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/c6x/include/asm/processor.h   # 55ccf3f: fork: move the real prepare_to_co
arch/cris/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/frv/include/asm/processor.h   # 55ccf3f: fork: move the real prepare_to_co
arch/frv/kernel/process.c          # 55ccf3f: fork: move the real prepare_to_co
arch/h8300/include/asm/processor.h # 55ccf3f: fork: move the real prepare_to_co
arch/hexagon/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/ia64/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/m32r/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/m68k/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/microblaze/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/mips/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/mn10300/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/mn10300/kernel/process.c      # 55ccf3f: fork: move the real prepare_to_co
arch/openrisc/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/parisc/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/powerpc/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/powerpc/kernel/process.c      # 55ccf3f: fork: move the real prepare_to_co
arch/s390/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/score/include/asm/processor.h # 55ccf3f: fork: move the real prepare_to_co
arch/sh/include/asm/processor_32.h # 55ccf3f: fork: move the real prepare_to_co
arch/sh/include/asm/processor_64.h # 55ccf3f: fork: move the real prepare_to_co
arch/sh/kernel/process.c           # 55ccf3f: fork: move the real prepare_to_co
arch/sh/kernel/process_32.c        # 55ccf3f: fork: move the real prepare_to_co
arch/sparc/include/asm/processor_32.h# 55ccf3f: fork: move the real prepare_to_co
arch/sparc/include/asm/processor_64.h# 55ccf3f: fork: move the real prepare_to_co
arch/tile/include/asm/processor.h  # 55ccf3f: fork: move the real prepare_to_co
arch/um/include/asm/processor-generic.h# 55ccf3f: fork: move the real prepare_to_co
arch/unicore32/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/xtensa/include/asm/processor.h# 55ccf3f: fork: move the real prepare_to_co
arch/xtensa/kernel/process.c       # 55ccf3f: fork: move the real prepare_to_co
fs/exec.c                          # 11aeca0: coredump: ensure the fpu state is

 Thanks,

	Ingo

------------------>
Suresh Siddha (4):
      fork: move the real prepare_to_copy() users to arch_dup_task_struct()
      coredump: ensure the fpu state is flushed for proper multi-threaded core dump
      x86, xsave: remove thread_has_fpu() bug check in __sanitize_i387_state()
      x86, fpu: drop the fpu state during thread exit


 arch/alpha/include/asm/processor.h      |  3 ---
 arch/arm/include/asm/processor.h        |  3 ---
 arch/avr32/include/asm/processor.h      |  3 ---
 arch/blackfin/include/asm/processor.h   |  2 --
 arch/c6x/include/asm/processor.h        |  3 ---
 arch/cris/include/asm/processor.h       |  4 ----
 arch/frv/include/asm/processor.h        |  2 --
 arch/frv/kernel/process.c               | 11 -----------
 arch/h8300/include/asm/processor.h      |  2 --
 arch/hexagon/include/asm/processor.h    |  7 -------
 arch/ia64/include/asm/processor.h       |  3 ---
 arch/m32r/include/asm/processor.h       |  2 --
 arch/m68k/include/asm/processor.h       |  3 ---
 arch/microblaze/include/asm/processor.h |  1 -
 arch/mips/include/asm/processor.h       |  3 ---
 arch/mn10300/include/asm/processor.h    |  3 ---
 arch/mn10300/kernel/process.c           | 10 ++++++----
 arch/openrisc/include/asm/processor.h   |  4 ----
 arch/parisc/include/asm/processor.h     |  3 ---
 arch/powerpc/include/asm/processor.h    |  3 ---
 arch/powerpc/kernel/process.c           | 19 +++++++++++--------
 arch/s390/include/asm/processor.h       |  3 ---
 arch/score/include/asm/processor.h      |  1 -
 arch/sh/include/asm/processor_32.h      |  3 ---
 arch/sh/include/asm/processor_64.h      |  1 -
 arch/sh/kernel/process.c                |  7 +++++++
 arch/sh/kernel/process_32.c             |  9 ---------
 arch/sparc/include/asm/processor_32.h   |  3 ---
 arch/sparc/include/asm/processor_64.h   |  3 ---
 arch/tile/include/asm/processor.h       |  3 ---
 arch/um/include/asm/processor-generic.h |  5 -----
 arch/unicore32/include/asm/processor.h  |  3 ---
 arch/x86/include/asm/processor.h        |  3 ---
 arch/x86/kernel/process.c               | 25 +++++++++++++++++++------
 arch/x86/kernel/process_32.c            |  9 ---------
 arch/x86/kernel/process_64.c            |  9 ---------
 arch/x86/kernel/xsave.c                 |  2 --
 arch/xtensa/include/asm/processor.h     |  3 ---
 arch/xtensa/kernel/process.c            |  9 ++++++---
 fs/exec.c                               | 15 ++++++++++++++-
 kernel/fork.c                           |  2 --
 41 files changed, 63 insertions(+), 149 deletions(-)

diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 94afe58..e37b887 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -49,9 +49,6 @@ extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 /* Create a kernel thread without removing it from tasklists.  */
 extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 5ac8d3d..6354224 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -77,9 +77,6 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 unsigned long get_wchan(struct task_struct *p);
 
 #if __LINUX_ARM_ARCH__ == 6 || defined(CONFIG_ARM_ERRATA_754327)
diff --git a/arch/avr32/include/asm/processor.h b/arch/avr32/include/asm/processor.h
index 108502b..87d8bac 100644
--- a/arch/avr32/include/asm/processor.h
+++ b/arch/avr32/include/asm/processor.h
@@ -145,9 +145,6 @@ extern void release_thread(struct task_struct *);
 /* Create a kernel thread without removing it from tasklists */
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk) do { } while(0)
-
 /* Return saved PC of a blocked thread */
 #define thread_saved_pc(tsk)    ((tsk)->thread.cpu_context.pc)
 
diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index 8af7772..4ef7cfe 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -75,8 +75,6 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags);
 
 /*
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
index 3ff7fab..c50af7e 100644
--- a/arch/c6x/include/asm/processor.h
+++ b/arch/c6x/include/asm/processor.h
@@ -92,9 +92,6 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 #define copy_segments(tsk, mm)		do { } while (0)
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 4210d72..37f522f 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -50,10 +50,6 @@ struct task_struct;
 #define task_pt_regs(task) user_regs(task_thread_info(task))
 #define current_regs() task_pt_regs(current)
 
-static inline void prepare_to_copy(struct task_struct *tsk)
-{
-}
-
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 unsigned long get_wchan(struct task_struct *p);
diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index 81c2e27..9c76817 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -103,8 +103,6 @@ do {							\
 	__frame->sp	= (_usp);			\
 } while(0)
 
-extern void prepare_to_copy(struct task_struct *tsk);
-
 /* Free all resources held by a thread. */
 static inline void release_thread(struct task_struct *dead_task)
 {
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index d4de48b..9f3dfad 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -180,17 +180,6 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, __frame, 0, parent_tidptr, child_tidptr);
 } /* end sys_clone() */
 
-/*****************************************************************************/
-/*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
- */
-void prepare_to_copy(struct task_struct *tsk)
-{
-	//unlazy_fpu(tsk);
-} /* end prepare_to_copy() */
-
-/*****************************************************************************/
 /*
  * set up the kernel stack and exception frames for a new process
  */
diff --git a/arch/h8300/include/asm/processor.h b/arch/h8300/include/asm/processor.h
index 61fabf1..4c9f6f8 100644
--- a/arch/h8300/include/asm/processor.h
+++ b/arch/h8300/include/asm/processor.h
@@ -109,8 +109,6 @@ static inline void release_thread(struct task_struct *dead_task)
 
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
-#define prepare_to_copy(tsk)	do { } while (0)
-
 /*
  * Free current thread data structures etc..
  */
diff --git a/arch/hexagon/include/asm/processor.h b/arch/hexagon/include/asm/processor.h
index 20c5dda..e8ea459 100644
--- a/arch/hexagon/include/asm/processor.h
+++ b/arch/hexagon/include/asm/processor.h
@@ -59,13 +59,6 @@ struct thread_struct {
 #define cpu_relax() __vmyield()
 
 /*
- * "Unlazying all lazy status" occurs here.
- */
-static inline void prepare_to_copy(struct task_struct *tsk)
-{
-}
-
-/*
  * Decides where the kernel will search for a free chunk of vm space during
  * mmaps.
  * See also arch_get_unmapped_area.
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 483f6c6..efcca1b 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -343,9 +343,6 @@ struct task_struct;
  */
 #define release_thread(dead_task)
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 /*
  * This is the mechanism for creating a new kernel thread.
  *
diff --git a/arch/m32r/include/asm/processor.h b/arch/m32r/include/asm/processor.h
index e1f46d7..da17253 100644
--- a/arch/m32r/include/asm/processor.h
+++ b/arch/m32r/include/asm/processor.h
@@ -118,8 +118,6 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-#define prepare_to_copy(tsk)	do { } while (0)
-
 /*
  * create a kernel thread without removing it from tasklists
  */
diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index 46460fa..f17c42a 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -153,9 +153,6 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 /*
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index bffb545..af2bb96 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -23,7 +23,6 @@ extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
 # define cpu_sleep()		do {} while (0)
-# define prepare_to_copy(tsk)	do {} while (0)
 
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 20e9dcf..5e33fab 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -310,9 +310,6 @@ struct task_struct;
 /* Free all resources held by a thread. */
 #define release_thread(thread) do { } while(0)
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index f7b3c9a..247928c 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -139,9 +139,6 @@ static inline void start_thread(struct pt_regs *regs,
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-extern void prepare_to_copy(struct task_struct *tsk);
-
 /*
  * create a kernel thread without removing it from tasklists
  */
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 14707f2..7dab0cd 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -208,12 +208,14 @@ void copy_segments(struct task_struct *p, struct mm_struct *new_mm)
 }
 
 /*
- * this gets called before we allocate a new thread and copy the current task
- * into it so that we can store lazy state into memory
+ * this gets called so that we can store lazy state into memory and copy the
+ * current task into the new thread.
  */
-void prepare_to_copy(struct task_struct *tsk)
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	unlazy_fpu(tsk);
+	unlazy_fpu(src);
+	*dst = *src;
+	return 0;
 }
 
 /*
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
index f7516fa..30462f1 100644
--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -72,10 +72,6 @@ struct thread_struct {
 #define task_pt_regs(task) user_regs(task_thread_info(task))
 #define current_regs() user_regs(current_thread_info())
 
-extern inline void prepare_to_copy(struct task_struct *tsk)
-{
-}
-
 #define INIT_SP         (sizeof(init_stack) + (unsigned long) &init_stack)
 
 #define INIT_THREAD  { }
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index acdf4ca..0e8b7b8 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -328,9 +328,6 @@ struct mm_struct;
 extern void release_thread(struct task_struct *);
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern void map_hpux_gateway_page(struct task_struct *tsk, struct mm_struct *mm);
 
 extern unsigned long get_wchan(struct task_struct *p);
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 8e2d037..854f899 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -74,9 +74,6 @@ struct task_struct;
 void start_thread(struct pt_regs *regs, unsigned long fdptr, unsigned long sp);
 void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-extern void prepare_to_copy(struct task_struct *tsk);
-
 /* Create a new kernel thread. */
 extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 4937c96..bc129f2 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -711,18 +711,21 @@ release_thread(struct task_struct *t)
 }
 
 /*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
+ * this gets called so that we can store coprocessor state into memory and
+ * copy the current task into the new thread.
  */
-void prepare_to_copy(struct task_struct *tsk)
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	flush_fp_to_thread(current);
-	flush_altivec_to_thread(current);
-	flush_vsx_to_thread(current);
-	flush_spe_to_thread(current);
+	flush_fp_to_thread(src);
+	flush_altivec_to_thread(src);
+	flush_vsx_to_thread(src);
+	flush_spe_to_thread(src);
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	flush_ptrace_hw_breakpoint(tsk);
+	flush_ptrace_hw_breakpoint(src);
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
+
+	*dst = *src;
+	return 0;
 }
 
 /*
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index d499b30..6cbf313 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -141,9 +141,6 @@ struct seq_file;
 extern void release_thread(struct task_struct *);
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 /*
  * Return saved PC of a blocked thread.
  */
diff --git a/arch/score/include/asm/processor.h b/arch/score/include/asm/processor.h
index 7e22f21..ab3aceb 100644
--- a/arch/score/include/asm/processor.h
+++ b/arch/score/include/asm/processor.h
@@ -26,7 +26,6 @@ extern unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()		barrier()
 #define release_thread(thread)	do {} while (0)
-#define prepare_to_copy(tsk)	do {} while (0)
 
 /*
  * User space process size: 2GB. This is hardcoded into a few places,
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index 900f8d7..b6311fd 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -126,9 +126,6 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_pc, unsigned lo
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-void prepare_to_copy(struct task_struct *tsk);
-
 /*
  * create a kernel thread without removing it from tasklists
  */
diff --git a/arch/sh/include/asm/processor_64.h b/arch/sh/include/asm/processor_64.h
index e25c4c7..fe99afe 100644
--- a/arch/sh/include/asm/processor_64.h
+++ b/arch/sh/include/asm/processor_64.h
@@ -172,7 +172,6 @@ extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 #define copy_segments(p, mm)	do { } while (0)
 #define release_segments(mm)	do { } while (0)
 #define forget_segments()	do { } while (0)
-#define prepare_to_copy(tsk)	do { } while (0)
 /*
  * FPU lazy state save handling.
  */
diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index 325f98b..2bde59e 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -6,8 +6,15 @@
 struct kmem_cache *task_xstate_cachep = NULL;
 unsigned int xstate_size;
 
+/*
+ * this gets called so that we can store lazy state into memory and copy the
+ * current task into the new thread.
+ */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
+#ifdef CONFIG_SUPERH32
+	unlazy_fpu(src, task_pt_regs(src));
+#endif
 	*dst = *src;
 
 	if (src->thread.xstate) {
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 94273aa..dee5961 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -155,15 +155,6 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
 }
 EXPORT_SYMBOL(dump_fpu);
 
-/*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
- */
-void prepare_to_copy(struct task_struct *tsk)
-{
-	unlazy_fpu(tsk, task_pt_regs(tsk));
-}
-
 asmlinkage void ret_from_fork(void);
 
 int copy_thread(unsigned long clone_flags, unsigned long usp,
diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index 09521c6..c9c760f 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -109,9 +109,6 @@ static inline void start_thread(struct pt_regs * regs, unsigned long pc,
 #define release_thread(tsk)		do { } while(0)
 extern pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern unsigned long get_wchan(struct task_struct *);
 
 #define task_pt_regs(tsk) ((tsk)->thread.kregs)
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index e713db2..67df5cc 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -186,9 +186,6 @@ do { \
 /* Free all resources held by a thread. */
 #define release_thread(tsk)		do { } while (0)
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 extern unsigned long get_wchan(struct task_struct *task);
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 34c1e01..15cd8a4 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -210,9 +210,6 @@ static inline void release_thread(struct task_struct *dead_task)
 	/* Nothing for now */
 }
 
-/* Prepare to copy thread state - unlazy all lazy status. */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
 extern int do_work_pending(struct pt_regs *regs, u32 flags);
diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index 98d01bc..63b7160 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -76,11 +76,6 @@ static inline void release_thread(struct task_struct *task)
 
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
-static inline void prepare_to_copy(struct task_struct *tsk)
-{
-}
-
-
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
 static inline void mm_copy_segments(struct mm_struct *from_mm,
diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
index f0d780a..14382cb 100644
--- a/arch/unicore32/include/asm/processor.h
+++ b/arch/unicore32/include/asm/processor.h
@@ -68,9 +68,6 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
 unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4fa7dcc..97fe043 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -579,9 +579,6 @@ extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-/* Prepare to copy thread state - unlazy all lazy state */
-extern void prepare_to_copy(struct task_struct *tsk);
-
 unsigned long get_wchan(struct task_struct *p);
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..1219fe2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -47,10 +47,16 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
+/*
+ * this gets called so that we can store lazy state into memory and copy the
+ * current task into the new thread.
+ */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	int ret;
 
+	unlazy_fpu(src);
+
 	*dst = *src;
 	if (fpu_allocated(&src->thread.fpu)) {
 		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
@@ -81,6 +87,16 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
+static inline void drop_fpu(struct task_struct *tsk)
+{
+	/*
+	 * Forget coprocessor state..
+	 */
+	tsk->fpu_counter = 0;
+	clear_fpu(tsk);
+	clear_used_math();
+}
+
 /*
  * Free current thread data structures etc..
  */
@@ -103,6 +119,8 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
+
+	drop_fpu(me);
 }
 
 void show_regs(struct pt_regs *regs)
@@ -143,12 +161,7 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
+	drop_fpu(tsk);
 }
 
 static void hard_disable_TSC(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ae68473..2aa57dc 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -126,15 +126,6 @@ void release_thread(struct task_struct *dead_task)
 	release_vm86_irqs(dead_task);
 }
 
-/*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
- */
-void prepare_to_copy(struct task_struct *tsk)
-{
-	unlazy_fpu(tsk);
-}
-
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 	unsigned long unused,
 	struct task_struct *p, struct pt_regs *regs)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 43d8b48..c4c0645 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -145,15 +145,6 @@ static inline u32 read_32bit_tls(struct task_struct *t, int tls)
 	return get_desc_base(&t->thread.tls_array[tls]);
 }
 
-/*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
- */
-void prepare_to_copy(struct task_struct *tsk)
-{
-	unlazy_fpu(tsk);
-}
-
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long unused,
 	struct task_struct *p, struct pt_regs *regs)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index e62728e..bd18149 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -48,8 +48,6 @@ void __sanitize_i387_state(struct task_struct *tsk)
 	if (!fx)
 		return;
 
-	BUG_ON(__thread_has_fpu(tsk));
-
 	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
 
 	/*
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index 3acb26e..5c371d8 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -168,9 +168,6 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 #define release_thread(thread) do { } while(0)
 
-/* Prepare to copy thread state - unlazy all lazy status */
-extern void prepare_to_copy(struct task_struct*);
-
 /* Create a kernel thread without removing it from tasklists */
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 6a2d6ed..9b306e5 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -140,13 +140,16 @@ void flush_thread(void)
 }
 
 /*
- * This is called before the thread is copied. 
+ * this gets called so that we can store coprocessor state into memory and
+ * copy the current task into the new thread.
  */
-void prepare_to_copy(struct task_struct *tsk)
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 #if XTENSA_HAVE_COPROCESSORS
-	coprocessor_flush_all(task_thread_info(tsk));
+	coprocessor_flush_all(task_thread_info(src));
 #endif
+	*dst = *src;
+	return 0;
 }
 
 /*
diff --git a/fs/exec.c b/fs/exec.c
index b1fd202..8e2ddeb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
-	if (core_waiters > 0)
+	if (core_waiters > 0) {
+		struct core_thread *ptr;
+
 		wait_for_completion(&core_state->startup);
+		/*
+		 * Wait for all the threads to become inactive, so that
+		 * all the thread context (extended register state, like
+		 * fpu etc) gets copied to the memory.
+		 */
+		ptr = core_state->dumper.next;
+		while (ptr != NULL) {
+			wait_task_inactive(ptr->task, 0);
+			ptr = ptr->next;
+		}
+	}
 
 	return core_waiters;
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 687a15d..7aed746 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -261,8 +261,6 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	int node = tsk_fork_get_node(orig);
 	int err;
 
-	prepare_to_copy(orig);
-
 	tsk = alloc_task_struct_node(node);
 	if (!tsk)
 		return NULL;
