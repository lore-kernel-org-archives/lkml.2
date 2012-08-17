Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586Ab2HQCze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:55:34 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:36178 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030474Ab2HQCzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:55:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1345172129!24277213!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 34/35] staging: comedi: dyna_pci10xx: remove manual legacy attach
Date: Thu, 16 Aug 2012 19:55:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161955.20224.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index e852808..9d55aa9 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -253,15 +253,6 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	return 0;
 }
 
-static int dyna_pci10xx_attach(struct comedi_device *dev,
-			       struct comedi_devconfig *it)
-{
-	dev_warn(dev->class_dev,
-		"This driver does not support attach using comedi_config\n");
-
-	return -ENOSYS;
-}
-
 static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -278,7 +269,6 @@ static void dyna_pci10xx_detach(struct comedi_device *dev)
 static struct comedi_driver dyna_pci10xx_driver = {
 	.driver_name	= "dyna_pci10xx",
 	.module		= THIS_MODULE,
-	.attach		= dyna_pci10xx_attach,
 	.attach_pci	= dyna_pci10xx_attach_pci,
 	.detach		= dyna_pci10xx_detach,
 };
-- 
1.7.11

