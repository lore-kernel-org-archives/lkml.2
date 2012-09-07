Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2IGEiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:38:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2IGEir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:38:47 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 53/57] staging/rts_pstor: remove braces {} in sd.c (sd_execute_read_data)
Date: Fri,  7 Sep 2012 13:38:43 +0900
Message-Id: <1346992723-18096-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   71 +++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index ccd6f88..39f23f0 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3872,20 +3872,18 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	retval = sd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 
 	cmd_idx = srb->cmnd[2] & 0x3F;
-	if (srb->cmnd[1] & 0x04) {
+	if (srb->cmnd[1] & 0x04)
 		send_cmd12 = 1;
-	}
-	if (srb->cmnd[1] & 0x02) {
+
+	if (srb->cmnd[1] & 0x02)
 		standby = 1;
-	}
-	if (srb->cmnd[1] & 0x01) {
+
+	if (srb->cmnd[1] & 0x01)
 		acmd = 1;
-	}
 
 	data_len = ((u32)srb->cmnd[7] << 16) | ((u32)srb->cmnd[8] << 8) | srb->cmnd[9];
 
@@ -3897,19 +3895,17 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	sd_card->last_rsp_type = rsp_type;
 
 	retval = sd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 
 #ifdef SUPPORT_SD_LOCK
 	if ((sd_card->sd_lock_status & SD_LOCK_1BIT_MODE) == 0) {
-		if (CHK_MMC_8BIT(sd_card)) {
+		if (CHK_MMC_8BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_8;
-		} else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card)) {
+		else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_4;
-		} else {
+		else
 			bus_width = SD_BUS_WIDTH_1;
-		}
 	} else {
 		bus_width = SD_BUS_WIDTH_4;
 	}
@@ -3921,24 +3917,21 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	if (data_len < 512) {
 		retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, data_len,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
 	if (standby) {
 		retval = sd_select_card(chip, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
 	if (acmd) {
 		retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
 	if (data_len <= 512) {
@@ -3957,9 +3950,8 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		cmd[4] = srb->cmnd[6];
 
 		buf = kmalloc(data_len, GFP_KERNEL);
-		if (buf == NULL) {
+		if (buf == NULL)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		retval = sd_read_data(chip, SD_TM_NORMAL_READ, cmd, 5, byte_cnt,
 				       blk_cnt, bus_width, buf, data_len, 2000);
@@ -4014,56 +4006,48 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	retval = ext_sd_get_rsp(chip, rsp_len, sd_card->rsp, rsp_type);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-	}
 
 	if (standby) {
 		retval = sd_select_card(chip, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
 	if (send_cmd12) {
 		retval = ext_sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION,
 				0, SD_RSP_TYPE_R1b, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
 	if (data_len < 512) {
 		retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 
 		retval = rtsx_write_register(chip, SD_BYTE_CNT_H, 0xFF, 0x02);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
+
 		retval = rtsx_write_register(chip, SD_BYTE_CNT_L, 0xFF, 0x00);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-		}
 	}
 
-	if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04)) {
+	if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04))
 		cmd13_checkbit = 1;
-	}
 
 	for (i = 0; i < 3; i++) {
 		retval = ext_sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr,
 			SD_RSP_TYPE_R1, NULL, 0, cmd13_checkbit);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			break;
-		}
 	}
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
-	}
 
 	scsi_set_resid(srb, 0);
 	return TRANSPORT_GOOD;
@@ -4071,14 +4055,13 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 SD_Execute_Read_Cmd_Failed:
 	sd_card->pre_cmd_err = 1;
 	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
-	if (read_err) {
+	if (read_err)
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-	}
+
 	release_sd_card(chip);
 	do_reset_sd_card(chip);
-	if (!(chip->card_ready & SD_CARD)) {
+	if (!(chip->card_ready & SD_CARD))
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
-	}
 
 	TRACE_RET(chip, TRANSPORT_FAILED);
 }
-- 
1.7.9.5

