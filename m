Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0GLOsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:48:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab0GLOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CK/ZICQm+PEWbMpDQ5duQA/ooG5hYri2IKsdq9iBA6zh/lLuHCd2KtcyD2I2DiftU2
         jMRPJUTQN7Wzox/ox2QCEq7FXSMk/SuX5XGwWbWyjTa/5KNGusSG/X0HwQeBuXXdwzAm
         Qh0x1TPUDJHMfKEt1x26tf495WrQGSrmTmjVY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
        Peter Huewe <peterhuewe@gmx.de>, Julia Lawall <julia@diku.dk>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: panel: fix memory leak
Date: Mon, 12 Jul 2010 18:48:24 +0400
Message-Id: <1278946104-30300-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

panel_bind_key() must free allocated memory.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/panel/panel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 3154ffe..0fa910d 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1999,8 +1999,10 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 		return NULL;
 	}
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
-			     &scan_mask_o))
+			     &scan_mask_o)) {
+		kfree(key);
 		return NULL;
+	}
 
 	key->type = INPUT_TYPE_KBD;
 	key->state = INPUT_ST_LOW;
-- 
1.7.0.4

