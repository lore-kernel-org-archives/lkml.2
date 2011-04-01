Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1DATqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:46:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43303 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1DATqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=hFIR+QgPBbLfsLwy3qK61cLvo4nR5lgqxwxnXEu9S1vHwgPMTJ6aaf7hvtd6lBAGtX
         pXIyflm0rMv9rK2MZWH0dU36B7vEiZe6n5kH1weHM19z3OQakYsXUdMLu7W3sRuXwcEX
         CQeW5+7+qFSXRYrSJEECEuRVnz1K5r1SNXykw=
Message-ID: <4D962B91.5090702@gmail.com>
Date: Fri, 01 Apr 2011 21:46:25 +0200
From: =?UTF-8?B?QmVuZWRlayBMw6FzemzDsw==?= <benedekl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110313 Thunderbird/3.3a3pre
MIME-Version: 1.0
To: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: New FTDI serial io vendor/product id patch
Content-Type: multipart/mixed;
 boundary="------------000603060508010507040304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000603060508010507040304
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear list,

I have an USB Atmel programmer which uses the FTDI driver. It has a
VID/PID pair of 0403:FA33. It identifies itself as "TavIR STK500". Here
is a photo of the the device:
http://avr.tavir.hu/images/contents/809/809l-stk500-m.jpg

lsusb output:
Bus 002 Device 005: ID 0403:fa33 Future Technology Devices
International, Ltd

dmesg output with patched kernel:
[ 1835.915073] usb 2-1.3: new full speed USB device using ehci_hcd and
address 5
[ 1836.012322] usb 2-1.3: New USB device found, idVendor=0403,
idProduct=fa33
[ 1836.012329] usb 2-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[ 1836.012336] usb 2-1.3: Product: TavIR STK500
[ 1836.012340] usb 2-1.3: Manufacturer: TavIR AVR
[ 1836.014620] ftdi_sio 2-1.3:1.0: FTDI USB Serial Device converter detected
[ 1836.014723] usb 2-1.3: Detected FT232RL
[ 1836.014730] usb 2-1.3: Number of endpoints 2
[ 1836.014737] usb 2-1.3: Endpoint 1 MaxPacketSize 64
[ 1836.014743] usb 2-1.3: Endpoint 2 MaxPacketSize 64
[ 1836.014749] usb 2-1.3: Setting MaxPacketSize 64
[ 1836.015394] usb 2-1.3: FTDI USB Serial Device converter now attached
to ttyUSB1

Please consider applying this trivial patch which allows the system to
recognise the device as a serial io port.

I'm not a subscriber of this mailing list, so please CC the answers
personally too. Thank you.

Regards,
Benedek László

--------------000603060508010507040304
Content-Type: text/x-diff;
 name="0001-USB-serial-FTDI-with-product-code-FA33-and-vendor-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-USB-serial-FTDI-with-product-code-FA33-and-vendor-id.pa";
 filename*1="tch"

>From 8f1c09d60e70f793bf818380a0c7d2a5064088e3 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Benedek=20L=C3=A1szl=C3=B3?= <benedekl@gmail.com>
Date: Fri, 1 Apr 2011 19:48:14 +0200
Subject: [PATCH] USB: serial: FTDI with product code FA33 and vendor id 0403

The TavIR-AVR USB STK500 Atmel programmer (0403:FA33) uses the
FTDI serial io driver, so add support for this device.
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f349a36..f1b047a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -563,6 +563,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_APP70_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	/*
 	 * ELV devices:
 	 */
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 117e8e6..ce6ed76 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -489,6 +489,11 @@
 /* www.canusb.com Lawicel CANUSB device (FTDI_VID) */
 #define FTDI_CANUSB_PID 0xFFA8 /* Product Id */
 
+/*
+ * TavIR AVR product ids (FTDI_VID)
+ */
+#define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
+
 
 
 /********************************/
-- 
1.7.4.1


--------------000603060508010507040304--
