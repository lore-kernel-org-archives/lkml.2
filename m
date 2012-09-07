Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab2IGEig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:38:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab2IGEid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:38:33 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 52/57] staging/rts_pstor: remove braces {} in sd.c (sd_execute_no_data)
Date: Fri,  7 Sep 2012 13:38:28 +0900
Message-Id: <1346992708-18064-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   41 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 23090cb..ccd6f88 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3757,9 +3757,8 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	retval = sd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
@@ -3768,12 +3767,11 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	cmd_idx = srb->cmnd[2] & 0x3F;
-	if (srb->cmnd[1] & 0x02) {
+	if (srb->cmnd[1] & 0x02)
 		standby = 1;
-	}
-	if (srb->cmnd[1] & 0x01) {
+
+	if (srb->cmnd[1] & 0x01)
 		acmd = 1;
-	}
 
 	arg = ((u32)srb->cmnd[3] << 24) | ((u32)srb->cmnd[4] << 16) |
 		((u32)srb->cmnd[5] << 8) | srb->cmnd[6];
@@ -3786,64 +3784,56 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
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
 
 	if (standby) {
 		retval = sd_select_card(chip, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
-		}
 	}
 
 	if (acmd) {
 		retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
 				SD_RSP_TYPE_R1, NULL, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
-		}
 	}
 
 	retval = ext_sd_send_cmd_get_rsp(chip, cmd_idx, arg, rsp_type,
 			sd_card->rsp, rsp_len, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
-	}
 
 	if (standby) {
 		retval = sd_select_card(chip, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
-		}
 	}
 
 #ifdef SUPPORT_SD_LOCK
 	retval = sd_update_lock_status(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
-	}
 #endif
 
 	scsi_set_resid(srb, 0);
@@ -3854,9 +3844,8 @@ SD_Execute_Cmd_Failed:
 	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
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

