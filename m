Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab2FQS3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:29:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758359Ab2FQSWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:52 -0400
Message-Id: <20120617175947.697308622@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [ 45/69] usb: cdc-wdm: Add device-id for Huawei 3G/LTE modems
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit fec67b45bf045582c3172101970090d640cd56d9 upstream.

[v2: Editorial changes suggested by Sergei Shtylyov]

These modems use the Qualcomm MSM Interface (QMI) protocol for
management of their CDC ECM like wwan interface.  This driver
is perfect for exporting the protocol to userspace.

The created character device will be indistinguishable from a
common AT command based Device Management interface, so
userspace applications must do some intelligent matching
on the USB device.

Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index c154d4f..23cf9d3 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -31,6 +31,8 @@
 #define DRIVER_AUTHOR "Oliver Neukum"
 #define DRIVER_DESC "USB Abstract Control Model driver for USB WCM Device Management"
 
+#define HUAWEI_VENDOR_ID	0x12D1
+
 static const struct usb_device_id wdm_ids[] = {
 	{
 		.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS |
@@ -38,6 +40,20 @@ static const struct usb_device_id wdm_ids[] = {
 		.bInterfaceClass = USB_CLASS_COMM,
 		.bInterfaceSubClass = USB_CDC_SUBCLASS_DMM
 	},
+	{
+		/* 
+		 * Huawei E392, E398 and possibly other Qualcomm based modems
+		 * embed the Qualcomm QMI protocol inside CDC on CDC ECM like
+		 * control interfaces.  Userspace access to this is required
+		 * to configure the accompanying data interface
+		 */
+		.match_flags        = USB_DEVICE_ID_MATCH_VENDOR |
+					USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = HUAWEI_VENDOR_ID,
+		.bInterfaceClass    = USB_CLASS_VENDOR_SPEC,
+		.bInterfaceSubClass = 1,
+		.bInterfaceProtocol = 9, /* NOTE: CDC ECM control interface! */
+	},
 	{ }
 };
 


