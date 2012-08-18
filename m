Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2HRBVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:21:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:42085 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2HRBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:20:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1345252856!7756458!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/20] staging: comedi: adv_pci_dio: add the number of subdevices to the boardinfo
Date: Fri, 17 Aug 2012 18:20:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171820.34689.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calculating the number of subdevices in the 'attach'
simply add the number to the boardinfo.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 39 +++++++++++++---------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index e535d31..2c3dbf0 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -241,6 +241,7 @@ struct dio_boardtype {
 	int device_id;
 	int main_pci_region;	/*  main I/O PCI region */
 	enum hw_cards_id cardtype;
+	int nsubdevs;
 	struct diosubd_data sdi[MAX_DI_SUBDEVS];	/*  DI chans */
 	struct diosubd_data sdo[MAX_DO_SUBDEVS];	/*  DO chans */
 	struct diosubd_data sdio[MAX_DIO_SUBDEVG];	/*  DIO 8255 chans */
@@ -256,6 +257,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1730,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1730,
+		.nsubdevs	= 5,
 		.sdi[0]		= { 16, PCI1730_DI, 2, 0, },
 		.sdi[1]		= { 16, PCI1730_IDI, 2, 0, },
 		.sdo[0]		= { 16, PCI1730_DO, 2, 0, },
@@ -268,6 +270,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1733,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1733,
+		.nsubdevs	= 2,
 		.sdi[1]		= { 32, PCI1733_IDI, 4, 0, },
 		.boardid	= { 4, PCI173x_BOARDID, 1, SDF_INTERNAL, },
 		.io_access	= IO_8b,
@@ -277,6 +280,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1734,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1734,
+		.nsubdevs	= 2,
 		.sdo[1]		= { 32, PCI1734_IDO, 4, 0, },
 		.boardid	= { 4, PCI173x_BOARDID, 1, SDF_INTERNAL, },
 		.io_access	= IO_8b,
@@ -286,6 +290,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1735,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1735,
+		.nsubdevs	= 4,
 		.sdi[0]		= { 32, PCI1735_DI, 4, 0, },
 		.sdo[0]		= { 32, PCI1735_DO, 4, 0, },
 		.boardid	= { 4, PCI1735_BOARDID, 1, SDF_INTERNAL, },
@@ -297,6 +302,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1736,
 		.main_pci_region = PCI1736_MAINREG,
 		.cardtype	= TYPE_PCI1736,
+		.nsubdevs	= 3,
 		.sdi[1]		= { 16, PCI1736_IDI, 2, 0, },
 		.sdo[1]		= { 16, PCI1736_IDO, 2, 0, },
 		.boardid	= { 4, PCI1736_BOARDID, 1, SDF_INTERNAL, },
@@ -307,6 +313,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1739,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1739,
+		.nsubdevs	= 2,
 		.sdio[0]	= { 48, PCI1739_DIO, 2, 0, },
 		.io_access	= IO_8b,
 	}, {
@@ -315,6 +322,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1750,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1750,
+		.nsubdevs	= 2,
 		.sdi[1]		= { 16, PCI1750_IDI, 2, 0, },
 		.sdo[1]		= { 16, PCI1750_IDO, 2, 0, },
 		.io_access	= IO_8b,
@@ -324,6 +332,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1751,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1751,
+		.nsubdevs	= 3,
 		.sdio[0]	= { 48, PCI1751_DIO, 2, 0, },
 		.s8254[0]	= { 3, PCI1751_CNT, 1, 0, },
 		.io_access	= IO_8b,
@@ -333,6 +342,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1752,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1752,
+		.nsubdevs	= 3,
 		.sdo[0]		= { 32, PCI1752_IDO, 2, 0, },
 		.sdo[1]		= { 32, PCI1752_IDO2, 2, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
@@ -343,6 +353,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1753,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1753,
+		.nsubdevs	= 4,
 		.sdio[0]	= { 96, PCI1753_DIO, 4, 0, },
 		.io_access	= IO_8b,
 	}, {
@@ -351,6 +362,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1753,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1753E,
+		.nsubdevs	= 8,
 		.sdio[0]	= { 96, PCI1753_DIO, 4, 0, },
 		.sdio[1]	= { 96, PCI1753E_DIO, 4, 0, },
 		.io_access	= IO_8b,
@@ -360,6 +372,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1754,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1754,
+		.nsubdevs	= 3,
 		.sdi[0]		= { 32, PCI1754_IDI, 2, 0, },
 		.sdi[1]		= { 32, PCI1754_IDI2, 2, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
@@ -370,6 +383,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1756,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1756,
+		.nsubdevs	= 3,
 		.sdi[1]		= { 32, PCI1756_IDI, 2, 0, },
 		.sdo[1]		= { 32, PCI1756_IDO, 2, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
@@ -381,6 +395,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1760,
 		.main_pci_region = 0,
 		.cardtype	= TYPE_PCI1760,
+		.nsubdevs	= 4,
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1762",
@@ -388,6 +403,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1762,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1762,
+		.nsubdevs	= 3,
 		.sdi[1]		= { 16, PCI1762_IDI, 1, 0, },
 		.sdo[1]		= { 16, PCI1762_RO, 1, 0, },
 		.boardid	= { 4, PCI1762_BOARDID, 1, SDF_INTERNAL, },
@@ -1085,7 +1101,7 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 	const struct dio_boardtype *this_board;
 	struct pci_dio_private *devpriv;
 	struct comedi_subdevice *s;
-	int ret, subdev, n_subdevices, i, j;
+	int ret, subdev, i, j;
 
 	comedi_set_hw_dev(dev, &pcidev->dev);
 
@@ -1105,26 +1121,7 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 		return ret;
 	dev->iobase = pci_resource_start(pcidev, this_board->main_pci_region);
 
-	if (this_board->cardtype == TYPE_PCI1760) {
-		n_subdevices = 4;	/*  8 IDI, 8 IDO, 2 PWM, 8 CNT */
-	} else {
-		n_subdevices = 0;
-		for (i = 0; i < MAX_DI_SUBDEVS; i++)
-			if (this_board->sdi[i].chans)
-				n_subdevices++;
-		for (i = 0; i < MAX_DO_SUBDEVS; i++)
-			if (this_board->sdo[i].chans)
-				n_subdevices++;
-		for (i = 0; i < MAX_DIO_SUBDEVG; i++)
-			n_subdevices += this_board->sdio[i].regs;
-		if (this_board->boardid.chans)
-			n_subdevices++;
-		for (i = 0; i < MAX_8254_SUBDEVS; i++)
-			if (this_board->s8254[i].chans)
-				n_subdevices++;
-	}
-
-	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, this_board->nsubdevs);
 	if (ret)
 		return ret;
 
-- 
1.7.11

