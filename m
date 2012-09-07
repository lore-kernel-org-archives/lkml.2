Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2IGE0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:26:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2IGE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:26:45 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 11/57] staging/rts_pstor: remove braces {} in sd.c (sd_wait_state_data_ready)
Date: Fri,  7 Sep 2012 13:26:35 +0900
Message-Id: <1346991996-16737-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 2ace2a0..8228231 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -757,13 +757,11 @@ static int sd_wait_state_data_ready(struct rtsx_chip *chip, u8 state, u8 data_re
 	for (i = 0; i < polling_cnt; i++) {
 		retval = sd_send_cmd_get_rsp(chip, SEND_STATUS,
 					     sd_card->sd_addr, SD_RSP_TYPE_R1, rsp, 5);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
-		if (((rsp[3] & 0x1E) == state) && ((rsp[3] & 0x01) == data_ready)) {
+		if (((rsp[3] & 0x1E) == state) && ((rsp[3] & 0x01) == data_ready))
 			return STATUS_SUCCESS;
-		}
 	}
 
 	TRACE_RET(chip, STATUS_FAIL);
-- 
1.7.9.5

