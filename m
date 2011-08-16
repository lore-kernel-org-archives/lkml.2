Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1HPXUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:20:39 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:60850 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab1HPXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:20:29 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 2/3] USB option driver K3765/K4505 avoid CDC_DATA interface
Date: Wed, 17 Aug 2011 00:20:03 +0100
Message-Id: <1313536804-5675-3-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
References: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost01-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the Option driver avoids binding interface 1 on Huawei K3765
and K4505 broadband modems as it should be handled by the cdc_ether
driver instead. This patch ensures we don't bind the interface 2
on those devices as that is CDC_DATA.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/option.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6e04222..53911aa 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1140,7 +1140,8 @@ static int option_probe(struct usb_serial *serial,
 	if (serial->dev->descriptor.idVendor == HUAWEI_VENDOR_ID &&
 		(serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K3765 ||
 			serial->dev->descriptor.idProduct == HUAWEI_PRODUCT_K4505) &&
-		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
+		(serial->interface->cur_altsetting->desc.bInterfaceNumber == 1 ||
+			serial->interface->cur_altsetting->desc.bInterfaceNumber == 2))
 		return -ENODEV;
 
 	/* Don't bind network interface on Samsung GT-B3730, it is handled by a separate module */
-- 
1.7.3.2

