Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2IGE1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:27:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2IGE13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:27:29 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 13/57] staging/rts_pstor: remove braces {} in sd.c (sd_voltage_switch)
Date: Fri,  7 Sep 2012 13:27:24 +0900
Message-Id: <1346992044-16801-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index ed95a1a..6badbc4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -802,9 +802,8 @@ static int sd_voltage_switch(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, SD_BUS_STAT, SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, SD_CLK_TOGGLE_EN);
 
 	retval = sd_send_cmd_get_rsp(chip, VOLTAGE_SWITCH, 0, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	udelay(chip->sd_voltage_switch_delay);
 
@@ -816,9 +815,9 @@ static int sd_voltage_switch(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, SD_BUS_STAT, 0xFF, SD_CLK_FORCE_STOP);
 	retval = sd_change_bank_voltage(chip, SD_IO_1V8);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	wait_timeout(50);
 
 	RTSX_WRITE_REG(chip, SD_BUS_STAT, 0xFF, SD_CLK_TOGGLE_EN);
-- 
1.7.9.5

