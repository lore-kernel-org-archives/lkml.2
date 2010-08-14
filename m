Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663Ab0HNJbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 05:31:32 -0400
Received: from sh.osrg.net ([192.16.179.4]:44241 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934651Ab0HNJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 05:31:18 -0400
Date: Sat, 14 Aug 2010 18:30:40 +0900
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mike@compulab.co.il, eric.y.miao@gmail.com,
        khc@pm.waw.pl, kaloz@openwrt.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix ARCH_IXP4XX compile error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100814182909O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Aug 2010 18:30:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 4fa5518c65df7a2c4b6c58061ac53d0b01228042 breaks
CONFIG_ARCH_IXP4XX:

linux-2.6/arch/arm/mach-ixp4xx/common-pci.c:340: error: redefinition of 'dma_needs_bounce'
linux-2.6/arch/arm/include/asm/dma-mapping.h:294: note: previous definition of 'dma_needs_bounce' was here
make[2]: *** [arch/arm/mach-ixp4xx/common-pci.o] Error 1

This is a safe option. Can we remove dma_needs_bounce in common-pci.c
too?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/arm/include/asm/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index c226fe1..2c763bc 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -288,7 +288,7 @@ extern void dmabounce_unregister_dev(struct device *);
  * DMA access and 1 if the buffer needs to be bounced.
  *
  */
-#ifdef CONFIG_SA1111
+#if defined(CONFIG_SA1111) || defined(CONFIG_ARCH_IXP4XX)
 extern int dma_needs_bounce(struct device*, dma_addr_t, size_t);
 #else
 static inline int dma_needs_bounce(struct device *dev, dma_addr_t addr,
-- 
1.6.5

