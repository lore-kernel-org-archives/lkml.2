Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2INVfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2INVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:45 +0200
Message-Id: <1347658492-11608-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QAYxnKFAJA1HkyW+yM3x3japnLJnjTfs0vOv+wN8IC8
 WNFGk2BEgK5ZPz6Oj0TtqYxajagiFTVlX2ZKDq/cG3aYiXxDuw
 JI1buhRCEUY4fuOxmDT25T5uJvEav7GHUrNhHZFzUYj/pcFtAg
 yM1tLCQ2Iy5Ayuxlc1uc+Yu416cvRZXPDp23TDt8If73EaV2lN
 wtHSGR0odSp1XT81Fce6ipUdSooATNKR0MkQWslT8AbJyO7OkR
 BiM0II4SvuztKABSsoWFy+q4hc3kKJsBT0Futew4G6PbCTqcec
 i4+hThvLkW9DyD98bXR83JcGlAjT4nACj8aSGSHGt+UK11uF0G
 CjCJxSloW9LhCAKrCgjxtTutS0pYhfwDbg3FEwqywJmBh4h1VX
 PXXwalismgdpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-omap/include/plat/hardware.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/hardware.h b/arch/arm/plat-omap/include/plat/hardware.h
index ddbde38..2518f6c 100644
--- a/arch/arm/plat-omap/include/plat/hardware.h
+++ b/arch/arm/plat-omap/include/plat/hardware.h
@@ -56,9 +56,9 @@
  * Timers
  * ----------------------------------------------------------------------------
  */
-#define OMAP_MPU_TIMER1_BASE	(0xfffec500)
-#define OMAP_MPU_TIMER2_BASE	(0xfffec600)
-#define OMAP_MPU_TIMER3_BASE	(0xfffec700)
+#define OMAP_MPU_TIMER1_BASE	IOMEM(0xfffec500)
+#define OMAP_MPU_TIMER2_BASE	IOMEM(0xfffec600)
+#define OMAP_MPU_TIMER3_BASE	IOMEM(0xfffec700)
 #define MPU_TIMER_FREE		(1 << 6)
 #define MPU_TIMER_CLOCK_ENABLE	(1 << 5)
 #define MPU_TIMER_AR		(1 << 1)
@@ -69,7 +69,7 @@
  * Clocks
  * ----------------------------------------------------------------------------
  */
-#define CLKGEN_REG_BASE		(0xfffece00)
+#define CLKGEN_REG_BASE		IOMEM(0xfffece00)
 #define ARM_CKCTL		(CLKGEN_REG_BASE + 0x0)
 #define ARM_IDLECT1		(CLKGEN_REG_BASE + 0x4)
 #define ARM_IDLECT2		(CLKGEN_REG_BASE + 0x8)
@@ -86,7 +86,7 @@
 #define SETARM_IDLE_SHIFT
 
 /* DPLL control registers */
-#define DPLL_CTL		(0xfffecf00)
+#define DPLL_CTL		IOMEM(0xfffecf00)
 
 /* DSP clock control. Must use __raw_readw() and __raw_writew() with these */
 #define DSP_CONFIG_REG_BASE     IOMEM(0xe1008000)
@@ -100,7 +100,7 @@
  * UPLD
  * ---------------------------------------------------------------------------
  */
-#define ULPD_REG_BASE		(0xfffe0800)
+#define ULPD_REG_BASE		IOMEM(0xfffe0800)
 #define ULPD_IT_STATUS		(ULPD_REG_BASE + 0x14)
 #define ULPD_SETUP_ANALOG_CELL_3	(ULPD_REG_BASE + 0x24)
 #define ULPD_CLOCK_CTRL		(ULPD_REG_BASE + 0x30)
@@ -131,7 +131,7 @@
  */
 
 /* Watchdog timer within the OMAP3.2 gigacell */
-#define OMAP_MPU_WATCHDOG_BASE	(0xfffec800)
+#define OMAP_MPU_WATCHDOG_BASE	IOMEM(0xfffec800)
 #define OMAP_WDT_TIMER		(OMAP_MPU_WATCHDOG_BASE + 0x0)
 #define OMAP_WDT_LOAD_TIM	(OMAP_MPU_WATCHDOG_BASE + 0x4)
 #define OMAP_WDT_READ_TIM	(OMAP_MPU_WATCHDOG_BASE + 0x4)
@@ -149,8 +149,8 @@
  * or something similar.. -- PFM.
  */
 
-#define OMAP_IH1_BASE		0xfffecb00
-#define OMAP_IH2_BASE		0xfffe0000
+#define OMAP_IH1_BASE		IOMEM(0xfffecb00)
+#define OMAP_IH2_BASE		IOMEM(0xfffe0000)
 
 #define OMAP_IH1_ITR		(OMAP_IH1_BASE + 0x00)
 #define OMAP_IH1_MIR		(OMAP_IH1_BASE + 0x04)
-- 
1.7.10

