Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2JBPB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:01:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:36740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2JBPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="218353017"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 6/7] usb: core: reuse kbasename()
Date: Tue,  2 Oct 2012 18:00:59 +0300
Message-Id: <1349190062-13107-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/file.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index e5387a4..eff9af9 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/usb.h>
 
 #include "usb.h"
@@ -163,7 +164,6 @@ int usb_register_dev(struct usb_interface *intf,
 	int minor_base = class_driver->minor_base;
 	int minor;
 	char name[20];
-	char *temp;
 
 #ifdef CONFIG_USB_DYNAMIC_MINORS
 	/* 
@@ -200,14 +200,9 @@ int usb_register_dev(struct usb_interface *intf,
 
 	/* create a usb class device for this usb interface */
 	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
-	temp = strrchr(name, '/');
-	if (temp && (temp[1] != '\0'))
-		++temp;
-	else
-		temp = name;
 	intf->usb_dev = device_create(usb_class->class, &intf->dev,
 				      MKDEV(USB_MAJOR, minor), class_driver,
-				      "%s", temp);
+				      "%s", kbasename(name));
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
 		usb_minors[minor] = NULL;
-- 
1.7.10.4

