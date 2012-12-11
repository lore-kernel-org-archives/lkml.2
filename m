Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2LKLK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:10:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34247 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2LKLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:10:23 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b9-50c7149d9206
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
Subject: [PATCH v5 08/14] iommu/exynos: set System MMU as the parent of client
 device
Date: Tue, 11 Dec 2012 20:10:21 +0900
Message-id: <003801cdd790$1c494a00$54dbde00$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjHogewjAdSyuTwqODuFphlqkcgAA5kOw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI925IscDDBrm61tc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW83z+HveDzGsaKS/vKGxj/dzJ2MXJySAiYSKy6/ogZ
	whaTuHBvPVsXIxeHkMAyRon+h1tYYIretPyDSixilOjqXMEI4fxjlGh+8h+sik1AS2L13ONg
	Y0UE7jJKvDzPA1LELHCESWLn/XNgRcIC4RKvGzeC2SwCqhKb9l5mArF5BWwlzhy/zwJhC0r8
	mHwPzGYGGrp+53EmCFteYvOat0C3cgCdpC7x6K8uxC4jiYlvrjBDlIhI7HvxjhFivIDEt8mH
	WCDKZSU2HWAGOUdCYDK7xN93t6A+k5Q4uOIGywRGsVlINs9CsnkWks2zkKxYwMiyilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyMkcqR2MK5ssDjEKMDBqMTDq6F1LECINbGsuDL3EKMEB7OS
	CG+k0PEAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4HRnVeSbyhsbGJmYmpibmlqbkpDmEl
	cd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYz1mcvqS+6/Svm//dSsbKbQ+18eMLVWTrNM8V7w
	8Oupo4y++36fy97y57le6kO2rO2VG8R3Hyt9/8BG/5lV3z6GDU3LBZWye8X0lQTfLZhTfeMC
	v/+avwes1i/V5180l/nKHIUjm4MkTITnCEZLrVlwrptNWzqvKyRlzaKHW78WHzSMeP7j1KsK
	JZbijERDLeai4kQADca058kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd25IscDDA61aFpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvN8/h73g8xrG
	ikv7yhsY/3cydjFyckgImEi8afnHBmGLSVy4tx7I5uIQEljEKNHVuYIRwvnHKNH85D8LSBWb
	gJbE6rnHwbpFBO4ySrw8zwNSxCxwhEli5/1zYEXCAuESrxs3gtksAqoSm/ZeZgKxeQVsJc4c
	v88CYQtK/Jh8D8xmBhq6fudxJghbXmLzmrfMXYwcQCepSzz6qwuxy0hi4psrzBAlIhL7Xrxj
	nMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj8pnUDsaV
	DRaHGAU4GJV4eDW0jgUIsSaWFVfmHmKU4GBWEuGNFDoeIMSbklhZlVqUH19UmpNafIjRB+jR
	icxSosn5wJSRVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAOj
	QeW9nQULf+4Sufxw5cK+p+9Odr/K+rS//4Pd07u2f3ZMtNiwrsQ3mWNz0eGjR7QW7alRzs6a
	/MDr3q770wp3h/bu9HkqUr3tzseHN5KKGr/fe+w86SXDgtf1XTVqH3vllzyWPHyG+5mcuMYS
	Ff+TW6dN+cvSfDviw8GzlicOlwtuFPUQ07zJv1KJpTgj0VCLuag4EQAJNbkP+AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sets System MM as the parent of the client device for
power management. If System MMU is the parent of a device, it is
guaranteed that System MMU is suspended later than the device and
resumed earlier. Runtime suspend/resume on the device is also
propagated to the System MMU.
If a device is configured to have more than one System MMU, the
advantage of power management also works and the System MMUs are
also have relationships of parent and child. In this situation,
the client device is still the descendant of its System MMUs.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 510 +++++++++++++++++++++++++++++--------------
 1 file changed, 342 insertions(+), 168 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 5b35820..a0e5ee1 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -101,6 +101,17 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+static void *sysmmu_placeholder; /* Inidcate if a device is System MMU */
+
+#define is_sysmmu(sysmmu) (sysmmu->archdata.iommu == &sysmmu_placeholder)
+#define has_sysmmu(dev)							\
+	(dev->parent && dev->archdata.iommu && is_sysmmu(dev->parent))
+#define for_each_sysmmu(dev, sysmmu)					\
+	for (sysmmu = dev->parent; sysmmu && is_sysmmu(sysmmu);		\
+			sysmmu = sysmmu->parent)
+#define for_each_sysmmu_until(dev, sysmmu, until)			\
+	for (sysmmu = dev->parent; sysmmu != until; sysmmu = sysmmu->parent)
+
 static struct kmem_cache *lv2table_kmem_cache;
 
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
@@ -157,10 +168,19 @@ struct exynos_iommu_domain {
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
 };
 
+/* exynos_iommu_owner
+ * Metadata attached to the owner of a group of System MMUs that belong
+ * to the same owner device.
+ */
+struct exynos_iommu_owner {
+	struct list_head client; /* entry of exynos_iommu_domain.clients */
+	struct device *dev;
+	spinlock_t lock;	/* Lock to preserve consistency of System MMU */
+};
+
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
+	struct device *master;	/* Client device that needs System MMU */
 	int nsfrs;
 	struct clk *clk;
 	int activations;
@@ -241,44 +261,50 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 				unsigned long base0, unsigned long size0,
 				unsigned long base1, unsigned long size1)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	unsigned long flags;
-	int i;
+	struct device *sysmmu;
 
-	BUG_ON((base0 + size0) <= base0);
-	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
+	for_each_sysmmu(dev, sysmmu) {
+		int i;
+		unsigned long flags;
+		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
 
-	spin_lock_irqsave(&data->lock, flags);
-	if (!is_sysmmu_active(data))
-		goto finish;
+		BUG_ON((base0 + size0) <= base0);
+		BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	for (i = 0; i < data->nsfrs; i++) {
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			if (!sysmmu_block(data->sfrbases[i]))
-				continue;
+		spin_lock_irqsave(&data->lock, flags);
+		if (!is_sysmmu_active(data)) {
+			spin_unlock_irqrestore(&data->lock, flags);
+			continue;
+		}
 
-			if (size1 == 0) {
-				if (size0 <= SZ_128K) {
-					base1 = base0;
-					size1 = size0;
-				} else {
-					size1 = size0 -
+		for (i = 0; i < data->nsfrs; i++) {
+			if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28)
+									== 3) {
+				if (!sysmmu_block(data->sfrbases[i]))
+					continue;
+
+				if (size1 == 0) {
+					if (size0 <= SZ_128K) {
+						base1 = base0;
+						size1 = size0;
+					} else {
+						size1 = size0 -
 						ALIGN(size0 / 2, SZ_64K);
-					size0 = size0 - size1;
-					base1 = base0 + size0;
+						size0 = size0 - size1;
+						base1 = base0 + size0;
+					}
 				}
-			}
 
-			__sysmmu_set_prefbuf(
+				__sysmmu_set_prefbuf(
 					data->sfrbases[i], base0, size0, 0);
-			__sysmmu_set_prefbuf(
+				__sysmmu_set_prefbuf(
 					data->sfrbases[i], base1, size1, 1);
 
-			sysmmu_unblock(data->sfrbases[i]);
+				sysmmu_unblock(data->sfrbases[i]);
+			}
 		}
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-finish:
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __show_fault_information(unsigned long *pgtable, unsigned long iova,
@@ -333,16 +359,17 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	}
 
 	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
+		ret = report_iommu_fault(data->domain,
+					data->master, addr, itype);
 	else
 		__show_fault_information(__va(data->pgtable), itype, addr);
 
 	if (ret == -ENOSYS)
 		pr_err("NO SYSTEM MMU FAULT HANDLER REGISTERED FOR %s\n",
-						dev_name(data->dev));
+						dev_name(data->master));
 	else if (ret < 0)
 		pr_err("SYSTEM MMU FAULT HANDLER FOR %s RETURNED ERROR, %d\n",
-						dev_name(data->dev), ret);
+						dev_name(data->master), ret);
 	else if (itype != SYSMMU_FAULT_UNKNOWN)
 		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
 	else
@@ -358,174 +385,259 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
+static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
 {
-	unsigned long flags;
-	bool disabled = false;
 	int i;
 
-	spin_lock_irqsave(&data->lock, flags);
+	for (i = 0; i < data->nsfrs; i++)
+		__raw_writel(CTRL_DISABLE,
+			data->sfrbases[i] + REG_MMU_CTRL);
 
-	if (!set_sysmmu_inactive(data))
-		goto finish;
+	clk_disable(data->clk);
+}
 
-	for (i = 0; i < data->nsfrs; i++)
-		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
+static bool __sysmmu_disable(struct sysmmu_drvdata *data)
+{
+	bool disabled;
+	unsigned long flags;
 
-	if (data->clk)
-		clk_disable(data->clk);
+	spin_lock_irqsave(&data->lock, flags);
 
-	disabled = true;
-	data->pgtable = 0;
-	data->domain = NULL;
-finish:
-	spin_unlock_irqrestore(&data->lock, flags);
+	disabled = set_sysmmu_inactive(data);
+
+	if (disabled) {
+		data->pgtable = 0;
+		data->domain = NULL;
+
+		__sysmmu_disable_nocount(data);
 
-	if (disabled)
 		dev_dbg(data->sysmmu, "Disabled\n");
-	else
+	} else  {
 		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
-					data->activations);
+						data->activations);
+	}
+
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
 
