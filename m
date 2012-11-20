Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2KTHah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:30:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43056 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KTHad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:33 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5c-50ab31976403
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v2 07/12] iommu/exynos: change rwlock to spinlock
Date: Tue, 20 Nov 2012 16:30:31 +0900
Message-id: <002101cdc6f0$ebcb43b0$c361cb10$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8OurnLtuWF4ITwa+8XYSwK/XGQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfd3phqsDDA78VbW4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpY3rmLqeC7asX6kzYNjDfluxg5OSQETCR6ex+yQNhi
	EhfurWfrYuTiEBJYxijR+6SfGabo7r8J7CC2kMAiRonVG4Ug7H+MEn961EBsNgEtidVzjzOC
	NIsI9DJKXOj/ygTiMAv8YJRY/OYN2CRhAUeJvq65rF2MHBwsAqoS3yZWgoR5BWwlXnQ8ZIOw
	BSV+TL4HdhEz0ND1O48zQdjyEpvXvGUGaZUQUJd49FcXJCwioCex/sYeNogSEYl9L94xgtgs
	AgIS3yYfYoEol5XYdIAZ5BoJgcnsEj+mdLNB/CUpcXDFDZYJjGKzkGyehWTzLCSbZyFZsYCR
	ZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGSMRI7WBc2WBxiFGAg1GJh/dhwqoAIdbEsuLK
	3EOMEhzMSiK8TeVAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4HRnNeSbyhsbGJmYmpibml
	qbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYwJFax7thr4e6YLMdlM0bL1+hvcEyDm
	PrF8N2PzN7Ptazc6yxy8VtYWMlf23jnFDU9eTk/4/N9Q8lTZxSkJj/YdMOo+v+pQnNfVzAd3
	V3t+dl/MKewffDux8M591dSnn5aEP59292DmE+GNlyT6eo1+ZkglfWtcceFvyYuMQ59SpZMv
	5sx+veStEktxRqKhFnNRcSIA2Y6LeMUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd3phqsDDBbPUbS4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWN65i6ngu2rF
	+pM2DYw35bsYOTkkBEwk7v6bwA5hi0lcuLeeDcQWEljEKLF6oxCE/Y9R4k+PGojNJqAlsXru
	ccYuRi4OEYFeRokL/V+ZQBxmgR+MEovfvGEGqRIWcJTo65rL2sXIwcEioCrxbWIlSJhXwFbi
	RcdDNghbUOLH5HssIDYz0ND1O48zQdjyEpvXvGUGaZUQUJd49FcXJCwioCex/sYeNogSEYl9
	L94xTmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx+Exq
	B+PKBotDjAIcjEo8vA8TVgUIsSaWFVfmHmKU4GBWEuFtKgcK8aYkVlalFuXHF5XmpBYfYvQB
	+nMis5Rocj4wVeSVxBsam5gZWRqZWRiZmJvjEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnV
	wNjzasmSZWK5W0J6uH24A1+fPPeq016eU3nvNxP1WRW/r1dU7gxvu3faySzkm6LXGX8rv2kz
	PQ++0DA4M5XV7jNLVu99yxW7VnxTXrTfjHnvzx+vqjaznheSlonuZ2V27jq4fIF1/uxpk9c0
	da78l8sklBax8AdftPL3txOz80XD1c7MPjRhipwSS3FGoqEWc1FxIgBmQQJy9AIAAA==
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
index 0191ab5..bab1bf8 100644
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
@@ -754,7 +754,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
 		data->sysmmu = dev;
-		rwlock_init(&data->lock);
+		spin_lock_init(&data->lock);
 		INIT_LIST_HEAD(&data->node);
 
 		__set_fault_handler(data, &default_fault_handler);
-- 
1.8.0


