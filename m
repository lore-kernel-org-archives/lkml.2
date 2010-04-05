Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0DEX4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:56:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:47046 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab0DEXzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:55:01 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH -mm 10/12] frv: use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:45 +0900
Message-Id: <1270511567-18567-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/scatterlist.h |   40 +-----------------------------------
 1 files changed, 1 insertions(+), 39 deletions(-)

diff --git a/arch/frv/include/asm/scatterlist.h b/arch/frv/include/asm/scatterlist.h
index 4bca8a2..1614bfd 100644
--- a/arch/frv/include/asm/scatterlist.h
+++ b/arch/frv/include/asm/scatterlist.h
@@ -1,45 +1,7 @@
 #ifndef _ASM_SCATTERLIST_H
 #define _ASM_SCATTERLIST_H
 
-#include <asm/types.h>
-
-/*
- * Drivers must set either ->address or (preferred) page and ->offset
- * to indicate where data must be transferred to/from.
- *
- * Using page is recommended since it handles highmem data as well as
- * low mem. ->address is restricted to data which has a virtual mapping, and
- * it will go away in the future. Updating to page can be automated very
- * easily -- something like
- *
- * sg->address = some_ptr;
- *
- * can be rewritten as
- *
- * sg_set_buf(sg, some_ptr, length);
- *
- * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
- */
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* for highmem, page offset */
-
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
 
 #define ISA_DMA_THRESHOLD (0xffffffffUL)
 
-- 
1.7.0

