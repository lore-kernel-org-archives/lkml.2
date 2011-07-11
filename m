Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1GKCPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:15:24 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56887 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1GKCPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:15:22 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p6B2F8h1003081, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] Fix a miswriting in ext_sd_send_cmd_get_rsp
Date: Mon, 11 Jul 2011 10:13:13 +0800
X-BOX-Message-Id: p6B2F8h1003081
Message-ID: <1310350393-6261-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

cppcheck reported: [staging/rts_pstor/sd.c:3730] -> [staging/rts_pstor/sd.c:3726]: (style) Found duplicate if expressions.
It's a miswriting, and the second if expression should be "(rsp_type == SD_RSP_TYPE_R0)"

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index e4b3891..8db14dd 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3747,7 +3747,7 @@ RTY_SEND_CMD:
 				if ((ptr[3] & 0x1E) != 0x04) {
 					TRACE_RET(chip, STATUS_FAIL);
 				}
-			} else if (rsp_type == SD_RSP_TYPE_R2) {
+			} else if (rsp_type == SD_RSP_TYPE_R0) {
 				if ((ptr[3] & 0x1E) != 0x03) {
 					TRACE_RET(chip, STATUS_FAIL);
 				}
-- 
1.7.6

