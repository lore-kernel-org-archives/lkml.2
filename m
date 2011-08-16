Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1HPXUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:20:37 -0400
Received: from smarthost04.mail.zen.net.uk ([212.23.3.143]:34774 "EHLO
	smarthost04.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab1HPXU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:20:27 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 1/3] USB option driver add PID of Huawei Vodafone K3806
Date: Wed, 17 Aug 2011 00:20:02 +0100
Message-Id: <1313536804-5675-2-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
References: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost04-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the product ID of Huawei's Vodafone K3806 mobile broadband
modem to option.c. This is necessary so that the driver gets loaded on demand
without the intervention of usb_modeswitch. This has the benefit of it becoming
available faster and also ensures that the option driver is not bound to a
network interface that should be claimed by cdc_ether.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 8156561..6e04222 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -148,6 +148,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
+#define HUAWEI_PRODUCT_K3806			0x14AE
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
@@ -551,6 +552,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },
-- 
1.7.3.2

