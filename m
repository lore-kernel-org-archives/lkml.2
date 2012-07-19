Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2GSBsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:48:22 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:52936 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2GSBsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:48:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1342662459!9057943!18
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 52/90] staging: comedi: cb_pcimdas: remove BADR4 from the private data
Date: Wed, 18 Jul 2012 18:48:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181848.08238.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci resource bar 4 address is only needed to initialize the
8255 subdevice. Use a local variable to hold it and remove it
from the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 3902c85bc..c8df680 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -59,7 +59,6 @@ See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 #define BADR0_SIZE 2		/* ?? */
 #define BADR2_SIZE 6
 #define BADR3_SIZE 16
-#define BADR4_SIZE 4
 
 /* DAC Offsets */
 #define ADC_TRIG 0
@@ -140,7 +139,6 @@ struct cb_pcimdas_private {
 	unsigned long BADR0;
 	unsigned long BADR2;
 	unsigned long BADR3;
-	unsigned long BADR4;
 
 	/* Used for AO readback */
 	unsigned int ao_readback[2];
@@ -204,6 +202,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 {
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
+	unsigned long iobase_8255;
 	int ret;
 
 /*
@@ -236,7 +235,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
 	devpriv->BADR2 = pci_resource_start(devpriv->pci_dev, 2);
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
-	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
+	iobase_8255 = pci_resource_start(devpriv->pci_dev, 4);
 
 /* Dont support IRQ yet */
 /*  get irq */
@@ -280,7 +279,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	s = dev->subdevices + 2;
 	/* digital i/o subdevice */
 	if (thisboard->has_dio)
-		subdev_8255_init(dev, s, NULL, devpriv->BADR4);
+		subdev_8255_init(dev, s, NULL, iobase_8255);
 	else
 		s->type = COMEDI_SUBD_UNUSED;
 
-- 
1.7.11

