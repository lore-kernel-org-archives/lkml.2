Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2IGE0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:26:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2IGE0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:26:24 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 10/57] staging/rts_pstor: remove braces {} in sd.c (sd_update_lock_status)
Date: Fri,  7 Sep 2012 13:26:16 +0900
Message-Id: <1346991977-16705-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 4b1763c..2ace2a0 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -731,21 +731,18 @@ static int sd_update_lock_status(struct rtsx_chip *chip)
 	u8 rsp[5];
 
 	retval = sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr, SD_RSP_TYPE_R1, rsp, 5);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (rsp[1] & 0x02) {
+	if (rsp[1] & 0x02)
 		sd_card->sd_lock_status |= SD_LOCKED;
-	} else {
+	else
 		sd_card->sd_lock_status &= ~SD_LOCKED;
-	}
 
 	RTSX_DEBUGP("sd_card->sd_lock_status = 0x%x\n", sd_card->sd_lock_status);
 
-	if (rsp[1] & 0x01) {
+	if (rsp[1] & 0x01)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

