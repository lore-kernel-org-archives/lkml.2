Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1G0Q3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:29:30 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:44596 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1G0Q32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:29:28 -0400
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 12:29:27 EDT
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 4/4] USB: option driver: add PID for Vodafone-Huawei K4511
Date: Wed, 27 Jul 2011 17:03:20 +0100
Message-Id: <1311782600-13353-4-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
References: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost01-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the product ID of Huawei's Vodafone K4511 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on demand
without the intervention of usb_modeswitch. This has the benefit of it becoming
available faster and also ensures that the option driver is not bound to a
network interface that should be claimed by cdc_ether.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ceb9336..8156561 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -151,6 +151,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
+#define HUAWEI_PRODUCT_K4511			0x14CC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 #define HUAWEI_PRODUCT_E353			0x1506
 
@@ -556,6 +557,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
-- 
1.7.6

