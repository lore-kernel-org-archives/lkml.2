Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab1JaTGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:06:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934601Ab1JaTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:06:12 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 15/17] freezer: remove now unused TIF_FREEZE
Date: Mon, 31 Oct 2011 12:05:26 -0700
Message-Id: <1320087928-32307-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
---
 arch/alpha/include/asm/thread_info.h      |    2 --
 arch/arm/include/asm/thread_info.h        |    2 --
 arch/avr32/include/asm/thread_info.h      |    2 --
 arch/blackfin/include/asm/thread_info.h   |    2 --
 arch/cris/include/asm/thread_info.h       |    2 --
 arch/frv/include/asm/thread_info.h        |    2 --
 arch/h8300/include/asm/thread_info.h      |    2 --
 arch/ia64/include/asm/thread_info.h       |    2 --
 arch/m32r/include/asm/thread_info.h       |    2 --
 arch/m68k/include/asm/thread_info.h       |    1 -
 arch/microblaze/include/asm/thread_info.h |    2 --
 arch/mips/include/asm/thread_info.h       |    2 --
 arch/mn10300/include/asm/thread_info.h    |    2 --
 arch/parisc/include/asm/thread_info.h     |    2 --
 arch/powerpc/include/asm/thread_info.h    |    2 --
 arch/s390/include/asm/thread_info.h       |    2 --
 arch/sh/include/asm/thread_info.h         |    2 --
 arch/sparc/include/asm/thread_info_32.h   |    2 --
 arch/sparc/include/asm/thread_info_64.h   |    2 --
 arch/um/include/asm/thread_info.h         |    2 --
 arch/unicore32/include/asm/thread_info.h  |    2 --
 arch/x86/include/asm/thread_info.h        |    2 --
 arch/xtensa/include/asm/thread_info.h     |    2 --
 23 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index ff73db0..28335bd 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -79,7 +79,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TIF_UAC_SIGBUS		12	/* ! userspace part of 'osf_sysinfo' */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	14	/* restore signal mask in do_signal */
-#define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -87,7 +86,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 7b5cc8d..0f30c3a 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -142,7 +142,6 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SECCOMP		21
 
@@ -152,7 +151,6 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index 7a9c03d..e5deda4 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -85,7 +85,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
 #define TIF_NOTIFY_RESUME	9	/* callback before returning to user */
-#define TIF_FREEZE		29
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
@@ -98,7 +97,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* Note: The masks below must never span more than 16 bits! */
 
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 02560fd..53ad100 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -100,7 +100,6 @@ static inline struct thread_info *current_thread_info(void)
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
-#define TIF_FREEZE		6	/* is freezing for suspend */
 #define TIF_IRQ_SYNC		7	/* sync pipeline stage */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 #define TIF_SINGLESTEP		9
