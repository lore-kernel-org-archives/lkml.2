Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0LHCHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:07:40 -0500
Received: from kroah.org ([198.145.64.141]:58409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab0LHAr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:30 2010
Message-Id: <20101208004430.800575691@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastien Bourdeauducq <sebastien@milkymist.org>
Subject: [065/127] USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastien Bourdeauducq <sebastien@milkymist.org>

commit 7fea0f714ffb3f303d4b66933af2df2f5584c9bf upstream.

Add the USB IDs for the Milkymist One FTDI-based JTAG/serial adapter
(http://projects.qi-hardware.com/index.php/p/mmone-jtag-serial-cable/)
to the ftdi_sio driver and disable the first serial channel (used as
JTAG from userspace).

Signed-off-by: Sebastien Bourdeauducq <sebastien@milkymist.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -800,6 +800,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
+	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1107,3 +1107,10 @@
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


