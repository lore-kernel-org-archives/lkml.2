Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2HSC7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:51768 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2HSC5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182675629"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 72/74] lto: Mark spinlocks noinline when inline spinlocks are disabled
Date: Sat, 18 Aug 2012 19:57:08 -0700
Message-Id: <1345345030-22211-73-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Otherwise LTO will inline them anyways

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/spinlock.c |   56 ++++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 75439be..e68917a 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -116,7 +116,7 @@ BUILD_LOCK_OPS(write, rwlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
-int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
+noinline int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return __raw_spin_trylock(lock);
 }
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(_raw_spin_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
+noinline int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
 	return __raw_spin_trylock_bh(lock);
 }
@@ -132,7 +132,7 @@ EXPORT_SYMBOL(_raw_spin_trylock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
 {
 	__raw_spin_lock(lock);
 }
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(_raw_spin_lock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
+noinline unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
 {
 	return __raw_spin_lock_irqsave(lock);
 }
@@ -148,7 +148,7 @@ EXPORT_SYMBOL(_raw_spin_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
-void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
 {
 	__raw_spin_lock_irq(lock);
 }
@@ -156,7 +156,7 @@ EXPORT_SYMBOL(_raw_spin_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_BH
-void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
 {
 	__raw_spin_lock_bh(lock);
 }
@@ -164,7 +164,7 @@ EXPORT_SYMBOL(_raw_spin_lock_bh);
 #endif
 
 #ifdef CONFIG_UNINLINE_SPIN_UNLOCK
-void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock(lock);
 }
@@ -172,7 +172,7 @@ EXPORT_SYMBOL(_raw_spin_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_unlock_irqrestore(lock, flags);
 }
@@ -180,7 +180,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock_irq(lock);
 }
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock_bh(lock);
 }
@@ -196,7 +196,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_TRYLOCK
-int __lockfunc _raw_read_trylock(rwlock_t *lock)
+noinline int __lockfunc _raw_read_trylock(rwlock_t *lock)
 {
 	return __raw_read_trylock(lock);
 }
@@ -204,7 +204,7 @@ EXPORT_SYMBOL(_raw_read_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK
-void __lockfunc _raw_read_lock(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock(rwlock_t *lock)
 {
 	__raw_read_lock(lock);
 }
@@ -212,7 +212,7 @@ EXPORT_SYMBOL(_raw_read_lock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
+noinline unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 {
 	return __raw_read_lock_irqsave(lock);
 }
@@ -220,7 +220,7 @@ EXPORT_SYMBOL(_raw_read_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQ
-void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
 {
 	__raw_read_lock_irq(lock);
 }
@@ -228,7 +228,7 @@ EXPORT_SYMBOL(_raw_read_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_BH
-void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
 {
 	__raw_read_lock_bh(lock);
 }
@@ -236,7 +236,7 @@ EXPORT_SYMBOL(_raw_read_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK
-void __lockfunc _raw_read_unlock(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock(rwlock_t *lock)
 {
 	__raw_read_unlock(lock);
 }
@@ -244,7 +244,7 @@ EXPORT_SYMBOL(_raw_read_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__raw_read_unlock_irqrestore(lock, flags);
 }
@@ -252,7 +252,7 @@ EXPORT_SYMBOL(_raw_read_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
-void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
 {
 	__raw_read_unlock_irq(lock);
 }
@@ -260,7 +260,7 @@ EXPORT_SYMBOL(_raw_read_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_BH
-void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
 {
 	__raw_read_unlock_bh(lock);
 }
@@ -268,7 +268,7 @@ EXPORT_SYMBOL(_raw_read_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_TRYLOCK
-int __lockfunc _raw_write_trylock(rwlock_t *lock)
+noinline int __lockfunc _raw_write_trylock(rwlock_t *lock)
 {
 	return __raw_write_trylock(lock);
 }
@@ -276,7 +276,7 @@ EXPORT_SYMBOL(_raw_write_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK
-void __lockfunc _raw_write_lock(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock(rwlock_t *lock)
 {
 	__raw_write_lock(lock);
 }
@@ -284,7 +284,7 @@ EXPORT_SYMBOL(_raw_write_lock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
+noinline unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 {
 	return __raw_write_lock_irqsave(lock);
 }
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(_raw_write_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
-void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
 {
 	__raw_write_lock_irq(lock);
 }
@@ -300,7 +300,7 @@ EXPORT_SYMBOL(_raw_write_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_BH
-void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
 {
 	__raw_write_lock_bh(lock);
 }
@@ -308,7 +308,7 @@ EXPORT_SYMBOL(_raw_write_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK
-void __lockfunc _raw_write_unlock(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock(rwlock_t *lock)
 {
 	__raw_write_unlock(lock);
 }
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(_raw_write_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__raw_write_unlock_irqrestore(lock, flags);
 }
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(_raw_write_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
 {
 	__raw_write_unlock_irq(lock);
 }
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(_raw_write_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
-void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
 {
 	__raw_write_unlock_bh(lock);
 }
-- 
1.7.7.6

