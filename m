Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1G0Qfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:35:39 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:44728 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1G0Qfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:35:36 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 1/4] USB: option driver: add PID for Vodafone-Huawei K3770
Date: Wed, 27 Jul 2011 17:03:17 +0100
Message-Id: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the product ID of Huawei's Vodafone K3770 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on demand
without the intervention of usb_modeswitch. This has the benefit of it becoming
available faster and also ensures that the option driver is not bound to a
network interface that should be claimed by cdc_ether.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 60b25d8..4dbce2d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -148,6 +148,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
+#define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 #define HUAWEI_PRODUCT_E353			0x1506
 
@@ -547,6 +548,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
-- 
1.7.6

