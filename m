Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab1COTjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:39:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1COTjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:39:12 -0400
Date: Tue, 15 Mar 2011 20:38:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v2.6.39
Message-ID: <20110315193854.GA1437@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Arnd Bergmann (1):
      rtmutex-tester: Remove BKL tests

Lai Jiangshan (1):
      rtmutex: Simplify PI algorithm and make highest prio task get lock

Steven Rostedt (1):
      lockdep/timers: Explain in detail the locking problems del_timer_sync() may cause

Thomas Gleixner (17):
      alpha: Replace deprecated spinlock initialization
      cris: Replace deprecated spinlock initialization
      mips: Replace deprecated spinlock initialization
      sparc: Replace deprecated spinlock initialization
      um: Replace deprecated spinlock initialization
      xtensa: Replace deprecated spinlock initialization
      kthread: Replace deprecated spinlock initialization
      cred: Replace deprecated spinlock initialization
      locking: Remove deprecated lock initializers
      rwsem: Cleanup includes
      x86: Cleanup rwsem_count_t typedef
      rwsem: Move duplicate struct rwsem declaration to linux/rwsem.h
      rwsem: Move duplicate init macros and functions to linux/rwsem.h
      rwsem: Unify the duplicate rwsem_is_locked() inlines
      rwsem: Move duplicate function prototypes to linux/rwsem.h
      rwsem: Remove redundant asmregparm annotation
      rtmutex: tester: Remove the remaining BKL leftovers


 Documentation/spinlocks.txt                        |   24 +--
 arch/alpha/include/asm/rwsem.h                     |   36 ---
 arch/cris/arch-v32/kernel/smp.c                    |    4 +-
 arch/ia64/include/asm/rwsem.h                      |   37 ---
 arch/mips/kernel/vpe.c                             |    4 +-
 arch/powerpc/include/asm/rwsem.h                   |   51 ---
 arch/s390/include/asm/rwsem.h                      |   63 ----
 arch/sh/include/asm/rwsem.h                        |   56 ----
 arch/sparc/include/asm/rwsem.h                     |   46 ---
 arch/sparc/lib/atomic32.c                          |    2 +-
 arch/um/drivers/ubd_kern.c                         |    2 +-
 arch/x86/include/asm/rwsem.h                       |   80 +-----
 arch/xtensa/include/asm/rwsem.h                    |   37 ---
 include/linux/kthread.h                            |    2 +-
 include/linux/rwlock_types.h                       |    8 -
 include/linux/rwsem-spinlock.h                     |   31 +--
 include/linux/rwsem.h                              |   53 ++++-
 include/linux/spinlock_types.h                     |    8 -
 kernel/cred.c                                      |    2 +-
 kernel/futex.c                                     |   22 +-
 kernel/rtmutex-debug.c                             |    1 -
 kernel/rtmutex-tester.c                            |   40 +---
 kernel/rtmutex.c                                   |  318 +++++++-------------
 kernel/rtmutex_common.h                            |   16 +-
 kernel/timer.c                                     |   23 ++
 lib/rwsem.c                                        |   10 +-
 scripts/checkpatch.pl                              |    5 -
 scripts/rt-tester/rt-tester.py                     |    2 -
 scripts/rt-tester/t2-l1-2rt-sameprio.tst           |    5 -
 scripts/rt-tester/t2-l1-pi.tst                     |    5 -
 scripts/rt-tester/t2-l1-signal.tst                 |    5 -
 scripts/rt-tester/t2-l2-2rt-deadlock.tst           |    5 -
 scripts/rt-tester/t3-l1-pi-1rt.tst                 |    5 -
 scripts/rt-tester/t3-l1-pi-2rt.tst                 |    5 -
 scripts/rt-tester/t3-l1-pi-3rt.tst                 |    5 -
 scripts/rt-tester/t3-l1-pi-signal.tst              |    5 -
 scripts/rt-tester/t3-l1-pi-steal.tst               |    5 -
 scripts/rt-tester/t3-l2-pi.tst                     |    5 -
 scripts/rt-tester/t4-l2-pi-deboost.tst             |    5 -
 .../rt-tester/t5-l4-pi-boost-deboost-setsched.tst  |    5 -
 scripts/rt-tester/t5-l4-pi-boost-deboost.tst       |    5 -
 41 files changed, 230 insertions(+), 818 deletions(-)

diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 178c831..2e3c64b 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -86,7 +86,7 @@ to change the variables it has to get an exclusive write lock.
 
 The routines look the same as above:
 
-   rwlock_t xxx_lock = RW_LOCK_UNLOCKED;
+   rwlock_t xxx_lock = __RW_LOCK_UNLOCKED(xxx_lock);
 
 	unsigned long flags;
 
@@ -196,25 +196,3 @@ appropriate:
 
 For static initialization, use DEFINE_SPINLOCK() / DEFINE_RWLOCK() or
 __SPIN_LOCK_UNLOCKED() / __RW_LOCK_UNLOCKED() as appropriate.
-
-SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated.  These interfere
-with lockdep state tracking.
-
-Most of the time, you can simply turn:
-	static spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
-into:
-	static DEFINE_SPINLOCK(xxx_lock);
-
-Static structure member variables go from:
-
-	struct foo bar {
-		.lock	=	SPIN_LOCK_UNLOCKED;
-	};
-
-to:
-
-	struct foo bar {
-		.lock	=	__SPIN_LOCK_UNLOCKED(bar.lock);
-	};
-
-Declaration of static rw_locks undergo a similar transformation.
diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 1570c0b..a83bbea 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -13,44 +13,13 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
 
