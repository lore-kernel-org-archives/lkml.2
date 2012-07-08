Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2GHJZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 05:25:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2GHJZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 05:25:49 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com
Cc: sjakub@gmail.com, linux-kernel@vger.kernel.org,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] [PATCH] asus_oled: Use pr_err(...) rather than printk(KERN_ERR ...)
Date: Sun,  8 Jul 2012 18:25:47 +0900
Message-Id: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by checkpatch.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/asus_oled/asus_oled.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 510d796..f63c1d3 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -782,20 +782,20 @@ static int __init asus_oled_init(void)
 	oled_class = class_create(THIS_MODULE, ASUS_OLED_UNDERSCORE_NAME);
 
 	if (IS_ERR(oled_class)) {
-		printk(KERN_ERR "Error creating " ASUS_OLED_UNDERSCORE_NAME " class\n");
+		pr_err("Error creating " ASUS_OLED_UNDERSCORE_NAME " class\n");
 		return PTR_ERR(oled_class);
 	}
 
 	retval = class_create_file(oled_class, &class_attr_version.attr);
 	if (retval) {
-		printk(KERN_ERR "Error creating class version file\n");
+		pr_err("Error creating class version file\n");
 		goto error;
 	}
 
 	retval = usb_register(&oled_driver);
 
 	if (retval) {
-		printk(KERN_ERR "usb_register failed. Error number %d\n", retval);
+		pr_err("usb_register failed. Error number %d\n", retval);
 		goto error;
 	}
 
-- 
1.7.5.4

