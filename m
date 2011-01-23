Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1AWPRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:17 -0500
Received: from www.tglx.de ([62.245.132.106]:58662 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1AWPRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:15 -0500
Message-Id: <20110123143837.223928325@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [patch 4/9] sparc: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=sparc-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/lib/atomic32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/sparc/lib/atomic32.c
===================================================================
--- linux-2.6.orig/arch/sparc/lib/atomic32.c
+++ linux-2.6/arch/sparc/lib/atomic32.c
@@ -16,7 +16,7 @@
 #define ATOMIC_HASH(a)	(&__atomic_hash[(((unsigned long)a)>>8) & (ATOMIC_HASH_SIZE-1)])
 
 spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
-	[0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
+	[0 ... (ATOMIC_HASH_SIZE-1)] = __SPIN_LOCK_UNLOCKED(__atomic_hash)
 };
 
 #else /* SMP */


