Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0LCASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:18:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab0LCARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XDzzTpm5CUhrLOiR9vPnllin4yWmugv2cQOv44SddYrJ04v48zYk+4MwA3M7GOkn2k
         ZHenWCCcOYFdZnyosF5Q==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/6] rwsem: implement rwsem_is_contended()
Date: Thu,  2 Dec 2010 16:16:50 -0800
Message-Id: <1291335412-16231-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291335412-16231-1-git-send-email-walken@google.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial implementations for rwsem_is_contended()

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/alpha/include/asm/rwsem.h   |    5 +++++
 arch/ia64/include/asm/rwsem.h    |    5 +++++
 arch/powerpc/include/asm/rwsem.h |    5 +++++
 arch/s390/include/asm/rwsem.h    |    5 +++++
 arch/sh/include/asm/rwsem.h      |    5 +++++
 arch/sparc/include/asm/rwsem.h   |    5 +++++
 arch/x86/include/asm/rwsem.h     |    5 +++++
 arch/xtensa/include/asm/rwsem.h  |    5 +++++
 include/linux/rwsem-spinlock.h   |    1 +
 lib/rwsem-spinlock.c             |   12 ++++++++++++
 10 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 1570c0b..6183eec 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -255,5 +255,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 215d545..e965b7a 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -179,4 +179,9 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* _ASM_IA64_RWSEM_H */
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 8447d89..69f5d13 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -179,5 +179,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return sem->count != 0;
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return sem->count < 0;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_RWSEM_H */
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 423fdda..7d36f68 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -382,5 +382,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index 06e2251..1f59516 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -184,5 +184,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_SH_RWSEM_H */
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index a2b4302..88242e6 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -165,6 +165,11 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index d1e41b0..a35521e 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -275,5 +275,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_RWSEM_H */
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index e39edf5..6c658cb 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -165,4 +165,9 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif	/* _XTENSA_RWSEM_H */
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..430de5b 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -69,6 +69,7 @@ extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
 extern int rwsem_is_locked(struct rw_semaphore *sem);
+extern int rwsem_is_contended(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ffc9fc7..783753d 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -30,6 +30,18 @@ int rwsem_is_locked(struct rw_semaphore *sem)
 }
 EXPORT_SYMBOL(rwsem_is_locked);
 
+int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
+		ret = !list_empty(&sem->wait_list);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	return ret;
+}
+
 /*
  * initialise the semaphore
  */
-- 
1.7.3.1

