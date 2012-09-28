Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030896Ab2I1TLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:11:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54594 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030717Ab2I1TGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20245/262=5D=20net=3A=20qmi=5Fwwan=3A=20add=20Sierra=20Wireless=20devices?=
Date: Fri, 28 Sep 2012 11:52:54 -0700
Message-Id: <20120928183027.344742799@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 9b469a60d68b13c288d5c3fc23de29d9d482dbe6 upstream.

Add 6 new devices and one modified device, based on
information from laptop vendor Windows drivers.

Sony provides a driver with two new devices using
a Gobi 2k+ layout (1199:68a5 and 1199:68a9).  The
Sony driver also adds a non-standard QMI/net
interface to the already supported 1199:9011
Gobi device. We do not know whether this is an
alternate interface number or an additional
interface which might be present, but that doesn't
really matter.

Lenovo provides a driver supporting 4 new devices:
 - MC7770 (1199:901b) with standard Gobi 2k+ layout
 - MC7700 (0f3d:68a2) with layout similar to MC7710
 - MC7750 (114f:68a2) with layout similar to MC7710
 - EM7700 (1199:901c) with layout similar to MC7710

Note regaring the three devices similar to MC7710:

The Windows drivers only support interface #8 on these
devices.  The MC7710 can support QMI/net functions on
interface #19 and #20 as well, and this driver is
verified to work on interface #19 (a firmware bug is
suspected to prevent #20 from working).

We do not enable these additional interfaces until they
either show up in a Windows driver or are verified to
work in some other way.  Therefore limiting the new
devices to interface #8 for now.

[bmork: backported to 3.4: use driver whitelisting]
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
for stable: v3.4 and v3.5

 drivers/net/usb/qmi_wwan.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -534,6 +534,33 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_sierra,
 	},
+	{	/* Sierra Wireless MC7700 */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x0f3d,
+		.idProduct          = 0x68a2,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_sierra,
+	},
+	{	/* Sierra Wireless MC7750 */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x114f,
+		.idProduct          = 0x68a2,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_sierra,
+	},
+	{	/* Sierra Wireless EM7700 */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x1199,
+		.idProduct          = 0x901c,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_sierra,
+	},
 
 	/* Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
@@ -561,6 +588,8 @@ static const struct usb_device_id produc
 	{QMI_GOBI_DEVICE(0x05c6, 0x9265)},	/* Asus Gobi 2000 Modem device (VR305) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9235)},	/* Top Global Gobi 2000 Modem device (VR306) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9275)},	/* iRex Technologies Gobi 2000 Modem device (VR307) */
+	{QMI_GOBI_DEVICE(0x1199, 0x68a5)},	/* Sierra Wireless Modem */
+	{QMI_GOBI_DEVICE(0x1199, 0x68a9)},	/* Sierra Wireless Modem */
 	{QMI_GOBI_DEVICE(0x1199, 0x9001)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x9002)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x9003)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
@@ -577,6 +606,8 @@ static const struct usb_device_id produc
 	{QMI_GOBI_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
 	{QMI_GOBI_DEVICE(0x1199, 0x9015)},	/* Sierra Wireless Gobi 3000 Modem device */
 	{QMI_GOBI_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device */
+	{QMI_GOBI_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
+
 	{ }					/* END */
 };
 MODULE_DEVICE_TABLE(usb, products);


