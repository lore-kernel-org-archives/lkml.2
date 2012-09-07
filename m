Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab2IGEgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:36:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2IGEgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:36:43 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 45/57] staging/rts_pstor: remove braces {} in sd.c (sd_stop_seq_mode)
Date: Fri,  7 Sep 2012 13:36:37 +0900
Message-Id: <1346992598-17835-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 918caf5..272b2d4 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3127,19 +3127,18 @@ void sd_stop_seq_mode(struct rtsx_chip *chip)
 
 	if (sd_card->seq_mode) {
 		retval = sd_switch_clock(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			return;
-		}
 
 		retval = sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION, 0,
 				SD_RSP_TYPE_R1b, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			sd_set_err_code(chip, SD_STS_ERR);
-		}
+
 		retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			sd_set_err_code(chip, SD_STS_ERR);
-		}
+
 		sd_card->seq_mode = 0;
 
 		rtsx_write_register(chip, RBCTL, RB_FLUSH, RB_FLUSH);
-- 
1.7.9.5

