Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab1KWAgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:36:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab1KWAgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:36:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:56 2011
Message-Id: <20111123002556.106636364@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Alvin.Zheng" <zheng.zhijian@zte.com.cn>,
        wsalvin <wsalvin@yahoo.com.cn>
Subject: [34/53] USB: option: release new PID for ZTE 3G modem
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zheng.zhijian@zte.com.cn" <zheng.zhijian@zte.com.cn>

commit 46b5a277ed90317a4d17e936c16037e76011b219 upstream.

This patch adds new PIDs for ZTE 3G modem, after we confirm it and tested.
Thanks for Dan's work at kernel option devier.

Signed-off-by: Alvin.Zheng <zheng.zhijian@zte.com.cn>
Signed-off-by: wsalvin <wsalvin@yahoo.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -316,6 +316,9 @@ static void option_instat_callback(struc
 #define ZTE_PRODUCT_AC8710			0xfff1
 #define ZTE_PRODUCT_AC2726			0xfff5
 #define ZTE_PRODUCT_AC8710T			0xffff
+#define ZTE_PRODUCT_MC2718			0xffe8
+#define ZTE_PRODUCT_AD3812			0xffeb
+#define ZTE_PRODUCT_MC2716			0xffed
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -500,6 +503,18 @@ static const struct option_blacklist_inf
 	.reserved = BIT(4),
 };
 
+static const struct option_blacklist_info zte_ad3812_z_blacklist = {
+	.sendsetup = BIT(0) | BIT(1) | BIT(2),
+};
+
+static const struct option_blacklist_info zte_mc2718_z_blacklist = {
+	.sendsetup = BIT(1) | BIT(2) | BIT(3) | BIT(4),
+};
+
+static const struct option_blacklist_info zte_mc2716_z_blacklist = {
+	.sendsetup = BIT(1) | BIT(2) | BIT(3),
+};
+
 static const struct option_blacklist_info huawei_cdc12_blacklist = {
 	.reserved = BIT(1) | BIT(2),
 };
@@ -1043,6 +1058,12 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2718, 0xff, 0xff, 0xff),
+	 .driver_info = (kernel_ulong_t)&zte_mc2718_z_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AD3812, 0xff, 0xff, 0xff),
+	 .driver_info = (kernel_ulong_t)&zte_ad3812_z_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2716, 0xff, 0xff, 0xff),
+	 .driver_info = (kernel_ulong_t)&zte_mc2716_z_blacklist },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */


