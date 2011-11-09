Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab1KJDWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:22:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631Ab1KJDWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:05 2011
Message-Id: <20111109212705.545678234@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Stuge <peter@stuge.se>
Subject: [052/262] USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Stuge <peter@stuge.se>

commit 3687f641307eeff6f7fe31a88dc39db88e89238b upstream.

Some Stellaris evaluation kits have the JTAG/SWD FTDI chip onboard,
and some, like EK-LM3S9B90, come with a separate In-Circuit Debugger
Interface Board. The ICDI board can also be used stand-alone, for
other boards and chips than the kit it came with. The ICDI has both
old style 20-pin JTAG connector and new style JTAG/SWD 10-pin 1.27mm
pitch connector.

Tested with EK-LM3S9B90, where the BD-ICDI board is included.

Signed-off-by: Peter Stuge <peter@stuge.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -746,6 +746,8 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -54,6 +54,7 @@
 /* FTDI 2332C Dual channel device, side A=245 FIFO (JTAG), Side B=RS232 UART */
 #define LMI_LM3S_DEVEL_BOARD_PID	0xbcd8
 #define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
+#define LMI_LM3S_ICDI_BOARD_PID		0xbcda
 
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmbH */
 


