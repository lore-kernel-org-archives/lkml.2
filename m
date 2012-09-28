Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2I1Ui0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:38:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37266 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261Ab2I1UiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:21 -0400
X-Sasl-enc: yVArd2QVdtjWbdm8+m88iwW1iQjVntTuck9MUpTMac18 1348864700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20196/218=5D=20net=3A=20qmi=5Fwwan=3A=20Add=20Vodafone/Huawei=20K5005=20support?=
Date: Fri, 28 Sep 2012 13:16:53 -0700
Message-Id: <20120928201524.067530106@linuxfoundation.org>
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

commit 88c16dc3bb61a1c1e9d4c78f45cc2107bc8d5249 upstream.

Tested-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -407,6 +407,14 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 8, /* NOTE: This is the *slave* interface of the CDC Union! */
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Vodafone/Huawei K5005 (12d1:14c8) and similar modems */
+		.match_flags        = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = HUAWEI_VENDOR_ID,
+		.bInterfaceClass    = USB_CLASS_VENDOR_SPEC,
+		.bInterfaceSubClass = 1,
+		.bInterfaceProtocol = 56, /* NOTE: This is the *slave* interface of the CDC Union! */
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 	{	/* Huawei E392, E398 and possibly others in "Windows mode"
 		 * using a combined control and data interface without any CDC
 		 * functional descriptors


