Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab2IGEhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:37:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37948 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2IGEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:37:10 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 47/57] staging/rts_pstor: remove braces {} in sd.c (sd_rw)
Date: Fri,  7 Sep 2012 13:37:05 +0900
Message-Id: <1346992625-17899-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index d0f5512..f2580a4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3224,11 +3224,10 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 		}
 	}
 
-	if (!CHK_SD_HCXC(sd_card) && !CHK_MMC_SECTOR_MODE(sd_card)) {
+	if (!CHK_SD_HCXC(sd_card) && !CHK_MMC_SECTOR_MODE(sd_card))
 		data_addr = start_sector << 9;
-	} else {
+	else
 		data_addr = start_sector;
-	}
 
 	sd_clr_err_code(chip);
 
@@ -3283,21 +3282,19 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01, RING_BUFFER);
 
-	if (CHK_MMC_8BIT(sd_card)) {
+	if (CHK_MMC_8BIT(sd_card))
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_8);
-	} else if (CHK_MMC_4BIT(sd_card) || CHK_SD(sd_card)) {
+	else if (CHK_MMC_4BIT(sd_card) || CHK_SD(sd_card))
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
-	} else {
+	else
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_1);
-	}
 
 	if (sd_card->seq_mode) {
 		cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
 				SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
 		if (CHECK_PID(chip, 0x5209)) {
-			if (!CHK_SD30_SPEED(sd_card)) {
+			if (!CHK_SD30_SPEED(sd_card))
 				cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
-			}
 		}
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
 
@@ -3327,9 +3324,8 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 			cfg2 = SD_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
 					SD_CHECK_CRC7 | SD_RSP_LEN_6;
 			if (CHECK_PID(chip, 0x5209)) {
-				if (!CHK_SD30_SPEED(sd_card)) {
+				if (!CHK_SD30_SPEED(sd_card))
 					cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
-				}
 			}
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
 
@@ -3370,9 +3366,8 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 			cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
 					SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
 			if (CHECK_PID(chip, 0x5209)) {
-				if (!CHK_SD30_SPEED(sd_card)) {
+				if (!CHK_SD30_SPEED(sd_card))
 					cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
-				}
 			}
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
 
@@ -3397,11 +3392,10 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 
 		sd_card->seq_mode = 0;
 
-		if (retval == -ETIMEDOUT) {
+		if (retval == -ETIMEDOUT)
 			err = STATUS_TIMEDOUT;
-		} else {
+		else
 			err = STATUS_FAIL;
-		}
 
 		rtsx_read_register(chip, REG_SD_STAT1, &stat);
 		rtsx_clear_sd_error(chip);
-- 
1.7.9.5

