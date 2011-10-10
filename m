Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1JJBlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 21:41:39 -0400
Received: from foo.stuge.se ([212.116.89.98]:47891 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751025Ab1JJBli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 21:41:38 -0400
From: Peter Stuge <peter@stuge.se>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board
Date: Mon, 10 Oct 2011 03:34:54 +0200
Message-Id: <1318210494-12231-1-git-send-email-peter@stuge.se>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Stellaris evaluation kits have the JTAG/SWD FTDI chip onboard,
and some, like EK-LM3S9B90, come with a separate In-Circuit Debugger
Interface Board. The ICDI board can also be used stand-alone, for
other boards and chips than the kit it came with. The ICDI has both
old style 20-pin JTAG connector and new style JTAG/SWD 10-pin 1.27mm
pitch connector.

Tested with EK-LM3S9B90, where the BD-ICDI board is included.

Signed-off-by: Peter Stuge <peter@stuge.se>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5fc13e7..0a8929b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -745,6 +745,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index bf5227a..3178f36 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -54,6 +54,7 @@
 /* FTDI 2332C Dual channel device, side A=245 FIFO (JTAG), Side B=RS232 UART */
 #define LMI_LM3S_DEVEL_BOARD_PID	0xbcd8
 #define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
+#define LMI_LM3S_ICDI_BOARD_PID		0xbcda
 
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmbH */
 
-- 
1.7.4.rc3