-struct rwsem_waiter;
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
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
-
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
-	LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
 
 static inline void __down_read(struct rw_semaphore *sem)
 {
@@ -250,10 +219,5 @@ static inline long rwsem_atomic_update(long val, struct rw_semaphore *sem)
 #endif
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 84fed3b..4c9e3e1 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -26,7 +26,9 @@
 #define FLUSH_ALL (void*)0xffffffff
 
 /* Vector of locks used for various atomic operations */
-spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
+spinlock_t cris_atomic_locks[] = {
+	[0 ... LOCK_COUNT - 1] = __SPIN_LOCK_UNLOCKED(cris_atomic_locks)
+};
 
 /* CPU masks */
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 215d545..3027e75 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -25,20 +25,8 @@
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
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
@@ -46,26 +34,6 @@ struct rw_semaphore {
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	  LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
-static inline void
-init_rwsem (struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
 /*
  * lock for reading
  */
@@ -174,9 +142,4 @@ __downgrade_write (struct rw_semaphore *sem)
 #define rwsem_atomic_add(delta, sem)	atomic64_add(delta, (atomic64_t *)(&(sem)->count))
 #define rwsem_atomic_update(delta, sem)	atomic64_add_return(delta, (atomic64_t *)(&(sem)->count))
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* _ASM_IA64_RWSEM_H */
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 6a1fdfe..ab52b7c 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -148,9 +148,9 @@ struct {
 	spinlock_t tc_list_lock;
 	struct list_head tc_list;	/* Thread contexts */
 } vpecontrol = {
-	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
+	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpe_list_lock),
 	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
-	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
+	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(tc_list_lock),
 	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
 };
 
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 8447d89..bb1e2cd 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -13,11 +13,6 @@
  * by Paul Mackerras <paulus@samba.org>.
  */
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
@@ -33,47 +28,6 @@
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
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name)				\
-{								\
-	RWSEM_UNLOCKED_VALUE,					\
-	__SPIN_LOCK_UNLOCKED((name).wait_lock),			\
-	LIST_HEAD_INIT((name).wait_list)			\
-	__RWSEM_DEP_MAP_INIT(name)				\
-}
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)					\
-	do {						\
-		static struct lock_class_key __key;	\
-							\
-		__init_rwsem((sem), #sem, &__key);	\
-	} while (0)
-
 /*
  * lock for reading
  */
@@ -174,10 +128,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return sem->count != 0;
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_RWSEM_H */
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 423fdda..d0eb465 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -43,29 +43,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_write(struct rw_semaphore *);
-
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
@@ -81,41 +58,6 @@ struct rw_semaphore {
 #define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
 /*
- * initialisation
- */
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
- { RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait.lock), \
-   LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)				\
-do {						\
-	static struct lock_class_key __key;	\
-						\
-	__init_rwsem((sem), #sem, &__key);	\
-} while (0)
-
-
-/*
  * lock for reading
  */
 static inline void __down_read(struct rw_semaphore *sem)
@@ -377,10 +319,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	return new;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index 06e2251..edab572 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -11,64 +11,13 @@
 #endif
 
 #ifdef __KERNEL__
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	long		count;
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
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	  LIST_HEAD_INIT((name).wait_list) \
-	  __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)				\
-do {						\
-	static struct lock_class_key __key;	\
-						\
-	__init_rwsem((sem), #sem, &__key);	\
-} while (0)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
 
 /*
  * lock for reading
@@ -179,10 +128,5 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_SH_RWSEM_H */
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index a2b4302..069bf4d 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -13,53 +13,12 @@
 
 #ifdef __KERNEL__
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
-struct rw_semaphore {
-	signed long			count;
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
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
 
 /*
  * lock for reading
@@ -160,11 +119,6 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	return atomic64_add_return(delta, (atomic64_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index cbddeb3..d3c7a12 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -16,7 +16,7 @@
 #define ATOMIC_HASH(a)	(&__atomic_hash[(((unsigned long)a)>>8) & (ATOMIC_HASH_SIZE-1)])
 
 spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
-	[0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
+	[0 ... (ATOMIC_HASH_SIZE-1)] = __SPIN_LOCK_UNLOCKED(__atomic_hash)
 };
 
 #else /* SMP */
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index ba4a98b..620f5b7 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -185,7 +185,7 @@ struct ubd {
 	.no_cow =               0, \
 	.shared =		0, \
 	.cow =			DEFAULT_COW, \
-	.lock =			SPIN_LOCK_UNLOCKED,	\
+	.lock =			__SPIN_LOCK_UNLOCKED(ubd_devs.lock), \
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index d1e41b0..df4cd32 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -37,26 +37,9 @@
 #endif
 
 #ifdef __KERNEL__
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/lockdep.h>
 #include <asm/asm.h>
 
-struct rwsem_waiter;
-
-extern asmregparm struct rw_semaphore *
- rwsem_down_read_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *
- rwsem_down_write_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *
- rwsem_wake(struct rw_semaphore *);
-extern asmregparm struct rw_semaphore *
- rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
- * the semaphore definition
- *
  * The bias values and the counter type limits the number of
  * potential readers/writers to 32767 for 32 bits and 2147483647
  * for 64 bits.
@@ -74,43 +57,6 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-typedef signed long rwsem_count_t;
-
-struct rw_semaphore {
-	rwsem_count_t		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
-};
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-
-#define __RWSEM_INITIALIZER(name)				\
-{								\
-	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) \
-}
-
-#define DECLARE_RWSEM(name)					\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
-
 /*
  * lock for reading
  */
@@ -133,7 +79,7 @@ static inline void __down_read(struct rw_semaphore *sem)
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	rwsem_count_t result, tmp;
+	long result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
@@ -155,7 +101,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* adds 0xffff0001, returns the old value */
@@ -180,9 +126,8 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	rwsem_count_t ret = cmpxchg(&sem->count,
-				    RWSEM_UNLOCKED_VALUE,
-				    RWSEM_ACTIVE_WRITE_BIAS);
+	long ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+			   RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
 	return 0;
@@ -193,7 +138,7 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -211,7 +156,7 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 0xffff0001, returns the old value */
@@ -247,8 +192,7 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(rwsem_count_t delta,
-				    struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
 	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
 		     : "+m" (sem->count)
@@ -258,10 +202,9 @@ static inline void rwsem_atomic_add(rwsem_count_t delta,
 /*
  * implement exchange and add functionality
  */
-static inline rwsem_count_t rwsem_atomic_update(rwsem_count_t delta,
-						struct rw_semaphore *sem)
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp = delta;
+	long tmp = delta;
 
 	asm volatile(LOCK_PREFIX "xadd %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)
@@ -270,10 +213,5 @@ static inline rwsem_count_t rwsem_atomic_update(rwsem_count_t delta,
 	return tmp + delta;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_RWSEM_H */
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index e39edf5..249619e 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -17,44 +17,12 @@
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
-
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
-	  LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
 
 /*
  * lock for reading
@@ -160,9 +128,4 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif	/* _XTENSA_RWSEM_H */
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index ce0775a..7ff16f7 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -64,7 +64,7 @@ struct kthread_work {
 };
 
 #define KTHREAD_WORKER_INIT(worker)	{				\
-	.lock = SPIN_LOCK_UNLOCKED,					\
+	.lock = __SPIN_LOCK_UNLOCKED((worker).lock),			\
 	.work_list = LIST_HEAD_INIT((worker).work_list),		\
 	}
 
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index bd31808..cc0072e 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -43,14 +43,6 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-/*
- * RW_LOCK_UNLOCKED defeat lockdep state tracking and is hence
- * deprecated.
- *
- * Please use DEFINE_RWLOCK() or __RW_LOCK_UNLOCKED() as appropriate.
- */
-#define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
-
 #define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
 
 #endif /* __LINUX_RWLOCK_TYPES_H */
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..3470124 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -12,15 +12,7 @@
 #error "please don't include linux/rwsem-spinlock.h directly, use linux/rwsem.h instead"
 #endif
 
-#include <linux/spinlock.h>
-#include <linux/list.h>
-
 #ifdef __KERNEL__
-
-#include <linux/types.h>
-
-struct rwsem_waiter;
-
 /*
  * the rw-semaphore definition
  * - if activity is 0 then there are no active readers or writers
@@ -37,28 +29,7 @@ struct rw_semaphore {
 #endif
 };
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-{ 0, __SPIN_LOCK_UNLOCKED(name.wait_lock), LIST_HEAD_INIT((name).wait_list) \
-  __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
+#define RWSEM_UNLOCKED_VALUE		0x00000000
 
 extern void __down_read(struct rw_semaphore *sem);
 extern int __down_read_trylock(struct rw_semaphore *sem);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..a8afe9c 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -11,6 +11,9 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
 #include <asm/system.h>
 #include <asm/atomic.h>
 
@@ -19,9 +22,57 @@ struct rw_semaphore;
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
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+
+/* Include the arch specific part */
+#include <asm/rwsem.h>
+
+/* In all implementations count != 0 means locked */
+static inline int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	return sem->count != 0;
+}
+
+#endif
+
+/* Common initializer macros and functions */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#else
+# define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
+#define __RWSEM_INITIALIZER(name) \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+
+#define DECLARE_RWSEM(name) \
+	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
+
+extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
+			 struct lock_class_key *key);
+
+#define init_rwsem(sem)						\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__init_rwsem((sem), #sem, &__key);			\
+} while (0)
+
 /*
  * lock for reading
  */
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 851b778..73548eb 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -81,14 +81,6 @@ typedef struct spinlock {
 #define __SPIN_LOCK_UNLOCKED(lockname) \
 	(spinlock_t ) __SPIN_LOCK_INITIALIZER(lockname)
 
-/*
- * SPIN_LOCK_UNLOCKED defeats lockdep state tracking and is hence
- * deprecated.
- * Please use DEFINE_SPINLOCK() or __SPIN_LOCK_UNLOCKED() as
- * appropriate.
- */
-#define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
-
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
 
 #include <linux/rwlock_types.h>
diff --git a/kernel/cred.c b/kernel/cred.c
index 3a9d6dd..2343c13 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -35,7 +35,7 @@ static struct kmem_cache *cred_jar;
 static struct thread_group_cred init_tgcred = {
 	.usage	= ATOMIC_INIT(2),
 	.tgid	= 0,
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(init_cred.tgcred.lock),
 };
 #endif
 
diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..64c3811 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1556,10 +1556,10 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 	/*
 	 * We are here either because we stole the rtmutex from the
-	 * pending owner or we are the pending owner which failed to
-	 * get the rtmutex. We have to replace the pending owner TID
-	 * in the user space variable. This must be atomic as we have
-	 * to preserve the owner died bit here.
+	 * previous highest priority waiter or we are the highest priority
+	 * waiter but failed to get the rtmutex the first time.
+	 * We have to replace the newowner TID in the user space variable.
+	 * This must be atomic as we have to preserve the owner died bit here.
 	 *
 	 * Note: We write the user space value _before_ changing the pi_state
 	 * because we can fault here. Imagine swapped out pages or a fork
@@ -1608,8 +1608,8 @@ retry:
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
-	 * lock here. That gives the other task (either the pending
-	 * owner itself or the task which stole the rtmutex) the
+	 * lock here. That gives the other task (either the highest priority
+	 * waiter itself or the task which stole the rtmutex) the
 	 * chance to try the fixup of the pi_state. So once we are
 	 * back from handling the fault we need to check the pi_state
 	 * after reacquiring the hash bucket lock and before trying to
@@ -1685,18 +1685,20 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		/*
 		 * pi_state is incorrect, some other task did a lock steal and
 		 * we returned due to timeout or signal without taking the
-		 * rt_mutex. Too late. We can access the rt_mutex_owner without
-		 * locking, as the other task is now blocked on the hash bucket
-		 * lock. Fix the state up.
+		 * rt_mutex. Too late.
 		 */
+		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
+		if (!owner)
+			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
+		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
 		ret = fixup_pi_state_owner(uaddr, q, owner);
 		goto out;
 	}
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner, nor the pending owner, of the rt_mutex.
+	 * the owner of the rt_mutex.
 	 */
 	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
 		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index ddabb54..3c7cbc2 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -215,7 +215,6 @@ void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 	put_pid(waiter->deadlock_task_pid);
 	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
 	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-	TRACE_WARN_ON(waiter->task);
 	memset(waiter, 0x22, sizeof(*waiter));
 }
 
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 66cb89b..5c9ccd3 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -9,7 +9,6 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/sysdev.h>
 #include <linux/timer.h>
@@ -27,7 +26,6 @@ struct test_thread_data {
 	int			opcode;
 	int			opdata;
 	int			mutexes[MAX_RT_TEST_MUTEXES];
-	int			bkl;
 	int			event;
 	struct sys_device	sysdev;
 };
@@ -46,9 +44,8 @@ enum test_opcodes {
 	RTTEST_LOCKINTNOWAIT,	/* 6 Lock interruptible no wait in wakeup, data = lockindex */
 	RTTEST_LOCKCONT,	/* 7 Continue locking after the wakeup delay */
 	RTTEST_UNLOCK,		/* 8 Unlock, data = lockindex */
-	RTTEST_LOCKBKL,		/* 9 Lock BKL */
-	RTTEST_UNLOCKBKL,	/* 10 Unlock BKL */
-	RTTEST_SIGNAL,		/* 11 Signal other test thread, data = thread id */
+	/* 9, 10 - reserved for BKL commemoration */
+	RTTEST_SIGNAL = 11,	/* 11 Signal other test thread, data = thread id */
 	RTTEST_RESETEVENT = 98,	/* 98 Reset event counter */
 	RTTEST_RESET = 99,	/* 99 Reset all pending operations */
 };
@@ -74,13 +71,6 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 				td->mutexes[i] = 0;
 			}
 		}
