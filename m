Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab1FQVxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34407 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab1FQVxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 3/6] asm-generic/atomic.h: add atomic_set_mask helper
Date: Fri, 17 Jun 2011 17:53:31 -0400
Message-Id: <1308347614-402-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308347614-402-1-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since arches are expected to implement this guy, add a common version
for people the same way as atomic_clear_mask is handled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/atomic.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 28f5939..8275ecd 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -157,6 +157,22 @@ static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 	raw_local_irq_restore(flags);
 }
 
+/**
+ * atomic_set_mask - Atomically set bits in atomic variable
+ * @mask: Mask of the bits to be set
+ * @v: pointer of type atomic_t
+ *
+ * Atomically sets the bits set in @mask in @v
+ */
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
+	v->counter |= mask;
+	raw_local_irq_restore(flags);
+}
+
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
-- 
1.7.5.3

