Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2F0AyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:54:04 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:65014 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2F0AyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:54:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1340758440!7016253!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/36] staging: comedi: cb_pcidas: remove some obvious comments in the attach
Date: Tue, 26 Jun 2012 17:53:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261753.55792.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These comments are unnecessary.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 051c94c..990e6ab 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1650,9 +1650,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int i;
 	int ret;
 
-/*
- * Allocate the private structure area.
- */
 	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
 		return -ENOMEM;
 	devpriv = dev->private;
@@ -1668,9 +1665,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		thisboard->name, devpriv->pci_dev->bus->number,
 		PCI_SLOT(devpriv->pci_dev->devfn));
 
-	/*
-	 * Enable PCI device and reserve I/O ports.
-	 */
 	if (comedi_pci_enable(devpriv->pci_dev, "cb_pcidas")) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
@@ -1696,7 +1690,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	outl(INTCSR_INBOX_INTR_STATUS,
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 
-	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
@@ -1705,7 +1698,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	}
 	dev->irq = devpriv->pci_dev->irq;
 
-	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 7);
-- 
1.7.11

