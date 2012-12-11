Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2LKLJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:09:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43017 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2LKLJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:09:11 -0500
X-AuditID: cbfee61b-b7f616d00000319b-23-50c714569163
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
Subject: [PATCH v5 04/14] iommu/exynos: change rwlock to spinlock
Date: Tue, 11 Dec 2012 20:09:09 +0900
Message-id: <003401cdd78f$f1d2c670$d5785350$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjHFq7K3FszdQSaKgKZFLNcNd9wAA3jBA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ90wkeMBBktfSVhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs2L6RteCCYsXKJR3MDYx/pbsYOTkkBEwkfh56xAph
	i0lcuLeerYuRi0NIYBmjxN/NM1lgivbf+sQOYgsJLGKUuP66FKLoH6PEho3TmUASbAJaEqvn
	HmcEsUUE7jJKvDzPA1LELHCESWLn/XNgk4QFHCWO/z7ODGKzCKhKvN8JMZVXwFZi2vk9zBC2
	oMSPyffA6pmBhq7feZwJwpaX2LzmLVANB9BF6hKP/upC7DKSmHT1PjNEiYjEvhfvGCHGC0h8
	m3yIBaJcVmLTAWaQcyQE+tklXuzcywTxmKTEwRU3WCYwis1CsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxghUSO9g3FVg8UhRgEORiUeXg2tYwFCrIllxZW5hxgl
	OJiVRHgjhY4HCPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MKLzSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamDcHGppvt6sSM/oz6frmZk+c5pZDz32/+Nw
	7m+eqN/9iPIGl5Oad59JRP16p/7Ja9rawJZdHj82tk1JkI5f3XD3Ut6l9tffHlRue3z7zlIz
	kwbD/g/JzzfUTFLndJsnWOR0OPRl8inTprzXvLoRFmURkreX885/mVx9nN93w+fL3+L/fipU
	2WukxFKckWioxVxUnAgA/BiSs8cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd0wkeMBBgfvCFpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrNi+kbXggmLF
	yiUdzA2Mf6W7GDk5JARMJPbf+sQOYYtJXLi3ng3EFhJYxChx/XVpFyMXkP2PUWLDxulMIAk2
	AS2J1XOPM4LYIgJ3GSVenucBKWIWOMIksfP+ORaQhLCAo8Tx38eZQWwWAVWJ9zshNvAK2EpM
	O7+HGcIWlPgx+R5YPTPQ0PU7jzNB2PISm9e8BarhALpIXeLRX12IXUYSk67eZ4YoEZHY9+Id
	4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREck8+kdzCu
	arA4xCjAwajEw6uhdSxAiDWxrLgy9xCjBAezkghvpNDxACHelMTKqtSi/Pii0pzU4kOMPkCP
	TmSWEk3OB6aLvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoY
	G5N3/XXfxm/T2lUx4RRjQ0NMm7b661Rh9b7fAR7Jx71u+X960fLFfSfrsv08iqeD5Yv1jS6c
	Txe+nzZ9XkH5/5eXrqyX2+q6umzm7haP9X8D79mtjmBTrOzeGVdh0yPqXKP3ul/mUx770Td3
	7D6rmf4VPZ+18OfUhOAnjye5fH28l7VF36xMiaU4I9FQi7moOBEAqT63RfYCAAA=
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


