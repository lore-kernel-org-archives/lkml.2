Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2HPRT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:19:29 -0400
Received: from mail.tpi.com ([70.99.223.143]:4470 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2HPRT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:19:28 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bernd Porr <berndporr@f2s.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 linux-next] usbduxsigma: Declare MODULE_FIRMWARE usage
Date: Thu, 16 Aug 2012 11:19:11 -0600
Message-Id: <1345137551-12763-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120814011709.GC18000@kroah.com>
References: <20120814011709.GC18000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bernd Porr <berndporr@f2s.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 543e604..f54ab8c 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -63,6 +63,7 @@ Status: testing
 #define BULK_TIMEOUT 1000
 
 /* constants for "firmware" upload and download */
+#define FIRMWARE "usbduxsigma_firmware.bin"
 #define USBDUXSUB_FIRMWARE 0xA0
 #define VENDOR_DIR_IN  0xC0
 #define VENDOR_DIR_OUT 0x40
@@ -2780,7 +2781,7 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbduxsigma_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxsub + index,
@@ -2845,3 +2846,4 @@ module_comedi_usb_driver(usbduxsigma_driver, usbduxsigma_usb_driver);
 MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
 MODULE_DESCRIPTION("Stirling/ITL USB-DUX SIGMA -- Bernd.Porr@f2s.com");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

