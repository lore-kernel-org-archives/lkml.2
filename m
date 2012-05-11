Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2EKKnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:43:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2EKKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:43:05 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 24/25] Staging: comedi: fix printk issue in ni_pcimio.c
Date: Fri, 11 May 2012 16:08:12 +0530
Message-Id: <1336732693-7408-25-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcimio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<level> function.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 1065b2c..9fd9c3c 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1491,8 +1491,8 @@ static void m_series_stc_writew(struct comedi_device *dev, uint16_t data,
 		/* FIXME: DIO_Output_Register (16 bit reg) is replaced by M_Offset_Static_Digital_Output (32 bit)
 		   and M_Offset_SCXI_Serial_Data_Out (8 bit) */
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->hw_dev, "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return;
 		break;
@@ -1526,8 +1526,8 @@ static uint16_t m_series_stc_readw(struct comedi_device *dev, int reg)
 		offset = M_Offset_G01_Status;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->hw_dev, "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -1568,8 +1568,8 @@ static void m_series_stc_writel(struct comedi_device *dev, uint32_t data,
 		offset = M_Offset_G1_Load_B;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->hw_dev, "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return;
 		break;
@@ -1594,8 +1594,8 @@ static uint32_t m_series_stc_readl(struct comedi_device *dev, int reg)
 		offset = M_Offset_G1_Save;
 		break;
 	default:
-		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		dev_warn(dev->hw_dev, "%s: bug! unhandled register=0x%x in switch.\n",
+			 __func__, reg);
 		BUG();
 		return 0;
 		break;
-- 
1.7.0.4

