Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1A0L4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:56:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:53272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1A0L4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:56:48 -0500
Date: Thu, 27 Jan 2011 11:56:31 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, chris@zankel.net, lethal@linux-sh.org,
        tony.luck@intel.com, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tony.luck@intel.com, lethal@linux-sh.org,
        chris@zankel.net, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20110126195833.679641914@linutronix.de>
References: <20110126195833.679641914@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Move duplicate struct rwsem declaration to linux/rwsem.h
Message-ID: <tip-1c8ed640d918290ddc1de5ada02ef6686a733c9f@git.kernel.org>
Git-Commit-ID: 1c8ed640d918290ddc1de5ada02ef6686a733c9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:56:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c8ed640d918290ddc1de5ada02ef6686a733c9f
Gitweb:     http://git.kernel.org/tip/1c8ed640d918290ddc1de5ada02ef6686a733c9f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:05:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:39 +0100

rwsem: Move duplicate struct rwsem declaration to linux/rwsem.h

The difference between these declarations is the data type of the
count member and the lack of lockdep in some architectures/

long is equivivalent to signed long and the #ifdef guarded dep_map
member does not hurt anyone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
LKML-Reference: <20110126195833.679641914@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    8 --------
 arch/ia64/include/asm/rwsem.h    |    9 ---------
 arch/powerpc/include/asm/rwsem.h |    9 ---------
 arch/s390/include/asm/rwsem.h    |   12 ------------
 arch/sh/include/asm/rwsem.h      |   12 +-----------
 arch/sparc/include/asm/rwsem.h   |    9 +--------
 arch/x86/include/asm/rwsem.h     |   12 ------------
 arch/xtensa/include/asm/rwsem.h  |    9 +--------
 include/linux/rwsem.h            |   13 ++++++++++++-
 9 files changed, 15 insertions(+), 78 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 839a3fa..3e5619e 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -19,20 +19,12 @@ extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	long			count;
 #define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS		0x0000000000000001L
 #define RWSEM_ACTIVE_MASK		0x00000000ffffffffL
 #define RWSEM_WAITING_BIAS		(-0x0000000100000000L)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
 
 #define __RWSEM_INITIALIZER(name) \
 	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 9bcf079..1fe4658 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -27,15 +27,6 @@
 
 #include <asm/intrinsics.h>
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
-
 #define RWSEM_UNLOCKED_VALUE		__IA64_UL_CONST(0x0000000000000000)
 #define RWSEM_ACTIVE_BIAS		(1L)
 #define RWSEM_ACTIVE_MASK		(0xffffffffL)
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index c12abbe..bc1acc2 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -28,15 +28,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-struct rw_semaphore {
-	long			count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
 #else
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 9cc8592..6e075f1 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -49,18 +49,6 @@ extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_write(struct rw_semaphore *);
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
-
 #ifndef __s390x__
 #define RWSEM_UNLOCKED_VALUE	0x00000000
 #define RWSEM_ACTIVE_BIAS	0x00000001
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index df6f346..dffc625 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -11,23 +11,13 @@
 #endif
 
 #ifdef __KERNEL__
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	long		count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index 902d36b..4c16d1d 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -12,20 +12,13 @@
 #endif
 
 #ifdef __KERNEL__
-struct rw_semaphore {
-	signed long			count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
 #define RWSEM_ACTIVE_BIAS		0x00000001L
 #define RWSEM_ACTIVE_MASK		0xffffffffL
 #define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t			wait_lock;
-	struct list_head		wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map		dep_map;
-#endif
-};
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index c30206c..995cfe4 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -49,8 +49,6 @@ extern asmregparm struct rw_semaphore *
  rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /*
- * the semaphore definition
- *
  * The bias values and the counter type limits the number of
  * potential readers/writers to 32767 for 32 bits and 2147483647
  * for 64 bits.
@@ -68,22 +66,12 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-struct rw_semaphore {
-	long			count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
-};
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-
 #define __RWSEM_INITIALIZER(name)				\
 {								\
 	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index 1be2102..585cab9 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -16,20 +16,13 @@
 #ifndef _LINUX_RWSEM_H
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
 
 #define __RWSEM_INITIALIZER(name) \
 	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 496296d..e8be18e 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -22,7 +22,18 @@ struct rw_semaphore;
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
 #include <linux/rwsem-spinlock.h> /* use a generic implementation */
 #else
-#include <asm/rwsem.h> /* use an arch-specific implementation */
+/* All arch specific implementations share the same struct */
+struct rw_semaphore {
+	long			count;
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+/* Include the arch specific part */
+#include <asm/rwsem.h>
 #endif
 
 /*
