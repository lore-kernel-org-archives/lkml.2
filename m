Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2LZByP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:54:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37944 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2LZByL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:11 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-62-50da58c1c4fa
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: [PATCH v6 08/12] iommu/exynos: add support for runtime pm and
 suspend/resume
Date: Wed, 26 Dec 2012 10:54:08 +0900
Message-id: <003b01cde30b$e49c8220$add58660$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC+R69X3K1tFGSyGUhimqnNyILQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zY92DEbcCDLYd1bG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpYvLWNqeCqW8X0Gd+ZGhj/WnYxcnJICJhIvL/1kQnC
	FpO4cG89G4gtJLCMUWLWgUKYms4FK4BquIDiixglbp/aC+X8Y5S4OvsWM0gVm4CWxOq5xxlB
	bBGBu4wSL8/zgBQxC/xllPh05hA7SEJYIFzi2pN/YEUsAqoSt97MZwGxeQVsJdp/PWGEsAUl
	fky+BxZnFjCQeD+rjxXClpfYvOYt0DIOoJPUJR791QUxRQT0JNZMkoeoEJHY9+Id1HQBiW+T
	D7FAVMtKbDrADHKNhMBkdomfB+4xQjwmKXFwxQ2WCYxis5AsnoVk8Swki2chWbGAkWUVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRkjMSO1gXNlgcYhRgINRiYd34/ebAUKsiWXFlbmHGCU4
	mJVEeJ0/AoV4UxIrq1KL8uOLSnNSiw8x+gBdPpFZSjQ5HxjPeSXxhsbGJmYmpibmlqbmpjiE
	lcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwClfHx7hZO0jJN8hZzFmTsru3fOvVrInXgfHj
	nFv8cU9qnnri0y1C+xUzQqZ/DP/Z/vbD2961n/32Zf1OvHbxu2fl0975PFa78qsf3mCx3ROt
	5SegZCQ5vcBsQZB88J34l0kqSyazMDM7PTl8etaBwMZfi5p69BrLtkzv3GFzUyn3QK4p728l
	luKMREMt5qLiRACyQ6PQxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd0DEbcCDA6sVbW4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWLy1jangqlvF
	9BnfmRoY/1p2MXJySAiYSHQuWMEEYYtJXLi3nq2LkYtDSGARo8TtU3uZIJx/jBJXZ99iBqli
	E9CSWD33OCOILSJwl1Hi5XkekCJmgb+MEp/OHGIHSQgLhEtce/IPrIhFQFXi1pv5LCA2r4Ct
	RPuvJ4wQtqDEj8n3wOLMAgYS72f1sULY8hKb17wFWsYBdJK6xKO/uiCmiICexJpJ8hAVIhL7
	XrxjnMAoMAvJoFlIBs1CMmgWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj8pnU
	DsaVDRaHGAU4GJV4eDd+vxkgxJpYVlyZe4hRgoNZSYTX+SNQiDclsbIqtSg/vqg0J7X4EKMP
	0J8TmaVEk/OB6SKvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6p
	BsZp+y0c5W0P6ZQ9XtmwtGpf3jXNL75svNrx7FrHg/YtvPv5LJ9OmDHDeoUVN1lDPXxmPrc9
	tnW98zID/dP6J98UPXI7WrN2VdiTGfX/Opd9uLuq6Wvwq4SX/ud5LR/nPS/pD2Cdwtrd1PDh
	zOfAo2sb5LI1b5hGp7NPTUuSm+8eE3jx7berKyKVWIozEg21mIuKEwEHqL/69gIAAA==
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


