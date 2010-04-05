Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0DETGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:06:55 -0400
Received: from mail.perches.com ([173.55.12.10]:1370 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab0DETFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:51 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] drivers/edac/cpc925_edac.c: Rename dev_info to cdi
Date: Mon,  5 Apr 2010 12:05:36 -0700
Message-Id: <58bd618ffb5176b25e0b1929bfc3f71211f78e06.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/edac/cpc925_edac.c |  122 ++++++++++++++++++++++----------------------
 1 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 3d50274..484e77c 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -286,8 +286,8 @@ struct cpc925_dev_info {
 	char *ctl_name;
 	int edac_idx;
 	struct edac_device_ctl_info *edac_dev;
-	void (*init)(struct cpc925_dev_info *dev_info);
-	void (*exit)(struct cpc925_dev_info *dev_info);
+	void (*init)(struct cpc925_dev_info *cdi);
+	void (*exit)(struct cpc925_dev_info *cdi);
 	void (*check)(struct edac_device_ctl_info *edac_dev);
 };
 
@@ -581,19 +581,19 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 
 /******************** CPU err device********************************/
 /* Enable CPU Errors detection */
-static void cpc925_cpu_init(struct cpc925_dev_info *dev_info)
+static void cpc925_cpu_init(struct cpc925_dev_info *cdi)
 {
 	u32 apimask;
 
-	apimask = __raw_readl(dev_info->vbase + REG_APIMASK_OFFSET);
+	apimask = __raw_readl(cdi->vbase + REG_APIMASK_OFFSET);
 	if ((apimask & CPU_MASK_ENABLE) == 0) {
 		apimask |= CPU_MASK_ENABLE;
-		__raw_writel(apimask, dev_info->vbase + REG_APIMASK_OFFSET);
+		__raw_writel(apimask, cdi->vbase + REG_APIMASK_OFFSET);
 	}
 }
 
 /* Disable CPU Errors detection */
