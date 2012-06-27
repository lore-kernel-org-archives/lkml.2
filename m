Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2F0BCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:02:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:5303 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2F0BCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:02:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1340758937!11257434!11
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/36] staging: comedi: cb_pcidas: use the driver_name for the resource name
Date: Tue, 26 Jun 2012 18:02:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261802.41008.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dev->driver->driver_name for the resource name passed
to pci_request_regions(), by way of comedi_pci_enable(), and
to request_irq() instead of the open coded "cb_pcidas".

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9f883dd..9379d25 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1567,7 +1567,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		return -EIO;
 	thisboard = comedi_board(dev);
 
-	if (comedi_pci_enable(devpriv->pci_dev, "cb_pcidas")) {
+	if (comedi_pci_enable(devpriv->pci_dev, dev->driver->driver_name)) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return -EIO;
@@ -1585,7 +1585,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
-			IRQF_SHARED, "cb_pcidas", dev)) {
+			IRQF_SHARED, dev->driver->driver_name, dev)) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
 			devpriv->pci_dev->irq);
 		return -EINVAL;
-- 
1.7.11

