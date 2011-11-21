Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1KUKhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1KUKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:53 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 7/8] Staging: comedi: fix printk issue in ni_pcimio.c
Date: Mon, 21 Nov 2011 16:07:05 +0530
Message-Id: <1321871826-13581-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_pcimio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 0b99d96..0f0d995 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1470,7 +1470,7 @@ static void m_series_stc_writew(struct comedi_device *dev, uint16_t data,
 		/* FIXME: DIO_Output_Register (16 bit reg) is replaced by M_Offset_Static_Digital_Output (32 bit)
 		   and M_Offset_SCXI_Serial_Data_Out (8 bit) */
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
+		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
 		       __func__, reg);
 		BUG();
 		return;
@@ -1505,7 +1505,7 @@ static uint16_t m_series_stc_readw(struct comedi_device *dev, int reg)
 		offset = M_Offset_G01_Status;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
+		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
 		       __func__, reg);
 		BUG();
 		return 0;
@@ -1547,7 +1547,7 @@ static void m_series_stc_writel(struct comedi_device *dev, uint32_t data,
 		offset = M_Offset_G1_Load_B;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
+		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
 		       __func__, reg);
 		BUG();
 		return;
@@ -1573,7 +1573,7 @@ static uint32_t m_series_stc_readl(struct comedi_device *dev, int reg)
 		offset = M_Offset_G1_Save;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
+		printk(KERN_WARNING "%s: bug! unhandled register=0x%x in switch.\n",
 		       __func__, reg);
 		BUG();
 		return 0;
-- 
1.7.0.4

