Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949Ab2I1Usm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:48:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47033 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423034Ab2I1Use (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:34 -0400
X-Sasl-enc: xadQxNgeTYahCUZ5QDIx5aTKZAdqMjGIkH2giVIAfQVI 1348865313
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        John Hommel <john.hommel@hp.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 098/127] Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices
Date: Fri, 28 Sep 2012 13:34:31 -0700
Message-Id: <20120928203057.369878972@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit 92c385f46b30f4954e9dd2d2005c12d233b479ea upstream.

Many Broadcom devices has a vendor specific devices class, with this rule
we match all existent and future controllers with this behavior.

We also remove old rules to that matches product id for Broadcom devices.

Tested-by: John Hommel <john.hommel@hp.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -102,16 +102,14 @@ static struct usb_device_id btusb_table[
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0489, 0xe042) },
-	{ USB_DEVICE(0x0a5c, 0x21e3) },
-	{ USB_DEVICE(0x0a5c, 0x21e6) },
-	{ USB_DEVICE(0x0a5c, 0x21e8) },
-	{ USB_DEVICE(0x0a5c, 0x21f3) },
-	{ USB_DEVICE(0x0a5c, 0x21f4) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
 	{ USB_DEVICE(0x0489, 0xe033) },
 
+	/*Broadcom devices with vendor specific id */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
+
 	{ }	/* Terminating entry */
 };
 


