Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2HOTux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62940 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2HOTuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Stuge <peter@stuge.se>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 078/165] USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board
Date: Wed, 15 Aug 2012 15:47:02 -0400
Message-ID: <1345060109-9187-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Stuge <peter@stuge.se>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3687f641307eeff6f7fe31a88dc39db88e89238b upstream.

Some Stellaris evaluation kits have the JTAG/SWD FTDI chip onboard,
and some, like EK-LM3S9B90, come with a separate In-Circuit Debugger
Interface Board. The ICDI board can also be used stand-alone, for
other boards and chips than the kit it came with. The ICDI has both
old style 20-pin JTAG connector and new style JTAG/SWD 10-pin 1.27mm
pitch connector.

Tested with EK-LM3S9B90, where the BD-ICDI board is included.

Signed-off-by: Peter Stuge <peter@stuge.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 27cd4a1..90dfdb1 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -748,6 +748,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 7d7f138..1167732 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -53,6 +53,7 @@
 /* FTDI 2332C Dual channel device, side A=245 FIFO (JTAG), Side B=RS232 UART */
 #define LMI_LM3S_DEVEL_BOARD_PID	0xbcd8
 #define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
+#define LMI_LM3S_ICDI_BOARD_PID		0xbcda
 
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmbH */
 
-- 
1.7.12.rc2

