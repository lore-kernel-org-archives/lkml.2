Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2HPRKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:10:19 -0400
Received: from mail.tpi.com ([70.99.223.143]:3610 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab2HPRKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:10:17 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 linux-next] usbduxfast: Declare MODULE_FIRMWARE usage
Date: Thu, 16 Aug 2012 11:09:28 -0600
Message-Id: <1345136968-11947-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120814011638.GA18000@kroah.com>
References: <20120814011638.GA18000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index d991158..8eb41257 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -57,6 +57,7 @@
 /*
  * constants for "firmware" upload and download
  */
+#define FIRMWARE		"usbduxfast_firmware.bin"
 #define USBDUXFASTSUB_FIRMWARE	0xA0
 #define VENDOR_DIR_IN		0xC0
 #define VENDOR_DIR_OUT		0x40
@@ -1706,7 +1707,7 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbduxfast_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxfastsub + index,
@@ -1774,3 +1775,4 @@ module_comedi_usb_driver(usbduxfast_driver, usbduxfast_usb_driver);
 MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
 MODULE_DESCRIPTION("USB-DUXfast, BerndPorr@f2s.com");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

