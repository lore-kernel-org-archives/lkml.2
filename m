Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1A3MkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:40:00 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:55235 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab1A3Mi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:28 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net F1BD21AB6F2
Subject: [PATCH 2/8] HID: roccat: Use new hid_err macros
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 13:38:21 +0100
Message-ID: <1296391101.2283.181.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new hid_err macros instead of dev_err.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-arvo.c     |   13 ++++++-------
 drivers/hid/hid-roccat-koneplus.c |   15 +++++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 8facbd3..ebf3c15 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -358,21 +358,20 @@ static int arvo_init_specials(struct hid_device *hdev)
 
 	arvo = kzalloc(sizeof(*arvo), GFP_KERNEL);
 	if (!arvo) {
-		dev_err(&hdev->dev, "can't alloc device descriptor\n");
+		hid_err(hdev, "can't alloc device descriptor\n");
 		return -ENOMEM;
 	}
 	hid_set_drvdata(hdev, arvo);
 
 	retval = arvo_init_arvo_device_struct(usb_dev, arvo);
 	if (retval) {
-		dev_err(&hdev->dev,
-				"couldn't init struct arvo_device\n");
+		hid_err(hdev, "couldn't init struct arvo_device\n");
 		goto exit_free;
 	}
 
 	retval = roccat_connect(arvo_class, hdev);
 	if (retval < 0) {
-		dev_err(&hdev->dev, "couldn't init char dev\n");
+		hid_err(hdev, "couldn't init char dev\n");
 	} else {
 		arvo->chrdev_minor = retval;
 		arvo->roccat_claimed = 1;
@@ -406,19 +405,19 @@ static int arvo_probe(struct hid_device *hdev,
 
 	retval = hid_parse(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto exit;
 	}
 
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (retval) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto exit;
 	}
 
 	retval = arvo_init_specials(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "couldn't install keyboard\n");
+		hid_err(hdev, "couldn't install keyboard\n");
 		goto exit_stop;
 	}
 
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 65d7cde..c826c0d 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -116,7 +116,7 @@ static int koneplus_receive_control_status(struct usb_device *usb_dev)
 			goto out;
 		}
 
-		dev_err(&usb_dev->dev, "koneplus_receive_control_status: "
+		hid_err(usb_dev, "koneplus_receive_control_status: "
 				"unknown response value 0x%x\n", control->value);
 		retval = -EINVAL;
 		goto out;
@@ -658,21 +658,20 @@ static int koneplus_init_specials(struct hid_device *hdev)
 
 		koneplus = kzalloc(sizeof(*koneplus), GFP_KERNEL);
 		if (!koneplus) {
-			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			hid_err(hdev, "can't alloc device descriptor\n");
 			return -ENOMEM;
 		}
 		hid_set_drvdata(hdev, koneplus);
 
 		retval = koneplus_init_koneplus_device_struct(usb_dev, koneplus);
 		if (retval) {
-			dev_err(&hdev->dev,
-					"couldn't init struct koneplus_device\n");
+			hid_err(hdev, "couldn't init struct koneplus_device\n");
 			goto exit_free;
 		}
 
 		retval = roccat_connect(koneplus_class, hdev);
 		if (retval < 0) {
-			dev_err(&hdev->dev, "couldn't init char dev\n");
+			hid_err(hdev, "couldn't init char dev\n");
 		} else {
 			koneplus->chrdev_minor = retval;
 			koneplus->roccat_claimed = 1;
@@ -708,19 +707,19 @@ static int koneplus_probe(struct hid_device *hdev,
 
 	retval = hid_parse(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto exit;
 	}
 
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (retval) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto exit;
 	}
 
 	retval = koneplus_init_specials(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "couldn't install mouse\n");
+		hid_err(hdev, "couldn't install mouse\n");
 		goto exit_stop;
 	}
 
-- 
1.7.3.4



