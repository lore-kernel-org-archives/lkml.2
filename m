Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab2JXNRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:17:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61443 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2JXNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:17:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 1/1] mmc: Standardise capability type
Date: Wed, 24 Oct 2012 14:17:44 +0100
Message-Id: <1351084664-30526-1-git-send-email-lee.jones@linaro.org>
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
 drivers/mmc/core/mmc.c     |    2 +-
 include/linux/mmc/dw_mmc.h |    4 ++--
 include/linux/mmc/host.h   |    2 +-
 include/linux/mmc/sdhci.h  |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 7cc4638..f31bf80 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -239,7 +239,7 @@ static void mmc_select_card_type(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
 	u8 card_type = card->ext_csd.raw_card_type & EXT_CSD_CARD_TYPE_MASK;
-	unsigned int caps = host->caps, caps2 = host->caps2;
+	unsigned long caps = host->caps, caps2 = host->caps2;
 	unsigned int hs_max_dtr = 0;
 
 	if (card_type & EXT_CSD_CARD_TYPE_26)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 7c6a113..60b71ae 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -229,8 +229,8 @@ struct dw_mci_board {
 	u32 quirks; /* Workaround / Quirk flags */
 	unsigned int bus_hz; /* Clock speed at the cclk_in pad */
 
-	unsigned int caps;	/* Capabilities */
-	unsigned int caps2;	/* More capabilities */
+	unsigned long caps;	/* Capabilities */
+	unsigned long caps2;	/* More capabilities */
 	/*
 	 * Override fifo depth. If 0, autodetect it from the FIFOTH register,
 	 * but note that this may not be reliable after a bootloader has used
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7abb0e1..f89c968 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -241,7 +241,7 @@ struct mmc_host {
 #define MMC_CAP_CMD23		(1 << 30)	/* CMD23 supported. */
 #define MMC_CAP_HW_RESET	(1 << 31)	/* Hardware reset */
 
-	unsigned int		caps2;		/* More host capabilities */
+	unsigned long		caps2;		/* More host capabilities */
 
 #define MMC_CAP2_BOOTPART_NOACC	(1 << 0)	/* Boot partition no access */
 #define MMC_CAP2_CACHE_CTRL	(1 << 1)	/* Allow cache control */
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index fa8529a..8c20910 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -157,8 +157,8 @@ struct sdhci_host {
 
 	struct timer_list timer;	/* Timer for timeouts */
 
-	unsigned int caps;	/* Alternative CAPABILITY_0 */
-	unsigned int caps1;	/* Alternative CAPABILITY_1 */
+	unsigned long caps;	/* Alternative CAPABILITY_0 */
+	unsigned long caps1;	/* Alternative CAPABILITY_1 */
 
 	unsigned int            ocr_avail_sdio;	/* OCR bit masks */
 	unsigned int            ocr_avail_sd;
-- 
1.7.9.5

