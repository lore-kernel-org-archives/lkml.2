Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2HPRP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:15:58 -0400
Received: from mail.tpi.com ([70.99.223.143]:4460 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2HPRP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:15:56 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 linux-next] usbdux: Declare MODULE_FIRMWARE usage
Date: Thu, 16 Aug 2012 11:15:37 -0600
Message-Id: <1345137337-12367-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120814011654.GB18000@kroah.com>
References: <20120814011654.GB18000@kroah.com>
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
index 848c7ec..11ee836 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -102,6 +102,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 #define BULK_TIMEOUT 1000
 
 /* constants for "firmware" upload and download */
+#define FIRMWARE "usbdux_firmware.bin"
 #define USBDUXSUB_FIRMWARE 0xA0
 #define VENDOR_DIR_IN  0xC0
 #define VENDOR_DIR_OUT 0x40
@@ -2791,7 +2792,7 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbdux_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxsub + index,
@@ -2850,3 +2851,4 @@ module_comedi_usb_driver(usbdux_driver, usbdux_usb_driver);
 MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
 MODULE_DESCRIPTION("Stirling/ITL USB-DUX -- Bernd.Porr@f2s.com");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

