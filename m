Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0LMADU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:03:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36424 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab0LLXrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: sebastien@milkymist.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [148/223] USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial
Message-Id: <20101212234731.5176BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sebastien Bourdeauducq <sebastien@milkymist.org>

commit 7fea0f714ffb3f303d4b66933af2df2f5584c9bf upstream.

Add the USB IDs for the Milkymist One FTDI-based JTAG/serial adapter
(http://projects.qi-hardware.com/index.php/p/mmone-jtag-serial-cable/)
to the ftdi_sio driver and disable the first serial channel (used as
JTAG from userspace).

Signed-off-by: Sebastien Bourdeauducq <sebastien@milkymist.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 9 insertions(+)

Index: linux/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio.c
+++ linux/drivers/usb/serial/ftdi_sio.c
@@ -794,6 +794,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
+	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
Index: linux/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux/drivers/usb/serial/ftdi_sio_ids.h
@@ -1100,3 +1100,10 @@
 #define FTDI_SCIENCESCOPE_LOGBOOKML_PID		0xFF18
 #define FTDI_SCIENCESCOPE_LS_LOGBOOK_PID	0xFF1C
 #define FTDI_SCIENCESCOPE_HS_LOGBOOK_PID	0xFF1D
+
+/*
+ * Milkymist One JTAG/Serial
+ */
+#define QIHARDWARE_VID			0x20B7
+#define MILKYMISTONE_JTAGSERIAL_PID	0x0713
+
