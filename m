Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2ETUpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:45:43 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:43215 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595Ab2ETUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:45:11 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net C2724AA46A
Subject: [PATCH 4/4] HID: roccat: Fixed wrong hid_err usage on struct
 usb_device
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 May 2012 22:45:08 +0200
Message-ID: <1337546708.19878.33.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 40090d6..9ce2d0b 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -138,7 +138,7 @@ static int kone_check_write(struct usb_device *usb_dev)
 		return 0;
 
 	/* unknown answer */
-	hid_err(usb_dev, "got retval %d when checking write\n", data);
+	dev_err(&usb_dev->dev, "got retval %d when checking write\n", data);
 	return -EIO;
 }
 
@@ -503,7 +503,7 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 
 		retval = kone_set_settings(usb_dev, &kone->settings);
 		if (retval) {
-			hid_err(usb_dev, "couldn't set tcu state\n");
+			dev_err(&usb_dev->dev, "couldn't set tcu state\n");
 			/*
 			 * try to reread valid settings into buffer overwriting
 			 * first error code
@@ -519,7 +519,7 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 
 	retval = size;
 exit_no_settings:
-	hid_err(usb_dev, "couldn't read settings\n");
+	dev_err(&usb_dev->dev, "couldn't read settings\n");
 exit_unlock:
 	mutex_unlock(&kone->kone_lock);
 	return retval;
-- 
1.7.3.4