-
-		if (!lockwakeup && td->bkl == 4) {
-#ifdef CONFIG_LOCK_KERNEL
-			unlock_kernel();
-#endif
-			td->bkl = 0;
-		}
 		return 0;
 
 	case RTTEST_RESETEVENT:
@@ -131,25 +121,6 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		td->mutexes[id] = 0;
 		return 0;
 
-	case RTTEST_LOCKBKL:
-		if (td->bkl)
-			return 0;
-		td->bkl = 1;
-#ifdef CONFIG_LOCK_KERNEL
-		lock_kernel();
-#endif
-		td->bkl = 4;
-		return 0;
-
-	case RTTEST_UNLOCKBKL:
-		if (td->bkl != 4)
-			break;
-#ifdef CONFIG_LOCK_KERNEL
-		unlock_kernel();
-#endif
-		td->bkl = 0;
-		return 0;
-
 	default:
 		break;
 	}
@@ -196,7 +167,6 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 		td->event = atomic_add_return(1, &rttest_event);
 		break;
 
-	case RTTEST_LOCKBKL:
 	default:
 		break;
 	}
@@ -229,8 +199,6 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 		td->event = atomic_add_return(1, &rttest_event);
 		return;
 
-	case RTTEST_LOCKBKL:
-		return;
 	default:
 		return;
 	}
