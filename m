Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1A0M5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:57:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:60202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1A0M5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:57:38 -0500
Date: Thu, 27 Jan 2011 11:57:19 GMT
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
In-Reply-To: <20110126195833.876773757@linutronix.de>
References: <20110126195833.876773757@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Unify the duplicate rwsem_is_locked() inlines
Message-ID: <tip-41e5887fa39ab272d9266a09cbefdef270e28b93@git.kernel.org>
Git-Commit-ID: 41e5887fa39ab272d9266a09cbefdef270e28b93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:57:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41e5887fa39ab272d9266a09cbefdef270e28b93
Gitweb:     http://git.kernel.org/tip/41e5887fa39ab272d9266a09cbefdef270e28b93
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:06:03 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:39 +0100

rwsem: Unify the duplicate rwsem_is_locked() inlines

Instead of having the same implementation in each architecture, move
it to linux/rwsem.h and remove the duplicates. It's unlikely that an
arch will ever implement something different, but we can deal with
that when it happens.

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
LKML-Reference: <20110126195833.876773757@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    5 -----
 arch/ia64/include/asm/rwsem.h    |    5 -----
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    5 -----
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    5 -----
 arch/x86/include/asm/rwsem.h     |    5 -----
 arch/xtensa/include/asm/rwsem.h  |    5 -----
 include/linux/rwsem.h            |    7 +++++++
 9 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index c9f5b90..fc7f543 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -224,10 +224,5 @@ static inline long rwsem_atomic_update(long val, struct rw_semaphore *sem)
 #endif
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 3798546..148b61a 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -147,9 +147,4 @@ __downgrade_write (struct rw_semaphore *sem)
 #define rwsem_atomic_add(delta, sem)	atomic64_add(delta, (atomic64_t *)(&(sem)->count))
 #define rwsem_atomic_update(delta, sem)	atomic64_add_return(delta, (atomic64_t *)(&(sem)->count))
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* _ASM_IA64_RWSEM_H */
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index f86fdf7..38e8e5c 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -133,10 +133,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
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
index f0f52775..80522dc 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -325,10 +325,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
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
index 798699d..2f8cf97 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -133,10 +133,5 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
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
index 79f7c1c..4f4391f 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -124,11 +124,6 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	return atomic64_add_return(delta, (atomic64_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index c0c91b4..776d76f 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -222,10 +222,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
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
index 2fa4202..da61633 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -133,9 +133,4 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif	/* _XTENSA_RWSEM_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8970c3e..8b9c7e9 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -34,6 +34,13 @@ struct rw_semaphore {
 
 /* Include the arch specific part */
 #include <asm/rwsem.h>
+
+/* In all implementations count != 0 means locked */
+static inline int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	return sem->count != 0;
+}
+
 #endif
 
 /* Common initializer macros and functions */
