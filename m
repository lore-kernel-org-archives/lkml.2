Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2DTUDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:03:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:19313 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2DTUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:03:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1334952185!6343231!7
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: use ARRAY_SIZE instead of custom n_boardtypes macros
Date: Fri, 20 Apr 2012 12:05:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <201204201205.05100.hartleys@visionengravers.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_boardtypes macros are simply open-coded versions of the kernels
ARRAY_SIZE macro. Use the kernel provided macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 9def225..f4a301a 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -36,7 +36,6 @@ static const struct boardtype boardtypes[] = {
 	{"p16r16dio", P16R16DIO_SIZE,},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct boardtype))
 #define this_board ((const struct boardtype *)dev->board_ptr)
 
 static struct comedi_driver driver_acl7225b = {
@@ -45,7 +44,7 @@ static struct comedi_driver driver_acl7225b = {
 	.attach = acl7225b_attach,
 	.detach = acl7225b_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct boardtype),
 };
 
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 2f341a3..5b5dae4 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -2528,14 +2528,12 @@ static const struct addi_board boardtypes[] = {
 #endif
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct addi_board))
-
 static struct comedi_driver driver_addi = {
 	.driver_name = ADDIDATA_DRIVER_NAME,
 	.module = THIS_MODULE,
 	.attach = i_ADDI_Attach,
 	.detach = i_ADDI_Detach,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.board_name = &boardtypes[0].pc_DriverName,
 	.offset = sizeof(struct addi_board),
 };
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index cfe164a..5b84573 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -277,14 +277,12 @@ static const struct boardtype boardtypes[] = {
 	 10000, 40, 512},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct boardtype))
-
 static struct comedi_driver driver_pci9118 = {
 	.driver_name = "adl_pci9118",
 	.module = THIS_MODULE,
 	.attach = pci9118_attach,
 	.detach = pci9118_detach,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.board_name = &boardtypes[0].name,
 	.offset = sizeof(struct boardtype),
 };
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index dc6fe3d..dc762e7 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -264,14 +264,12 @@ static const struct boardtype boardtypes[] = {
 	{.name = DRV_NAME},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct boardtype))
-
 static struct comedi_driver driver_pci1710 = {
 	.driver_name = DRV_NAME,
 	.module = THIS_MODULE,
 	.attach = pci1710_attach,
 	.detach = pci1710_detach,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.board_name = &boardtypes[0].name,
 	.offset = sizeof(struct boardtype),
 };
