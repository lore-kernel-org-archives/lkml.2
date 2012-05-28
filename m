Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2E1LnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:43:19 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.1.3]:58980 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab2E1LnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:43:15 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: smurf@smurf.noris.de, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH] USB: option: Updated Huawei K4605 has better id
Date: Mon, 28 May 2012 12:43:06 +0100
Message-Id: <1338205386-4333-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later firmwares for this device now have proper subclass and
protocol info so we can identify it nicely without needing to use
the blacklist. I'm not removing the old 0xff matching as there
may be devices in the field that still need that.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 1aae902..3ac049e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -666,6 +666,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },
-- 
1.7.6.5

