Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422802Ab2I1VTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:19:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45679 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759278Ab2I1UiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:25 -0400
X-Sasl-enc: LZl1qJB37sGZcURBV06HxshzFWXcX7rbGOyqWuoG5KQ3 1348864704
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20199/218=5D=20net=3A=20qmi=5Fwwan=3A=20add=20ZTE=20MF60?=
Date: Fri, 28 Sep 2012 13:16:56 -0700
Message-Id: <20120928201524.402560832@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6fecd35d4cd79fc75e8290abb86734c18500d2a2 upstream.

Adding a device with limited QMI support. It does not support
normal QMI_WDS commands for connection management. Instead,
sending a QMI_CTL SET_INSTANCE_ID command is required to
enable the network interface:

  01 0f 00 00 00 00 00 00  20 00 04 00 01 01 00 00

A number of QMI_DMS and QMI_NAS commands are also supported
for optional device management.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -346,6 +346,15 @@ static const struct driver_info	qmi_wwan
 	.data		= BIT(1), /* interface whitelist bitmap */
 };
 
+static const struct driver_info qmi_wwan_force_int2 = {
+	.description	= "Qualcomm WWAN/QMI device",
+	.flags		= FLAG_WWAN,
+	.bind		= qmi_wwan_bind_shared,
+	.unbind		= qmi_wwan_unbind_shared,
+	.manage_power	= qmi_wwan_manage_power,
+	.data		= BIT(2), /* interface whitelist bitmap */
+};
+
 static const struct driver_info	qmi_wwan_force_int3 = {
 	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
@@ -498,6 +507,15 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE MF60 */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x1402,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int2,
+	},
 	{	/* Sierra Wireless MC77xx in QMI mode */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x1199,


