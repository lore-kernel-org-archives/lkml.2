Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438Ab0G3TD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:03:28 -0400
Received: from kroah.org ([198.145.64.141]:51699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086Ab0G3RSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:06 2010
Message-Id: <20100730171506.335856393@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Leitner <colin.leitner@googlemail.com>
Subject: [074/165] USB: ftdi_sio: support for Signalyzer tools based on FTDI chips
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 77dbd74e16b566e9d5eeb4be18ae3ee7d5902bd3 upstream.

ftdi_sio: support for Signalyzer tools based on FTDI chips

This patch adds support for the Xverve Signalyzers.

Signed-off-by: Colin Leitner <colin.leitner@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    8 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h |    9 +++++++++
 2 files changed, 17 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -743,6 +743,14 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_HD_RADIO_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_XM_RADIO_PID) },
+	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_ST_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SLITE_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH2_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1024,3 +1024,12 @@
 #define MJSG_SR_RADIO_PID	0x9379
 #define MJSG_XM_RADIO_PID	0x937A
 #define MJSG_HD_RADIO_PID	0x937C
+
+/*
+ * Xverve Signalyzer tools (http://www.signalyzer.com/)
+ */
+#define XVERVE_SIGNALYZER_ST_PID	0xBCA0
+#define XVERVE_SIGNALYZER_SLITE_PID	0xBCA1
+#define XVERVE_SIGNALYZER_SH2_PID	0xBCA2
+#define XVERVE_SIGNALYZER_SH4_PID	0xBCA4
+


