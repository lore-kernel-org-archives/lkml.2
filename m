Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2C1As2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:51417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab2C1Arl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867367"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/13] Add a kerneldoc comment to spin_is_locked() that discourages its usage
Date: Tue, 27 Mar 2012 17:47:16 -0700
Message-Id: <1332895637-32572-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/spinlock.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7df6c17..4805e4d 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -360,6 +360,15 @@ static inline void spin_unlock_wait(spinlock_t *lock)
 	raw_spin_unlock_wait(&lock->rlock);
 }
 
+/**
+ * spin_is_locked() - Check if a spinlock is being held.
+ * @lock: Lock to check.
+ *
+ * This function should normally not be used. Especially using it in
+ * WARN and BUG_ONs is usually incorrect or redundant.
+ * If you want to check if a lock is held in a function
+ * use lockdep_assert_held(). A lot of other usages are racy.
+ */
 static inline int spin_is_locked(spinlock_t *lock)
 {
 	return raw_spin_is_locked(&lock->rlock);
-- 
1.7.7.6

