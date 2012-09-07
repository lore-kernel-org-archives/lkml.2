Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab2IGEjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:39:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2IGEjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:39:01 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 54/57] staging/rts_pstor: remove braces {} in sd.c (sd_execute_write_data)
Date: Fri,  7 Sep 2012 13:38:56 +0900
Message-Id: <1346992736-18129-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   90 ++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 39f23f0..3fd1cce 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -4093,20 +4093,18 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
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
 	arg = ((u32)srb->cmnd[3] << 24) | ((u32)srb->cmnd[4] << 16) |
@@ -4127,75 +4125,66 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	sd_card->last_rsp_type = rsp_type;
 
 	retval = sd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 
 #ifdef SUPPORT_SD_LOCK
 	if ((sd_card->sd_lock_status & SD_LOCK_1BIT_MODE) == 0) {
 		if (CHK_MMC_8BIT(sd_card)) {
 			retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_8);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card)) {
 			retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
 		}
 	}
 #else
 	retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 #endif
 
 	if (data_len < 512) {
 		retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, data_len,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 	}
 
 	if (standby) {
 		retval = sd_select_card(chip, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 	}
 
 	if (acmd) {
 		retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 	}
 
 	retval = ext_sd_send_cmd_get_rsp(chip, cmd_idx, arg, rsp_type,
 			sd_card->rsp, rsp_len, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-	}
 
 	if (data_len <= 512) {
 		u16 i;
 		u8 *buf;
 
 		buf = kmalloc(data_len, GFP_KERNEL);
-		if (buf == NULL) {
+		if (buf == NULL)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		rtsx_stor_get_xfer_buf(buf, data_len, srb);
 
 #ifdef SUPPORT_SD_LOCK
-		if (cmd_idx == LOCK_UNLOCK) {
+		if (cmd_idx == LOCK_UNLOCK)
 			lock_cmd_type = buf[0] & 0x0F;
-		}
 #endif
 
 		if (data_len > 256) {
@@ -4287,11 +4276,11 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		}
 
 		rtsx_init_cmd(chip);
-		if (CHECK_PID(chip, 0x5209)) {
+		if (CHECK_PID(chip, 0x5209))
 			rtsx_add_cmd(chip, CHECK_REG_CMD, SD_BUS_STAT, SD_DAT0_STATUS, SD_DAT0_STATUS);
-		} else {
+		else
 			rtsx_add_cmd(chip, CHECK_REG_CMD, 0xFD30, 0x02, 0x02);
-		}
+
 		rtsx_send_cmd(chip, SD_CARD, 250);
 
 		retval = sd_update_lock_status(chip);
@@ -4304,61 +4293,53 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (standby) {
 		retval = sd_select_card(chip, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 	}
 
 	if (send_cmd12) {
 		retval = ext_sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION,
 				0, SD_RSP_TYPE_R1b, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 	}
 
 	if (data_len < 512) {
 		retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
 
 		retval = rtsx_write_register(chip, SD_BYTE_CNT_H, 0xFF, 0x02);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-		}
+
 		rtsx_write_register(chip, SD_BYTE_CNT_L, 0xFF, 0x00);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
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
 		TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
-	}
 
 #ifdef SUPPORT_SD_LOCK
 	if (cmd_idx == LOCK_UNLOCK) {
 		if (!lock_cmd_fail) {
 			RTSX_DEBUGP("lock_cmd_type = 0x%x\n", lock_cmd_type);
-			if (lock_cmd_type & SD_CLR_PWD) {
+			if (lock_cmd_type & SD_CLR_PWD)
 				sd_card->sd_lock_status &= ~SD_PWD_EXIST;
-			}
-			if (lock_cmd_type & SD_SET_PWD) {
+
+			if (lock_cmd_type & SD_SET_PWD)
 				sd_card->sd_lock_status |= SD_PWD_EXIST;
-			}
 		}
 
 		RTSX_DEBUGP("sd_lock_state = 0x%x, sd_card->sd_lock_status = 0x%x\n",
@@ -4395,14 +4376,13 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 SD_Execute_Write_Cmd_Failed:
 	sd_card->pre_cmd_err = 1;
 	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
-	if (write_err) {
+	if (write_err)
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
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

