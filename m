Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1CJKvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:51:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1CJKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EN4AhGcgw6DvgScVQ2EvSJfaFajaJvGqlnxH9HL36Fm/cpOdt7PJu0LExsQNHVKM88
         oYYP+Dl14VEM8JFBhxB2ekRjdF9FYzNVNk6FihwTieo9fsJpfRw80855vHVx6ULHngMU
         CpAl3i/M2q98SCMzjWAOt5COSkd5oU628q8HQ=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 03/21] staging: ft1000: Fix coding style in dsp_reload function.
Date: Thu, 10 Mar 2011 11:51:17 +0100
Message-Id: <1299754295-8493-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   57 +++++++++++++------------
 1 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index ded13f2..53073d5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -534,49 +534,52 @@ void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
 //-----------------------------------------------------------------------
 int dsp_reload(struct ft1000_device *ft1000dev)
 {
-    u16 status;
-    u16 tempword;
-    u32 templong;
+	u16 status;
+	u16 tempword;
+	u32 templong;
 
 	struct ft1000_info *pft1000info;
 
-    pft1000info = netdev_priv(ft1000dev->net);
+	pft1000info = netdev_priv(ft1000dev->net);
 
-    pft1000info->CardReady = 0;
+	pft1000info->CardReady = 0;
 
-    // Program Interrupt Mask register
-    status = ft1000_write_register (ft1000dev, 0xffff, FT1000_REG_SUP_IMASK);
+	/* Program Interrupt Mask register */
+	status = ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_SUP_IMASK);
 
-    status = ft1000_read_register (ft1000dev, &tempword, FT1000_REG_RESET);
-    tempword |= ASIC_RESET_BIT;
-    status = ft1000_write_register (ft1000dev, tempword, FT1000_REG_RESET);
-    msleep(1000);
-    status = ft1000_read_register (ft1000dev, &tempword, FT1000_REG_RESET);
-    DEBUG("Reset Register = 0x%x\n", tempword);
+	status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
+	tempword |= ASIC_RESET_BIT;
+	status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
+	msleep(1000);
+	status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
+	DEBUG("Reset Register = 0x%x\n", tempword);
 
-    // Toggle DSP reset
-    card_reset_dsp (ft1000dev, 1);
-    msleep(1000);
-    card_reset_dsp (ft1000dev, 0);
-    msleep(1000);
+	/* Toggle DSP reset */
+	card_reset_dsp(ft1000dev, 1);
+	msleep(1000);
+	card_reset_dsp(ft1000dev, 0);
+	msleep(1000);
 
-    status = ft1000_write_register (ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
+	status =
+	    ft1000_write_register(ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
 
-    // Let's check for FEFE
-    status = ft1000_read_dpram32 (ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX, (u8 *)&templong, 4);
-    DEBUG("templong (fefe) = 0x%8x\n", templong);
+	/* Let's check for FEFE */
+	status =
+	    ft1000_read_dpram32(ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX,
+				(u8 *) &templong, 4);
+	DEBUG("templong (fefe) = 0x%8x\n", templong);
 
-    // call codeloader
-    status = scram_dnldr(ft1000dev, pFileStart, FileLength);
+	/* call codeloader */
+	status = scram_dnldr(ft1000dev, pFileStart, FileLength);
 
 	if (status != STATUS_SUCCESS)
 		return -EIO;
 
-    msleep(1000);
+	msleep(1000);
 
-    DEBUG("dsp_reload returned\n");
-	return 0;
+	DEBUG("dsp_reload returned\n");
 
+	return 0;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

