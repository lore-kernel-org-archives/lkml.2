Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2GHKQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:16:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GHKQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:16:01 -0400
From: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org
Cc: hitoshi.nakamori@gmail.com, wei_wang@realsil.com.cn,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Staging:rts_pstor: Fix brace coding style issue in ms.c
Date: Sun,  8 Jul 2012 10:15:49 +0900
Message-Id: <1341710152-4266-2-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
References: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ms.c file that fixes some brace warning found by checkpatch.pl tool.

Signed-off-by:Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
---
 drivers/staging/rts_pstor/ms.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 179a068..99886b0 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -287,9 +287,8 @@ static int ms_read_bytes(struct rtsx_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *dat
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
 
-	for (i = 0; i < data_len; i++) {
+	for (i = 0; i < data_len; i++)
 		data[i] = ptr[i];
-	}
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
 		RTSX_DEBUGP("Read format progress:\n");
@@ -337,34 +336,29 @@ static int ms_set_init_para(struct rtsx_chip *chip)
 	int retval;
 
 	if (CHK_HG8BIT(ms_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_hg_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_hg_clk;
-		}
 	} else if (CHK_MSPRO(ms_card) || CHK_MS4BIT(ms_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_4bit_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_4bit_clk;
-		}
 	} else {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_1bit_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_1bit_clk;
-		}
 	}
 
 	retval = switch_clock(chip, ms_card->ms_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = select_card(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.10

