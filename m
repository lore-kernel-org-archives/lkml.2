Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2AUKLB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:11:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2AUKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:10:23 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
Date: Sat, 21 Jan 2012 02:10:12 -0800
Message-Id: <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added KERN_ facility levels in XGI_main_26.c and vb_init.c in a few different
printk() statements.

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   16 ++++++++--------
 drivers/staging/xgifb/vb_init.c     |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index a743e1b..389768d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1711,7 +1711,7 @@ static int XGIfb_get_dram_size(struct xgifb_video_info *xgifb_info)
 	/* xgifb_info->video_size = 0x200000; */ /* 1024x768x16 */
 	/* xgifb_info->video_size = 0x1000000; */ /* benchmark */
 
-	printk("XGIfb: SR14=%x DramSzie %x ChannelNum %x\n",
+	printk(KERN_INFO "XGIfb: SR14=%x DramSzie %x ChannelNum %x\n",
 	       reg,
 	       xgifb_info->video_size, ChannelNum);
 	return 0;
@@ -1917,7 +1917,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->vga_base = pci_resource_start(pdev, 2) + 0x30;
 	hw_info->pjIOAddress = (unsigned char *)xgifb_info->vga_base;
 	/* XGI_Pr.RelIO  = ioremap(pci_resource_start(pdev, 2), 128) + 0x30; */
-	printk("XGIfb: Relocate IO address: %lx [%08lx]\n",
+	printk(KERN_INFO "XGIfb: Relocate IO address: %lx [%08lx]\n",
 	       (unsigned long)pci_resource_start(pdev, 2),
 	       xgifb_info->dev_info.RelIO);
 
@@ -1937,7 +1937,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	reg1 = xgifb_reg_get(XGISR, IND_XGI_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-		printk("\nXGIfb: I/O error!!!");
+		printk(KERN_ERR "\nXGIfb: I/O error!!!");
 		ret = -EIO;
 		goto error;
 	}
@@ -1989,7 +1989,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->video_base,
 				xgifb_info->video_size,
 				"XGIfb FB")) {
-		printk("unable request memory size %x",
+		printk(KERN_ERR "unable to request memory size %x",
 		       xgifb_info->video_size);
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve frame buffer memory\n");
 		printk(KERN_ERR "XGIfb: Is there another framebuffer driver active?\n");
@@ -2018,12 +2018,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	printk(KERN_INFO "XGIfb: MMIO at 0x%lx, mapped to 0x%p, size %ldk\n",
 	       xgifb_info->mmio_base, xgifb_info->mmio_vbase,
 	       xgifb_info->mmio_size / 1024);
-	printk("XGIfb: XGIInitNew() ...");
+	printk(KERN_INFO "XGIfb: XGIInitNew() ...");
 	pci_set_drvdata(pdev, xgifb_info);
 	if (XGIInitNew(pdev))
-		printk("OK\n");
+		printk(KERN_INFO "OK\n");
 	else
-		printk("Fail\n");
+		printk(KERN_ERR "Fail\n");
 
 	xgifb_info->mtrr = (unsigned int) 0;
 
@@ -2064,7 +2064,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		} */
 		else {
 			hw_info->ujVBChipID = VB_CHIP_301;
-			printk("XGIfb: XGI301 bridge detected\n");
+			printk(KERN_INFO "XGIfb: XGI301 bridge detected\n");
 		}
 		break;
 	case HASVB_302:
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 4ccd988..2b72e26 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1483,7 +1483,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* Newdebugcode(0x99); */
 
 	if (pVBInfo->FBAddr == NULL) {
-		printk("\n pVBInfo->FBAddr == 0 ");
+		printk(KERN_INFO "\n pVBInfo->FBAddr == 0 ");
 		return 0;
 	}
 	printk("1");
-- 
1.7.5.4

