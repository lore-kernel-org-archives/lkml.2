Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054Ab1KJD3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935027Ab1KJD3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.374027001@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Artur Zimmer <artur128@3dzimmer.de>
Subject: [167/262] USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-device
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Zimmer <artur128@3dzimmer.de>

commit ce7e9065958191e6b7ca49d7ed0e1099c486d198 upstream.

Here is a patch for a new PID (zeitcontrol-device mifare-reader FT232BL(like FT232BM but lead free)).

Signed-off-by: Artur Zimmer <artur128@3dzimmer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -156,6 +156,7 @@ static struct ftdi_sio_quirk ftdi_8u2232
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1162,4 +1162,8 @@
 /* USB-Nano-485*/
 #define FTDI_CTI_NANO_PID	0xF60B
 
-
+/*
+ * ZeitControl cardsystems GmbH rfid-readers http://zeitconrol.de
+ */
+/* TagTracer MIFARE*/
+#define FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID	0xF7C0


