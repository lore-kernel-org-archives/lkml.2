Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab2INVl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:41:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab2INVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland Stigge <stigge@antcom.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 11/24] ARM: lpc32xx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:39 +0200
Message-Id: <1347658492-11608-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/R78pjGOnM3PawmgQ22DgjQgKhQYiPgM0EM4GFqdljq
 hyhJOdCuOE0Oj+Y+WsHqUKsgBXQIgRqiueIdShPW5g4yc/PdpQ
 sdSkpU70c3dNz/oC4zozi3DmLyVgcx/+uZI9TjX4ccqiJLf1Ei
 CTnCEGyd1AuCa5NIqLRZKLzxLjG1cx4UokGRB1Kosmwjm3H+C8
 9ufaZanpMSwd26zE/oDx/Zkk2Ty7yOQN2i5Mw+MZAK7SaVJcjS
 JsAVTtwV5A8SNIBNS7h1nvLOucPHJydAULNLE5QilAIyq4PMRY
 14Mnjlj+ujQPGUe7OtZ7bRK8FKOARmRCqsVnZvdLAJMdf0zpsD
 L9/PbYlwo4SJI1vPrTAZh7yDVm25CR/b613+DtoQAJgByPJ+VM
 6P/P5mUdJ4hRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Roland Stigge <stigge@antcom.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-lpc32xx/common.c                |    8 ++++----
 arch/arm/mach-lpc32xx/include/mach/hardware.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index a48dc2d..0d4db8c 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -177,25 +177,25 @@ u32 clk_get_pclk_div(void)
 
 static struct map_desc lpc32xx_io_desc[] __initdata = {
 	{
-		.virtual	= IO_ADDRESS(LPC32XX_AHB0_START),
+		.virtual	= (unsigned long)IO_ADDRESS(LPC32XX_AHB0_START),
 		.pfn		= __phys_to_pfn(LPC32XX_AHB0_START),
 		.length		= LPC32XX_AHB0_SIZE,
 		.type		= MT_DEVICE
 	},
 	{
-		.virtual	= IO_ADDRESS(LPC32XX_AHB1_START),
+		.virtual	= (unsigned long)IO_ADDRESS(LPC32XX_AHB1_START),
 		.pfn		= __phys_to_pfn(LPC32XX_AHB1_START),
 		.length		= LPC32XX_AHB1_SIZE,
 		.type		= MT_DEVICE
 	},
 	{
-		.virtual	= IO_ADDRESS(LPC32XX_FABAPB_START),
+		.virtual	= (unsigned long)IO_ADDRESS(LPC32XX_FABAPB_START),
 		.pfn		= __phys_to_pfn(LPC32XX_FABAPB_START),
 		.length		= LPC32XX_FABAPB_SIZE,
 		.type		= MT_DEVICE
 	},
 	{
-		.virtual	= IO_ADDRESS(LPC32XX_IRAM_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(LPC32XX_IRAM_BASE),
 		.pfn		= __phys_to_pfn(LPC32XX_IRAM_BASE),
 		.length		= (LPC32XX_IRAM_BANK_SIZE * 2),
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-lpc32xx/include/mach/hardware.h b/arch/arm/mach-lpc32xx/include/mach/hardware.h
index 33e1dde..69065de 100644
--- a/arch/arm/mach-lpc32xx/include/mach/hardware.h
+++ b/arch/arm/mach-lpc32xx/include/mach/hardware.h
@@ -25,7 +25,7 @@
 /*
  * This macro relies on fact that for all HW i/o addresses bits 20-23 are 0
  */
-#define IO_ADDRESS(x)	(((((x) & 0xff000000) >> 4) | ((x) & 0xfffff)) |\
+#define IO_ADDRESS(x)	IOMEM(((((x) & 0xff000000) >> 4) | ((x) & 0xfffff)) |\
 			 IO_BASE)
 
 #define io_p2v(x)	((void __iomem *) (unsigned long) IO_ADDRESS(x))
-- 
1.7.10