@@ -111,7 +110,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_IRQ_SYNC		(1<<TIF_IRQ_SYNC)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 332f19c..29b9288 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -86,7 +86,6 @@ struct thread_info {
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
-#define TIF_FREEZE		18	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -94,7 +93,6 @@ struct thread_info {
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index cefbe73..92d83ea 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -111,7 +111,6 @@ register struct thread_info *__current_thread_info asm("gr15");
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
-#define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -120,7 +119,6 @@ register struct thread_info *__current_thread_info asm("gr15");
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff --git a/arch/h8300/include/asm/thread_info.h b/arch/h8300/include/asm/thread_info.h
index d6f1784..9c126e0 100644
--- a/arch/h8300/include/asm/thread_info.h
+++ b/arch/h8300/include/asm/thread_info.h
@@ -90,7 +90,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	6	/* callback before returning to user */
-#define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -99,7 +98,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index ff0cc84..e054bcc 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -113,7 +113,6 @@ struct thread_info {
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
-#define TIF_FREEZE		20	/* is freezing for suspend */
 #define TIF_RESTORE_RSE		21	/* user RBS is newer than kernel RBS */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -126,7 +125,6 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
 #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_RESTORE_RSE	(1 << TIF_RESTORE_RSE)
 
 /* "work to do on user-return" bits */
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index 0227dba..bf8fa3c 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -138,7 +138,6 @@ static inline unsigned int get_thread_fault_code(void)
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -149,7 +148,6 @@ static inline unsigned int get_thread_fault_code(void)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 7909889..294df15 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -103,7 +103,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16	/* is terminating due to OOM killer */
-#define TIF_FREEZE		17	/* thread is freezing for suspend */
 #define TIF_RESTORE_SIGMASK	18	/* restore signal mask in do_signal */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index b73da2a..1a8ab6a 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -125,7 +125,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		6	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	9       /* syscall auditing active */
 #define TIF_SECCOMP		10      /* secure computing */
-#define TIF_FREEZE		14	/* Freezing for suspend */
 
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_POLLING_NRFLAG	16
@@ -137,7 +136,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 97f8bf6..0d85d8e 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -117,7 +117,6 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_FREEZE		19
 #define TIF_FIXADE		20	/* Fix address errors in software */
 #define TIF_LOGADE		21	/* Log address errors to syslog */
 #define TIF_32BIT_REGS		22	/* also implies 16/32 fprs */
@@ -141,7 +140,6 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_FIXADE		(1<<TIF_FIXADE)
 #define _TIF_LOGADE		(1<<TIF_LOGADE)
 #define _TIF_32BIT_REGS		(1<<TIF_32BIT_REGS)
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 87c2130..28cf521 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -165,7 +165,6 @@ extern void free_thread_info(struct thread_info *);
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
-#define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	+(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	+(1 << TIF_NOTIFY_RESUME)
@@ -174,7 +173,6 @@ extern void free_thread_info(struct thread_info *);
 #define _TIF_SINGLESTEP		+(1 << TIF_SINGLESTEP)
 #define _TIF_RESTORE_SIGMASK	+(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	+(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		+(1 << TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index aa8de72..6d9c7c7 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -58,7 +58,6 @@ struct thread_info {
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
-#define TIF_FREEZE		7	/* is freezing for suspend */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 #define TIF_SINGLESTEP		9	/* single stepping? */
 #define TIF_BLOCKSTEP		10	/* branch stepping? */
@@ -69,7 +68,6 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 836f231..96471494 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -109,7 +109,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
-#define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
 #define TIF_RUNLATCH		16	/* Is the runlatch enabled? */
 
@@ -127,7 +126,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 1a5dbb6..589708a 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -101,7 +101,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	19	/* restore signal mask in do_signal() */
 #define TIF_SINGLE_STEP		20	/* This task is single stepped */
-#define TIF_FREEZE		21	/* thread is freezing for suspend */
 
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
@@ -118,7 +117,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_FREEZE)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #ifdef CONFIG_64BIT
 #define is_32bit_task()		(test_thread_flag(TIF_31BIT))
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index ea2d508..20ee40a 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -122,7 +122,6 @@ extern void init_thread_xstate(void);
 #define TIF_SYSCALL_TRACEPOINT	8	/* for ftrace syscall instrumentation */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_FREEZE		19	/* Freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -133,7 +132,6 @@ extern void init_thread_xstate(void);
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /*
  * _TIF_ALLWORK_MASK and _TIF_WORK_MASK need to fit within 2 bytes, or we
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index fa57532..5cc5888 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -133,7 +133,6 @@ BTFIXUPDEF_CALL(void, free_thread_info, struct thread_info *)
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
 #define TIF_MEMDIE		10	/* is terminating due to OOM killer */
-#define TIF_FREEZE		11	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -147,7 +146,6 @@ BTFIXUPDEF_CALL(void, free_thread_info, struct thread_info *)
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING | \
 					 _TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 60d86be..01d057f 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -225,7 +225,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 /* flag bit 12 is available */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14
-#define TIF_FREEZE		15	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -237,7 +236,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
 				 _TIF_DO_NOTIFY_RESUME_MASK | \
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 5bd1bad..200c4ab 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -71,7 +71,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
-#define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -80,6 +79,5 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #endif
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index c270e9e..89f7557 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -135,14 +135,12 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
 #define TIF_MEMDIE		18
-#define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 
 /*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..32125af 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -90,7 +90,6 @@ struct thread_info {
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
-#define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
@@ -112,7 +111,6 @@ struct thread_info {
 #define _TIF_FORK		(1 << TIF_FORK)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 7be8acc..6abbedd 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -132,7 +132,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_FREEZE		17	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -141,7 +140,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_IRET		(1<<TIF_IRET)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
-- 
1.7.3.1

