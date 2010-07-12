Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0GLGhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:37:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:54421 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0GLGhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:37:32 -0400
Date: Mon, 12 Jul 2010 15:37:20 +0900
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH] microblaze: remove unused HAVE_ARCH_PCI_SET_DMA_MASK
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100712153701V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 12 Jul 2010 15:37:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HAVE_ARCH_PCI_SET_DMA_MASK was removed in 2.6.36 (no architecture has
the own implementation of pci_set_dma_mask).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/microblaze/include/asm/dma-mapping.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 18b3731..5073895 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -79,12 +79,6 @@ static inline int dma_supported(struct device *dev, u64 mask)
 	return ops->dma_supported(dev, mask);
 }
 
-#ifdef CONFIG_PCI
-/* We have our own implementation of pci_set_dma_mask() */
-#define HAVE_ARCH_PCI_SET_DMA_MASK
-
-#endif
-
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
-- 
1.6.5

