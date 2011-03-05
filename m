Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab1CEBKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:10:48 -0500
Received: from kroah.org ([198.145.64.141]:50363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477Ab1CEBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.188246982@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yu-Chen Cho <acho@novell.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [47/73] Bluetooth: add Atheros BT AR9285 fw supported
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yu-Chen Cho <acho@novell.com>

commit 509e7861d8a5e26bb07b5a3a13e2b9e442283631 upstream.

Add the btusb.c blacklist [03f0:311d] for Atheros AR9285 Malbec BT
and add to ath3k.c ath3-1.fw (md5:1211fa34c09e10ba48381586b7c3883d)
supported this device.

Signed-off-by: Yu-Chen Cho <acho@novell.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    3 +++
 2 files changed, 5 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -39,6 +39,8 @@ static struct usb_device_id ath3k_table[
 	/* Atheros AR3011 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3002) },
 
+	/* Atheros AR9285 Malbec with sflash firmware */
+	{ USB_DEVICE(0x03F0, 0x311D) },
 	{ }	/* Terminating entry */
 };
 
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -102,6 +102,9 @@ static struct usb_device_id blacklist_ta
 	/* Atheros 3011 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
 
+	/* Atheros AR9285 Malbec with sflash firmware */
+	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
+
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },


