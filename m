Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0DEX4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:56:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:47026 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab0DEXyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:47 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH -mm 07/12] mips: use use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:42 +0900
Message-Id: <1270511567-18567-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/scatterlist.h |   22 +---------------------
 1 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/arch/mips/include/asm/scatterlist.h b/arch/mips/include/asm/scatterlist.h
index 83d69fe..9af65e7 100644
--- a/arch/mips/include/asm/scatterlist.h
+++ b/arch/mips/include/asm/scatterlist.h
@@ -1,27 +1,7 @@
 #ifndef __ASM_SCATTERLIST_H
 #define __ASM_SCATTERLIST_H
 
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;
-	dma_addr_t	dma_address;
-	unsigned int	length;
-};
-
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0x00ffffffUL)
 
-- 
1.7.0

