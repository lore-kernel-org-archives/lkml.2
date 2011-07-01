Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1GAIiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:38:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40830 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab1GAIiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:38:01 -0400
Subject: [PATCH] ARM: DMA: Add missing semicolon for the define of
 dma_alloc_area
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 16:37:52 +0800
Message-ID: <1309509472.30642.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build error by: make at91x40_defconfig;make
Fix it by adding a missing semicolon for the define of dma_alloc_area.

  CC      arch/arm/mm/dma-mapping.o
arch/arm/mm/dma-mapping.c:309: warning: 'struct dma_coherent_area' declared inside parameter list
arch/arm/mm/dma-mapping.c:309: warning: its scope is only this definition or declaration, which is probably not what you want
arch/arm/mm/dma-mapping.c: In function '__dma_alloc':
arch/arm/mm/dma-mapping.c:324: error: expected ';' before '}' token
arch/arm/mm/dma-mapping.c: At top level:
arch/arm/mm/dma-mapping.c:334: warning: 'struct dma_coherent_area' declared inside parameter list
arch/arm/mm/dma-mapping.c:374: warning: 'struct dma_coherent_area' declared inside parameter list
make[1]: *** [arch/arm/mm/dma-mapping.o] Error 1
make: *** [arch/arm/mm] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 3ec2129..090690d 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -291,7 +291,7 @@ static void dma_free_area(void *cpu_addr, size_t size, struct dma_coherent_area
 
 #else	/* !CONFIG_MMU */
 
-#define dma_alloc_area(size, pfn, gfp, area)	({ *(pfn) = 0; NULL })
+#define dma_alloc_area(size, pfn, gfp, area)	({ *(pfn) = 0; NULL; })
 #define dma_free_area(addr, size, area)		do { } while (0)
 
 #define nommu()	(1)
-- 
1.7.4.1



