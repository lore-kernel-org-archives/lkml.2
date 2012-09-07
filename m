Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab2IGEhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:37:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37948 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2IGEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:37:27 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 48/57] staging/rts_pstor: remove braces {} in sd.c (ext_sd_send_cmd_get_rsp)
Date: Fri,  7 Sep 2012 13:37:20 +0900
Message-Id: <1346992640-17931-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index f2580a4..4168af6 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3481,9 +3481,8 @@ int ext_sd_send_cmd_get_rsp(struct rtsx_chip *chip, u8 cmd_idx,
 
 	RTSX_DEBUGP("EXT SD/MMC CMD %d\n", cmd_idx);
 
-	if (rsp_type == SD_RSP_TYPE_R1b) {
+	if (rsp_type == SD_RSP_TYPE_R1b)
 		timeout = 3000;
-	}
 
 RTY_SEND_CMD:
 
@@ -3503,14 +3502,14 @@ RTY_SEND_CMD:
 	rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
-		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++) {
+		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-		}
+
 		stat_idx = 17;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
-		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
+		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-		}
+
 		stat_idx = 6;
 	}
 	rtsx_add_cmd(chip, READ_REG_CMD, REG_SD_CMD5, 0, 0);
@@ -3524,9 +3523,8 @@ RTY_SEND_CMD:
 
 			if (rsp_type & SD_WAIT_BUSY_END) {
 				retval = sd_check_data0_status(chip);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, retval);
-				}
 			} else {
 				sd_set_err_code(chip, SD_TO_ERR);
 			}
@@ -3534,9 +3532,8 @@ RTY_SEND_CMD:
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	if (rsp_type == SD_RSP_TYPE_R0) {
+	if (rsp_type == SD_RSP_TYPE_R0)
 		return STATUS_SUCCESS;
-	}
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
 
@@ -3565,9 +3562,8 @@ RTY_SEND_CMD:
 	if ((cmd_idx == SELECT_CARD) || (cmd_idx == APP_CMD) ||
 			(cmd_idx == SEND_STATUS) || (cmd_idx == STOP_TRANSMISSION)) {
 		if ((cmd_idx != STOP_TRANSMISSION) && (special_check == 0)) {
-			if (ptr[1] & 0x80) {
+			if (ptr[1] & 0x80)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 #ifdef SUPPORT_SD_LOCK
 		if (ptr[1] & 0x7D)
@@ -3577,26 +3573,23 @@ RTY_SEND_CMD:
 		{
 			TRACE_RET(chip, STATUS_FAIL);
 		}
-		if (ptr[2] & 0xF8) {
+		if (ptr[2] & 0xF8)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (cmd_idx == SELECT_CARD) {
 			if (rsp_type == SD_RSP_TYPE_R2) {
-				if ((ptr[3] & 0x1E) != 0x04) {
+				if ((ptr[3] & 0x1E) != 0x04)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 			} else if (rsp_type == SD_RSP_TYPE_R0) {
-				if ((ptr[3] & 0x1E) != 0x03) {
+				if ((ptr[3] & 0x1E) != 0x03)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 		}
 	}
 
-	if (rsp && rsp_len) {
+	if (rsp && rsp_len)
 		memcpy(rsp, ptr, rsp_len);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

