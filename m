Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680Ab2COLo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:44:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:39737 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2COLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:44:24 -0400
Message-Id: <20120314170918.404528547@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 11:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch 1/5] seqlock: Remove unused functions
References: <20120314170736.617746873@linutronix.de>
Content-Disposition: inline; filename=seqlock-remove-unused-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/seqlock.h |   21 ---------------------
 1 file changed, 21 deletions(-)

Index: tip/include/linux/seqlock.h
===================================================================
--- tip.orig/include/linux/seqlock.h
+++ tip/include/linux/seqlock.h
@@ -69,17 +69,6 @@ static inline void write_sequnlock(seqlo
 	spin_unlock(&sl->lock);
 }
 
-static inline int write_tryseqlock(seqlock_t *sl)
-{
-	int ret = spin_trylock(&sl->lock);
-
-	if (ret) {
-		++sl->sequence;
-		smp_wmb();
-	}
-	return ret;
-}
-
 /* Start of read calculation -- fetch last complete writer token */
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
@@ -248,14 +237,4 @@ static inline void write_seqcount_barrie
 #define write_sequnlock_bh(lock)					\
 	do { write_sequnlock(lock); local_bh_enable(); } while(0)
 
-#define read_seqbegin_irqsave(lock, flags)				\
-	({ local_irq_save(flags);   read_seqbegin(lock); })
-
-#define read_seqretry_irqrestore(lock, iv, flags)			\
-	({								\
-		int ret = read_seqretry(lock, iv);			\
-		local_irq_restore(flags);				\
-		ret;							\
-	})
-
 #endif /* __LINUX_SEQLOCK_H */


