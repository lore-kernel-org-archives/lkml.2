Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2GHKQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:16:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GHKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:16:10 -0400
From: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org
Cc: hitoshi.nakamori@gmail.com, wei_wang@realsil.com.cn,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Staging: rts_pstor: Fix brace coding style issue in ms.c
Date: Sun,  8 Jul 2012 10:15:51 +0900
Message-Id: <1341710152-4266-4-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
References: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ms.c file that fixes brace warning found by checkpatch.pl tool.

Signed-off-by:Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
---
 drivers/staging/rts_pstor/ms.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index f389930..9e9646a 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -447,9 +447,8 @@ static int ms_pull_ctl_enable(struct rtsx_chip *chip)
 	}
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -468,32 +467,29 @@ static int ms_prepare_reset(struct rtsx_chip *chip)
 	ms_card->pro_under_formatting = 0;
 
 	retval = ms_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!chip->ft2_fast_mode)
 		wait_timeout(250);
 
 	retval = enable_card_clock(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 
 	if (chip->asic_code) {
 		retval = ms_pull_ctl_enable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL, FPGA_MS_PULL_CTL_BIT | 0x20, 0);
 	}
 
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_on(chip, MS_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 		wait_timeout(150);
 
 #ifdef SUPPORT_OCP
-- 
1.7.10

