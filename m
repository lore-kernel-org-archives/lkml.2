Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2J2NJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:09:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34054 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2J2NJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:09:46 -0400
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH] Add bluetooth support for VAIO VPCEH [0489:e027]
Cc: linux-kernel@vger.kernel.org
From: Marcos Chaparro <marcos@mrkindustries.com.ar>
Organization: Mrk Industries
Date: Mon, 29 Oct 2012 10:09:12 -0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4/njQD219Vpj1fR"
Message-Id: <201210291009.12913.marcos@mrkindustries.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4/njQD219Vpj1fR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
this patch against 3.7-rc3 identifies my Atheros AR3011 internal bluetooth 
device, I just transferred some files from my phone to this debian PC using 
bluetooth and it works fine (btw, it needs atheros-firmware package).

Before changing this, lsusb was identifying it as a Foxconn / Hon Hai device, 
which is wrong, and it probably loaded a different firmware to the bluetooth 
module.

The patches solves the following discussions:
https://answers.launchpad.net/ubuntu/+source/bluez/+question/168992 
http://ubuntuforums.org/showthread.php?t=1867214 
http://linux-unix-open-source.1053819.n5.nabble.com/Atheros-AR9285-on-
Ubuntu-11-10-Sony-Vaio-VPCEH-wifi-does-t-works-td4931321.html 
http://www.vivaolinux.com.br/topico/Rede-Wireless/Bluetooth-vaio-VPCEH-
desabilitado 

Please tell me if you won't add it to mainstream for some reason.

Thanks in advance, and greetings from Argentina.

--
Marcos

PS: Sent again without HTML formatting

--Boundary-00=_4/njQD219Vpj1fR
Content-Type: text/x-patch;
  charset="utf-8";
  name="patchfile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patchfile"

diff -uNr linux-3.7-rc3.orig/drivers/bluetooth/ath3k.c linux-3.7-rc3.new/drivers/bluetooth/ath3k.c
--- linux-3.7-rc3.orig/drivers/bluetooth/ath3k.c	2012-10-28 16:24:48.000000000 -0300
+++ linux-3.7-rc3.new/drivers/bluetooth/ath3k.c	2012-10-29 09:39:03.459764720 -0300
@@ -67,6 +67,7 @@
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0489, 0xE03D) },
+	{ USB_DEVICE(0x0489, 0xE027) },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
diff -uNr linux-3.7-rc3.orig/drivers/bluetooth/btusb.c linux-3.7-rc3.new/drivers/bluetooth/btusb.c
--- linux-3.7-rc3.orig/drivers/bluetooth/btusb.c	2012-10-28 16:24:48.000000000 -0300
+++ linux-3.7-rc3.new/drivers/bluetooth/btusb.c	2012-10-29 09:39:06.219765159 -0300
@@ -124,6 +124,7 @@
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0489, 0xe027), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },

--Boundary-00=_4/njQD219Vpj1fR--
