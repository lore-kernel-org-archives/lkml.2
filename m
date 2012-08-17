Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab2HQCmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:42:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:36148 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:42:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1345171334!13486106!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/35] staging: comedi: adl_pci7296: remove manual legacy attach
Date: Thu, 16 Aug 2012 19:42:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161942.09464.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/adl_pci7296.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 1b9ea54..67233be 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -133,15 +133,6 @@ static int adl_pci7296_attach_pci(struct comedi_device *dev,
 	return 0;
 }
 
-static int adl_pci7296_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it)
-{
-	dev_warn(dev->class_dev,
-		"This driver does not support attach using comedi_config\n");
-
-	return -ENOSYS;
-}
-
 static void adl_pci7296_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -164,7 +155,6 @@ static void adl_pci7296_detach(struct comedi_device *dev)
 static struct comedi_driver adl_pci7296_driver = {
 	.driver_name	= "adl_pci7296",
 	.module		= THIS_MODULE,
-	.attach		= adl_pci7296_attach,
 	.attach_pci	= adl_pci7296_attach_pci,
 	.detach		= adl_pci7296_detach,
 };
-- 
1.7.11

