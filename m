Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2HQCmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:42:42 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:5043 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:42:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1345171358!3480057!5
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/35] staging: comedi: adl_pci6208: remove manual legacy attach
Date: Thu, 16 Aug 2012 19:41:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161941.45939.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/adl_pci6208.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 3abff556..99fbd94 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -248,15 +248,6 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci6208_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	dev_warn(dev->class_dev,
-		"This driver does not support attach using comedi_config\n");
-
-	return -ENOSYS;
-}
-
 static void pci6208_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -270,7 +261,6 @@ static void pci6208_detach(struct comedi_device *dev)
 static struct comedi_driver adl_pci6208_driver = {
 	.driver_name	= "adl_pci6208",
 	.module		= THIS_MODULE,
-	.attach		= pci6208_attach,
 	.attach_pci	= pci6208_attach_pci,
 	.detach		= pci6208_detach,
 };
-- 
1.7.11

