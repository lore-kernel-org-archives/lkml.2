Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2HSDB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911340"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 23/74] lto, mutex: Mark __visible
Date: Sat, 18 Aug 2012 19:56:19 -0700
Message-Id: <1345345030-22211-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Various kernel/mutex.c functions can be called from
inline assembler, so they should be all global and
__visible

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/mutex.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a307cc9..fef1585 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -56,8 +56,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static __used noinline void __sched
-__mutex_lock_slowpath(atomic_t *lock_count);
+__visible void __sched __mutex_lock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_lock - acquire the mutex
@@ -94,7 +93,7 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+__visible void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_unlock - release the mutex
@@ -338,7 +337,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static __used noinline void
+__visible void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -395,7 +394,7 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static __used noinline void __sched
+__visible void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-- 
1.7.7.6

