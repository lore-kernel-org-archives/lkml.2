Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2IGEeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:34:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37400 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2IGEeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:34:19 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 35/57] staging/rts_pstor: remove braces {} in sd.c (sd_init_power)
Date: Fri,  7 Sep 2012 13:34:14 +0900
Message-Id: <1346992454-17511-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index fa8cc86..7be3805 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2050,42 +2050,37 @@ static int sd_init_power(struct rtsx_chip *chip)
 {
 	int retval;
 
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		RTSX_WRITE_REG(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_OFF);
-	}
 
 	retval = sd_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (!chip->ft2_fast_mode) {
+	if (!chip->ft2_fast_mode)
 		wait_timeout(250);
-	}
 
 	retval = enable_card_clock(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (chip->asic_code) {
 		retval = sd_pull_ctl_enable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL, FPGA_SD_PULL_CTL_BIT | 0x20, 0);
 	}
 
 	if (chip->ft2_fast_mode) {
-		if (CHECK_PID(chip, 0x5209)) {
+		if (CHECK_PID(chip, 0x5209))
 			RTSX_WRITE_REG(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_ON);
-		}
+
 	} else {
 		retval = card_power_on(chip, SD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		wait_timeout(260);
 
 #ifdef SUPPORT_OCP
-- 
1.7.9.5

