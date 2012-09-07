Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2IGEjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:39:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2IGEj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:39:27 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 56/57] staging/rts_pstor: remove braces {} in sd.c (sd_power_off_card3v3)
Date: Fri,  7 Sep 2012 13:39:22 +0900
Message-Id: <1346992762-18194-1-git-send-email-yamanetoshi@gmail.com>
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
index cf054b6..c1f293a 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -4504,26 +4504,23 @@ int sd_power_off_card3v3(struct rtsx_chip *chip)
 	int retval;
 
 	retval = disable_card_clock(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_OE, SD_OUTPUT_EN, 0);
 
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_off(chip, SD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		wait_timeout(50);
 	}
 
 	if (chip->asic_code) {
 		retval = sd_pull_ctl_disable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL,
 			FPGA_SD_PULL_CTL_BIT | 0x20, FPGA_SD_PULL_CTL_BIT);
-- 
1.7.9.5

