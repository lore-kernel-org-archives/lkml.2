Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2JHM0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:26:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36812 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2JHM0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:26:22 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/ni_pcimio.c
Date: Mon,  8 Oct 2012 21:26:17 +0900
Message-Id: <1349699177-32434-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index f284a90..fff4a8f 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1381,8 +1381,9 @@ static void m_series_stc_writew(struct comedi_device *dev, uint16_t data,
 		/* FIXME: DIO_Output_Register (16 bit reg) is replaced by M_Offset_Static_Digital_Output (32 bit)
 		   and M_Offset_SCXI_Serial_Data_Out (8 bit) */
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->class_dev,
+			 "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return;
 		break;
@@ -1416,8 +1417,9 @@ static uint16_t m_series_stc_readw(struct comedi_device *dev, int reg)
 		offset = M_Offset_G01_Status;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->class_dev,
+			 "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -1458,8 +1460,9 @@ static void m_series_stc_writel(struct comedi_device *dev, uint32_t data,
 		offset = M_Offset_G1_Load_B;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->class_dev,
+			 "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return;
 		break;
@@ -1484,8 +1487,9 @@ static uint32_t m_series_stc_readl(struct comedi_device *dev, int reg)
 		offset = M_Offset_G1_Save;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->class_dev,
+			 "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return 0;
 		break;
-- 
1.7.9.5

