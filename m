Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2IGE1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:27:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2IGE1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:27:44 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 14/57] staging/rts_pstor: remove braces {} in sd.c (sd_change_phase)
Date: Fri,  7 Sep 2012 13:27:38 +0900
Message-Id: <1346992058-16833-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 6badbc4..67420f4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -866,9 +866,8 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 	if (tune_dir == TUNE_RX) {
 		SD_VP_CTL = SD_VPRX_CTL;
 		SD_DCMPS_CTL = SD_DCMPS_RX_CTL;
-		if (CHK_SD_DDR50(sd_card)) {
+		if (CHK_SD_DDR50(sd_card))
 			ddr_rx = 1;
-		}
 	} else {
 		SD_VP_CTL = SD_VPTX_CTL;
 		SD_DCMPS_CTL = SD_DCMPS_TX_CTL;
@@ -905,23 +904,22 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, SD_DCMPS_CTL, DCMPS_CHANGE, DCMPS_CHANGE);
 		rtsx_add_cmd(chip, CHECK_REG_CMD, SD_DCMPS_CTL, DCMPS_CHANGE_DONE, DCMPS_CHANGE_DONE);
 		retval = rtsx_send_cmd(chip, SD_CARD, 100);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, Fail);
-		}
 
 		val = *rtsx_get_cmd_data(chip);
-		if (val & DCMPS_ERROR) {
+		if (val & DCMPS_ERROR)
 			TRACE_GOTO(chip, Fail);
-		}
-		if ((val & DCMPS_CURRENT_PHASE) != sample_point) {
+
+		if ((val & DCMPS_CURRENT_PHASE) != sample_point)
 			TRACE_GOTO(chip, Fail);
-		}
+
 		RTSX_WRITE_REG(chip, SD_DCMPS_CTL, DCMPS_CHANGE, 0);
-		if (ddr_rx) {
+		if (ddr_rx)
 			RTSX_WRITE_REG(chip, SD_VP_CTL, PHASE_CHANGE, 0);
-		} else {
+		else
 			RTSX_WRITE_REG(chip, CLK_CTL, CHANGE_CLK, 0);
-		}
+
 		udelay(50);
 	}
 
-- 
1.7.9.5

