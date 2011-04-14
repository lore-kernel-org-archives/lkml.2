Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1DNRrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:38418 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab1DNRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Harrison Metzger <harrisonmetz@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 085/209] USB: misc: usbsevseg: fix up some sysfs attribute permissions
Date: Thu, 14 Apr 2011 13:41:55 -0400
Message-Id: <1302803039-9400-86-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e24d7ace4e822debcb78386bf279c9aba4d7fbd1 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harrison Metzger <harrisonmetz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/usbsevseg.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/usbsevseg.c b/drivers/usb/misc/usbsevseg.c
index de8ef94..417b8f2 100644
--- a/drivers/usb/misc/usbsevseg.c
+++ b/drivers/usb/misc/usbsevseg.c
@@ -192,7 +192,7 @@ static ssize_t set_attr_##name(struct device *dev, 		\
 								\
 	return count;						\
 }								\
-static DEVICE_ATTR(name, S_IWUGO | S_IRUGO, show_attr_##name, set_attr_##name);
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_attr_##name, set_attr_##name);
 
 static ssize_t show_attr_text(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -223,7 +223,7 @@ static ssize_t set_attr_text(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(text, S_IWUGO | S_IRUGO, show_attr_text, set_attr_text);
+static DEVICE_ATTR(text, S_IRUGO | S_IWUSR, show_attr_text, set_attr_text);
 
 static ssize_t show_attr_decimals(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -272,8 +272,7 @@ static ssize_t set_attr_decimals(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(decimals, S_IWUGO | S_IRUGO,
-	show_attr_decimals, set_attr_decimals);
+static DEVICE_ATTR(decimals, S_IRUGO | S_IWUSR, show_attr_decimals, set_attr_decimals);
 
 static ssize_t show_attr_textmode(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -319,8 +318,7 @@ static ssize_t set_attr_textmode(struct device *dev,
 	return -EINVAL;
 }
 
-static DEVICE_ATTR(textmode, S_IWUGO | S_IRUGO,
-	show_attr_textmode, set_attr_textmode);
+static DEVICE_ATTR(textmode, S_IRUGO | S_IWUSR, show_attr_textmode, set_attr_textmode);
 
 
 MYDEV_ATTR_SIMPLE_UNSIGNED(powered, update_display_powered);
-- 
1.7.4.4