@@ -380,11 +348,11 @@ static ssize_t sysfs_test_status(struct sys_device *dev, struct sysdev_attribute
 	spin_lock(&rttest_lock);
 
 	curr += sprintf(curr,
-		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, K: %d, M:",
+		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, M:",
 		td->opcode, td->event, tsk->state,
 			(MAX_RT_PRIO - 1) - tsk->prio,
 			(MAX_RT_PRIO - 1) - tsk->normal_prio,
-		tsk->pi_blocked_on, td->bkl);
+		tsk->pi_blocked_on);
 
 	for (i = MAX_RT_TEST_MUTEXES - 1; i >=0 ; i--)
 		curr += sprintf(curr, "%d", td->mutexes[i]);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a960481..ab44911 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -20,41 +20,34 @@
 /*
  * lock->owner state tracking:
  *
- * lock->owner holds the task_struct pointer of the owner. Bit 0 and 1
- * are used to keep track of the "owner is pending" and "lock has
- * waiters" state.
+ * lock->owner holds the task_struct pointer of the owner. Bit 0
+ * is used to keep track of the "lock has waiters" state.
  *
- * owner	bit1	bit0
- * NULL		0	0	lock is free (fast acquire possible)
- * NULL		0	1	invalid state
- * NULL		1	0	Transitional State*
- * NULL		1	1	invalid state
- * taskpointer	0	0	lock is held (fast release possible)
- * taskpointer	0	1	task is pending owner
- * taskpointer	1	0	lock is held and has waiters
- * taskpointer	1	1	task is pending owner and lock has more waiters
- *
- * Pending ownership is assigned to the top (highest priority)
- * waiter of the lock, when the lock is released. The thread is woken
- * up and can now take the lock. Until the lock is taken (bit 0
- * cleared) a competing higher priority thread can steal the lock
- * which puts the woken up thread back on the waiters list.
+ * owner	bit0
+ * NULL		0	lock is free (fast acquire possible)
+ * NULL		1	lock is free and has waiters and the top waiter
+ *				is going to take the lock*
+ * taskpointer	0	lock is held (fast release possible)
+ * taskpointer	1	lock is held and has waiters**
  *
  * The fast atomic compare exchange based acquire and release is only
- * possible when bit 0 and 1 of lock->owner are 0.
+ * possible when bit 0 of lock->owner is 0.
+ *
+ * (*) It also can be a transitional state when grabbing the lock
+ * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
+ * we need to set the bit0 before looking at the lock, and the owner may be
+ * NULL in this small time, hence this can be a transitional state.
  *
- * (*) There's a small time where the owner can be NULL and the
- * "lock has waiters" bit is set.  This can happen when grabbing the lock.
- * To prevent a cmpxchg of the owner releasing the lock, we need to set this
- * bit before looking at the lock, hence the reason this is a transitional
- * state.
+ * (**) There is a small time when bit 0 is set but there are no
+ * waiters. This can happen when grabbing the lock in the slow path.
+ * To prevent a cmpxchg of the owner releasing the lock, we need to
+ * set this bit before looking at the lock.
  */
 
 static void
-rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
-		   unsigned long mask)
+rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner)
 {
-	unsigned long val = (unsigned long)owner | mask;
+	unsigned long val = (unsigned long)owner;
 
 	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
@@ -203,15 +196,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * reached or the state of the chain has changed while we
 	 * dropped the locks.
 	 */
-	if (!waiter || !waiter->task)
+	if (!waiter)
 		goto out_unlock_pi;
 
 	/*
 	 * Check the orig_waiter state. After we dropped the locks,
-	 * the previous owner of the lock might have released the lock
-	 * and made us the pending owner:
+	 * the previous owner of the lock might have released the lock.
 	 */
-	if (orig_waiter && !orig_waiter->task)
+	if (orig_waiter && !rt_mutex_owner(orig_lock))
 		goto out_unlock_pi;
 
 	/*
@@ -254,6 +246,17 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	if (!rt_mutex_owner(lock)) {
+		/*
+		 * If the requeue above changed the top waiter, then we need
+		 * to wake the new top waiter up to try to get the lock.
+		 */
+
+		if (top_waiter != rt_mutex_top_waiter(lock))
+			wake_up_process(rt_mutex_top_waiter(lock)->task);
+		raw_spin_unlock(&lock->wait_lock);
+		goto out_put_task;
+	}
 	put_task_struct(task);
 
 	/* Grab the next task */
@@ -296,78 +299,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 }
 
 /*
- * Optimization: check if we can steal the lock from the
- * assigned pending owner [which might not have taken the
- * lock yet]:
- */
-static inline int try_to_steal_lock(struct rt_mutex *lock,
-				    struct task_struct *task)
-{
-	struct task_struct *pendowner = rt_mutex_owner(lock);
-	struct rt_mutex_waiter *next;
-	unsigned long flags;
-
-	if (!rt_mutex_owner_pending(lock))
-		return 0;
-
-	if (pendowner == task)
-		return 1;
-
-	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
-	if (task->prio >= pendowner->prio) {
-		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-		return 0;
-	}
-
-	/*
-	 * Check if a waiter is enqueued on the pending owners
-	 * pi_waiters list. Remove it and readjust pending owners
-	 * priority.
-	 */
-	if (likely(!rt_mutex_has_waiters(lock))) {
-		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-		return 1;
-	}
-
-	/* No chain handling, pending owner is not blocked on anything: */
-	next = rt_mutex_top_waiter(lock);
-	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
-	__rt_mutex_adjust_prio(pendowner);
-	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-
-	/*
-	 * We are going to steal the lock and a waiter was
-	 * enqueued on the pending owners pi_waiters queue. So
-	 * we have to enqueue this waiter into
-	 * task->pi_waiters list. This covers the case,
-	 * where task is boosted because it holds another
-	 * lock and gets unboosted because the booster is
-	 * interrupted, so we would delay a waiter with higher
-	 * priority as task->normal_prio.
-	 *
-	 * Note: in the rare case of a SCHED_OTHER task changing
-	 * its priority and thus stealing the lock, next->task
-	 * might be task:
-	 */
-	if (likely(next->task != task)) {
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &task->pi_waiters);
-		__rt_mutex_adjust_prio(task);
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	}
-	return 1;
-}
-
-/*
  * Try to take an rt-mutex
  *
- * This fails
- * - when the lock has a real owner
- * - when a different pending owner exists and has higher priority than current
- *
  * Must be called with lock->wait_lock held.
+ *
+ * @lock:   the lock to be acquired.
+ * @task:   the task which wants to acquire the lock
+ * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
  */
