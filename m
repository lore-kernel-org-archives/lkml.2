Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760Ab2I1TGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:06:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685Ab2I1TGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?q?Thomas=20Sch=E4fer?= <tschaefer@t-online.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20246/262=5D=20net=3A=20qmi=5Fwwan=3A=20new=20devices=3A=20UML290=20and=20K5006-Z?=
Date: Fri, 28 Sep 2012 11:52:55 -0700
Message-Id: <20120928183027.490371160@linuxfoundation.org>
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

commit 10cbc1d97a7c7f9ae862fffe27b771ef0da9c461 upstream.

Newer firmware versions for the Pantech UML290 use a different
subclass ID.  The Windows driver match on both IDs, so we do
that as well.

The ZTE (Vodafone) K5006-Z is a new device.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Thomas Schäfer <tschaefer@t-online.de>
[bmork: backported to 3.4: use driver whitelisting]
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
for stable: v3.4 and v3.5

 drivers/net/usb/qmi_wwan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -444,6 +444,15 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_shared,
 	},
+	{	/* Pantech UML290 - newer firmware */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x106c,
+		.idProduct          = 0x3718,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xf1,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_shared,
+	},
 	{	/* ZTE MF820D */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,
@@ -516,6 +525,15 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE (Vodafone) K5006-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x1018,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int3,
+	},
 	{	/* ZTE MF60 */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,


