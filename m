Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab2IGEfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:35:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61979 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2IGEfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:35:05 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 38/57] staging/rts_pstor: remove braces {} in sd.c (reset_sd)
Date: Fri,  7 Sep 2012 13:35:00 +0900
Message-Id: <1346992500-17609-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |  114 ++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index c9dc000..23fe9f2 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2216,14 +2216,12 @@ Switch_Fail:
 #endif
 
 	retval = sd_prepare_reset(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_dummy_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip) && try_sdio) {
 		int rty_cnt = 0;
@@ -2257,9 +2255,8 @@ Switch_Fail:
 	/* Start Initialization Process of SD Card */
 RTY_SD_RST:
 	retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 	       TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	wait_timeout(20);
 
@@ -2286,9 +2283,8 @@ RTY_SD_RST:
 		voltage = SUPPORT_VOLTAGE;
 
 		retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 		       TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		wait_timeout(20);
 	}
@@ -2302,42 +2298,38 @@ RTY_SD_RST:
 			}
 
 			j++;
-			if (j < 3) {
+			if (j < 3)
 				goto RTY_SD_RST;
-			} else {
+			else
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 
 		retval = sd_send_cmd_get_rsp(chip, SD_APP_OP_COND, voltage, SD_RSP_TYPE_R3, rsp, 5);
 		if (retval != STATUS_SUCCESS) {
 			k++;
-			if (k < 3) {
+			if (k < 3)
 				goto RTY_SD_RST;
-			} else {
+			else
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 
 		i++;
 		wait_timeout(20);
 	} while (!(rsp[1] & 0x80) && (i < 255));
 
-	if (i == 255) {
+	if (i == 255)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (hi_cap_flow) {
-		if (rsp[1] & 0x40) {
+		if (rsp[1] & 0x40)
 			SET_SD_HCXC(sd_card);
-		} else {
+		else
 			CLR_SD_HCXC(sd_card);
-		}
-		if (CHECK_PID(chip, 0x5209) && CHK_SD_HCXC(sd_card) && !sd20_mode) {
+
+		if (CHECK_PID(chip, 0x5209) && CHK_SD_HCXC(sd_card) && !sd20_mode)
 			support_1v8 = (rsp[1] & 0x01) ? 1 : 0;
-		} else {
+		else
 			support_1v8 = 0;
-		}
 	} else {
 		CLR_SD_HCXC(sd_card);
 		support_1v8 = 0;
@@ -2346,46 +2338,39 @@ RTY_SD_RST:
 
 	if (support_1v8) {
 		retval = sd_voltage_switch(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	retval = sd_send_cmd_get_rsp(chip, ALL_SEND_CID, 0, SD_RSP_TYPE_R2, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	for (i = 0; i < 3; i++) {
 		retval = sd_send_cmd_get_rsp(chip, SEND_RELATIVE_ADDR, 0, SD_RSP_TYPE_R6, rsp, 5);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		sd_card->sd_addr = (u32)rsp[1] << 24;
 		sd_card->sd_addr += (u32)rsp[2] << 16;
 
-		if (sd_card->sd_addr) {
+		if (sd_card->sd_addr)
 			break;
-		}
 	}
 
 	retval = sd_check_csd(chip, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_select_card(chip, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 #ifdef SUPPORT_SD_LOCK
 SD_UNLOCK_ENTRY:
 	retval = sd_update_lock_status(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (sd_card->sd_lock_status & SD_LOCKED) {
 		sd_card->sd_lock_status |= (SD_LOCK_1BIT_MODE | SD_PWD_EXIST);
@@ -2396,23 +2381,21 @@ SD_UNLOCK_ENTRY:
 #endif
 
 	retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	retval = sd_send_cmd_get_rsp(chip, SET_CLR_CARD_DETECT, 0, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (support_1v8) {
 		retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = sd_send_cmd_get_rsp(chip, SET_BUS_WIDTH, 2, SD_RSP_TYPE_R1, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		switch_bus_width = SD_BUS_WIDTH_4;
 	} else {
@@ -2420,14 +2403,12 @@ SD_UNLOCK_ENTRY:
 	}
 
 	retval = sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!(sd_card->raw_csd[4] & 0x40))
 		sd_dont_switch = 1;
@@ -2446,9 +2427,9 @@ SD_UNLOCK_ENTRY:
 		if (retval == STATUS_SUCCESS) {
 			retval = sd_switch_function(chip, switch_bus_width);
 			if (retval != STATUS_SUCCESS) {
-				if (CHECK_PID(chip, 0x5209)) {
+				if (CHECK_PID(chip, 0x5209))
 					sd_change_bank_voltage(chip, SD_IO_3V3);
-				}
+
 				sd_init_power(chip);
 				sd_dont_switch = 1;
 				try_sdio = 0;
@@ -2457,9 +2438,9 @@ SD_UNLOCK_ENTRY:
 			}
 		} else {
 			if (support_1v8) {
-				if (CHECK_PID(chip, 0x5209)) {
+				if (CHECK_PID(chip, 0x5209))
 					sd_change_bank_voltage(chip, SD_IO_3V3);
-				}
+
 				sd_init_power(chip);
 				sd_dont_switch = 1;
 				try_sdio = 0;
@@ -2471,13 +2452,12 @@ SD_UNLOCK_ENTRY:
 
 	if (!support_1v8) {
 		retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = sd_send_cmd_get_rsp(chip, SET_BUS_WIDTH, 2, SD_RSP_TYPE_R1, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 #ifdef SUPPORT_SD_LOCK
@@ -2490,24 +2470,22 @@ SD_UNLOCK_ENTRY:
 		RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_1v8);
 
 		retval = sd_set_init_para(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
-		if (CHK_SD_DDR50(sd_card)) {
+		if (CHK_SD_DDR50(sd_card))
 			retval = sd_ddr_tuning(chip);
-		} else {
+		else
 			retval = sd_sdr_tuning(chip);
-		}
 
 		if (retval != STATUS_SUCCESS) {
 			if (sd20_mode) {
 				TRACE_RET(chip, STATUS_FAIL);
 			} else {
 				retval = sd_init_power(chip);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 				try_sdio = 0;
 				sd20_mode = 1;
 				goto Switch_Fail;
@@ -2518,9 +2496,8 @@ SD_UNLOCK_ENTRY:
 
 		if (CHK_SD_DDR50(sd_card)) {
 			retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				read_lba0 = 0;
-			}
 		}
 
 		if (read_lba0) {
@@ -2530,9 +2507,9 @@ SD_UNLOCK_ENTRY:
 					TRACE_RET(chip, STATUS_FAIL);
 				} else {
 					retval = sd_init_power(chip);
-					if (retval != STATUS_SUCCESS) {
+					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
-					}
+
 					try_sdio = 0;
 					sd20_mode = 1;
 					goto Switch_Fail;
@@ -2542,9 +2519,8 @@ SD_UNLOCK_ENTRY:
 	}
 
 	retval = sd_check_wp_state(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	chip->card_bus_width[chip->card2lun[SD_CARD]] = 4;
 
-- 
1.7.9.5

