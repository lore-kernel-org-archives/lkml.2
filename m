Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab0HLAWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:22:48 -0400
Received: from kroah.org ([198.145.64.141]:60309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587Ab0HLAEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:34 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.131697294@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cyril Lacoux <clacoux@ifeelgood.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [42/54] Bluetooth: Added support for controller shipped with iMac i5
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cyril Lacoux <clacoux@ifeelgood.org>

commit 0a79f67445de50ca0a8dc1d34f3cc406d89c28b2 upstream.

Device class is ff(vend.) instead of e0(wlcon).

Output from command `usb-devices`:
T:  Bus=01 Lev=03 Prnt=03 Port=00 Cnt=01 Dev#=  6 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=8215 Rev=01.82
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=7C6D62936607
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)

Signed-off-by: Cyril Lacoux <clacoux@ifeelgood.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -59,6 +59,9 @@ static struct usb_device_id btusb_table[
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple iMac11,1 */
+	{ USB_DEVICE(0x05ac, 0x8215) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 


