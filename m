Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2ETI3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 04:29:19 -0400
Received: from smarthost04.mail.zen.net.uk ([212.23.1.4]:32940 "EHLO
	smarthost04.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab2ETI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 04:29:15 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: bjorn@mork.no
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 2/3] USB: qmi_wwan: Add ZTE (Vodafone) K3765-Z
Date: Sun, 20 May 2012 09:28:37 +0100
Message-Id: <1337502518-1444-2-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
References: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost04-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ZTE (Vodafone) K3765-Z to the whitelist. This requires the
previous patch to make the whitelist with forced interface 4 generic
or the device fails to initialise. After applying this patch and
loading the Option driver without usb-modeswitch's bind all
interfaces trick, a wwan0 net interface and /dev/cdc-wdm0 device
file were created. Using Bjorn Mork's perl connection script a
connection was made to a mobile network using QMI and the network
interface's IPv4 address was configured OK.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/net/usb/qmi_wwan.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 62a1a43..0646e45 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -457,6 +457,15 @@ static const struct usb_device_id products[] = {
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE (Vodafone) K3765-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x2002,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
 	{	/* ZTE (Vodafone) K4505-Z */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,
-- 
1.7.5.4

