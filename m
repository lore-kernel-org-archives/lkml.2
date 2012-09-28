Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033141Ab2I1VT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:19:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58752 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759264Ab2I1UiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:22 -0400
X-Sasl-enc: R04Md5mAdeBcgD9huTv++HZQo2tUDyh5Nmv3rw+Do5By 1348864702
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20197/218=5D=20USB=3A=20qmi=5Fwwan=3A=20Add=20ZTE=20=28Vodafone=29=20K3765-Z?=
Date: Fri, 28 Sep 2012 13:16:54 -0700
Message-Id: <20120928201524.164078976@linuxfoundation.org>
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

From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>

commit 8965c98fdebedce077257241957b205515dd1a5f upstream.

Add the ZTE (Vodafone) K3765-Z to the whitelist. This requires the
previous patch to make the whitelist with forced interface 4 generic
or the device fails to initialise. After applying this patch and
loading the Option driver without usb-modeswitch's bind all
interfaces trick, a wwan0 net interface and /dev/cdc-wdm0 device
file were created. Using Bjorn Mork's perl connection script a
connection was made to a mobile network using QMI and the network
interface's IPv4 address was configured OK.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -480,6 +480,15 @@ static const struct usb_device_id produc
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


