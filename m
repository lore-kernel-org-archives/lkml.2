Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab2IGEjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:39:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42830 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2IGEjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:39:42 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 57/57] staging/rts_pstor: remove braces {} in sd.c (release_sd_card)
Date: Fri,  7 Sep 2012 13:39:36 +0900
Message-Id: <1346992776-18226-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index c1f293a..c6a581c 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -4552,19 +4552,16 @@ int release_sd_card(struct rtsx_chip *chip)
 	memset(sd_card->raw_scr, 0, 8);
 
 	retval = sd_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHECK_PID(chip, 0x5209)) {
 		retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
-		if (CHK_SD30_SPEED(sd_card)) {
+		if (CHK_SD30_SPEED(sd_card))
 			RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_3v3);
-		}
 
 		RTSX_WRITE_REG(chip, OCPPARA2, SD_OCP_THD_MASK, chip->sd_400mA_ocp_thd);
 	}
-- 
1.7.9.5

