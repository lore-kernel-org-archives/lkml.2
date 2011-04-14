Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1DNRpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:37553 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab1DNRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jakub Schmidtke <sjakub@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 025/209] Staging: asus_oled: fix up some sysfs attribute permissions
Date: Thu, 14 Apr 2011 13:40:55 -0400
Message-Id: <1302803039-9400-26-git-send-email-paul.gortmaker@windriver.com>
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

commit 590b0b9754bd8928926bae7194b6da7ead9bda3b upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Schmidtke <sjakub@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/asus_oled/asus_oled.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..3dd5173 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -620,13 +620,13 @@ static ssize_t class_set_picture(struct device *device,
 
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
-- 
1.7.4.4

