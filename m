Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0DUPfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:35:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40488 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab0DUPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ozcFU4AACo/8b1V+ViyeiaXzl7QmLbYmXBB84hxBm19gqIspqimq5Fa4FaUOQkcpzZ
         TRWE7oDRMwf2rQfdKAlf2qnGcPjiqVkHG25Tne+yQNbGv7sNcG8Xi0Wlfaph9YhDH9Vz
         M7fJC5ZYHJPI5mpgMTubCzh3bZLGzL8GS8AmU=
From: Rabin Vincent <rabin@rab.in>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       Rabin Vincent <rabin@rab.in>
Subject: [PATCH] mfd: WM8350: remove incorrect kfree
Date: Wed, 21 Apr 2010 21:06:05 +0530
Message-Id: <1271864165-8096-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_client received in probe() should not be kfree()'d.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/mfd/wm8350-i2c.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 65830f5..5fe5de1 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -64,10 +64,8 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	int ret = 0;
 
 	wm8350 = kzalloc(sizeof(struct wm8350), GFP_KERNEL);
-	if (wm8350 == NULL) {
-		kfree(i2c);
+	if (wm8350 == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, wm8350);
 	wm8350->dev = &i2c->dev;
-- 
1.7.0.4

