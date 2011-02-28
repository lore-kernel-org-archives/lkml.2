Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1CATir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:38:47 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1CAThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:25 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYeHF010310@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:58:39 -0500
Subject: [PATCH] arch/tile: fix some comments and whitespace
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:40.0467 (UTC) FILETIME=[B535CA30:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a grab bag of changes with no actual change to generated code.
This includes whitespace and comment typos, plus a couple of stale
comments being removed.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig             |   20 ++++++++++----------
 arch/tile/kernel/intvec_32.S  |    4 ++--
 arch/tile/lib/atomic_32.c     |    2 +-
 arch/tile/lib/atomic_asm_32.S |    2 +-
 arch/tile/mm/fault.c          |    8 --------
 5 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 9e4eb51..92f7ea0 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -1,5 +1,5 @@
 # For a description of the syntax of this configuration file,
-# see Documentation/kbuild/config-language.txt.
+# see Documentation/kbuild/kconfig-language.txt.
 
 config TILE
 	def_bool y
@@ -15,14 +15,14 @@ config TILE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
-#       select HAVE_OPTPROBES
-#       select HAVE_REGS_AND_STACK_ACCESS_API
-#       select HAVE_HW_BREAKPOINT
-#       select PERF_EVENTS
-#       select HAVE_USER_RETURN_NOTIFIER
-#       config NO_BOOTMEM
-#       config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-#       config HUGETLB_PAGE_SIZE_VARIABLE
+#	select HAVE_OPTPROBES
+#	select HAVE_REGS_AND_STACK_ACCESS_API
+#	select HAVE_HW_BREAKPOINT
+#	select PERF_EVENTS
+#	select HAVE_USER_RETURN_NOTIFIER
+#	config NO_BOOTMEM
+#	config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+#	config HUGETLB_PAGE_SIZE_VARIABLE
 
 config MMU
 	def_bool y
@@ -40,7 +40,7 @@ config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
 config NEED_PER_CPU_PAGE_FIRST_CHUNK
-        def_bool y
+	def_bool y
 
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index abf92f5..eabf1ef 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1584,7 +1584,7 @@ ENTRY(sys_cmpxchg)
 	 * about aliasing among multiple mappings of the same physical page,
 	 * and we ignore the low 3 bits so we have one lock that covers
 	 * both a cmpxchg64() and a cmpxchg() on either its low or high word.
-	 * NOTE: this code must match __atomic_hashed_lock() in lib/atomic.c.
+	 * NOTE: this must match __atomic_hashed_lock() in lib/atomic_32.c.
 	 */
 
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
@@ -1718,7 +1718,7 @@ ENTRY(sys_cmpxchg)
 
 	/*
 	 * Perform the actual cmpxchg or atomic_update.
-	 * Note that __futex_mark_unlocked() in uClibc relies on
+	 * Note that the system <arch/atomic.h> header relies on
 	 * atomic_update() to always perform an "mf", so don't make
 	 * it optional or conditional without modifying that code.
 	 */
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 59e3a02..020866a 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -53,7 +53,7 @@ int atomic_locks[PAGE_SIZE / sizeof(int) /* Only ATOMIC_HASH_SIZE is used */]
 
 static inline int *__atomic_hashed_lock(volatile void *v)
 {
-	/* NOTE: this code must match "sys_cmpxchg" in kernel/intvec.S */
+	/* NOTE: this code must match "sys_cmpxchg" in kernel/intvec_32.S */
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	unsigned long i =
 		(unsigned long) v & ((PAGE_SIZE-1) & -sizeof(long long));
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 5a5514b..82f64cc 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -14,7 +14,7 @@
  * Support routines for atomic operations.  Each function takes:
  *
  * r0: address to manipulate
- * r1: pointer to atomic lock guarding this operation (for FUTEX_LOCK_REG)
+ * r1: pointer to atomic lock guarding this operation (for ATOMIC_LOCK_REG)
  * r2: new value to write, or for cmpxchg/add_unless, value to compare against
  * r3: (cmpxchg/xchg_add_unless) new value to write or add;
  *     (atomic64 ops) high word of value to write
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index dcebfc8..758f597 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -655,14 +655,6 @@ struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 	}
 
 	/*
-	 * NOTE: the one other type of access that might bring us here
-	 * are the memory ops in __tns_atomic_acquire/__tns_atomic_release,
-	 * but we don't have to check specially for them since we can
-	 * always safely return to the address of the fault and retry,
-	 * since no separate atomic locks are involved.
-	 */
-
-	/*
 	 * Now that we have released the atomic lock (if necessary),
 	 * it's safe to spin if the PTE that caused the fault was migrating.
 	 */
-- 
1.6.5.2

