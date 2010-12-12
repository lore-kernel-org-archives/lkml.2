Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0LLXri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36440 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab0LLXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:33 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: m00150988@huawei.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [149/223] USB: option: fix when the driver is loaded incorrectly for some Huawei devices.
Message-Id: <20101212234732.6456CB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: ma rui <m00150988@huawei.com>

commit 58c0d9d70109bd7e82bdb9517007311a48499960 upstream.

When huawei datacard with PID 0x14AC is insterted into Linux system, the
present kernel will load the "option" driver to all the interfaces. But
actually, some interfaces run as other function and do not need "option"
driver.

In this path, we modify the id_tables, when the PID is 0x14ac ,VID is
0x12d1, Only when the interface's Class is 0xff,Subclass is 0xff, Pro is
0xff, it does need "option" driver.

Signed-off-by: ma rui <m00150988@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/option.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/serial/option.c
===================================================================
--- linux.orig/drivers/usb/serial/option.c
+++ linux/drivers/usb/serial/option.c
@@ -492,7 +492,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
