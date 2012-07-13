Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221Ab2GMKVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:21:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30927 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2GMKVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:21:35 -0400
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Liuqifeng (Qifeng)" <qifeng.liuqifeng@huawei.com>,
        Wangyeqi <wangyeqi@huawei.com>,
        Wangchangliang <wangchangliang@huawei.com>,
        Zhuxinbo <zhuxinbo@huawei.com>
Subject: [PATCH 7/13] USB:support the new interfaces of Huawei Data Card
 devices in option driver
Thread-Topic: [PATCH 7/13] USB:support the new interfaces of Huawei Data
 Card devices in option driver
Thread-Index: Ac1gzTK4DnZ8Xb5EQmOskzHlz+Hq8w==
Date: Fri, 13 Jul 2012 10:20:23 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326D427A5@szxeml546-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.37.117]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>
1. This patch is based on the kernel of 3.5-rc6 
2. In this patch, we add new micro for matching the series USB devices with vendor ID and interface information.
3. In this patch, we add new declarations into option.c to support the new interfaces of Huawei Data Card devices.
Signed-off-by: fangxiaozhi <huananhu@huawei.com>
-----------------------
--- ../test/linux-3.5-rc6/include/linux/usb.h	2012-07-08 08:23:56.000000000 +0800
+++ include/linux/usb.h	2012-07-13 17:45:59.000000000 +0800
@@ -828,6 +828,27 @@ static inline int usb_make_path(struct u
 	.bInterfaceClass = (cl), \
 	.bInterfaceSubClass = (sc), \
 	.bInterfaceProtocol = (pr)
+/**
+ *  * USB_VENDOR_AND_INTERFACE_INFO - describe a specific usb device with a class of usb interfaces, but independent of product ID
+ *  @vend: the 16 bit USB Vendor ID
+ *  @cl: bInterfaceClass value
+ *  @sc: bInterfaceSubClass value
+ *  @pr: bInterfaceProtocol value
+ *  
+ *  This macro is used to create a struct usb_device_id that matches a
+ *  series of devices with a vendor ID and a specific class of interfaces.
+ * 
+ *  This is especially useful when explicitly matching the specific interface for series of different devices with
+ *  the same vendor. 
+ */
+
+#define USB_VENDOR_AND_INTERFACE_INFO(vend, cl, sc, pr) \
+	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
+		| USB_DEVICE_ID_MATCH_VENDOR, \
+	.idVendor = (vend), \
+	.bInterfaceClass = (cl), \
+	.bInterfaceSubClass = (sc), \
+	.bInterfaceProtocol = (pr)
 
 /* ----------------------------------------------------------------------- */
 
--- ../test/linux-3.5-rc6/drivers/usb/serial/option.c	2012-07-13 14:22:52.000000000 +0800
+++ drivers/usb/serial/option.c	2012-07-13 17:38:38.000000000 +0800
@@ -572,6 +572,115 @@ static const struct option_blacklist_inf
 };
 
 static const struct usb_device_id option_ids[] = {
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x7C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7C) },
+
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA_LIGHT) },
