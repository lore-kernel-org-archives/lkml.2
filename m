Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2HOBZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:25:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:38422 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2HOBZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:25:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1344993926!11638555!14
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] staging: comedi: dnya_pci10xx: remove unneeded boardinfo code
Date: Tue, 14 Aug 2012 18:25:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141825.36510.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boardinfo code is not needed by this driver. Only one board
type is supported.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 38 ++-------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index a23969e..56fb35b 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -54,20 +54,6 @@ static const struct comedi_lrange range_pci1050_ai = { 3, {
 
 static const char range_codes_pci1050_ai[] = { 0x00, 0x10, 0x30 };
 
-struct boardtype {
-	const char *name;
-	int device_id;
-};
-
-static const struct boardtype boardtypes[] = {
-	{
-	.name = "dyna_pci1050",
-	.device_id = 0x1050,
-	},
-	/*  dummy entry corresponding to driver name */
-	{.name = DRV_NAME},
-};
-
 struct dyna_pci10xx_private {
 	struct mutex mutex;
 	unsigned long BADR3;
@@ -194,35 +180,16 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static const void *dyna_pci10xx_find_boardinfo(struct comedi_device *dev,
-					       struct pci_dev *pcidev)
-{
-	const struct boardtype *thisboard;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
-		thisboard = &boardtypes[i];
-		if (pcidev->device != thisboard->device_id)
-			return thisboard;
-	}
-	return NULL;
-}
-
 static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 				   struct pci_dev *pcidev)
 {
-	const struct boardtype *thisboard;
 	struct dyna_pci10xx_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
 	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	thisboard = dyna_pci10xx_find_boardinfo(dev, pcidev);
-	if (!thisboard)
-		return -ENODEV;
-	dev->board_ptr = thisboard;
-	dev->board_name = thisboard->name;
+	dev->board_name = dev->driver->driver_name;
 
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret)
@@ -282,8 +249,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-	dev_info(dev->class_dev, "%s: %s attached\n",
-		dev->driver->driver_name, dev->board_name);
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
 
 	return 0;
 }
-- 
1.7.11

