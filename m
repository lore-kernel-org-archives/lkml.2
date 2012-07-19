Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2GSCAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:00:43 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:62826 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2GSCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:00:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1342663240!13776735!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 73/90] staging: comedi: dyna_pci10xx: remove unused bars from the private data
Date: Wed, 18 Jul 2012 19:00:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181900.37359.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the pci device base address registers are saved in the private
data but only bar2 and bar3 are used by the driver. Remove the others.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 24c5cd2..95ee422 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -104,7 +104,7 @@ struct dyna_pci10xx_private {
 	struct mutex mutex;
 
 	/* device base address registers */
-	unsigned long BADR0, BADR1, BADR2, BADR3, BADR4, BADR5;
+	unsigned long BADR2, BADR3;
 };
 
 #define thisboard ((const struct boardtype *)dev->board_ptr)
@@ -288,13 +288,8 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
 
-	/* initialize device base address registers */
-	devpriv->BADR0 = pci_resource_start(pcidev, 0);
-	devpriv->BADR1 = pci_resource_start(pcidev, 1);
 	devpriv->BADR2 = pci_resource_start(pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(pcidev, 3);
-	devpriv->BADR4 = pci_resource_start(pcidev, 4);
-	devpriv->BADR5 = pci_resource_start(pcidev, 5);
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
-- 
1.7.11

