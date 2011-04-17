Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1DQN5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:57:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1DQN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZnsTklRpR/hnkjRSWYUTIB64fxAIJUAlpsrWLcfyFgCifBzb6ffz+6PcxU9cS65htp
         rROMZIlvTEC9ycs3GlvGm9ZCY3RaTH1jaGPVnjWG+9VgWBGu7C/2AFgEhbOBTboIGkVy
         8rSg6kd8D+IWqZz6sXDUn3O7abVU+xZwMRx70=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] m68knommu: use asm-generic/bitops/ext2-atomic.h
Date: Sun, 17 Apr 2011 22:57:29 +0900
Message-Id: <1303048649-28265-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68knommu can use generic implementation of ext2 atomic bitops.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/bitops_no.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 7d3779f..6b0e2d3 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -246,23 +246,7 @@ static inline int __test_and_clear_bit_le(int nr, volatile void *addr)
 	return retval;
 }
 
-#define ext2_set_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = __test_and_set_bit_le((nr), (addr));	\
-		spin_unlock(lock);			\
-		ret;					\
-	})
-
-#define ext2_clear_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = __test_and_clear_bit_le((nr), (addr));	\
-		spin_unlock(lock);			\
-		ret;					\
-	})
+#include <asm-generic/bitops/ext2-atomic.h>
 
 static inline int test_bit_le(int nr, const volatile void *addr)
 {
-- 
1.7.4.2