-static int try_to_take_rt_mutex(struct rt_mutex *lock)
+static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
+		struct rt_mutex_waiter *waiter)
 {
 	/*
 	 * We have to be careful here if the atomic speedups are
@@ -390,15 +331,52 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
+	if (rt_mutex_owner(lock))
 		return 0;
 
+	/*
+	 * It will get the lock because of one of these conditions:
+	 * 1) there is no waiter
+	 * 2) higher priority than waiters
+	 * 3) it is top waiter
+	 */
+	if (rt_mutex_has_waiters(lock)) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
+			if (!waiter || waiter != rt_mutex_top_waiter(lock))
+				return 0;
+		}
+	}
+
+	if (waiter || rt_mutex_has_waiters(lock)) {
+		unsigned long flags;
+		struct rt_mutex_waiter *top;
+
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/* remove the queued waiter. */
+		if (waiter) {
+			plist_del(&waiter->list_entry, &lock->wait_list);
+			task->pi_blocked_on = NULL;
+		}
+
+		/*
+		 * We have to enqueue the top waiter(if it exists) into
+		 * task->pi_waiters list.
+		 */
+		if (rt_mutex_has_waiters(lock)) {
+			top = rt_mutex_top_waiter(lock);
+			top->pi_list_entry.prio = top->list_entry.prio;
+			plist_add(&top->pi_list_entry, &task->pi_waiters);
+		}
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
+
 	/* We got the lock. */
 	debug_rt_mutex_lock(lock);
 
-	rt_mutex_set_owner(lock, current, 0);
+	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, current);
+	rt_mutex_deadlock_account_lock(lock, task);
 
 	return 1;
 }
@@ -436,6 +414,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
+	if (!owner)
+		return 0;
+
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
@@ -472,21 +453,18 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 /*
  * Wake up the next waiter on the lock.
  *
- * Remove the top waiter from the current tasks waiter list and from
- * the lock waiter list. Set it as pending owner. Then wake it up.
+ * Remove the top waiter from the current tasks waiter list and wake it up.
  *
  * Called with lock->wait_lock held.
  */
 static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
-	struct task_struct *pendowner;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 
 	waiter = rt_mutex_top_waiter(lock);
-	plist_del(&waiter->list_entry, &lock->wait_list);
 
 	/*
 	 * Remove it from current->pi_waiters. We do not adjust a
@@ -495,43 +473,19 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 * lock->wait_lock.
 	 */
 	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
-	pendowner = waiter->task;
-	waiter->task = NULL;
 
-	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
+	rt_mutex_set_owner(lock, NULL);
 
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	/*
-	 * Clear the pi_blocked_on variable and enqueue a possible
-	 * waiter into the pi_waiters list of the pending owner. This
-	 * prevents that in case the pending owner gets unboosted a
-	 * waiter with higher priority than pending-owner->normal_prio
-	 * is blocked on the unboosted (pending) owner.
-	 */
-	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
-
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
-
-	pendowner->pi_blocked_on = NULL;
-
-	if (rt_mutex_has_waiters(lock)) {
-		struct rt_mutex_waiter *next;
-
-		next = rt_mutex_top_waiter(lock);
-		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
-	}
-	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-
-	wake_up_process(pendowner);
+	wake_up_process(waiter->task);
 }
 
 /*
- * Remove a waiter from a lock
+ * Remove a waiter from a lock and give up
  *
- * Must be called with lock->wait_lock held
+ * Must be called with lock->wait_lock held and
+ * have just failed to try_to_take_rt_mutex().
  */
 static void remove_waiter(struct rt_mutex *lock,
 			  struct rt_mutex_waiter *waiter)
