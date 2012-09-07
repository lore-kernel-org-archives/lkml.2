Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2IGEaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:30:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2IGEaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:30:21 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 24/57] staging/rts_pstor: remove braces {} in sd.c (sd_ddr_tuning_tx_cmd)
Date: Fri,  7 Sep 2012 13:30:16 +0900
Message-Id: <1346992216-17156-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 6088d93..24daabb 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1522,26 +1522,23 @@ static int sd_ddr_tuning_tx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	u8 cmd[5], bus_width;
 
 	retval = sd_change_phase(chip, sample_point, TUNE_TX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHK_SD(sd_card)) {
 		bus_width = SD_BUS_WIDTH_4;
 	} else {
-		if (CHK_MMC_8BIT(sd_card)) {
+		if (CHK_MMC_8BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_8;
-		} else if (CHK_MMC_4BIT(sd_card)) {
+		else if (CHK_MMC_4BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_4;
-		} else {
+		else
 			bus_width = SD_BUS_WIDTH_1;
-		}
 	}
 
 	retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, SD_RSP_80CLK_TIMEOUT_EN);
 
-- 
1.7.9.5

