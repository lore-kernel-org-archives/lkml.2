Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3AGINu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:13:50 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:53544 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab3AGINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:13:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Michel Jaouen <michel.jaouen@st.com>
Subject: [PATCH] mfd: prcmu: delete pin control helpers
Date: Mon, 7 Jan 2013 09:13:18 +0100
Message-ID: <1357546398-9541-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

These static inlines are duplicating the task now done by the
Nomadik pinctrl drivers, so delete them from the prcmu static
inlines, also delete the register definitions as these should
only be known by the pinctrl driver.

Cc: Loic Pallardy <loic.pallardy@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Michel Jaouen <michel.jaouen@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, this is a pure clean-up patch following the v3.8 merge
window. These inlines are completely unused in the kernel and
I'd simply apply it to the -rc series but it's up to you.
---
 include/linux/mfd/db8500-prcmu.h |  6 ---
 include/linux/mfd/dbx500-prcmu.h | 79 ----------------------------------------
 2 files changed, 85 deletions(-)

diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 6ee4247..a65dedd 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -16,12 +16,6 @@
 /*
  * Registers
  */
-#define DB8500_PRCM_GPIOCR 0x138
-#define DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0	BIT(0)
-#define DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD	BIT(9)
-#define DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1	BIT(11)
-#define DB8500_PRCM_GPIOCR_SPI2_SELECT		BIT(23)
-
 #define DB8500_PRCM_LINE_VALUE 0x170
 #define DB8500_PRCM_LINE_VALUE_HSI_CAWAKE0	BIT(3)
 
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index c202d6c..ac60147 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -626,85 +626,6 @@ static inline void prcmu_clear(unsigned int reg, u32 bits)
 	prcmu_write_masked(reg, bits, 0);
 }
 
-#if defined(CONFIG_UX500_SOC_DB8500)
-
-/**
- * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
- */
-static inline void prcmu_enable_spi2(void)
-{
-	if (cpu_is_u8500())
-		prcmu_set(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
-}
-
-/**
- * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
- */
-static inline void prcmu_disable_spi2(void)
-{
-	if (cpu_is_u8500())
-		prcmu_clear(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
-}
-
-/**
- * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
- * and UARTMOD on OtherAlternateC3.
- */
-static inline void prcmu_enable_stm_mod_uart(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_set(DB8500_PRCM_GPIOCR,
-			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
-			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
-	}
-}
-
-/**
- * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
- * and UARTMOD on OtherAlternateC3.
- */
-static inline void prcmu_disable_stm_mod_uart(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_clear(DB8500_PRCM_GPIOCR,
-			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
-			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
-	}
-}
-
-/**
- * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
- */
-static inline void prcmu_enable_stm_ape(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_set(DB8500_PRCM_GPIOCR,
-			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
-	}
-}
-
-/**
- * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
- */
-static inline void prcmu_disable_stm_ape(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_clear(DB8500_PRCM_GPIOCR,
-			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
-	}
-}
-
-#else
-
-static inline void prcmu_enable_spi2(void) {}
-static inline void prcmu_disable_spi2(void) {}
-static inline void prcmu_enable_stm_mod_uart(void) {}
-static inline void prcmu_disable_stm_mod_uart(void) {}
-static inline void prcmu_enable_stm_ape(void) {}
-static inline void prcmu_disable_stm_ape(void) {}
-
-#endif
-
 /* PRCMU QoS APE OPP class */
 #define PRCMU_QOS_APE_OPP 1
 #define PRCMU_QOS_DDR_OPP 2
-- 
1.7.11.3