@@ -543,11 +497,13 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->task = NULL;
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (first && owner != current) {
+	if (!owner)
+		return;
+
+	if (first) {
 
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
@@ -614,21 +570,19 @@ void rt_mutex_adjust_pi(struct task_struct *task)
  * 			 or TASK_UNINTERRUPTIBLE)
  * @timeout:		 the pre-initialized and started timer, or NULL for none
  * @waiter:		 the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
  *
  * lock->wait_lock must be held by the caller.
  */
 static int __sched
 __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct hrtimer_sleeper *timeout,
-		    struct rt_mutex_waiter *waiter,
-		    int detect_deadlock)
+		    struct rt_mutex_waiter *waiter)
 {
 	int ret = 0;
 
 	for (;;) {
 		/* Try to acquire the lock: */
-		if (try_to_take_rt_mutex(lock))
+		if (try_to_take_rt_mutex(lock, current, waiter))
 			break;
 
 		/*
@@ -645,39 +599,11 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		/*
-		 * waiter->task is NULL the first time we come here and
-		 * when we have been woken up by the previous owner
-		 * but the lock got stolen by a higher prio task.
-		 */
-		if (!waiter->task) {
-			ret = task_blocks_on_rt_mutex(lock, waiter, current,
-						      detect_deadlock);
-			/*
-			 * If we got woken up by the owner then start loop
-			 * all over without going into schedule to try
-			 * to get the lock now:
-			 */
-			if (unlikely(!waiter->task)) {
-				/*
-				 * Reset the return value. We might
-				 * have returned with -EDEADLK and the
-				 * owner released the lock while we
-				 * were walking the pi chain.
-				 */
-				ret = 0;
-				continue;
-			}
-			if (unlikely(ret))
-				break;
-		}
-
 		raw_spin_unlock(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
-		if (waiter->task)
-			schedule_rt_mutex(lock);
+		schedule_rt_mutex(lock);
 
 		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
@@ -698,12 +624,11 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
 
 	raw_spin_lock(&lock->wait_lock);
 
 	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
+	if (try_to_take_rt_mutex(lock, current, NULL)) {
 		raw_spin_unlock(&lock->wait_lock);
 		return 0;
 	}
@@ -717,12 +642,14 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
-				  detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+
+	if (likely(!ret))
+		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter.task))
+	if (unlikely(ret))
 		remove_waiter(lock, &waiter);
 
 	/*
@@ -737,14 +664,6 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	if (unlikely(timeout))
 		hrtimer_cancel(&timeout->timer);
 
-	/*
-	 * Readjust priority, when we did not get the lock. We might
-	 * have been the pending owner and boosted. Since we did not
-	 * take the lock, the PI boost has to go.
-	 */
-	if (unlikely(ret))
-		rt_mutex_adjust_prio(current);
-
 	debug_rt_mutex_free_waiter(&waiter);
 
 	return ret;
@@ -762,7 +681,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 
 	if (likely(rt_mutex_owner(lock) != current)) {
 
-		ret = try_to_take_rt_mutex(lock);
+		ret = try_to_take_rt_mutex(lock, current, NULL);
 		/*
 		 * try_to_take_rt_mutex() sets the lock waiters
 		 * bit unconditionally. Clean this up.
@@ -992,7 +911,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 {
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
-	rt_mutex_set_owner(lock, proxy_owner, 0);
+	rt_mutex_set_owner(lock, proxy_owner);
 	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
@@ -1008,7 +927,7 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 			   struct task_struct *proxy_owner)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL, 0);
+	rt_mutex_set_owner(lock, NULL);
 	rt_mutex_deadlock_account_unlock(proxy_owner);
 }
 
@@ -1034,20 +953,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_lock(&lock->wait_lock);
 
-	mark_rt_mutex_waiters(lock);
-
-	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
-		/* We got the lock for task. */
-		debug_rt_mutex_lock(lock);
-		rt_mutex_set_owner(lock, task, 0);
+	if (try_to_take_rt_mutex(lock, task, NULL)) {
 		raw_spin_unlock(&lock->wait_lock);
-		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
-	if (ret && !waiter->task) {
+	if (ret && !rt_mutex_owner(lock)) {
 		/*
 		 * Reset the return value. We might have
 		 * returned with -EDEADLK and the owner
@@ -1056,6 +969,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		 */
 		ret = 0;
 	}
+
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
+
 	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
@@ -1110,12 +1027,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
-				  detect_deadlock);
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter->task))
+	if (unlikely(ret))
 		remove_waiter(lock, waiter);
 
 	/*
@@ -1126,13 +1042,5 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	/*
-	 * Readjust priority, when we did not get the lock. We might have been
-	 * the pending owner and boosted. Since we did not take the lock, the
-	 * PI boost has to go.
-	 */
-	if (unlikely(ret))
-		rt_mutex_adjust_prio(current);
-
 	return ret;
 }
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 97a2f81..53a66c8 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -91,9 +91,8 @@ task_top_pi_waiter(struct task_struct *p)
 /*
  * lock->owner state tracking:
  */
-#define RT_MUTEX_OWNER_PENDING	1UL
-#define RT_MUTEX_HAS_WAITERS	2UL
-#define RT_MUTEX_OWNER_MASKALL	3UL
+#define RT_MUTEX_HAS_WAITERS	1UL
+#define RT_MUTEX_OWNER_MASKALL	1UL
 
 static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
 {
@@ -101,17 +100,6 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
 		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
 }
 
-static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
-{
-	return (struct task_struct *)
-		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
-}
-
-static inline unsigned long rt_mutex_owner_pending(struct rt_mutex *lock)
-{
-	return (unsigned long)lock->owner & RT_MUTEX_OWNER_PENDING;
-}
-
 /*
  * PI-futex support (proxy locking functions, etc.):
  */
diff --git a/kernel/timer.c b/kernel/timer.c
index d645992..5f40c2e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -964,6 +964,25 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
  *
+ * Note: You must not hold locks that are held in interrupt context
+ *   while calling this function. Even if the lock has nothing to do
+ *   with the timer in question.  Here's why:
+ *
+ *    CPU0                             CPU1
+ *    ----                             ----
+ *                                   <SOFTIRQ>
+ *                                   call_timer_fn();
+ *                                     base->running_timer = mytimer;
+ *  spin_lock_irq(somelock);
+ *                                     <IRQ>
+ *                                        spin_lock(somelock);
+ *  del_timer_sync(mytimer);
+ *   while (base->running_timer == mytimer);
+ *
+ * Now del_timer_sync() will never return and never release somelock.
+ * The interrupt on the other CPU is waiting to grab somelock but
+ * it has interrupted the softirq that CPU0 is waiting to finish.
+ *
  * The function returns whether it has deactivated a pending timer or not.
  */
 int del_timer_sync(struct timer_list *timer)
