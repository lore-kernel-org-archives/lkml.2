Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0LMAVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:21:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44895 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab0LLXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:56 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, sjakub@gmail.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [57/223] Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
Message-Id: <20101212234554.EDD0AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit 515b4987ccd097cdf5416530b05fdf9e01afe95a upstream.

They should be writable by root, not readable.
Doh, stupid me with the wrong flags.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jakub Schmidtke <sjakub@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/asus_oled/asus_oled.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/staging/asus_oled/asus_oled.c
===================================================================
--- linux.orig/drivers/staging/asus_oled/asus_oled.c
+++ linux/drivers/staging/asus_oled/asus_oled.c
@@ -620,13 +620,13 @@ static ssize_t class_set_picture(struct
 
 #define ASUS_OLED_DEVICE_ATTR(_file)		dev_attr_asus_oled_##_file
 
-static DEVICE_ATTR(asus_oled_enabled, S_IRUSR | S_IRUGO,
+static DEVICE_ATTR(asus_oled_enabled, S_IWUSR | S_IRUGO,
 		   get_enabled, set_enabled);
-static DEVICE_ATTR(asus_oled_picture, S_IRUSR , NULL, set_picture);
+static DEVICE_ATTR(asus_oled_picture, S_IWUSR , NULL, set_picture);
 
-static DEVICE_ATTR(enabled, S_IRUSR | S_IRUGO,
+static DEVICE_ATTR(enabled, S_IWUSR | S_IRUGO,
 		   class_get_enabled, class_set_enabled);
-static DEVICE_ATTR(picture, S_IRUSR, NULL, class_set_picture);
+static DEVICE_ATTR(picture, S_IWUSR, NULL, class_set_picture);
 
 static int asus_oled_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id)
