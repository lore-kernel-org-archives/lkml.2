Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2J2IiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:38:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51529 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2J2IiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:38:23 -0400
Message-ID: <1351499898.14725.5.camel@phoenix>
Subject: [PATCH] backlight: lm3639_bl: Fix up world writable sysfs file
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 16:38:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need the sysfs file to be world writable or group writable.
This file is write-only, change it to S_IWUSR (0200).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/video/backlight/lm3639_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 585949b..6f7a20e 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -214,7 +214,7 @@ out_input:
 
 }
 
-static DEVICE_ATTR(bled_mode, 0666, NULL, lm3639_bled_mode_store);
+static DEVICE_ATTR(bled_mode, S_IWUSR, NULL, lm3639_bled_mode_store);
 
 /* torch */
 static void lm3639_torch_brightness_set(struct led_classdev *cdev,
-- 
1.7.9.5



