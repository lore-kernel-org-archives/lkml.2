Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2KUFGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:06:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2KUFGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:06:17 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-0a-50ac6148defc
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 07/12] iommu/exynos: change rwlock to spinlock
Date: Wed, 21 Nov 2012 14:06:15 +0900
Message-id: <002e01cdc7a5$ef301750$cd9045f0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Hpe8P22nb1/mmSamK/GPzUcRKgQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI12PxDUBBgfuCVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8nPiIqWCtWsXC3TcYGxh7FLoYOTkkBEwkls+YyAZh
	i0lcuLceyObiEBJYxigx69pVRpiio1vnsEAkpjNK9F39wQjh/GOUePF/NxNIFZuAlsTqucfB
	EiICvYwSF/q/MoE4zAI/GCUWv3nDDFIlLOAo0bVoL9hCFgFVic7tF8BsXgFbibU981ghbEGJ
	H5PvsYDYzEBT1+88zgRhy0tsXvMWaA4H0E3qEo/+6oKERQT0JGZPb2SEKBGR2PfiHSPEeAGJ
	b5MPsUCUy0psOsAMco6EwGR2iaN3ZkD9LClxcMUNlgmMYrOQbJ6FZPMsJJtnIVmxgJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZI5EjtYFzZYHGIUYCDUYmHd+Pa1QFCrIllxZW5hxgl
	OJiVRHgZ5NcECPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MKrzSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamCMKxcTW8Kx8JqCwvSXfwNLNs7sdDnqEPMu
	vVXLWvnd22u77wg0LrnTPG3blT2VdiyVW09+vnkpf2P59aBoi6SA6s3THz3oPVWy6c7jyHST
	JUZVMptPphmpPVoXfjH8/gxu13X3mpcv/Dj9yduj87aIn7KwlyuvinaLKZ7W63I11OvqxONs
	YiXnlViKMxINtZiLihMBG4P2l8kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQV2PxDUBBn8W8Vpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvJz4iKlgrVrF
	wt03GBsYexS6GDk5JARMJI5uncMCYYtJXLi3nq2LkYtDSGA6o0Tf1R+MEM4/RokX/3czgVSx
	CWhJrJ57HCwhItDLKHGh/ysTiMMs8INRYvGbN8wgVcICjhJdi/aygdgsAqoSndsvgNm8ArYS
	a3vmsULYghI/Jt8D280MNHX9zuNMELa8xOY1b4HmcADdpC7x6K8uSFhEQE9i9vRGRogSEYl9
	L94xTmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx+Uxq
	B+PKBotDjAIcjEo8vBvXrg4QYk0sK67MPcQowcGsJMLLIL8mQIg3JbGyKrUoP76oNCe1+BCj
	D9CjE5mlRJPzgSkjryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5O
	qQbGAE8GkdhtGelWc83XbWLP8jiq8WzrspNSrp7H7r+Xdt5/6Ayf6tZKT9FjP5q02QRLf1ub
	Z9acsJqSFa084/HjgxtE8hR77W/9NZ/AKcD3722dzgyFDI3bO3Sqc5uLZSwVjnaciZp7g/WA
	drd+GkuZ5FNL/j6/iNUnlv/bceBj+WKeBwaf3l5QYinOSDTUYi4qTgQAqCundvgCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Change-Id: Ia3365ccec0744e735b71f0389e5c56a0243bcd2c
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


