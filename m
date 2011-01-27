Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1A0L4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:56:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:53234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1A0L4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:56:05 -0500
Date: Thu, 27 Jan 2011 11:55:40 GMT
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
In-Reply-To: <20110126195833.483520950@linutronix.de>
References: <20110126195833.483520950@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Cleanup includes
Message-ID: <tip-c16a87ce063f79e0ec7d25ce2950e1bc6db03c72@git.kernel.org>
Git-Commit-ID: c16a87ce063f79e0ec7d25ce2950e1bc6db03c72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:55:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c16a87ce063f79e0ec7d25ce2950e1bc6db03c72
Gitweb:     http://git.kernel.org/tip/c16a87ce063f79e0ec7d25ce2950e1bc6db03c72
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:05:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:38 +0100

rwsem: Cleanup includes

All rwsem implementations include the same headers. Include them from
include/linux/rwsem.h

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
LKML-Reference: <20110126195833.483520950@linutronix.de>

---
 arch/alpha/include/asm/rwsem.h   |    4 ----
 arch/ia64/include/asm/rwsem.h    |    3 ---
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    5 -----
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    6 ------
 arch/x86/include/asm/rwsem.h     |    6 ------
 arch/xtensa/include/asm/rwsem.h  |    6 ------
 include/linux/rwsem-spinlock.h   |    8 --------
 include/linux/rwsem.h            |    3 +++
 10 files changed, 3 insertions(+), 48 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 19c9cc7..839a3fa 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -13,10 +13,6 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
 
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 215d545..9bcf079 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -25,9 +25,6 @@
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
 #include <asm/intrinsics.h>
 
 /*
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 8447d89..c12abbe 100644
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
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 423fdda..9cc8592 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -43,11 +43,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index 06e2251..df6f346 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -11,11 +11,6 @@
 #endif
 
 #ifdef __KERNEL__
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index a2b4302..902d36b 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -12,12 +12,6 @@
 #endif
 
 #ifdef __KERNEL__
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
 struct rw_semaphore {
 	signed long			count;
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index d1e41b0..a626cff 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -37,14 +37,8 @@
 #endif
 
 #ifdef __KERNEL__
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/lockdep.h>
 #include <asm/asm.h>
 
-struct rwsem_waiter;
-
 extern asmregparm struct rw_semaphore *
  rwsem_down_read_failed(struct rw_semaphore *sem);
 extern asmregparm struct rw_semaphore *
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index 9d32f68..1be2102 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -16,12 +16,6 @@
 #ifndef _LINUX_RWSEM_H
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..8c0dc7f 100644
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
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..496296d 100644
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
 
