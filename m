Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2KHGpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:45:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38502 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2KHGp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:45:29 -0500
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH]backlight: lm3639: fix coccinelle warning.
Date: Thu,  8 Nov 2012 15:44:49 +0900
Message-Id: <1352357089-4819-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

Fix coccinelle warning.

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/lm3639_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 585949b..868a9da 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -403,9 +403,9 @@ static int __devexit lm3639_remove(struct i2c_client *client)
 
 	regmap_write(pchip->regmap, REG_ENABLE, 0x00);
 
-	if (&pchip->cdev_torch)
+	if ((&pchip->cdev_torch)!=NULL)
 		led_classdev_unregister(&pchip->cdev_torch);
-	if (&pchip->cdev_flash)
+	if ((&pchip->cdev_flash)!=NULL)
 		led_classdev_unregister(&pchip->cdev_flash);
 	if (pchip->bled) {
 		device_remove_file(&(pchip->bled->dev), &dev_attr_bled_mode);
-- 
1.7.5.4

