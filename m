Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2CYKKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:10:46 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:41161 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511Ab2CYKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:10:40 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@linuxfoundation.org
Cc: smurf@smurf.noris.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 2/3] USB: option: Ignore ZTE (Vodafone) K3570/71 net interfaces
Date: Sun, 25 Mar 2012 11:10:28 +0100
Message-Id: <1332670229-2045-3-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
References: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost02-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These interfaces need to be handled by QMI/WWAN driver

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6815701..836cfa9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -903,8 +903,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0165, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0167, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff, 0xff) },
-- 
1.7.6.5

