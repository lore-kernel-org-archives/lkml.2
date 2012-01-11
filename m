Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2AKIoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:44:15 -0500
Received: from mx02.lb01.inode.at ([62.99.145.2]:8157 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755838Ab2AKIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:44:14 -0500
X-Greylist: delayed 1654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 03:44:13 EST
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>
Cc: Michael Thalmeier <michael.thalmeier@hale.at>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael@thalmeier.at
Subject: [PATCH] usb/gadget/fsl_udc_core.c: fix oops on resume
Date: Wed, 11 Jan 2012 09:46:17 +0100
Message-Id: <1326271577-13418-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.7.5
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: q0B8iFkL002768
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1326876256.48914@Bn9T0SfANIWWrBH0lvqbpA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the fsl_udc_irq function oopses when waking up from suspend.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/usb/gadget/fsl_udc_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index d7ea6c0..4070c7a 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1749,7 +1749,7 @@ static void suspend_irq(struct fsl_udc *udc)
 	udc->usb_state = USB_STATE_SUSPENDED;
 
 	/* report suspend to the driver, serial.c does not support this */
-	if (udc->driver->suspend)
+	if (udc->driver && udc->driver->suspend)
 		udc->driver->suspend(&udc->gadget);
 }
 
@@ -1759,7 +1759,7 @@ static void bus_resume(struct fsl_udc *udc)
 	udc->resume_state = 0;
 
 	/* report resume to the driver, serial.c does not support this */
-	if (udc->driver->resume)
+	if (udc->driver && udc->driver->resume)
 		udc->driver->resume(&udc->gadget);
 }
 
-- 
1.7.7.5



--
Scanned by MailScanner.

