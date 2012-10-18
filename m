Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2JRRVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:21:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2JRRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:20:57 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/4] mmc: core: sd.c: Made alignment for the multiline function calls
Date: Fri, 19 Oct 2012 02:19:18 +0900
Message-Id: <1350580760-3886-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350580760-3886-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350580760-3886-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made the alignment based on the strict coding style as follows;
CHECK: Alignment should match open parenthesis

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sd.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 91a73d7..7c6b38e 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -165,7 +165,7 @@ static int mmc_decode_csd(struct mmc_card *card)
 		break;
 	default:
 		pr_err("%s: unrecognised CSD structure version %d\n",
-			mmc_hostname(card->host), csd_struct);
+		       mmc_hostname(card->host), csd_struct);
 		return -EINVAL;
 	}
 
@@ -189,7 +189,7 @@ static int mmc_decode_scr(struct mmc_card *card)
 	scr_struct = UNSTUFF_BITS(resp, 60, 4);
 	if (scr_struct != 0) {
 		pr_err("%s: unrecognised SCR structure version %d\n",
-			mmc_hostname(card->host), scr_struct);
+		       mmc_hostname(card->host), scr_struct);
 		return -EINVAL;
 	}
 
@@ -305,7 +305,7 @@ static int mmc_read_switch(struct mmc_card *card)
 			goto out;
 
 		pr_warning("%s: problem reading Bus Speed modes.\n",
-			mmc_hostname(card->host));
+			   mmc_hostname(card->host));
 		err = 0;
 
 		goto out;
@@ -429,7 +429,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 
 	if ((status[15] & 0xF) != drive_strength) {
 		pr_warning("%s: Problem setting drive strength!\n",
-			mmc_hostname(card->host));
+			   mmc_hostname(card->host));
 		return 0;
 	}
 
@@ -508,7 +508,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 
 	if ((status[16] & 0xF) != card->sd_bus_speed)
 		pr_warning("%s: Problem setting bus speed mode!\n",
-			mmc_hostname(card->host));
+			   mmc_hostname(card->host));
 	else {
 		mmc_set_timing(card->host, timing);
 		mmc_set_clock(card->host, card->sw_caps.uhs_max_dtr);
@@ -588,7 +588,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 
 		if (((status[15] >> 4) & 0x0F) != current_limit)
 			pr_warning("%s: Problem setting current limit!\n",
-				mmc_hostname(card->host));
+				   mmc_hostname(card->host));
 
 	}
 
@@ -662,9 +662,9 @@ out:
 }
 
 MMC_DEV_ATTR(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
-	card->raw_cid[2], card->raw_cid[3]);
+	     card->raw_cid[2], card->raw_cid[3]);
 MMC_DEV_ATTR(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
-	card->raw_csd[2], card->raw_csd[3]);
+	     card->raw_csd[2], card->raw_csd[3]);
 MMC_DEV_ATTR(scr, "%08x%08x\n", card->raw_scr[0], card->raw_scr[1]);
 MMC_DEV_ATTR(date, "%02d/%04d\n", card->cid.month, card->cid.year);
 MMC_DEV_ATTR(erase_size, "%u\n", card->erase_size << 9);
@@ -758,7 +758,7 @@ try_again:
 	 * Switch procedure. SPI mode doesn't support CMD11.
 	 */
 	if (!mmc_host_is_spi(host) && rocr &&
-	   ((*rocr & 0x41000000) == 0x41000000)) {
+	    ((*rocr & 0x41000000) == 0x41000000)) {
 		err = mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180, true);
 		if (err) {
 			ocr &= ~SD_OCR_S18R;
@@ -989,7 +989,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		 * Switch to wider bus (if supported).
 		 */
 		if ((host->caps & MMC_CAP_4_BIT_DATA) &&
-			(card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
+		    (card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
 			err = mmc_app_set_bus_width(card, MMC_BUS_WIDTH_4);
 			if (err)
 				goto free_card;
@@ -1227,7 +1227,7 @@ err:
 	mmc_detach_bus(host);
 
 	pr_err("%s: error %d whilst initialising SD card\n",
-		mmc_hostname(host), err);
+	       mmc_hostname(host), err);
 
 	return err;
 }
-- 
1.7.9.5