-static void cpc925_cpu_exit(struct cpc925_dev_info *dev_info)
+static void cpc925_cpu_exit(struct cpc925_dev_info *cdi)
 {
 	/*
 	 * WARNING:
@@ -612,16 +612,16 @@ static void cpc925_cpu_exit(struct cpc925_dev_info *dev_info)
 /* Check for CPU Errors */
 static void cpc925_cpu_check(struct edac_device_ctl_info *edac_dev)
 {
-	struct cpc925_dev_info *dev_info = edac_dev->pvt_info;
+	struct cpc925_dev_info *cdi = edac_dev->pvt_info;
 	u32 apiexcp;
 	u32 apimask;
 
 	/* APIEXCP is cleared when read */
-	apiexcp = __raw_readl(dev_info->vbase + REG_APIEXCP_OFFSET);
+	apiexcp = __raw_readl(cdi->vbase + REG_APIEXCP_OFFSET);
 	if ((apiexcp & CPU_EXCP_DETECTED) == 0)
 		return;
 
-	apimask = __raw_readl(dev_info->vbase + REG_APIMASK_OFFSET);
+	apimask = __raw_readl(cdi->vbase + REG_APIMASK_OFFSET);
 	cpc925_printk(KERN_INFO, "Processor Interface Fault\n"
 				 "Processor Interface register dump:\n");
 	cpc925_printk(KERN_INFO, "APIMASK		0x%08x\n", apimask);
@@ -632,35 +632,35 @@ static void cpc925_cpu_check(struct edac_device_ctl_info *edac_dev)
 
 /******************** HT Link err device****************************/
 /* Enable HyperTransport Link Error detection */
-static void cpc925_htlink_init(struct cpc925_dev_info *dev_info)
+static void cpc925_htlink_init(struct cpc925_dev_info *cdi)
 {
 	u32 ht_errctrl;
 
-	ht_errctrl = __raw_readl(dev_info->vbase + REG_ERRCTRL_OFFSET);
+	ht_errctrl = __raw_readl(cdi->vbase + REG_ERRCTRL_OFFSET);
 	if ((ht_errctrl & HT_ERRCTRL_ENABLE) == 0) {
 		ht_errctrl |= HT_ERRCTRL_ENABLE;
-		__raw_writel(ht_errctrl, dev_info->vbase + REG_ERRCTRL_OFFSET);
+		__raw_writel(ht_errctrl, cdi->vbase + REG_ERRCTRL_OFFSET);
 	}
 }
 
 /* Disable HyperTransport Link Error detection */
-static void cpc925_htlink_exit(struct cpc925_dev_info *dev_info)
+static void cpc925_htlink_exit(struct cpc925_dev_info *cdi)
 {
 	u32 ht_errctrl;
 
-	ht_errctrl = __raw_readl(dev_info->vbase + REG_ERRCTRL_OFFSET);
+	ht_errctrl = __raw_readl(cdi->vbase + REG_ERRCTRL_OFFSET);
 	ht_errctrl &= ~HT_ERRCTRL_ENABLE;
-	__raw_writel(ht_errctrl, dev_info->vbase + REG_ERRCTRL_OFFSET);
+	__raw_writel(ht_errctrl, cdi->vbase + REG_ERRCTRL_OFFSET);
 }
 
 /* Check for HyperTransport Link errors */
 static void cpc925_htlink_check(struct edac_device_ctl_info *edac_dev)
 {
-	struct cpc925_dev_info *dev_info = edac_dev->pvt_info;
-	u32 brgctrl = __raw_readl(dev_info->vbase + REG_BRGCTRL_OFFSET);
-	u32 linkctrl = __raw_readl(dev_info->vbase + REG_LINKCTRL_OFFSET);
-	u32 errctrl = __raw_readl(dev_info->vbase + REG_ERRCTRL_OFFSET);
-	u32 linkerr = __raw_readl(dev_info->vbase + REG_LINKERR_OFFSET);
+	struct cpc925_dev_info *cdi = edac_dev->pvt_info;
+	u32 brgctrl = __raw_readl(cdi->vbase + REG_BRGCTRL_OFFSET);
+	u32 linkctrl = __raw_readl(cdi->vbase + REG_LINKCTRL_OFFSET);
+	u32 errctrl = __raw_readl(cdi->vbase + REG_ERRCTRL_OFFSET);
+	u32 linkerr = __raw_readl(cdi->vbase + REG_LINKERR_OFFSET);
 
 	if (!((brgctrl & BRGCTRL_DETSERR) ||
 	      (linkctrl & HT_LINKCTRL_DETECTED) ||
@@ -682,24 +682,24 @@ static void cpc925_htlink_check(struct edac_device_ctl_info *edac_dev)
 	/* Clear by write 1 */
 	if (brgctrl & BRGCTRL_DETSERR)
 		__raw_writel(BRGCTRL_DETSERR,
-				dev_info->vbase + REG_BRGCTRL_OFFSET);
+				cdi->vbase + REG_BRGCTRL_OFFSET);
 
 	if (linkctrl & HT_LINKCTRL_DETECTED)
 		__raw_writel(HT_LINKCTRL_DETECTED,
-				dev_info->vbase + REG_LINKCTRL_OFFSET);
+				cdi->vbase + REG_LINKCTRL_OFFSET);
 
 	/* Initiate Secondary Bus Reset to clear the chain failure */
 	if (errctrl & ERRCTRL_CHN_FAL)
 		__raw_writel(BRGCTRL_SECBUSRESET,
-				dev_info->vbase + REG_BRGCTRL_OFFSET);
+				cdi->vbase + REG_BRGCTRL_OFFSET);
 
 	if (errctrl & ERRCTRL_RSP_ERR)
 		__raw_writel(ERRCTRL_RSP_ERR,
-				dev_info->vbase + REG_ERRCTRL_OFFSET);
+				cdi->vbase + REG_ERRCTRL_OFFSET);
 
 	if (linkerr & HT_LINKERR_DETECTED)
 		__raw_writel(HT_LINKERR_DETECTED,
-				dev_info->vbase + REG_LINKERR_OFFSET);
+				cdi->vbase + REG_LINKERR_OFFSET);
 
 	edac_device_handle_ce(edac_dev, 0, 0, edac_dev->ctl_name);
 }
