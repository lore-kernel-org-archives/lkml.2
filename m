Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0LHBAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:37 -0500
Received: from kroah.org ([198.145.64.141]:48801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0LHBAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.844797650@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jakub Schmidtke <sjakub@gmail.com>
Subject: [095/289] Staging: asus_oled: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 590b0b9754bd8928926bae7194b6da7ead9bda3b upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Schmidtke <sjakub@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/asus_oled/asus_oled.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -620,13 +620,13 @@ static ssize_t class_set_picture(struct
 
 #define ASUS_OLED_DEVICE_ATTR(_file)		dev_attr_asus_oled_##_file
 
-static DEVICE_ATTR(asus_oled_enabled, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(asus_oled_enabled, S_IRUSR | S_IRUGO,
 		   get_enabled, set_enabled);
-static DEVICE_ATTR(asus_oled_picture, S_IWUGO , NULL, set_picture);
+static DEVICE_ATTR(asus_oled_picture, S_IRUSR , NULL, set_picture);
 
-static DEVICE_ATTR(enabled, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(enabled, S_IRUSR | S_IRUGO,
 		   class_get_enabled, class_set_enabled);
-static DEVICE_ATTR(picture, S_IWUGO, NULL, class_set_picture);
+static DEVICE_ATTR(picture, S_IRUSR, NULL, class_set_picture);
 
 static int asus_oled_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id)


