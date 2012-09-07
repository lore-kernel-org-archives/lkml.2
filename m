Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2IGEfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:35:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2IGEfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:35:18 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 39/57] staging/rts_pstor: remove braces {} in sd.c (mmc_test_switch_bus)
Date: Fri,  7 Sep 2012 13:35:14 +0900
Message-Id: <1346992514-17642-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 23fe9f2..ff8eb96 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2544,9 +2544,8 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	int len;
 
 	retval = sd_send_cmd_get_rsp(chip, BUSTEST_W, 0, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, SWITCH_FAIL);
-	}
 
 	if (width == MMC_8BIT_BUS) {
 		buf[0] = 0x55;
@@ -2575,9 +2574,8 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			rtsx_read_register(chip, REG_SD_STAT1, &val1);
 			rtsx_read_register(chip, REG_SD_STAT2, &val2);
 			rtsx_clear_sd_error(chip);
-			if ((val1 & 0xE0) || val2) {
+			if ((val1 & 0xE0) || val2)
 				TRACE_RET(chip, SWITCH_ERR);
-			}
 		} else {
 			rtsx_clear_sd_error(chip);
 			rtsx_write_register(chip, REG_SD_CFG3, 0x02, 0);
@@ -2597,11 +2595,10 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0, 0xFF, 0x40 | BUSTEST_R);
 
-	if (width == MMC_8BIT_BUS) {
+	if (width == MMC_8BIT_BUS)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, 0x08);
-	} else {
+	else
 		rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, 0x04);
-	}
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BLOCK_CNT_L, 0xFF, 1);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BLOCK_CNT_H, 0xFF, 0);
@@ -2614,9 +2611,8 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
 
 	rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2, 0, 0);
-	if (width == MMC_8BIT_BUS) {
+	if (width == MMC_8BIT_BUS)
 		rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + 1, 0, 0);
-	}
 
 	retval = rtsx_send_cmd(chip, SD_CARD, 100);
 	if (retval < 0) {
@@ -2632,15 +2628,14 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			u8 rsp[5];
 			u32 arg;
 
-			if (CHK_MMC_DDR52(sd_card)) {
+			if (CHK_MMC_DDR52(sd_card))
 				arg = 0x03B70600;
-			} else {
+			else
 				arg = 0x03B70200;
-			}
+
 			retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
-			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
+			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR))
 				return SWITCH_SUCCESS;
-			}
 		}
 	} else {
 		RTSX_DEBUGP("BUSTEST_R [4bits]: 0x%02x\n", ptr[0]);
@@ -2648,15 +2643,14 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			u8 rsp[5];
 			u32 arg;
 
-			if (CHK_MMC_DDR52(sd_card)) {
+			if (CHK_MMC_DDR52(sd_card))
 				arg = 0x03B70500;
-			} else {
+			else
 				arg = 0x03B70100;
-			}
+
 			retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
-			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
+			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR))
 				return SWITCH_SUCCESS;
-			}
 		}
 	}
 
-- 
1.7.9.5

