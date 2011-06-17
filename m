Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab1FQVxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34402 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab1FQVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/6] asm-generic/atomic.h: fix type used in atomic_clear_mask
Date: Fri, 17 Jun 2011 17:53:30 -0400
Message-Id: <1308347614-402-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308347614-402-1-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic helpers are supposed to take an atomic_t pointer, not a
random unsigned long pointer.  So convert atomic_clear_mask over.

While we're here, also add some nice documentation to the func.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/atomic.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 5f62e28..28f5939 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -140,13 +140,20 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+/**
+ * atomic_clear_mask - Atomically clear bits in atomic variable
+ * @mask: Mask of the bits to be cleared
+ * @v: pointer of type atomic_t
+ *
+ * Atomically clears the bits set in @mask from @v
+ */
+static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 {
 	unsigned long flags;
 
 	mask = ~mask;
 	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	*addr &= mask;
+	v->counter &= mask;
 	raw_local_irq_restore(flags);
 }
 
-- 
1.7.5.3