@@ -971,6 +990,10 @@ int del_timer_sync(struct timer_list *timer)
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
+	/*
+	 * If lockdep gives a backtrace here, please reference
+	 * the synchronization rules above.
+	 */
 	local_irq_save(flags);
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
diff --git a/lib/rwsem.c b/lib/rwsem.c
index f236d7c..aa7c305 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -222,8 +222,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 /*
  * wait for the read lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_read_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
 					-RWSEM_ACTIVE_READ_BIAS);
@@ -232,8 +231,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait for the write lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_write_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
 					-RWSEM_ACTIVE_WRITE_BIAS);
@@ -243,7 +241,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -263,7 +261,7 @@ asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..58848e3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2654,11 +2654,6 @@ sub process {
 			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
-# SPIN_LOCK_UNLOCKED & RW_LOCK_UNLOCKED are deprecated
-		if ($line =~ /\b(SPIN_LOCK_UNLOCKED|RW_LOCK_UNLOCKED)/) {
-			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n" . $herecurr);
-		}
-
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("if this code is redundant consider removing it\n" .
diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
index 44423b4..8c81d76 100644
--- a/scripts/rt-tester/rt-tester.py
+++ b/scripts/rt-tester/rt-tester.py
@@ -33,8 +33,6 @@ cmd_opcodes = {
     "lockintnowait" : "6",
     "lockcont"      : "7",
     "unlock"        : "8",
-    "lockbkl"       : "9",
-    "unlockbkl"     : "10",
     "signal"        : "11",
     "resetevent"    : "98",
     "reset"         : "99",
diff --git a/scripts/rt-tester/t2-l1-2rt-sameprio.tst b/scripts/rt-tester/t2-l1-2rt-sameprio.tst
index 8821f27..3710c8b 100644
--- a/scripts/rt-tester/t2-l1-2rt-sameprio.tst
+++ b/scripts/rt-tester/t2-l1-2rt-sameprio.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	0
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t2-l1-pi.tst b/scripts/rt-tester/t2-l1-pi.tst
index cde1f18..b4cc959 100644
--- a/scripts/rt-tester/t2-l1-pi.tst
+++ b/scripts/rt-tester/t2-l1-pi.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	0
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t2-l1-signal.tst b/scripts/rt-tester/t2-l1-signal.tst
index 3ab0bfc..1b57376 100644
--- a/scripts/rt-tester/t2-l1-signal.tst
+++ b/scripts/rt-tester/t2-l1-signal.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	0
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t2-l2-2rt-deadlock.tst b/scripts/rt-tester/t2-l2-2rt-deadlock.tst
index f4b5d5d..68b1062 100644
--- a/scripts/rt-tester/t2-l2-2rt-deadlock.tst
+++ b/scripts/rt-tester/t2-l2-2rt-deadlock.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	0
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l1-pi-1rt.tst b/scripts/rt-tester/t3-l1-pi-1rt.tst
index 63440ca..8e6c8b1 100644
--- a/scripts/rt-tester/t3-l1-pi-1rt.tst
+++ b/scripts/rt-tester/t3-l1-pi-1rt.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l1-pi-2rt.tst b/scripts/rt-tester/t3-l1-pi-2rt.tst
index e5816fe..69c2212 100644
--- a/scripts/rt-tester/t3-l1-pi-2rt.tst
+++ b/scripts/rt-tester/t3-l1-pi-2rt.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l1-pi-3rt.tst b/scripts/rt-tester/t3-l1-pi-3rt.tst
index 718b82b..9b0f1eb 100644
--- a/scripts/rt-tester/t3-l1-pi-3rt.tst
+++ b/scripts/rt-tester/t3-l1-pi-3rt.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l1-pi-signal.tst b/scripts/rt-tester/t3-l1-pi-signal.tst
index c6e2135..39ec74a 100644
--- a/scripts/rt-tester/t3-l1-pi-signal.tst
+++ b/scripts/rt-tester/t3-l1-pi-signal.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l1-pi-steal.tst b/scripts/rt-tester/t3-l1-pi-steal.tst
index f53749d..e03db7e 100644
--- a/scripts/rt-tester/t3-l1-pi-steal.tst
+++ b/scripts/rt-tester/t3-l1-pi-steal.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t3-l2-pi.tst b/scripts/rt-tester/t3-l2-pi.tst
index cdc3e4f..7b59100 100644
--- a/scripts/rt-tester/t3-l2-pi.tst
+++ b/scripts/rt-tester/t3-l2-pi.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t4-l2-pi-deboost.tst b/scripts/rt-tester/t4-l2-pi-deboost.tst
index baa1413..2f0e049 100644
--- a/scripts/rt-tester/t4-l2-pi-deboost.tst
+++ b/scripts/rt-tester/t4-l2-pi-deboost.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t5-l4-pi-boost-deboost-setsched.tst b/scripts/rt-tester/t5-l4-pi-boost-deboost-setsched.tst
index e6ec0c8..04f4034 100644
--- a/scripts/rt-tester/t5-l4-pi-boost-deboost-setsched.tst
+++ b/scripts/rt-tester/t5-l4-pi-boost-deboost-setsched.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
diff --git a/scripts/rt-tester/t5-l4-pi-boost-deboost.tst b/scripts/rt-tester/t5-l4-pi-boost-deboost.tst
index ca64f8b..a48a6ee 100644
--- a/scripts/rt-tester/t5-l4-pi-boost-deboost.tst
+++ b/scripts/rt-tester/t5-l4-pi-boost-deboost.tst
@@ -19,8 +19,6 @@
 # lockintnowait	lock nr (0-7)
 # lockcont	lock nr (0-7)
 # unlock	lock nr (0-7)
-# lockbkl	lock nr (0-7)
-# unlockbkl	lock nr (0-7)
 # signal	thread to signal (0-7)
 # reset		0
 # resetevent	0
@@ -39,9 +37,6 @@
 # blocked	lock nr (0-7)
 # blockedwake	lock nr (0-7)
 # unlocked	lock nr (0-7)
-# lockedbkl	dont care
-# blockedbkl	dont care
-# unlockedbkl	dont care
 # opcodeeq	command opcode or number
 # opcodelt	number
 # opcodegt	number
