Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab2BAVy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:54:56 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51705 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013Ab2BAVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:03 -0500
X-Sasl-enc: x6fRbczHMCeXdKLKakSXDOP7kY31fTa0dzPEuHPViJje 1328130481
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:32 2012
Message-Id: <20120201201532.083848738@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Naulls <peter@chocky.org>
Subject: [12/20] USB: serial: ftdi additional IDs
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Naulls <peter@chocky.org>

commit fc216ec363f4d174932df90bbf35c77d0540e561 upstream.

I tested this against 2.6.39 in the Ubuntu kernel, however I see the IDs
are not in latest 3.2 git.

This adds IDs for the FTDI controller in the Rainforest Automation
Zigbee dongle.

Signed-off-by: Peter Naulls <peter@chocky.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -844,6 +844,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1180,3 +1180,9 @@
  */
 /* TagTracer MIFARE*/
 #define FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID	0xF7C0
+
+/*
+ * Rainforest Automation
+ */
+/* ZigBee controller */
+#define FTDI_RF_R106		0x8A28


