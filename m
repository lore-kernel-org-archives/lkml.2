Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0D3Q7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:59:14 -0400
Received: from kroah.org ([198.145.64.141]:34120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab0D3Q6c (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:32 -0400
Subject: patch usb-core-config.c-usb_get_configuration-simplified.patch added to gregkh-2.6 tree
To: mina86@mina86.com, gregkh@suse.de, Linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Thu, 29 Apr 2010 16:21:08 -0700
In-Reply-To: <87sk6uaz9h.fsf@erwin.mina86.com>
Message-ID: <1272583268118@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: core: config.c: usb_get_configuration() simplified

to my gregkh-2.6 tree.  Its filename is

    usb-core-config.c-usb_get_configuration-simplified.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From mina86@mina86.com  Thu Apr 29 16:05:40 2010
From: Michal Nazarewicz <mina86@mina86.com>
Date: Sat, 17 Apr 2010 17:12:58 +0200
Subject: USB: core: config.c: usb_get_configuration() simplified
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, <Linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <87sk6uaz9h.fsf@erwin.mina86.com>


usb_gat_configuratio() used two pointers to point to the same
memory.  Code simplified, by removing one of them.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/config.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -735,7 +735,6 @@ int usb_get_configuration(struct usb_dev
 	int ncfg = dev->descriptor.bNumConfigurations;
 	int result = 0;
 	unsigned int cfgno, length;
-	unsigned char *buffer;
 	unsigned char *bigbuffer;
 	struct usb_config_descriptor *desc;
 
@@ -764,17 +763,16 @@ int usb_get_configuration(struct usb_dev
 	if (!dev->rawdescriptors)
 		goto err2;
 
-	buffer = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
-	if (!buffer)
+	desc = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
+	if (!desc)
 		goto err2;
-	desc = (struct usb_config_descriptor *)buffer;
 
 	result = 0;
 	for (; cfgno < ncfg; cfgno++) {
 		/* We grab just the first descriptor so we know how long
 		 * the whole configuration is */
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
-		    buffer, USB_DT_CONFIG_SIZE);
+		    desc, USB_DT_CONFIG_SIZE);
 		if (result < 0) {
 			dev_err(ddev, "unable to read config index %d "
 			    "descriptor/%s: %d\n", cfgno, "start", result);
@@ -823,7 +821,7 @@ int usb_get_configuration(struct usb_dev
 	result = 0;
 
 err:
-	kfree(buffer);
+	kfree(desc);
 out_not_authorized:
 	dev->descriptor.bNumConfigurations = cfgno;
 err2:

