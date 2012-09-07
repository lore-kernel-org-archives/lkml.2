Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2IGEWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:22:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54492 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2IGEWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:22:52 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 02/57]  staging/rts_pstor: remove braces {} in sd.c (sd_read_data)
Date: Fri,  7 Sep 2012 13:22:43 +0900
Message-Id: <1346991763-16437-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 3a7f869..4575212 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -320,17 +320,15 @@ static int sd_read_data(struct rtsx_chip *chip,
 	if (!buf)
 		buf_len = 0;
 
-	if (buf_len > 512) {
+	if (buf_len > 512)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
 	if (cmd_len) {
 		RTSX_DEBUGP("SD/MMC CMD %d\n", cmd[0] - 0x40);
-		for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++) {
+		for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++)
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0 + i, 0xFF, cmd[i]);
-		}
 	}
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, (u8)byte_cnt);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_H, 0xFF, (u8)(byte_cnt >> 8));
@@ -342,9 +340,9 @@ static int sd_read_data(struct rtsx_chip *chip,
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF,
 			SD_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
 			SD_CHECK_CRC7 | SD_RSP_LEN_6);
-	if (trans_mode != SD_TM_AUTO_TUNING) {
+	if (trans_mode != SD_TM_AUTO_TUNING)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01, PINGPONG_BUFFER);
-	}
+
 	rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_TRANSFER, 0xFF, trans_mode | SD_TRANSFER_START);
 	rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
 
@@ -360,9 +358,8 @@ static int sd_read_data(struct rtsx_chip *chip,
 
 	if (buf && buf_len) {
 		retval = rtsx_read_ppbuf(chip, buf, buf_len);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
-- 
1.7.9.5

