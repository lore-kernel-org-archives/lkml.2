Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1KSBTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 20:19:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57093 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1KSBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 20:19:12 -0500
From: "Ken O'Brien" <kernel@kenobrien.org>
To: sjakub@gmail.com, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH] Staging: asus_oled: Fixed use of obsolete function.
Date: Sat, 19 Nov 2011 01:18:12 +0000
Message-Id: <1321665492-1718-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed use of obsolete function "strict_strtoul". Replaced with "kstrtoul"
as suggested by checkpatch.pl

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/asus_oled/asus_oled.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7bb7da7..e77e4e0 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -201,7 +201,7 @@ static ssize_t set_enabled(struct device *dev, struct device_attribute *attr,
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct asus_oled_dev *odev = usb_get_intfdata(intf);
 	unsigned long value;
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	enable_oled(odev, value);
@@ -217,7 +217,7 @@ static ssize_t class_set_enabled(struct device *device,
 		(struct asus_oled_dev *) dev_get_drvdata(device);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	enable_oled(odev, value);
-- 
1.7.5.4

