Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100Ab2INVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:41:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2INVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 08/24] ARM: iop32x: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:36 +0200
Message-Id: <1347658492-11608-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:55dRg2RUrIbKzJ+fLFqM1RABXRkd+5fiyEzpJnp8yPf
 si/gHYeNjDx5mR1udZAl9fz9Xg2PME3urVA0qz6+oxIcNivM+3
 8QvuUAbNZabQ3OgGkf+fX+80fxdmJ9BSuKnrTqNl0o7VoP6d1a
 a0ULnp13U3vok66GHe6hvKHEMhvKgTcwlLuYsnA6ZpEFmtvf8P
 Km2en2VU32BdZ97iJmrvSz3YDkay4hTOgcHXq5lwr6fkIMiACA
 5uEaN+oH0eEXRN1cZ28QekHUNRvnUQ6TgIeGMgJlMWOPwjsNSY
 WoIBRg+0QrEzFHQPM5mu7JoImhtP+Iw7dvN4YhcYkDYLeDRpx1
 8nsyTn1nz/KbWPEnQ84yz/Sz34gI+06WQxUH6AnUh5q8a6A0Fj
 4oeAD8iaHa1YA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-iop32x/glantank.c                 |    2 +-
 arch/arm/mach-ixp4xx/common.c                   |    6 +++---
 arch/arm/mach-ixp4xx/include/mach/cpu.h         |    5 +++--
 arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h |    2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-iop32x/glantank.c b/arch/arm/mach-iop32x/glantank.c
index c15a100..02e20c3 100644
--- a/arch/arm/mach-iop32x/glantank.c
+++ b/arch/arm/mach-iop32x/glantank.c
@@ -183,7 +183,7 @@ static struct i2c_board_info __initdata glantank_i2c_devices[] = {
 
 static void glantank_power_off(void)
 {
-	__raw_writeb(0x01, 0xfe8d0004);
+	__raw_writeb(0x01, IOMEM(0xfe8d0004));
 
 	while (1)
 		;
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index a9f8094..8c9cd5d 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -53,17 +53,17 @@ static struct clock_event_device clockevent_ixp4xx;
  *************************************************************************/
 static struct map_desc ixp4xx_io_desc[] __initdata = {
 	{	/* UART, Interrupt ctrl, GPIO, timers, NPEs, MACs, USB .... */
-		.virtual	= IXP4XX_PERIPHERAL_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_PERIPHERAL_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_PERIPHERAL_BASE_PHYS),
 		.length		= IXP4XX_PERIPHERAL_REGION_SIZE,
 		.type		= MT_DEVICE
 	}, {	/* Expansion Bus Config Registers */
-		.virtual	= IXP4XX_EXP_CFG_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_EXP_CFG_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_EXP_CFG_BASE_PHYS),
 		.length		= IXP4XX_EXP_CFG_REGION_SIZE,
 		.type		= MT_DEVICE
 	}, {	/* PCI Registers */
-		.virtual	= IXP4XX_PCI_CFG_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_PCI_CFG_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_PCI_CFG_BASE_PHYS),
 		.length		= IXP4XX_PCI_CFG_REGION_SIZE,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-ixp4xx/include/mach/cpu.h b/arch/arm/mach-ixp4xx/include/mach/cpu.h
index b2ef65d..e3d5a2e 100644
--- a/arch/arm/mach-ixp4xx/include/mach/cpu.h
+++ b/arch/arm/mach-ixp4xx/include/mach/cpu.h
@@ -14,6 +14,7 @@
 #ifndef __ASM_ARCH_CPU_H__
 #define __ASM_ARCH_CPU_H__
 
+#include <linux/io.h>
 #include <asm/cputype.h>
 
 /* Processor id value in CP15 Register 0 */
@@ -37,7 +38,7 @@
 
 static inline u32 ixp4xx_read_feature_bits(void)
 {
-	u32 val = ~*IXP4XX_EXP_CFG2;
+	u32 val = ~__raw_readl(IXP4XX_EXP_CFG2);
 
 	if (cpu_is_ixp42x_rev_a0())
 		return IXP42X_FEATURE_MASK & ~(IXP4XX_FEATURE_RCOMP |
@@ -51,7 +52,7 @@ static inline u32 ixp4xx_read_feature_bits(void)
 
 static inline void ixp4xx_write_feature_bits(u32 value)
 {
-	*IXP4XX_EXP_CFG2 = ~value;
+	__raw_writel(~cpu_to_le32(value), IXP4XX_EXP_CFG2);
 }
 
 #endif  /* _ASM_ARCH_CPU_H */
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
index 97c530f..2272f5a 100644
--- a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
@@ -92,7 +92,7 @@
 /*
  * Expansion Bus Controller registers.
  */
-#define IXP4XX_EXP_REG(x) ((volatile u32 *)(IXP4XX_EXP_CFG_BASE_VIRT+(x)))
+#define IXP4XX_EXP_REG(x) ((volatile u32 __iomem *)(IXP4XX_EXP_CFG_BASE_VIRT+(x)))
 
 #define IXP4XX_EXP_CS0      IXP4XX_EXP_REG(IXP4XX_EXP_CS0_OFFSET)
 #define IXP4XX_EXP_CS1      IXP4XX_EXP_REG(IXP4XX_EXP_CS1_OFFSET)
-- 
1.7.10

