Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2GKWdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:33:38 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:45203 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2GKWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:33:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1342045936!12488910!64
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/30] staging: comedi: dyna_pci10xx: remove unused variables in the private data
Date: Wed, 11 Jul 2012 15:33:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111533.29402.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These variables are set during the attach of the device but they are
never read. Just remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 16ad05f..32fcaee 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -102,11 +102,10 @@ static const struct boardtype boardtypes[] = {
 };
 
 struct dyna_pci10xx_private {
-	char valid;			/*  card is usable */
 	struct mutex mutex;
 
 	/* device base address registers */
-	unsigned long BADR0, BADR1, BADR2, BADR3, BADR4, BADR5;
+	unsigned long BADR2, BADR3;
 };
 
 #define thisboard ((const struct boardtype *)dev->board_ptr)
@@ -290,12 +289,8 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	mutex_init(&devpriv->mutex);
 
 	/* initialize device base address registers */
-	devpriv->BADR0 = pci_resource_start(dev->pcidev, 0);
-	devpriv->BADR1 = pci_resource_start(dev->pcidev, 1);
 	devpriv->BADR2 = pci_resource_start(dev->pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(dev->pcidev, 3);
-	devpriv->BADR4 = pci_resource_start(dev->pcidev, 4);
-	devpriv->BADR5 = pci_resource_start(dev->pcidev, 5);
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret) {
@@ -344,7 +339,6 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-	devpriv->valid = 1;
 	mutex_unlock(&start_stop_sem);
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
-- 
1.7.11

