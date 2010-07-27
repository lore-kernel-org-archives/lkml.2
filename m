Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0G0Cog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 22:44:36 -0400
Received: from trinity.trinnet.net ([69.12.138.16]:62728 "EHLO
	trinity4.trinnet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586Ab0G0Cof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 22:44:35 -0400
Date: Mon, 26 Jul 2010 19:44:33 -0700
From: dranch@trinnet.net
To: greg@kroah.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: dranch@trinnet.net
Subject: [PATCH] small FTDI USB serial driver update -- attempt #2
Message-ID: <20100727024433.GA29758@trinity4.trinnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resending via Mutt due to various issues cited by Greg Kroah-Hartman on my 
first attempt via Thunderbird2.


Reason for patch:
-----------------
This patch is to add a US Interface, Inc. "Navigator" USB device.
Specifically, it's a HAM Radio USB sound modem that also
incorporates three pairs of unique FTDI serial ports.  The standard
Linux FTDI serial driver will only recognize the first two serial
ports of an unknown FDTI derived device and this patch adds in
recognition to these specific new IDs.

Diffs are against a vanilla 2.6.34

Signed-off-by: David A. Ranch <dranch@trinnet.net>



--- linux-2.6.34/drivers/usb/serial/ftdi_sio_ids.h.orig 2010-07-25 07:17:44.000000000 -0700
+++ linux-2.6.34/drivers/usb/serial/ftdi_sio_ids.h      2010-07-25 07:20:46.000000000 -0700
@@ -40,6 +40,13 @@

 #define FTDI_NXTCAM_PID                0xABB8 /* NXTCam for Mindstorms NXT */

+/* US Interface Navigator (http://www.usinterface.com/). */
+/* Submitted by David Ranch */
+#define FTDI_USINT_CAT_PID     0xB810  /* Navigator CAT and 2nd PTT lines */
+#define FTDI_USINT_WKEY_PID    0xB811  /* Navigator WKEY and FSK lines */
+#define FTDI_USINT_RS232_PID   0xB812  /* Navigator RS232 and CONFIG lines */
+
+
 /* OOCDlink by Joern Kaipf <joernk@web.de>
  * (http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink) */
 #define FTDI_OOCDLINK_PID      0xbaf8  /* Amontec JTAGkey */



--- linux-2.6.34/drivers/usb/serial/ftdi_sio.c.orig     2010-07-25 07:21:10.000000000 -0700
+++ linux-2.6.34/drivers/usb/serial/ftdi_sio.c  2010-07-25 07:24:21.000000000 -0700
@@ -162,6 +162,9 @@ static struct usb_device_id id_table_com
        { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_5_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_6_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_7_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_CAT_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_WKEY_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_RS232_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_ACTZWAVE_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_IRTRANS_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_IPLUS_PID) 


