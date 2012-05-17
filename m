Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966113Ab2EQATs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:19:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369Ab2EQATo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:19:44 -0400
Date: Wed, 16 May 2012 17:16:39 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-55ccf3fe3f9a3441731aa79cf42a628fc4ecace9@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, lennox.wu@gmail.com, tony.luck@intel.com,
        chris@zankel.net, hskinnemoen@gmail.com, linux@arm.linux.org.uk,
        suresh.b.siddha@intel.com, gxt@mprc.pku.edu.cn, deller@gmx.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        yasutake.koichi@jp.panasonic.com, liqin.chen@sunplusct.com,
        dhowells@redhat.com, benh@kernel.crashing.org, rkuo@codeaurora.org,
        jdike@addtoit.com, a-jacquiot@ti.com, monstr@monstr.eu,
        ralf@linux-mips.org, vapier@gentoo.org, heiko.carstens@de.ibm.com,
        oleg@redhat.com, tglx@linutronix.de, rth@twiddle.net, paulus@samba.org,
        richard@nod.at, lethal@linux-sh.org, msalter@redhat.com,
        davem@davemloft.net, jejb@parisc-linux.org, starvik@axis.com,
        jonas@southpole.se, hpa@linux.intel.com, ysato@users.sourceforge.jp
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        schwidefsky@de.ibm.com, cmetcalf@tilera.com, chris@zankel.net,
        tony.luck@intel.com, lennox.wu@gmail.com, hskinnemoen@gmail.com,
        linux@arm.linux.org.uk, suresh.b.siddha@intel.com, gxt@mprc.pku.edu.cn,
        deller@gmx.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yasutake.koichi@jp.panasonic.com, liqin.chen@sunplusct.com,
        benh@kernel.crashing.org, dhowells@redhat.com, rkuo@codeaurora.org,
        jdike@addtoit.com, a-jacquiot@ti.com, monstr@monstr.eu,
        ralf@linux-mips.org, vapier@gentoo.org, heiko.carstens@de.ibm.com,
        oleg@redhat.com, tglx@linutronix.de, rth@twiddle.net, paulus@samba.org,
        richard@nod.at, lethal@linux-sh.org, msalter@redhat.com,
        davem@davemloft.net, jejb@parisc-linux.org, starvik@axis.com,
        jonas@southpole.se, ysato@users.sourceforge.jp, hpa@linux.intel.com
In-Reply-To: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] fork: move the real prepare_to_copy()
  users to arch_dup_task_struct()
Git-Commit-ID: 55ccf3fe3f9a3441731aa79cf42a628fc4ecace9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 17:16:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55ccf3fe3f9a3441731aa79cf42a628fc4ecace9
Gitweb:     http://git.kernel.org/tip/55ccf3fe3f9a3441731aa79cf42a628fc4ecace9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 May 2012 15:03:51 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 15:16:26 -0700

fork: move the real prepare_to_copy() users to arch_dup_task_struct()

Historical prepare_to_copy() is mostly a no-op, duplicated for majority of
the architectures and the rest following the x86 model of flushing the extended
register state like fpu there.

Remove it and use the arch_dup_task_struct() instead.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/alpha/include/asm/processor.h      |    3 ---
 arch/arm/include/asm/processor.h        |    3 ---
 arch/avr32/include/asm/processor.h      |    3 ---
 arch/blackfin/include/asm/processor.h   |    2 --
 arch/c6x/include/asm/processor.h        |    3 ---
 arch/cris/include/asm/processor.h       |    4 ----
 arch/frv/include/asm/processor.h        |    2 --
 arch/frv/kernel/process.c               |   11 -----------
 arch/h8300/include/asm/processor.h      |    2 --
 arch/hexagon/include/asm/processor.h    |    7 -------
 arch/ia64/include/asm/processor.h       |    3 ---
 arch/m32r/include/asm/processor.h       |    2 --
 arch/m68k/include/asm/processor.h       |    3 ---
 arch/microblaze/include/asm/processor.h |    1 -
 arch/mips/include/asm/processor.h       |    3 ---
 arch/mn10300/include/asm/processor.h    |    3 ---
 arch/mn10300/kernel/process.c           |   10 ++++++----
 arch/openrisc/include/asm/processor.h   |    4 ----
 arch/parisc/include/asm/processor.h     |    3 ---
 arch/powerpc/include/asm/processor.h    |    3 ---
 arch/powerpc/kernel/process.c           |   19 +++++++++++--------
 arch/s390/include/asm/processor.h       |    3 ---
 arch/score/include/asm/processor.h      |    1 -
 arch/sh/include/asm/processor_32.h      |    3 ---
 arch/sh/include/asm/processor_64.h      |    1 -
 arch/sh/kernel/process.c                |    7 +++++++
 arch/sh/kernel/process_32.c             |    9 ---------
 arch/sparc/include/asm/processor_32.h   |    3 ---
 arch/sparc/include/asm/processor_64.h   |    3 ---
 arch/tile/include/asm/processor.h       |    3 ---
 arch/um/include/asm/processor-generic.h |    5 -----
 arch/unicore32/include/asm/processor.h  |    3 ---
 arch/x86/include/asm/processor.h        |    3 ---
 arch/x86/kernel/process.c               |    6 ++++++
 arch/x86/kernel/process_32.c            |    9 ---------
 arch/x86/kernel/process_64.c            |    9 ---------
 arch/xtensa/include/asm/processor.h     |    3 ---
 arch/xtensa/kernel/process.c            |    9 ++++++---
 kernel/fork.c                           |    2 --
 39 files changed, 36 insertions(+), 140 deletions(-)

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
index 1d92a5a..b7e1e0e 100644
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