@@ -1398,13 +1396,13 @@ static int pci1710_attach(struct comedi_device *dev,
 	while (NULL != (pcidev = pci_get_device(PCI_VENDOR_ID_ADVANTECH,
 						PCI_ANY_ID, pcidev))) {
 		if (strcmp(this_board->name, DRV_NAME) == 0) {
-			for (i = 0; i < n_boardtypes; ++i) {
+			for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
 				if (pcidev->device == boardtypes[i].device_id) {
 					board_index = i;
 					break;
 				}
 			}
-			if (i == n_boardtypes)
+			if (i == ARRAY_SIZE(boardtypes))
 				continue;
 		} else {
 			if (pcidev->device != boardtypes[board_index].device_id)
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index eb49c87..4a4ae5f 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -171,8 +171,6 @@ static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
 static int pci1723_detach(struct comedi_device *dev);
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pci1723_board))
-
 static struct comedi_driver driver_pci1723 = {
 	.driver_name = "adv_pci1723",
 	.module = THIS_MODULE,
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 491df0c..7d920fe 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -406,8 +406,6 @@ static const struct dio_boardtype boardtypes[] = {
 	 IO_16b}
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct dio_boardtype))
-
 static struct comedi_driver driver_pci_dio = {
 	.driver_name = "adv_pci_dio",
 	.module = THIS_MODULE,
@@ -1134,7 +1132,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
-		for (i = 0; i < n_boardtypes; ++i) {
+		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
 			if (boardtypes[i].vendor_id != pcidev->vendor)
 				continue;
 			if (boardtypes[i].device_id != pcidev->device)
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 7073197..952b081 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -321,7 +321,6 @@ static const struct daq200_boardtype boardtypes[] = {
 	{"ids4", DAQBOARD2000_SUBSYSTEM_IDS4},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct daq200_boardtype))
 #define this_board ((const struct daq200_boardtype *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
@@ -761,7 +760,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 		devpriv->pci_dev = card;
 		id = ((u32) card->
 		      subsystem_device << 16) | card->subsystem_vendor;
-		for (i = 0; i < n_boardtypes; i++) {
+		for (i = 0; i < ARRAY_SIZE(boardtypes); i++) {
 			if (boardtypes[i].id == id) {
 				dev_dbg(dev->hw_dev, "%s\n",
 					boardtypes[i].name);
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 95ebc26..210b3f0 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -350,7 +350,6 @@ static const struct dt282x_board boardtypes[] = {
 	 },
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct dt282x_board))
 #define this_board ((const struct dt282x_board *)dev->board_ptr)
 
 struct dt282x_private {
@@ -420,7 +419,7 @@ static struct comedi_driver driver_dt282x = {
 	.attach = dt282x_attach,
 	.detach = dt282x_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct dt282x_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 126550f3..67b6f5a 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -173,14 +173,12 @@ static const struct boardtype boardtypes[] = {
 	 &range_analog},	/*  Rangelist for D/A */
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct boardtype))
-
 static struct comedi_driver driver_icp_multi = {
 	.driver_name = "icp_multi",
 	.module = THIS_MODULE,
 	.attach = icp_multi_attach,
 	.detach = icp_multi_detach,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.board_name = &boardtypes[0].name,
 	.offset = sizeof(struct boardtype),
 };
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index b44386a..ce6e514 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -155,7 +155,6 @@ static const struct pcl711_board boardtypes[] = {
 	{"acl8112dg", 0, 1, 1, 9, 16, 2, 15, &range_acl8112dg_ai},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl711_board))
 #define this_board ((const struct pcl711_board *)dev->board_ptr)
 
 static int pcl711_attach(struct comedi_device *dev,
@@ -167,7 +166,7 @@ static struct comedi_driver driver_pcl711 = {
 	.attach = pcl711_attach,
 	.detach = pcl711_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl711_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 61b075d..20715d1 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -80,7 +80,6 @@ static const struct pcl724_board boardtypes[] = {
 	{"pet48dio", 48, 2, 0x9eb8, PET48_SIZE, 0, 1,},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl724_board))
 #define this_board ((const struct pcl724_board *)dev->board_ptr)
 
 static struct comedi_driver driver_pcl724 = {
@@ -89,7 +88,7 @@ static struct comedi_driver driver_pcl724 = {
 	.attach = pcl724_attach,
 	.detach = pcl724_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl724_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 897cd80..a880ceb 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -149,7 +149,6 @@ static const struct pcl726_board boardtypes[] = {
 	 &rangelist_728[0],},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl726_board))
 #define this_board ((const struct pcl726_board *)dev->board_ptr)
 
 static struct comedi_driver driver_pcl726 = {
@@ -158,7 +157,7 @@ static struct comedi_driver driver_pcl726 = {
 	.attach = pcl726_attach,
 	.detach = pcl726_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl726_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index c9682d6..78c8e59 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -42,7 +42,6 @@ static const struct pcl730_board boardtypes[] = {
 	{"acl7130", ACL7130_SIZE,},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl730_board))
 #define this_board ((const struct pcl730_board *)dev->board_ptr)
 
 static struct comedi_driver driver_pcl730 = {
@@ -51,7 +50,7 @@ static struct comedi_driver driver_pcl730 = {
 	.attach = pcl730_attach,
 	.detach = pcl730_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl730_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 6fc7464..555d0df 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -397,7 +397,6 @@ static const struct pcl812_board boardtypes[] = {
 	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl812_board))
 #define this_board ((const struct pcl812_board *)dev->board_ptr)
 
 static struct comedi_driver driver_pcl812 = {
@@ -406,7 +405,7 @@ static struct comedi_driver driver_pcl812 = {
 	.attach = pcl812_attach,
 	.detach = pcl812_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl812_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 96cd7ec..bf7b262 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -146,7 +146,6 @@ static const struct pcl816_board boardtypes[] = {
 	 100},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl816_board))
 #define devpriv ((struct pcl816_private *)dev->private)
 #define this_board ((const struct pcl816_board *)dev->board_ptr)
 
@@ -165,7 +164,7 @@ static struct comedi_driver driver_pcl816 = {
 	.attach = pcl816_attach,
 	.detach = pcl816_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl816_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 7344a53..0272491 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -302,15 +302,13 @@ static const struct pcl818_board boardtypes[] = {
 	 0x0a, 0xfff, 0xfff, 0, 1 /* XXX ? */ },
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcl818_board))
-
 static struct comedi_driver driver_pcl818 = {
 	.driver_name = "pcl818",
 	.module = THIS_MODULE,
 	.attach = pcl818_attach,
 	.detach = pcl818_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcl818_board),
 };
 
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index f5c0bd1..4601703 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -84,7 +84,6 @@ static const struct pcm3724_board boardtypes[] = {
 	{"pcm3724", 48, 2, 0x00fc, PCM3724_SIZE,},
 };
 
-#define n_boardtypes (sizeof(boardtypes)/sizeof(struct pcm3724_board))
 #define this_board ((const struct pcm3724_board *)dev->board_ptr)
 
 static struct comedi_driver driver_pcm3724 = {
@@ -93,7 +92,7 @@ static struct comedi_driver driver_pcm3724 = {
 	.attach = pcm3724_attach,
 	.detach = pcm3724_detach,
 	.board_name = &boardtypes[0].name,
-	.num_names = n_boardtypes,
+	.num_names = ARRAY_SIZE(boardtypes),
 	.offset = sizeof(struct pcm3724_board),
 };
 
