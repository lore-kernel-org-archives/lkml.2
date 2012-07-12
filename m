Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161947Ab2GLWlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161893Ab2GLWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?y?q?=5B=20107/187=5D=20USB=3A=20qmi=5Fwwan=3A=20Add=20ZTE=20=28Vodafone=29=20K3520-Z?=
Date: Thu, 12 Jul 2012 15:34:23 -0700
Message-Id: <20120712191532.310606899@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>

commit f7142e6c226076fd40c2ebaad9fb0c9a631b790e upstream.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -356,6 +356,15 @@ static const struct driver_info	qmi_wwan
 };
 
 /* ZTE suck at making USB descriptors */
+static const struct driver_info	qmi_wwan_force_int1 = {
+	.description	= "Qualcomm WWAN/QMI device",
+	.flags		= FLAG_WWAN,
+	.bind		= qmi_wwan_bind_shared,
+	.unbind		= qmi_wwan_unbind_shared,
+	.manage_power	= qmi_wwan_manage_power,
+	.data		= BIT(1), /* interface whitelist bitmap */
+};
+
 static const struct driver_info	qmi_wwan_force_int4 = {
 	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
@@ -430,6 +439,15 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE (Vodafone) K3520-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x0055,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int1,
+	},
 	{	/* ZTE (Vodafone) K3565-Z */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,


