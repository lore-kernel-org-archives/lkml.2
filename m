Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab0HLAmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:42:01 -0400
Received: from kroah.org ([198.145.64.141]:40125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840Ab0HKX5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:53 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:58 2010
Message-Id: <20100811235457.932051889@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Rogers <jgrogers@gmail.com>
Subject: [026/111] USB: serial: enabling support for Segway RMP in ftdi_sio
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John G. Rogers <jgrogers@gmail.com>

commit afad19648f70c6493193e0a774bd754b7790b4a0 upstream.

I have added the ProductID=0xe729 VendorID=FTDI_VID=0x0403 which will
enable support for the Segway Robotic Mobility Platform (RMP200) in the
ftdi_sio kernel module.  Currently, users of the Segway RMP200 must use
a RUN+="/sbin/modprobe -q ftdi-sio product=0xe729 vendor=0x0403 in a
udev rule to get the ftdi_sio module to handle the usb interface and
mount it on /dev/ttyXXX.  This is not a good solution because some users
will have multiple USB to Serial converters which will use the ftdi_sio
module.

Signed-off-by: John Rogers <jgrogers@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -752,6 +752,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1039,3 +1039,8 @@
 #define XVERVE_SIGNALYZER_SH2_PID	0xBCA2
 #define XVERVE_SIGNALYZER_SH4_PID	0xBCA4
 
+/*
+ * Segway Robotic Mobility Platform USB interface (using VID 0x0403)
+ * Submitted by John G. Rogers
+ */
+#define SEGWAY_RMP200_PID	0xe729