-/* __exynos_sysmmu_enable: Enables System MMU
- *
- * returns -error if an error occurred and System MMU is not enabled,
- * 0 if the System MMU has been just enabled and 1 if System MMU was already
- * enabled before.
- */
-static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+static bool __exynos_sysmmu_disable(struct device *dev)
 {
-	int i, ret = 0;
 	unsigned long flags;
+	bool disabled = true;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
 
-	spin_lock_irqsave(&data->lock, flags);
+	BUG_ON(!has_sysmmu(dev));
 
-	if (!set_sysmmu_active(data)) {
-		if (WARN_ON(pgtable != data->pgtable)) {
-			ret = -EBUSY;
-			set_sysmmu_inactive(data);
-		} else {
-			ret = 1;
-		}
+	spin_lock_irqsave(&owner->lock, flags);
 
-		dev_dbg(data->sysmmu, "Already enabled\n");
-		goto finish;
+	/* Every call to __sysmmu_disable() must return same result */
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+		disabled = __sysmmu_disable(data);
+		if (disabled)
+			data->master = NULL;
 	}
 
-	if (data->clk)
-		clk_enable(data->clk);
+	spin_unlock_irqrestore(&owner->lock, flags);
 
-	data->pgtable = pgtable;
+	return disabled;
+}
+
+static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
+{
+	int i;
+
+	clk_enable(data->clk);
 
 	for (i = 0; i < data->nsfrs; i++) {
-		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
+		unsigned long cfg = 1;
+
+		__sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
 
 		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
 			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
+			cfg |= (1 << 12) | (2 << 28);
 			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
 			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
 		}
 
+		__raw_writel(cfg, data->sfrbases[i] + REG_MMU_CFG);
+
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
+}
+
+static int __sysmmu_enable(struct sysmmu_drvdata *data,
+			unsigned long pgtable, struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
 
-	data->domain = domain;
+	spin_lock_irqsave(&data->lock, flags);
+	if (set_sysmmu_active(data)) {
+		data->pgtable = pgtable;
+		data->domain = domain;
+
+		__sysmmu_enable_nocount(data);
+
+		dev_dbg(data->sysmmu, "Enabled\n");
+	} else {
+		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
+
+		dev_dbg(data->sysmmu, "Already enabled\n");
+	}
+
+	if (WARN_ON(ret < 0))
+		set_sysmmu_inactive(data); /* decrement count */
 
-	dev_dbg(data->sysmmu, "Enabled\n");
-finish:
 	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
 
+/* __exynos_sysmmu_enable: Enables System MMU
+ *
+ * returns -error if an error occurred and System MMU is not enabled,
+ * 0 if the System MMU has been just enabled and 1 if System MMU was already
+ * enabled before.
+ */
+static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
+				struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
+
+	BUG_ON(!has_sysmmu(dev));
+
+	spin_lock_irqsave(&owner->lock, flags);
+
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+		ret = __sysmmu_enable(data, pgtable, domain);
+		if (ret < 0) {
+			struct device *iter;
+			for_each_sysmmu_until(dev, iter, sysmmu) {
+				data = dev_get_drvdata(iter);
+				__sysmmu_disable(data);
+			}
+		} else {
+			data->master = dev;
+		}
+	}
+
+	spin_unlock_irqrestore(&owner->lock, flags);
+
+	return ret;
+}
+
 int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	int ret;
