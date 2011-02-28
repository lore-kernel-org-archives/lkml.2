Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1B1Twq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:52:46 -0500
Received: from 15.70.mail-out.ovh.net ([178.33.253.55]:37925 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753265Ab1B1Twp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:52:45 -0500
X-Greylist: delayed 13999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 14:52:44 EST
Message-ID: <4D6BC4CB.6050602@osean.fr>
Date: Mon, 28 Feb 2011 16:52:43 +0100
From: Jean-Francois Argentino <jf.argentino@osean.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: jhovold@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ftdi_sio: adding support for OLIMEX ARM-USB-OCD-H
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14180427853780148558
X-Ovh-Remote: 82.241.52.98 (tga83-1-82-241-52-98.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from JF Argentino <jf.argentino@free.fr>

Adding support for the OLIMEX ARM-USB-OCD-H JTAG device (id 15ba:002b) 
based on FTDI FT2232H
Signed-off-by: JF Argentino <jf.argentino@free.fr>

--- linux-2.6.37.2/drivers/usb/serial/ftdi_sio_ids.h	2011-02-25 
00:09:00.000000000 +0100
+++ linux/drivers/usb/serial/ftdi_sio_ids.h	2011-02-28 
15:42:19.000000000 +0100
@@ -730,6 +730,7 @@
  /* Olimex */
  #define OLIMEX_VID			0x15BA
  #define OLIMEX_ARM_USB_OCD_PID		0x0003
+#define OLIMEX_ARM_USB_OCD_H_PID	0x002b

  /*
   * Telldus Technologies
--- linux-2.6.37.2/drivers/usb/serial/ftdi_sio.c	2011-02-25 
00:09:00.000000000 +0100
+++ linux/drivers/usb/serial/ftdi_sio.c	2011-02-28 16:27:02.000000000 +0100
@@ -721,6 +721,8 @@ static struct usb_device_id id_table_com
  	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_JTAGCABLEII_PID) },
  	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
  		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_H_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
  	{ USB_DEVICE(FIC_VID, FIC_NEO1973_DEBUG_PID),
  		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
  	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
