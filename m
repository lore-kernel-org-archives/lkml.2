Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2GZQSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:18:15 -0400
Received: from mail.tpi.com ([70.99.223.143]:4450 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2GZQSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:18:13 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] usbdux: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 10:18:29 -0600
Message-Id: <1343319509-104135-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/comedi/drivers/usbdux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 13d9fd3..20679c5 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -102,6 +102,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 #include "../comedidev.h"
 
 #define BOARDNAME "usbdux"
+#define FIRMWARE "usbdux_firmware.bin"
 
 /* timeout for the USB-transfer in ms*/
 #define BULK_TIMEOUT 1000
@@ -2577,7 +2578,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbdux_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxsub + index,
@@ -2887,3 +2888,4 @@ module_exit(exit_usbdux);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

