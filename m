Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768Ab2KNMgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:36:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50635 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422709Ab2KNMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:36:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: Standardise capability type
Date: Wed, 14 Nov 2012 12:35:51 +0000
Message-Id: <1352896551-17948-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are discrepancies with regards to how MMC capabilities
are carried throughout the subsystem. Let's standardise them
to elevate any confusion.

Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/core/mmc.c                  |    2 +-
 include/linux/mmc/dw_mmc.h              |    4 ++--
 include/linux/mmc/host.h                |    4 ++--
 include/linux/mmc/sdhci.h               |    4 ++--
 include/linux/platform_data/pxa_sdhci.h |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 7cc4638..8c2fa80 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -239,7 +239,7 @@ static void mmc_select_card_type(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
 	u8 card_type = card->ext_csd.raw_card_type & EXT_CSD_CARD_TYPE_MASK;
-	unsigned int caps = host->caps, caps2 = host->caps2;
+	u32 caps = host->caps, caps2 = host->caps2;
 	unsigned int hs_max_dtr = 0;
 
 	if (card_type & EXT_CSD_CARD_TYPE_26)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 7c6a113..f825379 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -229,8 +229,8 @@ struct dw_mci_board {
 	u32 quirks; /* Workaround / Quirk flags */
 	unsigned int bus_hz; /* Clock speed at the cclk_in pad */
 
-	unsigned int caps;	/* Capabilities */
-	unsigned int caps2;	/* More capabilities */
+	u32 caps;	/* Capabilities */
+	u32 caps2;	/* More capabilities */
 	/*
 	 * Override fifo depth. If 0, autodetect it from the FIFOTH register,
 	 * but note that this may not be reliable after a bootloader has used
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7abb0e1..37442b2 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -211,7 +211,7 @@ struct mmc_host {
 #define MMC_VDD_34_35		0x00400000	/* VDD voltage 3.4 ~ 3.5 */
 #define MMC_VDD_35_36		0x00800000	/* VDD voltage 3.5 ~ 3.6 */
 
-	unsigned long		caps;		/* Host capabilities */
+	u32			caps;		/* Host capabilities */
 
 #define MMC_CAP_4_BIT_DATA	(1 << 0)	/* Can the host do 4 bit transfers */
 #define MMC_CAP_MMC_HIGHSPEED	(1 << 1)	/* Can do MMC high-speed timing */
@@ -241,7 +241,7 @@ struct mmc_host {
 #define MMC_CAP_CMD23		(1 << 30)	/* CMD23 supported. */
 #define MMC_CAP_HW_RESET	(1 << 31)	/* Hardware reset */
 
-	unsigned int		caps2;		/* More host capabilities */
+	u32			caps2;		/* More host capabilities */
 
 #define MMC_CAP2_BOOTPART_NOACC	(1 << 0)	/* Boot partition no access */
 #define MMC_CAP2_CACHE_CTRL	(1 << 1)	/* Allow cache control */
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index fa8529a..c76b4a3 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -157,8 +157,8 @@ struct sdhci_host {
 
 	struct timer_list timer;	/* Timer for timeouts */
 
-	unsigned int caps;	/* Alternative CAPABILITY_0 */
-	unsigned int caps1;	/* Alternative CAPABILITY_1 */
+	u32 caps;		/* Alternative CAPABILITY_0 */
+	u32 caps1;		/* Alternative CAPABILITY_1 */
 
 	unsigned int            ocr_avail_sdio;	/* OCR bit masks */
 	unsigned int            ocr_avail_sd;
diff --git a/include/linux/platform_data/pxa_sdhci.h b/include/linux/platform_data/pxa_sdhci.h
index 59acd98..0d75008 100644
--- a/include/linux/platform_data/pxa_sdhci.h
+++ b/include/linux/platform_data/pxa_sdhci.h
@@ -48,8 +48,8 @@ struct sdhci_pxa_platdata {
 	unsigned int	ext_cd_gpio;
 	bool		ext_cd_gpio_invert;
 	unsigned int	max_speed;
-	unsigned int	host_caps;
-	unsigned int	host_caps2;
+	u32		host_caps;
+	u32		host_caps2;
 	unsigned int	quirks;
 	unsigned int	pm_caps;
 };
-- 
1.7.9.5

