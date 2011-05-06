Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1EFAqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:46:37 -0400
Received: from kroah.org ([198.145.64.141]:37053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1EFAZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.333251525@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [093/143] Bluetooth: Add support Bluetooth controller of MacbookPro 7,1
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

commit 3cd01976e702ccaffb907727caff4f8789353599 upstream.

Bluetooth controller of MacbookPro 7,1 does not work.
Because Device Class of these controllers was set 255 (Vendor Sepecific Class).

T:  Bus=04 Lev=02 Prnt=04 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=8213 Rev=01.86
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=5C5948C81B99
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -59,6 +59,9 @@ static struct usb_device_id btusb_table[
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple MacBookPro 7,1 */
+	{ USB_DEVICE(0x05ac, 0x8213) },
+
 	/* Apple iMac11,1 */
 	{ USB_DEVICE(0x05ac, 0x8215) },
 


