Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab2INVgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:36:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925Ab2INVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: [PATCH 09/24] ARM: ixp4xx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:37 +0200
Message-Id: <1347658492-11608-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qjdHXFt0OGzBBe7zzfj82ethu5hbr5rg2ek3atNt7vH
 K0l+uwOncVHRQWIiwT0kJfokY/9wSf/im8/dBa1M96YJOA0Skf
 jxEWJ5BG0YgYGRUkjVl+PHzFSmeOCE/NaU6UjgY3NwbvATgh7s
 vYW1xaj6ExyWu8eQ9pJP7HaZtFWxjQ1BFwbDKk89GRLU7Erdlx
 3PD25/uO050etd1+hu8MpjS7zwX+AFSNCuQhrjpxAoytwUto/U
 OhTA9w03QdJ34Y2P3LsORPL++342Nt3H2K2ukYHHbbPZcAZCQq
 NMwbZx/02le7bSjPYzw2yY7GplXUujHJN9Y/ERrX+LxAEq9e8H
 G/7IDSaPJgFFgNsE5BJFe1A5kxq0JJV05eX/jTOxtEevAzUBgi
 HEtz2GKRs6BgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

At the moment, this patch conflicts with other patches in linux-next,
need to sort this out.

Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-ixp4xx/common.c                   |    2 +-
 arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 8c9cd5d..fdf91a1 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -70,7 +70,7 @@ static struct map_desc ixp4xx_io_desc[] __initdata = {
 	},
 #ifdef CONFIG_DEBUG_LL
 	{	/* Debug UART mapping */
-		.virtual	= IXP4XX_DEBUG_UART_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_DEBUG_UART_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_DEBUG_UART_BASE_PHYS),
 		.length		= IXP4XX_DEBUG_UART_REGION_SIZE,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
index 2272f5a..eb68b61 100644
--- a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
@@ -49,21 +49,21 @@
  * Expansion BUS Configuration registers
  */
 #define IXP4XX_EXP_CFG_BASE_PHYS	(0xC4000000)
-#define IXP4XX_EXP_CFG_BASE_VIRT	(0xFFBFE000)
+#define IXP4XX_EXP_CFG_BASE_VIRT	IOMEM(0xFFBFE000)
 #define IXP4XX_EXP_CFG_REGION_SIZE	(0x00001000)
 
 /*
  * PCI Config registers
  */
 #define IXP4XX_PCI_CFG_BASE_PHYS	(0xC0000000)
-#define	IXP4XX_PCI_CFG_BASE_VIRT	(0xFFBFF000)
+#define	IXP4XX_PCI_CFG_BASE_VIRT	IOMEM(0xFFBFF000)
 #define IXP4XX_PCI_CFG_REGION_SIZE	(0x00001000)
 
 /*
  * Peripheral space
  */
 #define IXP4XX_PERIPHERAL_BASE_PHYS	(0xC8000000)
-#define IXP4XX_PERIPHERAL_BASE_VIRT	(0xFFBEB000)
+#define IXP4XX_PERIPHERAL_BASE_VIRT	IOMEM(0xFFBEB000)
 #define IXP4XX_PERIPHERAL_REGION_SIZE	(0x00013000)
 
 /*
@@ -73,7 +73,7 @@
  * aligned so that it * can be used with the low-level debug code.
  */
 #define	IXP4XX_DEBUG_UART_BASE_PHYS	(0xC8000000)
-#define	IXP4XX_DEBUG_UART_BASE_VIRT	(0xffb00000)
+#define	IXP4XX_DEBUG_UART_BASE_VIRT	IOMEM(0xffb00000)
 #define	IXP4XX_DEBUG_UART_REGION_SIZE	(0x00001000)
 
 #define IXP4XX_EXP_CS0_OFFSET	0x00
-- 
1.7.10

