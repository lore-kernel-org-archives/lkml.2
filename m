Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2KUFHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:07:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33969 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2KUFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:07:03 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-87-50ac6175d85f
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 09/12] iommu/exynos: add supoort for runtime pm and
 suspend/resume
Date: Wed, 21 Nov 2012 14:07:01 +0900
Message-id: <003001cdc7a6$0a571470$1f053d50$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Hpgo2U4ZZsjbJRZKw9ccPSVfuLQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA93SxDUBBieOW1hc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcPnmfteCMe8XbX1vZGxg/WnUxcnJICJhIrG79wAxh
	i0lcuLeerYuRi0NIYBmjxOmGi2wwRetbr7NCJKYzSvy9f5gdwvnHKHFg6WOwdjYBLYnVc48z
	giREBHoZJS70f2UCcZgFfjBKLH7zBqxKWCBc4uK+NqBZHBwsAqoSCw4agpi8ArYSv95agFTw
	CghK/Jh8jwXEZgaauX7ncSYIW15i85q3zCDlEgLqEo/+6oKERQT0JLr/XYYqF5HY9+IdI4jN
	IiAg8W3yIRaIclmJTQegnpzOLjHhUB6ELSlxcMUNlgmMYrOQLJ6FZPEsJItnIdmwgJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZIzEjtYFzZYHGIUYCDUYmHd+Pa1QFCrIllxZW5hxgl
	OJiVRHgZ5NcECPGmJFZWpRblxxeV5qQWH2L0ATp8IrOUaHI+MJ7zSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamBcGxfE0cr+PkWk79GZazqbnZ76FWb92JDE
	7iFp2FbKMDfa3aMu/fHJ2SEfH7Ken6+xPN2Y2fbTlkbeh24LzqwNfRb/9oc1W0XbsZMcPMZm
	TbtfLr8vp6W8x/5Jdu+NFZlvOaSs6+/UPbTn0vtb91V312XTmv8pVbJv9wdtEdrEwZKvsEI2
	/qsSS3FGoqEWc1FxIgC8ALMkxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd3SxDUBBg/bTSwu75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzDp+8z1pwxr3i
	7a+t7A2MH626GDk5JARMJNa3XmeFsMUkLtxbz9bFyMUhJDCdUeLv/cPsEM4/RokDSx8zg1Sx
	CWhJrJ57nBEkISLQyyhxof8rE4jDLPCDUWLxmzdgVcIC4RIX97UBzeXgYBFQlVhw0BDE5BWw
	lfj11gKkgldAUOLH5HssIDYz0Mz1O48zQdjyEpvXvGUGKZcQUJd49FcXJCwioCfR/e8yVLmI
	xL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Jh8
	JrWDcWWDxSFGAQ5GJR7ejWtXBwixJpYVV+YeYpTgYFYS4WWQXxMgxJuSWFmVWpQfX1Sak1p8
	iNEH6M2JzFKiyfnAdJFXEm9obGJmZGlkZmFkYm6OQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwT
	B6dUA+OhFaUyLmpbggUd9b+uebROeu8l3qNz7v3InM/7VSpfgTFhmwvnvLZjZSYCxY9c5Bye
	pjHOYvv7RL3pI9cTHwM7U8eP5wuuPPLhc373Ubh46e67S04+FJtwRVDrz5a5jMrd12/kvVjb
	6dcntUPtnlCVusuvR62+0gkPiquetf+8fMA6xtvAT0mJpTgj0VCLuag4EQAc/Ov+9gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change enables the client device drivers not to care about
the state of System MMU since the internal state of System MMU
is controlled by the runtime PM and suspend/resume callback functions.

Change-Id: Ic04c8f259d8b8af2846175dd7b98dbc4e463c96e
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 175 ++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 86 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index f7dff54..8d95505 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -208,6 +208,7 @@ struct sysmmu_drvdata {
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
+	bool runtime_active;
 	void __iomem *sfrbases[0];
 };
 
@@ -477,7 +478,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *drvdata)
 		drvdata->pgtable = 0;
 		drvdata->domain = NULL;
 
-		__sysmmu_disable_nocount(drvdata);
+		if (drvdata->runtime_active)
+			__sysmmu_disable_nocount(drvdata);
 
 		dev_dbg(drvdata->sysmmu, "Disabled\n");
 	} else  {
@@ -490,30 +492,6 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *drvdata)
 	return disabled;
 }
 
