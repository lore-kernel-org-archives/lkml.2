Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1CGIVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:21:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1CGIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cmPQSQiahZ8C4x4BjaWTm8qbAquVms26F+1ic9ZhVanoP/COQTQu2kC80H07v39heU
         JK0+qEQYhabHah+DJ7tuinSN+dsL/7S7Y5Nu2fNLgdcV0Wf9P6dUTpH2aXS7HU88vimB
         7YTx1ZFbtxTM3WNgYHDJPItrz5lSxt4yDbr3k=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 04/21] staging: ft1000: Fix coding style in ft1000_reset_asic function.
Date: Mon,  7 Mar 2011 09:21:09 +0100
Message-Id: <1299486086-7325-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   37 +++++++++++++------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 53073d5..188a8e3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -593,32 +593,33 @@ int dsp_reload(struct ft1000_device *ft1000dev)
 //     none
 //
 //---------------------------------------------------------------------------
-static void ft1000_reset_asic (struct net_device *dev)
+static void ft1000_reset_asic(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-    u16 tempword;
-
-    DEBUG("ft1000_hw:ft1000_reset_asic called\n");
+	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	u16 tempword;
 
-    info->ASICResetNum++;
+	DEBUG("ft1000_hw:ft1000_reset_asic called\n");
 
-    // Let's use the register provided by the Magnemite ASIC to reset the
-    // ASIC and DSP.
-    ft1000_write_register(ft1000dev,  (DSP_RESET_BIT | ASIC_RESET_BIT), FT1000_REG_RESET );
+	info->ASICResetNum++;
 
-    mdelay(1);
+	/* Let's use the register provided by the Magnemite ASIC to reset the
+	 * ASIC and DSP.
+	 */
+	ft1000_write_register(ft1000dev, (DSP_RESET_BIT | ASIC_RESET_BIT),
+			      FT1000_REG_RESET);
 
-    // set watermark to -1 in order to not generate an interrrupt
-    ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
+	mdelay(1);
 
-    // clear interrupts
-    ft1000_read_register (ft1000dev, &tempword, FT1000_REG_SUP_ISR);
-    DEBUG("ft1000_hw: interrupt status register = 0x%x\n",tempword);
-    ft1000_write_register (ft1000dev,  tempword, FT1000_REG_SUP_ISR);
-    ft1000_read_register (ft1000dev, &tempword, FT1000_REG_SUP_ISR);
-    DEBUG("ft1000_hw: interrupt status register = 0x%x\n",tempword);
+	/* set watermark to -1 in order to not generate an interrrupt */
+	ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
+	/* clear interrupts */
+	ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_ISR);
+	DEBUG("ft1000_hw: interrupt status register = 0x%x\n", tempword);
+	ft1000_write_register(ft1000dev, tempword, FT1000_REG_SUP_ISR);
+	ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_ISR);
+	DEBUG("ft1000_hw: interrupt status register = 0x%x\n", tempword);
 }
 
 
-- 
1.7.1

