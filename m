Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2IGEfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:35:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2IGEfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:35:46 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 41/57] staging/rts_pstor: remove braces {} in sd.c (reset_mmc)
Date: Fri,  7 Sep 2012 13:35:41 +0900
Message-Id: <1346992541-17706-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for any arm of this statement
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   52 +++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index dfb728b..c117dc4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2804,17 +2804,15 @@ static int reset_mmc(struct rtsx_chip *chip)
 
 Switch_Fail:
 	retval = sd_prepare_reset(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
-	}
 
 	SET_MMC(sd_card);
 
 RTY_MMC_RST:
 	retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 	       TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	do {
 		if (detect_card_cd(chip, SD_CARD) != STATUS_SUCCESS) {
@@ -2848,56 +2846,47 @@ RTY_MMC_RST:
 		i++;
 	} while (!(rsp[1] & 0x80) && (i < 255));
 
-	if (i == 255) {
+	if (i == 255)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if ((rsp[1] & 0x60) == 0x40) {
+	if ((rsp[1] & 0x60) == 0x40)
 		SET_MMC_SECTOR_MODE(sd_card);
-	} else {
+	else
 		CLR_MMC_SECTOR_MODE(sd_card);
-	}
 
 	retval = sd_send_cmd_get_rsp(chip, ALL_SEND_CID, 0, SD_RSP_TYPE_R2, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	sd_card->sd_addr = 0x00100000;
 	retval = sd_send_cmd_get_rsp(chip, SET_RELATIVE_ADDR, sd_card->sd_addr, SD_RSP_TYPE_R6, rsp, 5);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_check_csd(chip, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	spec_ver = (sd_card->raw_csd[0] & 0x3C) >> 2;
 
 	retval = sd_select_card(chip, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 #ifdef SUPPORT_SD_LOCK
 MMC_UNLOCK_ENTRY:
 	retval = sd_update_lock_status(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 #endif
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	chip->card_bus_width[chip->card2lun[SD_CARD]] = 1;
 
@@ -2914,22 +2903,20 @@ MMC_UNLOCK_ENTRY:
 			}
 		}
 
-		if (CHK_MMC_SECTOR_MODE(sd_card) && (sd_card->capacity == 0)) {
+		if (CHK_MMC_SECTOR_MODE(sd_card) && (sd_card->capacity == 0))
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (switch_ddr && CHK_MMC_DDR52(sd_card)) {
 			retval = sd_set_init_para(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			retval = mmc_ddr_tuning(chip);
 			if (retval != STATUS_SUCCESS) {
 				retval = sd_init_power(chip);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 				switch_ddr = 0;
 				TRACE_GOTO(chip, Switch_Fail);
 			}
@@ -2939,9 +2926,9 @@ MMC_UNLOCK_ENTRY:
 				retval = sd_read_lba0(chip);
 				if (retval != STATUS_SUCCESS) {
 					retval = sd_init_power(chip);
-					if (retval != STATUS_SUCCESS) {
+					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
-					}
+
 					switch_ddr = 0;
 					TRACE_GOTO(chip, Switch_Fail);
 				}
@@ -2957,9 +2944,8 @@ MMC_UNLOCK_ENTRY:
 #endif
 
 	temp = rtsx_readl(chip, RTSX_BIPR);
-	if (temp & SD_WRITE_PROTECT) {
+	if (temp & SD_WRITE_PROTECT)
 		chip->card_wp |= SD_CARD;
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

