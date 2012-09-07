Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2IGE2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:28:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2IGE2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:28:15 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 16/57] staging/rts_pstor: remove braces {} in sd.c (sd_check_switch_mode)
Date: Fri,  7 Sep 2012 13:28:09 +0900
Message-Id: <1346992089-16898-1-git-send-email-yamanetoshi@gmail.com>
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
index aae9c72..2b7a4e1 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1141,13 +1141,12 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 		 */
 		u16 cc = ((u16)buf[0] << 8) | buf[1];
 		RTSX_DEBUGP("Maximum current consumption: %dmA\n", cc);
-		if ((cc == 0) || (cc > 800)) {
+		if ((cc == 0) || (cc > 800))
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = sd_query_switch_result(chip, func_group, func_to_switch, buf, 64);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if ((cc > 400) || (func_to_switch > CURRENT_LIMIT_400)) {
 			RTSX_WRITE_REG(chip, OCPPARA2, SD_OCP_THD_MASK, chip->sd_800mA_ocp_thd);
-- 
1.7.9.5

