Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2LKLLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:11:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52166 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2LKLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:10:59 -0500
X-AuditID: cbfee61b-b7f616d00000319b-16-50c714c288c0
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
Subject: [PATCH v5 10/14] iommu/exynos: add support for runtime pm and
 suspend/resume
Date: Tue, 11 Dec 2012 20:10:57 +0900
Message-id: <003a01cdd790$3206c7a0$961456e0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjH5YlZtBt8cNTvO9UPmtXUriUgAA6uIQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI91DIscDDD7+5ba4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpYvLWNqeCqW8X0Gd+ZGhj/WnYxcnJICJhIzL15jw3C
	FpO4cG89kM3FISSwjFHi0vbnrDBFe1+9ZYJILGKU+DWtmxkkISTwj1HizoViEJtNQEti9dzj
	jCC2iMBdRomX53lAGpgFjjBJ7Lx/jgUkISwQLrFj9WsmEJtFQFXi36RusA28ArYS5/uXMUHY
	ghI/Jt8Dq2cGGrp+53EmCFteYvOat0CLOYAuUpd49FcXxBQRMJLY+1YEokJEYt+Ld4wQ0wUk
	vk0+xAJRLSux6QAzyDUSApPZJRZ8uwj1sKTEwRU3WCYwis1CsngWksWzkCyehWTFAkaWVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxghMSO9g3FVg8UhRgEORiUeXg2tYwFCrIllxZW5hxgl
	OJiVRHgjhY4HCPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MJ7zSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamCcKDx/Y9Ny3ayMde8W31L/f2jz/ezUWrl5
	DCfl7cXSHm+fGfuNIbLCXF/R7emqRzuLQrsOs0pVbo57vqx14fzI4Pe9F66dbfxX5bth+6dH
	nYetzHscK7+Hu7B8tHiWtMxtq74Ho9EU1W37/nDO+3ufwWN7cITu3YXvbz9/N/+54a4rQW98
	nXjnKLEUZyQaajEXFScCAAXhIfbGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd1DIscDDJ7/ZLG4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWLy1jangqlvF
	9BnfmRoY/1p2MXJySAiYSOx99ZYJwhaTuHBvPVsXIxeHkMAiRolf07qZQRJCAv8YJe5cKAax
	2QS0JFbPPc4IYosI3GWUeHmeB6SBWeAIk8TO++dYQBLCAuESO1a/BpvKIqAq8W9SNyuIzStg
	K3G+fxkThC0o8WPyPbB6ZqCh63ceZ4Kw5SU2r3kLtJgD6CJ1iUd/dUFMEQEjib1vRSAqRCT2
	vXjHOIFRYBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH5DPp
	HYyrGiwOMQpwMCrx8GpoHQsQYk0sK67MPcQowcGsJMIbKXQ8QIg3JbGyKrUoP76oNCe1+BCj
	D9CfE5mlRJPzgckiryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5O
	qQZGr9SphdOOH7BdJiT8KoTXvKV3xVXN6aydDv6eVfm+/ZkqPxdft14aVFl4zjelYc31Bobb
	91LVPk/ZyM6lfv769Jtv71ge6O3TObWry7ygOdDsYIPS+cgfXPLKX83XTX21r1d7Xcom//+p
	dnohgomnQ5eeeS50Uedx243Dlt8WzBYvbT/I9rtGiaU4I9FQi7moOBEAhynnU/UCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change enables the client device drivers not to care about
the state of System MMU since the internal state of System MMU
is controlled by the runtime PM and suspend/resume callback functions.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 176 ++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 87 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index a0e5ee1..c3c5b7b 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -187,6 +187,7 @@ struct sysmmu_drvdata {
 	spinlock_t lock;
 	struct iommu_domain *domain;
 	unsigned long pgtable;
+	bool runtime_active;
 	void __iomem *sfrbases[0];
 };
 
@@ -409,7 +410,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 		data->pgtable = 0;
 		data->domain = NULL;
 
-		__sysmmu_disable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_disable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Disabled\n");
 	} else  {
@@ -422,30 +424,6 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
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
-		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
-		disabled = __sysmmu_disable(data);
-		if (disabled)
-			data->master = NULL;
-	}
-
-	spin_unlock_irqrestore(&owner->lock, flags);
-
-	return disabled;
-}
-
 static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 {
 	int i;
@@ -481,7 +459,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 		data->pgtable = pgtable;
 		data->domain = domain;
 
-		__sysmmu_enable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_enable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
@@ -537,42 +516,31 @@ static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
 
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
+
+	spin_lock_irqsave(&owner->lock, flags);
+
+	/* Every call to __sysmmu_disable() must return same result */
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
+		disabled = __sysmmu_disable(drvdata);
+		if (disabled)
+			drvdata->master = NULL;
+	}
 
-	for_each_sysmmu(dev, sysmmu)
-		pm_runtime_put(sysmmu);
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return disabled;
 }
@@ -588,7 +556,8 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 		data = dev_get_drvdata(sysmmu);
 
 		spin_lock_irqsave(&data->lock, flags);
-		if (is_sysmmu_active(data)) {
+		if (is_sysmmu_active(data) &&
+				data->runtime_active) {
 			int i;
 			for (i = 0; i < data->nsfrs; i++) {
 				if (sysmmu_block(data->sfrbases[i])) {
@@ -817,7 +786,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
 
-		pm_runtime_enable(dev);
+		data->runtime_active = !pm_runtime_enabled(dev);
 
 		platform_set_drvdata(pdev, data);
 
@@ -828,6 +797,64 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
@@ -865,6 +892,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &__pm_ops,
 		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
 };
@@ -939,13 +967,9 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
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
@@ -968,7 +992,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
 	int ret;
-	struct device *sysmmu;
 
 	if (WARN_ON(!list_empty(&owner->client))) {
 		bool found = false;
@@ -993,20 +1016,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
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
@@ -1021,15 +1030,12 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
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
@@ -1045,7 +1051,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
 	list_for_each_entry_safe(owner, n, &priv->clients, client) {
 		if (owner == dev->archdata.iommu) {
-			if (__exynos_sysmmu_disable(dev))
+			if (exynos_sysmmu_disable(dev))
 				list_del_init(&owner->client);
 			else
 				BUG();
@@ -1055,14 +1061,10 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
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