@@ -729,21 +729,21 @@ static struct cpc925_dev_info cpc925_devs[] = {
  */
 static void cpc925_add_edac_devices(void __iomem *vbase)
 {
-	struct cpc925_dev_info *dev_info;
+	struct cpc925_dev_info *cdi;
 
 	if (!vbase) {
 		cpc925_printk(KERN_ERR, "MMIO not established yet\n");
 		return;
 	}
 
-	for (dev_info = &cpc925_devs[0]; dev_info->init; dev_info++) {
-		dev_info->vbase = vbase;
-		dev_info->pdev = platform_device_register_simple(
-					dev_info->ctl_name, 0, NULL, 0);
-		if (IS_ERR(dev_info->pdev)) {
+	for (cdi = &cpc925_devs[0]; cdi->init; cdi++) {
+		cdi->vbase = vbase;
+		cdi->pdev = platform_device_register_simple(
+					cdi->ctl_name, 0, NULL, 0);
+		if (IS_ERR(cdi->pdev)) {
 			cpc925_printk(KERN_ERR,
 				"Can't register platform device for %s\n",
-				dev_info->ctl_name);
+				cdi->ctl_name);
 			continue;
 		}
 
@@ -751,45 +751,45 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 		 * Don't have to allocate private structure but
 		 * make use of cpc925_devs[] instead.
 		 */
-		dev_info->edac_idx = edac_device_alloc_index();
-		dev_info->edac_dev =
-			edac_device_alloc_ctl_info(0, dev_info->ctl_name,
-				1, NULL, 0, 0, NULL, 0, dev_info->edac_idx);
-		if (!dev_info->edac_dev) {
+		cdi->edac_idx = edac_device_alloc_index();
+		cdi->edac_dev =
+			edac_device_alloc_ctl_info(0, cdi->ctl_name,
+				1, NULL, 0, 0, NULL, 0, cdi->edac_idx);
+		if (!cdi->edac_dev) {
 			cpc925_printk(KERN_ERR, "No memory for edac device\n");
 			goto err1;
 		}
 
-		dev_info->edac_dev->pvt_info = dev_info;
-		dev_info->edac_dev->dev = &dev_info->pdev->dev;
-		dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-		dev_info->edac_dev->mod_name = CPC925_EDAC_MOD_STR;
-		dev_info->edac_dev->dev_name = dev_name(&dev_info->pdev->dev);
+		cdi->edac_dev->pvt_info = cdi;
+		cdi->edac_dev->dev = &cdi->pdev->dev;
+		cdi->edac_dev->ctl_name = cdi->ctl_name;
+		cdi->edac_dev->mod_name = CPC925_EDAC_MOD_STR;
+		cdi->edac_dev->dev_name = dev_name(&cdi->pdev->dev);
 
 		if (edac_op_state == EDAC_OPSTATE_POLL)
-			dev_info->edac_dev->edac_check = dev_info->check;
+			cdi->edac_dev->edac_check = cdi->check;
 
-		if (dev_info->init)
-			dev_info->init(dev_info);
+		if (cdi->init)
+			cdi->init(cdi);
 
-		if (edac_device_add_device(dev_info->edac_dev) > 0) {
+		if (edac_device_add_device(cdi->edac_dev) > 0) {
 			cpc925_printk(KERN_ERR,
 				"Unable to add edac device for %s\n",
-				dev_info->ctl_name);
+				cdi->ctl_name);
 			goto err2;
 		}
 
 		debugf0("%s: Successfully added edac device for %s\n",
-			__func__, dev_info->ctl_name);
+			__func__, cdi->ctl_name);
 
 		continue;
 
 err2:
-		if (dev_info->exit)
-			dev_info->exit(dev_info);
-		edac_device_free_ctl_info(dev_info->edac_dev);
+		if (cdi->exit)
+			cdi->exit(cdi);
+		edac_device_free_ctl_info(cdi->edac_dev);
 err1:
-		platform_device_unregister(dev_info->pdev);
+		platform_device_unregister(cdi->pdev);
 	}
 }
 
@@ -799,20 +799,20 @@ err1:
  */
 static void cpc925_del_edac_devices(void)
 {
-	struct cpc925_dev_info *dev_info;
+	struct cpc925_dev_info *cdi;
 
-	for (dev_info = &cpc925_devs[0]; dev_info->init; dev_info++) {
-		if (dev_info->edac_dev) {
-			edac_device_del_device(dev_info->edac_dev->dev);
-			edac_device_free_ctl_info(dev_info->edac_dev);
-			platform_device_unregister(dev_info->pdev);
+	for (cdi = &cpc925_devs[0]; cdi->init; cdi++) {
+		if (cdi->edac_dev) {
+			edac_device_del_device(cdi->edac_dev->dev);
+			edac_device_free_ctl_info(cdi->edac_dev);
+			platform_device_unregister(cdi->pdev);
 		}
 
-		if (dev_info->exit)
-			dev_info->exit(dev_info);
+		if (cdi->exit)
+			cdi->exit(cdi);
 
 		debugf0("%s: Successfully deleted edac device for %s\n",
-			__func__, dev_info->ctl_name);
+			__func__, cdi->ctl_name);
 	}
 }
 
-- 
1.7.0.3.311.g6a6955

