Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab1FQVx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34420 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab1FQVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 5/6] Blackfin: SMP: punt unused atomic_test_mask helper
Date: Fri, 17 Jun 2011 17:53:33 -0400
Message-Id: <1308347614-402-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308347614-402-1-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one uses this func, so just punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/atomic.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index e485089..c857579 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -76,11 +76,6 @@ static inline void atomic_set_mask(int mask, atomic_t *v)
 	__raw_atomic_set_asm(&v->counter, mask);
 }
 
-static inline int atomic_test_mask(int mask, atomic_t *v)
-{
-	return __raw_atomic_test_asm(&v->counter, mask);
-}
-
 /* Atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()    barrier()
 #define smp_mb__after_atomic_dec() barrier()
-- 
1.7.5.3

