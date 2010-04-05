Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab0DEXz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:55:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:47041 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab0DEXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:55 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH -mm 09/12] blackfin: use use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:44 +0900
Message-Id: <1270511567-18567-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/scatterlist.h |   22 +---------------------
 1 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/include/asm/scatterlist.h b/arch/blackfin/include/asm/scatterlist.h
index 04f4487..64d41d3 100644
--- a/arch/blackfin/include/asm/scatterlist.h
+++ b/arch/blackfin/include/asm/scatterlist.h
@@ -1,27 +1,7 @@
 #ifndef _BLACKFIN_SCATTERLIST_H
 #define _BLACKFIN_SCATTERLIST_H
 
-#include <linux/mm.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	dma_addr_t dma_address;
-	unsigned int length;
-};
-
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD	(0xffffffff)
 
-- 
1.7.0

