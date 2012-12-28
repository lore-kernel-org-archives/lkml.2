Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2L1TXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:23:49 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:44886 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab2L1TXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:23:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_HAS_DMA
Date: Fri, 28 Dec 2012 20:23:31 +0100
Message-Id: <1356722614-18224-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two places, we check !CONFIG_MMU_SUN3 while we should check
CONFIG_HAS_DMA instead.
While fixing this, the check in <asm/dma-mapping.h> became redundant
(<linux/dma-mapping.h> already handles this case), so just remove it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/dma-mapping.h |    5 -----
 arch/m68k/kernel/Makefile           |    4 +---
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index 3e6b844..c68cdb4 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -5,7 +5,6 @@
 
 struct scatterlist;
 
-#ifndef CONFIG_MMU_SUN3
 static inline int dma_supported(struct device *dev, u64 mask)
 {
 	return 1;
@@ -111,8 +110,4 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t handle)
 	return 0;
 }
 
-#else
-#include <asm-generic/dma-mapping-broken.h>
-#endif
-
 #endif  /* _M68K_DMA_MAPPING_H */
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index 068ad49..655347d 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -20,7 +20,5 @@ obj-$(CONFIG_MMU_MOTOROLA) += ints.o vectors.o
 obj-$(CONFIG_MMU_SUN3) += ints.o vectors.o
 obj-$(CONFIG_PCI) += pcibios.o
 
-ifndef CONFIG_MMU_SUN3
-obj-y	+= dma.o
-endif
+obj-$(CONFIG_HAS_DMA)	+= dma.o
 
-- 
1.7.0.4

