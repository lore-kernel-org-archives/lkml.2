Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2ARC0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:26:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab2ARC0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:26:46 -0500
Message-ID: <4F162DFD.7010200@chocky.org>
Date: Tue, 17 Jan 2012 18:27:09 -0800
From: Peter Naulls <peter@chocky.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ftdi USB serial additional IDs
Content-Type: multipart/mixed;
 boundary="------------060901050903090308090905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901050903090308090905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I tested this against 2.6.39 in the Ubuntu kernel, however I see the IDs are not 
in latest 3.2 git.

This adds IDs for the FTDI controller in the Rainforest Automation Zigbee
dongle.

I don't subscribe to this list, please CC responses.



--------------060901050903090308090905
Content-Type: text/x-patch;
 name="ftdi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ftdi.patch"

--- a/drivers/usb/serial/ftdi_sio_ids.h.orig	2012-01-16 15:05:19.479187251 -0800
+++ b/drivers/usb/serial/ftdi_sio_ids.h	2012-01-16 15:09:36.059187291 -0800
@@ -1159,4 +1159,8 @@
 /* USB-Nano-485*/
 #define FTDI_CTI_NANO_PID	0xF60B
 
-
+/*
+ * Rainforest Automation
+ */
+/* ZigBee controller */
+#define FTDI_RF_R106		0x8A28
--- a/drivers/usb/serial/ftdi_sio.c.orig	2012-01-16 15:05:27.727187253 -0800
+++ b/drivers/usb/serial/ftdi_sio.c	2012-01-16 15:10:37.695187302 -0800
@@ -828,6 +828,7 @@
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };


Signed-off-by: Peter Naulls <peter@chocky.org>

--------------060901050903090308090905--
