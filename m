Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1AZUGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:45 -0500
Received: from www.tglx.de ([62.245.132.106]:44552 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1AZUGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:40 -0500
Message-Id: <20110126195833.970840140@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:06:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 6/6] rwsem: Move duplicate function prototypes to linux/rwsem.h
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline;
	filename=rwsem-move-duplicate-function-definitions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architecture specific rwsem headers carry the same function
prototypes. Just x86 adds asmregparm, which is an empty define on all
other architectures. S390 has a stale rwsem_downgrade_write()
prototype.

Remove the duplicates and add the prototypes to linux/rwsem.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    5 -----
 arch/ia64/include/asm/rwsem.h    |    5 -----
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    6 ------
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    5 -----
 arch/x86/include/asm/rwsem.h     |    9 ---------
 arch/xtensa/include/asm/rwsem.h  |    5 -----
 include/linux/rwsem.h            |    5 +++++
 9 files changed, 5 insertions(+), 45 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -14,11 +14,6 @@
 
 #include <linux/compiler.h>
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 #define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS		0x0000000000000001L
 #define RWSEM_ACTIVE_MASK		0x00000000ffffffffL
Index: linux-2.6/arch/ia64/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/rwsem.h
+++ linux-2.6/arch/ia64/include/asm/rwsem.h
@@ -34,11 +34,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/powerpc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/rwsem.h
+++ linux-2.6/arch/powerpc/include/asm/rwsem.h
@@ -28,11 +28,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/s390/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/rwsem.h
+++ linux-2.6/arch/s390/include/asm/rwsem.h
@@ -43,12 +43,6 @@
 
 #ifdef __KERNEL__
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *);
-extern struct rw_semaphore *rwsem_downgrade_write(struct rw_semaphore *);
-
 #ifndef __s390x__
 #define RWSEM_UNLOCKED_VALUE	0x00000000
 #define RWSEM_ACTIVE_BIAS	0x00000001
Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -19,11 +19,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -20,11 +20,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -39,15 +39,6 @@
 #ifdef __KERNEL__
 #include <asm/asm.h>
 
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
  * The bias values and the counter type limits the number of
  * potential readers/writers to 32767 for 32 bits and 2147483647
Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -24,11 +24,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
 /*
  * lock for reading
  */
Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -32,6 +32,11 @@ struct rw_semaphore {
 #endif
 };
 
+extern asmregparm struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern asmregparm struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
+extern asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+
 /* Include the arch specific part */
 #include <asm/rwsem.h>
 