+	struct device *sysmmu;
 
 	BUG_ON(!memblock_is_memory(pgtable));
 
-	ret = pm_runtime_get_sync(data->sysmmu);
+	for_each_sysmmu(dev, sysmmu) {
+		ret = pm_runtime_get_sync(sysmmu);
+		if (ret < 0)
+			break;
+	}
+
 	if (ret < 0) {
-		dev_dbg(data->sysmmu, "Failed to enable\n");
+		struct device *start;
+		for_each_sysmmu_until(dev, start, sysmmu)
+			pm_runtime_put(start);
+
 		return ret;
 	}
 
-	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
-	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu,
-			"Already enabled with page table %#lx\n",
-			data->pgtable);
-	} else {
-		data->dev = dev;
-	}
+	ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
+	if (ret < 0)
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 
 	return ret;
 }
 
 bool exynos_sysmmu_disable(struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	bool disabled;
+	struct device *sysmmu;
+
+	disabled = __exynos_sysmmu_disable(dev);
 
-	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
+	for_each_sysmmu(dev, sysmmu)
+		pm_runtime_put(sysmmu);
 
 	return disabled;
 }
 
 static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct device *sysmmu;
 
-	spin_lock_irqsave(&data->lock, flags);
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *data;
 
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate_entry(
+		data = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (is_sysmmu_active(data)) {
+			int i;
+			for (i = 0; i < data->nsfrs; i++) {
+				if (sysmmu_block(data->sfrbases[i])) {
+					__sysmmu_tlb_invalidate_entry(
 						data->sfrbases[i], iova);
-				sysmmu_unblock(data->sfrbases[i]);
+					sysmmu_unblock(data->sfrbases[i]);
+				} else {
+					dev_err(dev,
+					"%s failed due to blocking timeout\n",
+					__func__);
+				}
 			}
+		} else {
+			dev_dbg(dev,
+			"Disabled. Skipping TLB invalidation for %#lx\n", iova);
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"Disabled. Skipping invalidating TLB.\n");
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-
-	spin_lock_irqsave(&data->lock, flags);
-
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate(data->sfrbases[i]);
-				sysmmu_unblock(data->sfrbases[i]);
+	struct device *sysmmu;
+
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *data;
+
+		data = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (is_sysmmu_active(data)) {
+			int i;
+			for (i = 0; i < data->nsfrs; i++) {
+				if (sysmmu_block(data->sfrbases[i])) {
+					__sysmmu_tlb_invalidate(
+							data->sfrbases[i]);
+					sysmmu_unblock(data->sfrbases[i]);
+				} else {
+					dev_err(dev,
+					"%s failed due to blocking timeout\n",
+					__func__);
+				}
 			}
+		} else {
+			dev_dbg(dev, "Disabled. Skipping TLB invalidation\n");
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"Disabled. Skipping invalidating TLB.\n");
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int __init __sysmmu_init_clock(struct device *sysmmu,
@@ -579,6 +691,7 @@ static int __init __sysmmu_setup(struct device *sysmmu,
 				struct sysmmu_drvdata *drvdata)
 {
 	struct device_node *master_node;
+	struct device *child;
 	const char *compat;
 	struct platform_device *pmaster = NULL;
 	u32 master_inst_no = -1;
@@ -605,12 +718,41 @@ static int __init __sysmmu_setup(struct device *sysmmu,
 		return __sysmmu_init_clock(sysmmu, drvdata, NULL);
 	}
 
-	pmaster->dev.archdata.iommu = sysmmu;
+	child = &pmaster->dev;
+
+	while (child->parent && is_sysmmu(child->parent))
+		child = child->parent;
+
+	ret = device_move(child, sysmmu, DPM_ORDER_PARENT_BEFORE_DEV);
+	if (ret) {
+		dev_err(sysmmu, "Failed to set parent of %s\n",
+						dev_name(child));
+		goto err_dev_put;
+	}
+
+	if (!pmaster->dev.archdata.iommu) {
+		struct exynos_iommu_owner *owner;
+		owner = devm_kzalloc(sysmmu, sizeof(*owner), GFP_KERNEL);
+		if (!owner) {
+			ret = -ENOMEM;
+			dev_err(sysmmu, "Failed to allocate iommu data\n");
+			goto err_dev_put;
+		}
+
+		INIT_LIST_HEAD(&owner->client);
+		owner->dev = &pmaster->dev;
+		spin_lock_init(&owner->lock);
+
+		pmaster->dev.archdata.iommu = owner;
+	}
 
 	ret = __sysmmu_init_clock(sysmmu, drvdata, &pmaster->dev);
 	if (ret)
 		dev_err(sysmmu, "Failed to initialize gating clocks\n");
-
+	else
+		dev_dbg(sysmmu, "Assigned master device %s\n",
+						dev_name(&pmaster->dev));
+err_dev_put:
 	of_dev_put(pmaster);
 
 	return ret;
@@ -674,13 +816,13 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	if (!ret) {
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
-		INIT_LIST_HEAD(&data->node);
 
 		pm_runtime_enable(dev);
 
 		platform_set_drvdata(pdev, data);
 
-		dev_dbg(dev, "Initialized\n");
+		dev->archdata.iommu = &sysmmu_placeholder;
+		dev_dbg(dev, "Initialized successfully!\n");
 	}
 
 	return ret;
@@ -788,7 +930,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner, *n;
 	unsigned long flags;
 	int i;
 
@@ -796,9 +938,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, node) {
-		while (!exynos_sysmmu_disable(data->dev))
+	list_for_each_entry_safe(owner, n, &priv->clients, client) {
+		struct device *sysmmu;
+		while (!__exynos_sysmmu_disable(owner->dev))
 			; /* until System MMU is actually disabled */
+		list_del_init(&owner->client);
+
+		for_each_sysmmu(owner->dev, sysmmu)
+			pm_runtime_put(sysmmu);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -817,37 +964,68 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
 	int ret;
+	struct device *sysmmu;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0)
-		return ret;
+	if (WARN_ON(!list_empty(&owner->client))) {
+		bool found = false;
+		struct exynos_iommu_owner *tmpowner;
 
-	ret = 0;
+		spin_lock_irqsave(&priv->lock, flags);
+		list_for_each_entry(tmpowner, &priv->clients, client) {
+			if (tmpowner == owner) {
+				found = true;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&priv->lock, flags);
 
-	spin_lock_irqsave(&priv->lock, flags);
+		if (!found) {
+			dev_err(dev, "%s: Already attached to another domain\n",
+								__func__);
+			return -EBUSY;
+		}
 
-	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
+		dev_dbg(dev, "%s: Already attached to this domain\n", __func__);
+		return 0;
+	}
 
-	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
+	for_each_sysmmu(dev, sysmmu) {
+		ret = pm_runtime_get_sync(sysmmu);
+		if (ret < 0)
+			break;
 	}
 
+	if (ret < 0) {
+		struct device *start;
+		for_each_sysmmu_until(dev, start, sysmmu)
+			pm_runtime_put(start);
+
+		return ret;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+
+	/*
+	 * __exynos_sysmmu_enable() returns 1
+	 * if the System MMU of dev is already enabled
+	 */
+	BUG_ON(ret > 0);
+
+	list_add_tail(&owner->client, &priv->clients);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 	} else {
 		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
 					__func__, __pa(priv->pgtable));
@@ -859,39 +1037,33 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner, *n;
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct list_head *pos;
 	unsigned long flags;
-	bool found = false;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each(pos, &priv->clients) {
-		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
-			found = true;
+	list_for_each_entry_safe(owner, n, &priv->clients, client) {
+		if (owner == dev->archdata.iommu) {
+			if (__exynos_sysmmu_disable(dev))
+				list_del_init(&owner->client);
+			else
+				BUG();
 			break;
 		}
 	}
 
-	if (!found)
-		goto finish;
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (__exynos_sysmmu_disable(data)) {
+	if (owner == dev->archdata.iommu) {
+		struct device *sysmmu;
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		list_del_init(&data->node);
-
-	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
-					__func__, __pa(priv->pgtable));
-	}
-
-finish:
-	spin_unlock_irqrestore(&priv->lock, flags);
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 
-	if (found)
-		pm_runtime_put(data->sysmmu);
+	} else
+		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
@@ -1006,7 +1178,6 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					       unsigned long iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
 
@@ -1060,8 +1231,11 @@ done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+	{
+		struct exynos_iommu_owner *owner;
+		list_for_each_entry(owner, &priv->clients, client)
+			sysmmu_tlb_invalidate_entry(owner->dev, iova);
+	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 
-- 
1.8.0


