Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2LZBxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:53:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48023 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2LZBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:53:44 -0500
X-AuditID: cbfee61b-b7f616d00000319b-9e-50da58a77595
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
Subject: [PATCH v6 04/12] iommu/exynos: change rwlock to spinlock
Date: Wed, 26 Dec 2012 10:53:42 +0900
Message-id: <003701cde30b$d5754430$805fcc90$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC9VV+NlFvJ4iRgOn7s6N9B+qcA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zY93lEbcCDKa18Vlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs2L6RteCCYsXKJR3MDYx/pbsYOTkkBEwkfk78xQJh
	i0lcuLeerYuRi0NIYBmjxIPD09hhij6smsAEkZjOKLFv+31mCOcfo8TLmQvAqtgEtCRWzz3O
	CGKLCNwFSpznASliFvjLKPHpzCGgIg4OYQFHicsn60FqWARUJbqXPgNbzStgK/Hp/X5WCFtQ
	4sfke2BxZgEDifez+lghbHmJzWveMoOMkRBQl3j0VxdilZ7EvdV32CBKRCT2vXjHCDFeQOLb
	5EMsEOWyEpsOgJ0sITCZXWJ1cwcrxGOSEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525ihESN9A7GVQ0WhxgFOBiVeHg5f90MEGJNLCuuzD3EKMHB
	rCTC6/wRKMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5wIjOK4k3NDY2MTMxNTG3NDU3xSGs
	JM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoEx34WnS8T54Vzp7+H5j3LD4pLre89Er2takRWy
	98gvwXR35Ue5Drmlj88Uuxzc/KStMUOp6N7H/L4vDEkxpzOeNnIzaE47/q3Xaf3hyB0LXO3v
	Ne9rXeln0VsaoLX0mVPAl1rD69s3PAkMPGSfkH3B6rMsh1OAzMK4ooC4V6d8cr1sTFw6dyix
	FGckGmoxFxUnAgBv/BLExwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd3lEbcCDLZ2cFpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrNi+kbXggmLF
	yiUdzA2Mf6W7GDk5JARMJD6smsAEYYtJXLi3nq2LkYtDSGA6o8S+7feZIZx/jBIvZy5gB6li
	E9CSWD33OCOILSJwFyhxngekiFngL6PEpzOHgIo4OIQFHCUun6wHqWERUJXoXvqMBcTmFbCV
	+PR+PyuELSjxY/I9sDizgIHE+1l9rBC2vMTmNW+ZQcZICKhLPPqrC7FKT+Le6jtsECUiEvte
	vGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPymfQO
	xlUNFocYBTgYlXh4OX/dDBBiTSwrrsw9xCjBwawkwuv8ESjEm5JYWZValB9fVJqTWnyI0Qfo
	0YnMUqLJ+cB0kVcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD
	o9Z3f5e/TBnBXEfvaExrLnh7aXHdkYOmfjPDhQ0aUu4zvr2tN8P0zvufjlO3JUpE1+z7K3yH
	xVb0q9jLGw+Xrru29PP9WT2x0dONPS7ONtp+4cW7b0svCjxlFTj5OcLAd0Fv8nGmHw6R6X+T
	Xl7fJPqxPOrHwQDeiW8izm6awSQpHNfwcfHZZ2VKLMUZiYZazEXFiQDe6vv+9gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 58d2a24..5847508 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -166,7 +166,7 @@ struct sysmmu_drvdata {
 	void __iomem **sfrbases;
 	struct clk *clk[2];
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	unsigned long pgtable;
 };
@@ -249,7 +249,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	BUG_ON((base0 + size0) <= base0);
 	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (!is_sysmmu_active(data))
 		goto finish;
 
@@ -279,7 +279,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 		}
 	}
 finish:
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __show_fault_information(unsigned long *pgtable, unsigned long iova,
@@ -312,7 +312,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	int i, ret = -ENOSYS;
 
-	read_lock(&data->lock);
+	spin_lock(&data->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
@@ -354,7 +354,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	sysmmu_unblock(data->sfrbases[i]);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -365,7 +365,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled = false;
 	int i;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_inactive(data))
 		goto finish;
@@ -382,7 +382,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	data->pgtable = 0;
 	data->domain = NULL;
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
 		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
@@ -405,7 +405,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	int i, ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_active(data)) {
 		if (WARN_ON(pgtable != data->pgtable)) {
@@ -444,7 +444,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -491,7 +491,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -508,7 +508,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 			data->dbgname);
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
@@ -516,7 +516,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -532,7 +532,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			data->dbgname);
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
@@ -629,7 +629,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	}
 
 	data->sysmmu = dev;
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
 	if (dev->parent)
-- 
1.8.0


