Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0LHBDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:16 -0500
Received: from kroah.org ([198.145.64.141]:33620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0LHBDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:09 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005742.867957557@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Harrison Metzger <harrisonmetz@gmail.com>
Subject: [214/289] USB: misc: usbsevseg: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit e24d7ace4e822debcb78386bf279c9aba4d7fbd1 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harrison Metzger <harrisonmetz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/usbsevseg.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/usbsevseg.c
+++ b/drivers/usb/misc/usbsevseg.c
@@ -192,7 +192,7 @@ static ssize_t set_attr_##name(struct de
 								\
 	return count;						\
 }								\
-static DEVICE_ATTR(name, S_IWUGO | S_IRUGO, show_attr_##name, set_attr_##name);
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_attr_##name, set_attr_##name);
 
 static ssize_t show_attr_text(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -223,7 +223,7 @@ static ssize_t set_attr_text(struct devi
 	return count;
 }
 
-static DEVICE_ATTR(text, S_IWUGO | S_IRUGO, show_attr_text, set_attr_text);
+static DEVICE_ATTR(text, S_IRUGO | S_IWUSR, show_attr_text, set_attr_text);
 
 static ssize_t show_attr_decimals(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -272,8 +272,7 @@ static ssize_t set_attr_decimals(struct
 	return count;
 }
 
-static DEVICE_ATTR(decimals, S_IWUGO | S_IRUGO,
-	show_attr_decimals, set_attr_decimals);
+static DEVICE_ATTR(decimals, S_IRUGO | S_IWUSR, show_attr_decimals, set_attr_decimals);
 
 static ssize_t show_attr_textmode(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -319,8 +318,7 @@ static ssize_t set_attr_textmode(struct
 	return -EINVAL;
 }
 
-static DEVICE_ATTR(textmode, S_IWUGO | S_IRUGO,
-	show_attr_textmode, set_attr_textmode);
+static DEVICE_ATTR(textmode, S_IRUGO | S_IWUSR, show_attr_textmode, set_attr_textmode);
 
 
 MYDEV_ATTR_SIMPLE_UNSIGNED(powered, update_display_powered);


