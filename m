Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab2IGEgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:36:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2IGEgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:36:01 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 42/57] staging/rts_pstor: remove braces {} in sd.c (reset_sd_card)
Date: Fri,  7 Sep 2012 13:35:56 +0900
Message-Id: <1346992556-17738-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index c117dc4..f0b11a4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2961,36 +2961,31 @@ int reset_sd_card(struct rtsx_chip *chip)
 	chip->capacity[chip->card2lun[SD_CARD]] = 0;
 
 	retval = enable_card_clock(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (chip->ignore_sd && CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
 		if (chip->asic_code) {
 			retval = sd_pull_ctl_enable(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		} else {
 			retval = rtsx_write_register(chip, FPGA_PULL_CTL,
 						     FPGA_SD_PULL_CTL_BIT | 0x20, 0);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 		retval = card_share_mode(chip, SD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		chip->sd_io = 1;
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	retval = sd_init_power(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (chip->sd_ctl & RESET_MMC_FIRST) {
 		retval = reset_mmc(chip);
@@ -3029,18 +3024,17 @@ int reset_sd_card(struct rtsx_chip *chip)
 	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_L, 0xFF, 0);
 	RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_H, 0xFF, 2);
 
 	chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity;
 
 	retval = sd_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("sd_card->sd_type = 0x%x\n", sd_card->sd_type);
 
-- 
1.7.9.5

