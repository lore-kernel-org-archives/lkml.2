Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2HQQfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:35:22 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:20692 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2HQQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:35:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1345221274!13535862!71
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: contec_pci: remove manual legacy attach
Date: Fri, 17 Aug 2012 09:34:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208170934.52758.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses the 'attach_pci' callback to attach the pci device
to the comedi subsystem. Since the 'attach' callback is now optional
it can be removed from the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 12ad9fa3..def3e7d 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -108,15 +108,6 @@ static int contec_attach_pci(struct comedi_device *dev,
 	return 0;
 }
 
-static int contec_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it)
-{
-	dev_warn(dev->class_dev,
-		"This driver does not support attach using comedi_config\n");
-
-	return -ENOSYS;
-}
-
 static void contec_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -130,7 +121,6 @@ static void contec_detach(struct comedi_device *dev)
 static struct comedi_driver contec_pci_dio_driver = {
 	.driver_name	= "contec_pci_dio",
 	.module		= THIS_MODULE,
-	.attach		= contec_attach,
 	.attach_pci	= contec_attach_pci,
 	.detach		= contec_detach,
 };
-- 
1.7.11