-static bool __exynos_sysmmu_disable(struct device *dev)
-{
-	unsigned long flags;
-	bool disabled = true;
-	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	struct device *sysmmu;
-
-	BUG_ON(!has_sysmmu(dev));
-
-	spin_lock_irqsave(&owner->lock, flags);
-
-	/* Every call to __sysmmu_disable() must return same result */
-	for_each_sysmmu(dev, sysmmu) {
-		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
-		disabled = __sysmmu_disable(drvdata);
-		if (disabled)
-			drvdata->master = NULL;
-	}
-
-	spin_unlock_irqrestore(&owner->lock, flags);
-
-	return disabled;
-}
-
 static void __sysmmu_enable_nocount(struct sysmmu_drvdata *drvdata)
 {
 	int i;
@@ -554,7 +532,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *drvdata,
 		drvdata->pgtable = pgtable;
 		drvdata->domain = domain;
 
-		__sysmmu_enable_nocount(drvdata);
+		if (drvdata->runtime_active)
+			__sysmmu_enable_nocount(drvdata);
 
 		dev_dbg(drvdata->sysmmu, "Enabled\n");
 	} else {
@@ -610,42 +589,31 @@ static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
 
 int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 {
-	int ret;
-	struct device *sysmmu;
-
 	BUG_ON(!memblock_is_memory(pgtable));
 
-	for_each_sysmmu(dev, sysmmu) {
-		ret = pm_runtime_get_sync(sysmmu);
-		if (ret < 0)
-			break;
-	}
-
-	if (ret < 0) {
-		struct device *start;
-		for_each_sysmmu_until(dev, start, sysmmu)
-			pm_runtime_put(start);
-
-		return ret;
-	}
-
-	ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
-	if (ret < 0)
-		for_each_sysmmu(dev, sysmmu)
-			pm_runtime_put(sysmmu);
-
-	return ret;
+	return __exynos_sysmmu_enable(dev, pgtable, NULL);
 }
 
 bool exynos_sysmmu_disable(struct device *dev)
 {
-	bool disabled;
+	unsigned long flags;
+	bool disabled = true;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct device *sysmmu;
 
-	disabled = __exynos_sysmmu_disable(dev);
+	BUG_ON(!has_sysmmu(dev));
 
-	for_each_sysmmu(dev, sysmmu)
-		pm_runtime_put(sysmmu);
+	spin_lock_irqsave(&owner->lock, flags);
+
+	/* Every call to __sysmmu_disable() must return same result */
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
+		disabled = __sysmmu_disable(drvdata);
+		if (disabled)
+			drvdata->master = NULL;
+	}
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return disabled;
 }
@@ -661,7 +629,8 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 		data = dev_get_drvdata(sysmmu);
 
 		spin_lock_irqsave(&data->lock, flags);
-		if (is_sysmmu_active(data)) {
+		if (is_sysmmu_active(data) &&
+				data->runtime_active) {
 			int i;
 			for (i = 0; i < data->nsfrs; i++) {
 				if (sysmmu_block(data->sfrbases[i])) {
@@ -893,6 +862,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
+		data->runtime_active = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
 
@@ -907,6 +877,64 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	return ret;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata) &&
+		(!pm_runtime_enabled(dev) || drvdata->runtime_active))
+		__sysmmu_disable_nocount(drvdata);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
+
+static int sysmmu_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata) &&
+		(!pm_runtime_enabled(dev) || drvdata->runtime_active)) {
+		__sysmmu_enable_nocount(drvdata);
+	}
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static int sysmmu_runtime_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata))
+		__sysmmu_disable_nocount(drvdata);
+	drvdata->runtime_active = false;
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
+
+static int sysmmu_runtime_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	drvdata->runtime_active = true;
+	if (is_sysmmu_active(drvdata))
+		__sysmmu_enable_nocount(drvdata);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops __pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(sysmmu_suspend, sysmmu_resume)
+	SET_RUNTIME_PM_OPS(sysmmu_runtime_suspend, sysmmu_runtime_resume, NULL)
+};
+
 /*
  * Descriptions of Device Tree node for System MMU
  *
@@ -944,6 +972,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &__pm_ops,
 		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
 };
@@ -1005,13 +1034,9 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	list_for_each_entry_safe(owner, n, &priv->clients, client) {
-		struct device *sysmmu;
-		while (!__exynos_sysmmu_disable(owner->dev))
+		while (!exynos_sysmmu_disable(owner->dev))
 			; /* until System MMU is actually disabled */
 		list_del_init(&owner->client);
-
-		for_each_sysmmu(owner->dev, sysmmu)
-			pm_runtime_put(sysmmu);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1034,7 +1059,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
 	int ret;
-	struct device *sysmmu;
 
 	if (WARN_ON(!list_empty(&owner->client))) {
 		bool found = false;
@@ -1059,20 +1083,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 		return 0;
 	}
 
-	for_each_sysmmu(dev, sysmmu) {
-		ret = pm_runtime_get_sync(sysmmu);
-		if (ret < 0)
-			break;
-	}
-
-	if (ret < 0) {
-		struct device *start;
-		for_each_sysmmu_until(dev, start, sysmmu)
-			pm_runtime_put(start);
-
-		return ret;
-	}
-
 	spin_lock_irqsave(&priv->lock, flags);
 
 	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
@@ -1087,15 +1097,12 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		for_each_sysmmu(dev, sysmmu)
-			pm_runtime_put(sysmmu);
-	} else {
+	else
 		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
 					__func__, __pa(priv->pgtable));
-	}
 
 	return ret;
 }
@@ -1111,7 +1118,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
 	list_for_each_entry_safe(owner, n, &priv->clients, client) {
 		if (owner == dev->archdata.iommu) {
-			if (__exynos_sysmmu_disable(dev))
+			if (exynos_sysmmu_disable(dev))
 				list_del_init(&owner->client);
 			else
 				BUG();
@@ -1121,14 +1128,10 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (owner == dev->archdata.iommu) {
-		struct device *sysmmu;
+	if (owner == dev->archdata.iommu)
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		for_each_sysmmu(dev, sysmmu)
-			pm_runtime_put(sysmmu);
-
-	} else
+	else
 		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
-- 
1.8.0


