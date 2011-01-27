Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1A0L6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:58:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:40710 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1A0L6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:58:07 -0500
Date: Thu, 27 Jan 2011 11:57:43 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, chris@zankel.net, lethal@linux-sh.org,
        tony.luck@intel.com, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tony.luck@intel.com, lethal@linux-sh.org,
        chris@zankel.net, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20110126195833.970840140@linutronix.de>
References: <20110126195833.970840140@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Move duplicate function prototypes to linux/rwsem.h
Message-ID: <tip-aac72277fda6ef788bb8d5deaa502ce9b9b6e472@git.kernel.org>
Git-Commit-ID: aac72277fda6ef788bb8d5deaa502ce9b9b6e472
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aac72277fda6ef788bb8d5deaa502ce9b9b6e472
Gitweb:     http://git.kernel.org/tip/aac72277fda6ef788bb8d5deaa502ce9b9b6e472
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:06:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:39 +0100

rwsem: Move duplicate function prototypes to linux/rwsem.h

All architecture specific rwsem headers carry the same function
prototypes. Just x86 adds asmregparm, which is an empty define on all
other architectures. S390 has a stale rwsem_downgrade_write()
prototype.

Remove the duplicates and add the prototypes to linux/rwsem.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
LKML-Reference: <20110126195833.970840140@linutronix.de>
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

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index fc7f543..a83bbea 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
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
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 148b61a..3027e75 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
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
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 38e8e5c..bb1e2cd 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
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
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 80522dc..d0eb465 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
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
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index 2f8cf97..edab572 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
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
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index 4f4391f..069bf4d 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
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
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 776d76f..df4cd32 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
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
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index da61633..249619e 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
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
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8b9c7e9..f7c957f 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
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
 
