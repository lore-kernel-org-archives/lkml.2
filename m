Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab3AIUiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:41943 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab3AIUiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 026/123] qmi_wwan/cdc_ether: add Dell Wireless 5800 (Novatel E362) USB IDs
Date: Wed,  9 Jan 2013 12:34:25 -0800
Message-Id: <20130109201501.877415123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 0370acd4d4d2595a11b0b0a793acb506e19b9d4c upstream.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |   15 +++++++++++++++
 drivers/net/usb/qmi_wwan.c  |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -487,6 +487,7 @@ static const struct driver_info wwan_inf
 #define HUAWEI_VENDOR_ID	0x12D1
 #define NOVATEL_VENDOR_ID	0x1410
 #define ZTE_VENDOR_ID		0x19D2
+#define DELL_VENDOR_ID		0x413C
 
 static const struct usb_device_id	products [] = {
 /*
@@ -618,6 +619,20 @@ static const struct usb_device_id	produc
 	.driver_info = 0,
 },
 
+/* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8195, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
+/* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8196, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /*
  * WHITELIST!!!
  *
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -383,6 +383,20 @@ static const struct usb_device_id produc
 		                              USB_CDC_PROTO_NONE),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Dell Wireless 5800 (Novatel E362) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x8195,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
+	{	/* Dell Wireless 5800 V2 (Novatel E362) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x8196,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x12d1, 0x140c, 1)},	/* Huawei E173 */


