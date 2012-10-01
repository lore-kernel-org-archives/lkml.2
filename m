Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2JAMKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:10:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56090 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2JAMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:10:34 -0400
Date: Mon, 1 Oct 2012 14:10:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.7
Message-ID: <20121001121029.GA21377@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 4fe84fb8c6b5081f7364af63aee8e118a665b966 locking: Adjust spin lock inlining Kconfig options

It includes a lockdep improvement plus a spinlock inlining 
Kconfig cleanup.

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      locking: Adjust spin lock inlining Kconfig options

Maarten Lankhorst (1):
      lockdep: Check if nested lock is actually held


 kernel/Kconfig.locks | 103 +++++++++++++++++++++++++++++++--------------------
 kernel/lockdep.c     |  39 +++++++++++++++++++
 2 files changed, 102 insertions(+), 40 deletions(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 2251882..44511d1 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -87,6 +87,9 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQ
 config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	bool
 
+config UNINLINE_SPIN_UNLOCK
+	bool
+
 #
 # lock_* functions are inlined when:
 #   - DEBUG_SPINLOCK=n and GENERIC_LOCKBREAK=n and ARCH_INLINE_*LOCK=y
@@ -103,100 +106,120 @@ config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 #   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
 #
 
+if !DEBUG_SPINLOCK
+
 config INLINE_SPIN_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_SPIN_TRYLOCK
 
 config INLINE_SPIN_TRYLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_SPIN_TRYLOCK_BH
 
 config INLINE_SPIN_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
 
 config INLINE_SPIN_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_BH
 
 config INLINE_SPIN_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_IRQ
 
 config INLINE_SPIN_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
-
-config UNINLINE_SPIN_UNLOCK
-	bool
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK_IRQSAVE
 
 config INLINE_SPIN_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
 
 
 config INLINE_READ_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_READ_TRYLOCK
 
 config INLINE_READ_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
 
 config INLINE_READ_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_BH
 
 config INLINE_READ_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_IRQ
 
 config INLINE_READ_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_READ_LOCK_IRQSAVE
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK_IRQSAVE
 
 config INLINE_READ_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK
 
 config INLINE_READ_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_READ_UNLOCK_IRQRESTORE
 
 
 config INLINE_WRITE_TRYLOCK
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_TRYLOCK
+	def_bool y
+	depends on ARCH_INLINE_WRITE_TRYLOCK
 
 config INLINE_WRITE_LOCK
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
 
 config INLINE_WRITE_LOCK_BH
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_BH
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_BH
 
 config INLINE_WRITE_LOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_IRQ
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_IRQ
 
 config INLINE_WRITE_LOCK_IRQSAVE
-	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
-		 ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	def_bool y
+	depends on !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK_IRQSAVE
 
 config INLINE_WRITE_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK
 
 config INLINE_WRITE_UNLOCK_BH
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_BH
+	def_bool y
+	depends on ARCH_INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQ
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH)
+	def_bool y
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
-	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	def_bool y
+	depends on ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+
+endif
 
 config MUTEX_SPIN_ON_OWNER
-	def_bool SMP && !DEBUG_MUTEXES
+	def_bool y
+	depends on SMP && !DEBUG_MUTEXES
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..7981e5b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2998,6 +2998,42 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
 
+static int
+print_lock_nested_lock_not_held(struct task_struct *curr,
+				struct held_lock *hlock,
+				unsigned long ip)
+{
+	if (!debug_locks_off())
+		return 0;
+	if (debug_locks_silent)
+		return 0;
+
+	printk("\n");
+	printk("==================================\n");
+	printk("[ BUG: Nested lock was not taken ]\n");
+	print_kernel_ident();
+	printk("----------------------------------\n");
+
+	printk("%s/%d is trying to lock:\n", curr->comm, task_pid_nr(curr));
+	print_lock(hlock);
+
+	printk("\nbut this task is not holding:\n");
+	printk("%s\n", hlock->nest_lock->name);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	printk("\nother info that might help us debug this:\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+
+static int __lock_is_held(struct lockdep_map *lock);
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -3139,6 +3175,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	}
 	chain_key = iterate_chain_key(chain_key, id);
 
+	if (nest_lock && !__lock_is_held(nest_lock))
+		return print_lock_nested_lock_not_held(curr, hlock, ip);
+
 	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
