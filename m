Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1CJKvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:51:54 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50672 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1CJKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=J1V+eUhC0PrxmElJz9DF3PDPQauEw6Mk8jVTO9fQ8Qg9geA+KCm2E3l+oJy4YBzYfT
         3bgjPFi7XHQ4mrelXKJBwBKG1WTDOMM1O3ZCB2+iwtZBuq/F01tMjEvLgGFnMbzRKGOd
         AXBCsEMoXYoSJ5sAblWyGlaFP1vuJwfFpk7aM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 05/21] staging: ft1000: Fix coding style in ft1000_reset_card function.
Date: Thu, 10 Mar 2011 11:51:19 +0100
Message-Id: <1299754295-8493-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   65 ++++++++++++-------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 188a8e3..71c7c5d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -634,54 +634,53 @@ static void ft1000_reset_asic(struct net_device *dev)
 //              TRUE  (card reset successful)
 //
 //---------------------------------------------------------------------------
-static int ft1000_reset_card (struct net_device *dev)
+static int ft1000_reset_card(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-    u16 tempword;
+	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	u16 tempword;
 	struct prov_record *ptr;
 
-    DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
-
-    info->fCondResetPend = 1;
-    info->CardReady = 0;
-    info->fProvComplete = 0;
+	DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
 
-    // Make sure we free any memory reserve for provisioning
-    while (list_empty(&info->prov_list) == 0) {
-        DEBUG("ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
-	ptr = list_entry(info->prov_list.next, struct prov_record, list);
-        list_del(&ptr->list);
-        kfree(ptr->pprov_data);
-        kfree(ptr);
-    }
+	info->fCondResetPend = 1;
+	info->CardReady = 0;
+	info->fProvComplete = 0;
 
-    DEBUG("ft1000_hw:ft1000_reset_card: reset asic\n");
-    //reset ASIC
-    ft1000_reset_asic(dev);
-
-    info->DSPResetNum++;
+	/* Make sure we free any memory reserve for provisioning */
+	while (list_empty(&info->prov_list) == 0) {
+		DEBUG("ft1000_reset_card:deleting provisioning record\n");
+		ptr =
+		    list_entry(info->prov_list.next, struct prov_record, list);
+		list_del(&ptr->list);
+		kfree(ptr->pprov_data);
+		kfree(ptr);
+	}
 
-    DEBUG("ft1000_hw:ft1000_reset_card: call dsp_reload\n");
-    dsp_reload(ft1000dev);
+	DEBUG("ft1000_hw:ft1000_reset_card: reset asic\n");
+	ft1000_reset_asic(dev);
 
-    DEBUG("dsp reload successful\n");
+	info->DSPResetNum++;
 
+	DEBUG("ft1000_hw:ft1000_reset_card: call dsp_reload\n");
+	dsp_reload(ft1000dev);
 
-    mdelay(10);
+	DEBUG("dsp reload successful\n");
 
-    // Initialize DSP heartbeat area to ho
-    ft1000_write_dpram16(ft1000dev, FT1000_MAG_HI_HO, ho_mag, FT1000_MAG_HI_HO_INDX);
-    ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *)&tempword, FT1000_MAG_HI_HO_INDX);
-    DEBUG("ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n", tempword);
+	mdelay(10);
 
+	/* Initialize DSP heartbeat area */
+	ft1000_write_dpram16(ft1000dev, FT1000_MAG_HI_HO, ho_mag,
+			     FT1000_MAG_HI_HO_INDX);
+	ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *) &tempword,
+			    FT1000_MAG_HI_HO_INDX);
+	DEBUG("ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n", tempword);
 
+	info->CardReady = 1;
 
-    info->CardReady = 1;
-
-    info->fCondResetPend = 0;
-    return TRUE;
+	info->fCondResetPend = 0;
 
+	return TRUE;
 }
 
 
-- 
1.7.1

