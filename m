Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2KVTps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:45:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2KVTpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:45:44 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-0a-50ae0d82e6f0
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
Date: Thu, 22 Nov 2012 20:33:21 +0900
Message-id: <002801cdc8a5$2d68bbd0$883a3370$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpS1JCVrvc+Q4QlOeIKUxzXb2vw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zY90m3nUBBpOXS1hc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcP3uVpeC7asXhrsdMDYw35bsYOTkkBEwk7h1+xgRh
	i0lcuLeerYuRi0NIYBmjxLYlfewwRev7ZjJCJBYxSjS/vAbl/GOU6Ju+jgWkik1AS2L13ONg
	CRGBXkaJC/1fmUAcZoEfjBLTN/8CqxIWcJT4vbIVyObgYBFQlZj5tQgkzCtgK7H9yW92CFtQ
	4sfke2DlzEBD1+88zgRhy0tsXvOWGaRVQkBd4tFfXZCwiICexLsPe1khSkQk9r14xwhiswgI
	SHybfIgFolxWYtMBZpBrJAQms0scnP6HBeIzSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYoFjCyr
	GEVTC5ILipPScw31ihNzi0vz0vWS83M3MULiRmoH48oGi0OMAhyMSjy8ms5rA4RYE8uKK3MP
	MUpwMCuJ8N7jXhcgxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAmM4riTc0NjYxMzE1Mbc0
	NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgZHphWXp+QLG5g2RGy8fuF/HfD6rZuOi
	U4pRRSsnBE5JVv7Eumd1TQizusxPftGVca0xG1tY7a8VBfMlXj3w0Unk3Nftq67cajCSbZmy
	9H2fXORdo6+7/9++JxeiHS3mtumZ6eb8T6r32wWn7NF7J60lNauRaVrcx87klBfn2yrd9i77
	lL8ix1eJpTgj0VCLuag4EQD3Z1dtyAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd0m3nUBBjd3CVhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHD97laXgu2rF
	4a7HTA2MN+W7GDk5JARMJNb3zWSEsMUkLtxbz9bFyMUhJLCIUaL55TVGCOcfo0Tf9HUsIFVs
	AloSq+ceB0uICPQySlzo/8oE4jAL/GCUmL75F1iVsICjxO+VrUA2BweLgKrEzK9FIGFeAVuJ
	7U9+s0PYghI/Jt8DK2cGGrp+53EmCFteYvOat8wgrRIC6hKP/uqChEUE9CTefdjLClEiIrHv
	xTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgqn0nt
	YFzZYHGIUYCDUYmHV9N5bYAQa2JZcWXuIUYJDmYlEd573OsChHhTEiurUovy44tKc1KLDzH6
	AP05kVlKNDkfmDDySuINjU3MjCyNzCyMTMzNcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCU
	amDcbO7edb/cTZ+7LoEvZOPyzqmzA/2OpDmuPdpUmvlnv+G0bcX2q57JX+/YfKz0hc+m62Gx
	7EmpL3QC/i6I3/3ykPmptY/rezZMNA60b8mf8jaa2ziW2fXWMbE6iTtKoYcDOzbvPXg7nqFK
	rfLPn9V3D541lFS7KfaxR3QD833mVckPbaS1fHuVWIozEg21mIuKEwHasZKk9wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0bb194e..e39ddac 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -184,7 +184,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	int activations;
 	struct sysmmu_version ver;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
@@ -288,7 +288,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	BUG_ON((base0 + size0) <= base0);
 	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (!is_sysmmu_active(data))
 		goto finish;
 
@@ -318,7 +318,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 		}
 	}
 finish:
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __set_fault_handler(struct sysmmu_drvdata *data,
@@ -326,9 +326,9 @@ static void __set_fault_handler(struct sysmmu_drvdata *data,
 {
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	data->fault_handler = handler;
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_set_fault_handler(struct device *dev,
@@ -376,7 +376,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	int i, ret = -ENOSYS;
 
-	read_lock(&data->lock);
+	spin_lock(&data->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
@@ -420,7 +420,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -431,7 +431,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled = false;
 	int i;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_inactive(data))
 		goto finish;
@@ -446,7 +446,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	data->pgtable = 0;
 	data->domain = NULL;
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
 		dev_dbg(data->sysmmu, "Disabled\n");
@@ -469,7 +469,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	int i, ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_active(data)) {
 		if (WARN_ON(pgtable != data->pgtable)) {
@@ -506,7 +506,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -553,7 +553,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -569,7 +569,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 			"Disabled. Skipping invalidating TLB.\n");
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
@@ -577,7 +577,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -592,7 +592,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			"Disabled. Skipping invalidating TLB.\n");
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int __init __sysmmu_init_clock(struct device *sysmmu,
@@ -748,7 +748,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
 		data->sysmmu = dev;
-		rwlock_init(&data->lock);
+		spin_lock_init(&data->lock);
 		INIT_LIST_HEAD(&data->node);
 
 		__set_fault_handler(data, &default_fault_handler);
-- 
1.8.0


