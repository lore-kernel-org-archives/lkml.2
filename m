Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0LMAA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:00:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36511 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0LLXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:45 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, harrisonmetz@gmail.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [160/223] USB: misc: usbsevseg: fix up some sysfs attribute permissions
Message-Id: <20101212234744.12642B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit e24d7ace4e822debcb78386bf279c9aba4d7fbd1 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harrison Metzger <harrisonmetz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/usbsevseg.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux/drivers/usb/misc/usbsevseg.c
===================================================================
--- linux.orig/drivers/usb/misc/usbsevseg.c
+++ linux/drivers/usb/misc/usbsevseg.c
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
