Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2GSCFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:05:07 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:4464 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2GSCFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:05:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1342663499!13416722!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 87/90] staging: comedi: rtd520: remove the '#if 0' code in the attach
Date: Wed, 18 Jul 2012 19:04:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181904.57308.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has code #if 0'ed out that would allow cleaning up
the attach if there was an error. The comedi core currently
calls the detach function to do this if the attach fails.

Remove the #if 0'ed out code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 46 ---------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index aeccae9..d1753e2 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1886,52 +1886,6 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("\ncomedi%d: rtd520 driver attached.\n", dev->minor);
 
 	return 1;
-
-#if 0
-	/* hit an error, clean up memory and return ret */
-/* rtd_attach_die_error: */
-#ifdef USE_DMA
-	for (index = 0; index < DMA_CHAIN_COUNT; index++) {
-		if (NULL != devpriv->dma0Buff[index]) {	/* free buffer memory */
-			pci_free_consistent(devpriv->pci_dev,
-					    sizeof(u16) * devpriv->fifoLen / 2,
-					    devpriv->dma0Buff[index],
-					    devpriv->dma0BuffPhysAddr[index]);
-			devpriv->dma0Buff[index] = NULL;
-		}
-	}
-	if (NULL != devpriv->dma0Chain) {
-		pci_free_consistent(devpriv->pci_dev,
-				    sizeof(struct plx_dma_desc)
-				    * DMA_CHAIN_COUNT,
-				    devpriv->dma0Chain,
-				    devpriv->dma0ChainPhysAddr);
-		devpriv->dma0Chain = NULL;
-	}
-#endif /* USE_DMA */
-	/* subdevices and priv are freed by the core */
-	if (dev->irq) {
-		writel(readl(devpriv->lcfg + LCFG_ITCSR) &
-			~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E),
-			devpriv->lcfg + LCFG_ITCSR);
-		free_irq(dev->irq, dev);
-	}
-
-	/* release all regions that were allocated */
-	if (devpriv->las0)
-		iounmap(devpriv->las0);
-
-	if (devpriv->las1)
-		iounmap(devpriv->las1);
-
-	if (devpriv->lcfg)
-		iounmap(devpriv->lcfg);
-
-	if (devpriv->pci_dev)
-		pci_dev_put(devpriv->pci_dev);
-
-	return ret;
-#endif
 }
 
 static void rtd_detach(struct comedi_device *dev)
-- 
1.7.11

