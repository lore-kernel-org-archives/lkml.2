Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1EWIhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:37:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37111 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1EWIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:37:19 -0400
From: Shahar Lev <shahar@wizery.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, pavan_savoy@ti.com,
        Shahar Lev <shahar@wizery.com>
Subject: [PATCH] drivers:misc: ti-st: fix skipping of change remote baud
Date: Mon, 23 May 2011 11:36:11 +0300
Message-Id: <1306139771-9705-1-git-send-email-shahar@wizery.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the incrementing of ptr in skip_change_remote_baud,
it points to cur_action, but the increment is done by
the size of nxt_action instead. This could cause ptr
to not point to a bts_action structure, which is
harmful for the increment of ptr done in download_firmware.
Therefore, the skipping is first done for cur_action.

Signed-off-by: Shahar Lev <shahar@wizery.com>
---
 drivers/misc/ti-st/st_kim.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 5da93ee..e58ebec 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -245,9 +245,9 @@ void skip_change_remote_baud(unsigned char **ptr, long *len)
 		pr_err("invalid action after change remote baud command");
 	} else {
 		*ptr = *ptr + sizeof(struct bts_action) +
-			((struct bts_action *)nxt_action)->size;
+			((struct bts_action *)cur_action)->size;
 		*len = *len - (sizeof(struct bts_action) +
-				((struct bts_action *)nxt_action)->size);
+				((struct bts_action *)cur_action)->size);
 		/* warn user on not commenting these in firmware */
 		pr_warn("skipping the wait event of change remote baud");
 	}
-- 
1.7.4.1

