Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab2HQCmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:42:53 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:57885 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:42:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1345171358!7672810!5
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/35] staging: comedi: adl_pci7x3x: remove manual legacy attach
Date: Thu, 16 Aug 2012 19:42:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161942.30423.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/adl_pci7x3x.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index 41963fb..48b3baa 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -280,15 +280,6 @@ static int adl_pci7x3x_attach_pci(struct comedi_device *dev,
 	return 0;
 }
 
-static int adl_pci7x3x_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it)
-{
-	dev_warn(dev->class_dev,
-		"This driver does not support attach using comedi_config\n");
-
-	return -ENOSYS;
-}
-
 static void adl_pci7x3x_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -302,7 +293,6 @@ static void adl_pci7x3x_detach(struct comedi_device *dev)
 static struct comedi_driver adl_pci7x3x_driver = {
 	.driver_name	= "adl_pci7x3x",
 	.module		= THIS_MODULE,
-	.attach		= adl_pci7x3x_attach,
 	.attach_pci	= adl_pci7x3x_attach_pci,
 	.detach		= adl_pci7x3x_detach,
 };
-- 
1.7.11

