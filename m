Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0DDOob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:44:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:56599 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0DDOoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:25 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de
Subject: [PATCH -mm 1/5] asm-generic: remove ISA_DMA_THRESHOLD in scatterlist.h
Date: Sun,  4 Apr 2010 23:25:49 +0900
Message-Id: <1270391153-17519-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trick for ISA_DMA_THRESHOLD in asm-generic/scatterlist.h doesn't
work for powerpc. This lets architectures defin ISA_DMA_THRESHOLD.

Hopefully, we can remove ISA_DMA_THRESHOLD in the future; we can do
better to decide if the bouncing is necessary or not.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/scatterlist.h |    2 ++
 arch/s390/include/asm/scatterlist.h       |    2 ++
 arch/score/include/asm/scatterlist.h      |    2 ++
 arch/sparc/include/asm/scatterlist.h      |    2 ++
 include/asm-generic/scatterlist.h         |    4 ----
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
index 35d786f..be44d94 100644
--- a/arch/microblaze/include/asm/scatterlist.h
+++ b/arch/microblaze/include/asm/scatterlist.h
@@ -1 +1,3 @@
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
diff --git a/arch/s390/include/asm/scatterlist.h b/arch/s390/include/asm/scatterlist.h
index 35d786f..be44d94 100644
--- a/arch/s390/include/asm/scatterlist.h
+++ b/arch/s390/include/asm/scatterlist.h
@@ -1 +1,3 @@
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
index 9f533b8..4fa1a66 100644
--- a/arch/score/include/asm/scatterlist.h
+++ b/arch/score/include/asm/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_SCORE_SCATTERLIST_H
 #define _ASM_SCORE_SCATTERLIST_H
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_SCORE_SCATTERLIST_H */
diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
index d112025..0fa0d6d 100644
--- a/arch/sparc/include/asm/scatterlist.h
+++ b/arch/sparc/include/asm/scatterlist.h
@@ -3,6 +3,8 @@
 
 #define sg_dma_len(sg)     	((sg)->dma_length)
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
 
 #endif /* !(_SPARC_SCATTERLIST_H) */
diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 8b94544..51a7a43 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -34,10 +34,6 @@ struct scatterlist {
 #endif /* 64 bit */
 #endif /* sg_dma_len */
 
-#ifndef ISA_DMA_THRESHOLD
-#define ISA_DMA_THRESHOLD	(~0UL)
-#endif
-
 #define ARCH_HAS_SG_CHAIN
 
 #endif /* __ASM_GENERIC_SCATTERLIST_H */
-- 
1.7.0

