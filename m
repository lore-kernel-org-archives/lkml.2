Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3AECxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:53:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:22160 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3AECxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:53:50 -0500
From: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zihan@huawei.com>, <Lin.Lei@huawei.com>,
        <greg@kroah.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>, <balbi@ti.com>, <mdharm-usb@one-eyed-alien.net>,
        <sebastian@breakpoint.cc>
Message-ID: <fdcda8fa52a8.52a8fdcda8fa@huawei.com>
Date: Sat, 5 Jan 2013 10:53:23 +0800
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: [PATCH 1/1]linux-usb:Define a new macro for USB storage match
 rules
X-Accept-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>

1. Define a new macro for USB storage match rules: 
    matching with Vendor ID and interface descriptors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
--------------------------------------------------------------------
diff -uprN linux-3.8-rc2_orig/drivers/usb/storage/usb.c linux-3.8-rc2/drivers/usb/storage/usb.c
--- linux-3.8-rc2_orig/drivers/usb/storage/usb.c	2013-01-04 10:12:01.421356594 +0800
+++ linux-3.8-rc2/drivers/usb/storage/usb.c	2013-01-04 10:15:06.404043992 +0800
@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
 	.useTransport = use_transport,	\
 }
 
+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
+		vendor_name, product_name, use_protocol, use_transport, \
+		init_function, Flags) \
+{ \
+	.vendorName = vendor_name,	\
+	.productName = product_name,	\
+	.useProtocol = use_protocol,	\
+	.useTransport = use_transport,	\
+	.initFunction = init_function,	\
+}
+
 static struct us_unusual_dev us_unusual_dev_list[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -131,6 +142,7 @@ static struct us_unusual_dev for_dynamic
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 #ifdef CONFIG_LOCKDEP
 
diff -uprN linux-3.8-rc2_orig/drivers/usb/storage/usual-tables.c linux-3.8-rc2/drivers/usb/storage/usual-tables.c
--- linux-3.8-rc2_orig/drivers/usb/storage/usual-tables.c	2013-01-04 10:12:01.446356281 +0800
+++ linux-3.8-rc2/drivers/usb/storage/usual-tables.c	2013-01-04 10:15:20.186871683 +0800
@@ -41,6 +41,19 @@
 #define USUAL_DEV(useProto, useTrans) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
 
+/* Define the device is matched with Vendor ID and interface descriptors */
+#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
+			vendorName, productName, useProtocol, useTransport, \
+			initFunction, flags) \
+{ \
+	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
+				| USB_DEVICE_ID_MATCH_VENDOR, \
+	.idVendor    = (id_vendor), \
+	.bInterfaceClass = (cl), \
+	.bInterfaceSubClass = (sc), \
+	.bInterfaceProtocol = (pr), \
+	.driver_info = (flags) }
+
 struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -50,6 +63,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 /*
  * The table of devices to ignore

