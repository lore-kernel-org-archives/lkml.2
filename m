Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3AHChB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:37:01 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:54326 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3AHChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:37:00 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sisusbvga: use proper device for dev_err() during probe
Date: Mon,  7 Jan 2013 21:36:52 -0500
Message-Id: <1357612612-37962-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc returns NULL, do not dereference the said NULL pointer as the
first argument to dev_err(); use &dev->dev instead.  Similarly, before
sisusb->sisusb_dev has been initialized to dev, use dev_err(&dev->dev)
instead.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index dd573ab..bf5f12c 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3084,7 +3084,7 @@ static int sisusb_probe(struct usb_interface *intf,
 
 	/* Allocate memory for our private */
 	if (!(sisusb = kzalloc(sizeof(*sisusb), GFP_KERNEL))) {
-		dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate memory for private data\n");
+		dev_err(&dev->dev, "Failed to allocate memory for private data\n");
 		return -ENOMEM;
 	}
 	kref_init(&sisusb->kref);
@@ -3093,7 +3093,7 @@ static int sisusb_probe(struct usb_interface *intf,
 
 	/* Register device */
 	if ((retval = usb_register_dev(intf, &usb_sisusb_class))) {
-		dev_err(&sisusb->sisusb_dev->dev, "Failed to get a minor for device %d\n",
+		dev_err(&dev->dev, "Failed to get a minor for device %d\n",
 			dev->devnum);
 		retval = -ENODEV;
 		goto error_1;
-- 
1.7.10.4

