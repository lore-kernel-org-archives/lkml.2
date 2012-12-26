Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2LZByX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:54:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37959 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2LZByR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:17 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-97-50da58c8df68
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
Subject: [PATCH v6 09/12] iommu/exynos: add support for System MMU 3.2 and 3.3
Date: Wed, 26 Dec 2012 10:54:15 +0900
Message-id: <003c01cde30b$e8ff6710$bafe3530$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC+jEnbY01r0KS2uWelf+JlQU2w==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA90TEbcCDCafY7e4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYd+YqU8GUkoq2R3vZGhg/RHcxcnJICJhIvFpyiw3C
	FpO4cG89kM3FISSwjFHixLbnzDBFR9cvZwKxhQQWMUps2iULUfSPUeLOg1esIAk2AS2J1XOP
	M4LYIgJ3GSVenucBKWIW+Mso8enMIXaQhLCAn8Sxw/fAprIIqEpcX3qaBcTmFbCV+PxnCxOE
	LSjxY/I9sDizgIHE+1l9rBC2vMTmNW+BejmALlKXePRXF8QUEdCTmNwFVS0ise/FO0aI6QIS
	3yYfYoGolpXYdIAZ5BoJgcnsErM2nWeB+EtS4uCKGywTGMVmIVk8C8niWUgWz0KyYgEjyypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2MkJiR2sG4ssHiEKMAB6MSD+/G7zcDhFgTy4orcw8x
	SnAwK4nwOn8ECvGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MJ7zSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamA0t2zdJ5gpllOSzCP47rWc11vTc4tPCq+5
	J/+r60Pht2wz6ZapZ/8eaHTa4nSmKNT/w+osa+2WwF/FL/kWzhNcsvzz+2OrvjaHijqLJMil
	z+W22ia8f68C4+mFJ3Z63zN1/MPSb796Cqvki4Xq56tuH3otZnW/fndqieynjksuxsaS8uc3
	/LqrxFKckWioxVxUnAgALQE14MYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd3jEbcCDGZ9trG4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2HfmKlPBlJKK
	tkd72RoYP0R3MXJySAiYSBxdv5wJwhaTuHBvPRuILSSwiFFi0y7ZLkYuIPsfo8SdB69YQRJs
	AloSq+ceZwSxRQTuMkq8PM8DUsQs8JdR4tOZQ+wgCWEBP4ljh+8xg9gsAqoS15eeZgGxeQVs
	JT7/2cIEYQtK/Jh8DyzOLGAg8X5WHyuELS+xec1boF4OoIvUJR791QUxRQT0JCZ3QVWLSOx7
	8Y5xAqPALCSDZiEZNAvJoFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7IZ1I7
	GFc2WBxiFOBgVOLh3fj9ZoAQa2JZcWXuIUYJDmYlEV7nj0Ah3pTEyqrUovz4otKc1OJDjD5A
	f05klhJNzgcmi7ySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUa
	GCsXJG74fnrPZ+/glskSpT3zzGKeOE1dIFwtvF43/b9jnXPthdXqfFGaDedYPi0397/7P14i
	Z0nc/628Z0xDZXQlGUQO2TBd+b6jKM9wZ2Dy9PktTfej13rMWZosO0/6fPrm3dM2NvTkbuZJ
	Xu6pcPzNlEmSZyapCHHVTD2872TZ+/hv3D57vyqxFGckGmoxFxUnAgDPOUbc9QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since System MMU 3.2 and 3.3 have more prefetch buffers than 2, the
existing function to set prefetch buffers, exynos_sysmmu_set_prefbuf()
is not able to support them.
This commit removes exynos_sysmmu_set_prefbuf() and introduces new
interface, exynos_sysmmu_set_pbuf() that can pass information of
more buffers than 2. It is safe to remove the existing function
because there is no device driver in the kernel yet that calls the
removed function.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 370 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 322 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c3c5b7b..a558c51 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -80,6 +80,14 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_LRU		0x1
+#define CFG_QOS(n)	((n & 0xF) << 7)
+#define CFG_MASK	0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
+#define CFG_ACGEN	(1 << 24) /* System MMU 3.3 only */
+#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
+#define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
+#define CFG_SHAREABLE	(1 << 12) /* System MMU 3.x only */
+
 #define REG_MMU_CTRL		0x000
 #define REG_MMU_CFG		0x004
 #define REG_MMU_STATUS		0x008
@@ -88,6 +96,10 @@
 #define REG_PT_BASE_ADDR	0x014
 #define REG_INT_STATUS		0x018
 #define REG_INT_CLEAR		0x01C
+#define REG_PB_INFO		0x400
+#define REG_PB_LMM		0x404
+#define REG_PB_INDICATE		0x408
+#define REG_PB_CFG		0x40C
 
 #define REG_PAGE_FAULT_ADDR	0x024
 #define REG_AW_FAULT_ADDR	0x028
@@ -96,10 +108,12 @@
 
 #define REG_MMU_VERSION		0x034
 
-#define REG_PB0_SADDR		0x04C
-#define REG_PB0_EADDR		0x050
-#define REG_PB1_SADDR		0x054
-#define REG_PB1_EADDR		0x058
+#define MMU_MAJ_VER(reg)	(reg >> 28)
+#define MMU_MIN_VER(reg)	((reg >> 21) & 0x7F)
+
+#define MAX_NUM_PBUF		6
+
+#define NUM_MINOR_OF_SYSMMU_V3	4
 
 static void *sysmmu_placeholder; /* Inidcate if a device is System MMU */
 
@@ -178,6 +192,19 @@ struct exynos_iommu_owner {
 	spinlock_t lock;	/* Lock to preserve consistency of System MMU */
 };
 
+#define SYSMMU_PBUFCFG_TLB_UPDATE	(1 << 16)
+#define SYSMMU_PBUFCFG_ASCENDING	(1 << 12)
+#define SYSMMU_PBUFCFG_DSECENDING	(0 << 12) /* default */
+#define SYSMMU_PBUFCFG_PREFETCH		(1 << 8)
+#define SYSMMU_PBUFCFG_WRITE		(1 << 4)
+#define SYSMMU_PBUFCFG_READ		(0 << 4) /* default */
+
+struct sysmmu_prefbuf {
+	unsigned long base;
+	unsigned long size;
+	unsigned long config;
+};
+
 struct sysmmu_drvdata {
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *master;	/* Client device that needs System MMU */
@@ -185,6 +212,8 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	int activations;
 	spinlock_t lock;
+	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
+	int num_pbufs;
 	struct iommu_domain *domain;
 	unsigned long pgtable;
 	bool runtime_active;
@@ -210,6 +239,21 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
 	return data->activations > 0;
 }
 
+static unsigned int __sysmmu_version(struct sysmmu_drvdata *drvdata,
+					int idx, unsigned int *minor)
+{
+	unsigned int major;
+
+	major = readl(drvdata->sfrbases[idx] + REG_MMU_VERSION);
+
+	if (minor)
+		*minor = MMU_MIN_VER(major);
+
+	major = MMU_MAJ_VER(major);
+
+	return major;
+}
+
 static void sysmmu_unblock(void __iomem *sfrbase)
 {
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
@@ -245,32 +289,235 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 				       unsigned long pgd)
 {
-	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
+static void __sysmmu_set_prefbuf(void __iomem *pbufbase, unsigned long base,
+					unsigned long size, int idx)
+{
+	__raw_writel(base, pbufbase + idx * 8);
+	__raw_writel(size - 1 + base,  pbufbase + 4 + idx * 8);
+}
+
+/*
+ * Offset of prefetch buffer setting registers are different
+ * between SysMMU 3.1 and 3.2. 3.3 has a single prefetch buffer setting.
+ */
+static unsigned short
+	pbuf_offset[NUM_MINOR_OF_SYSMMU_V3] = {0x04C, 0x04C, 0x070, 0x410};
+
+/**
+ * __sysmmu_sort_prefbuf - sort the given @prefbuf in descending order.
+ * @prefbuf: array of buffer information
+ * @nbufs: number of elements of @prefbuf
+ * @check_size: whether to compare buffer sizes. See below description.
+ *
+ * return value is valid if @check_size is true. If the size of first buffer
+ * in @prefbuf is larger than or equal to the sum of the sizes of the other
+ * buffers, returns 1. If the size of the first buffer is smaller than the
+ * sum of other sizes, returns -1. Returns 0, otherwise.
+ */
+static int __sysmmu_sort_prefbuf(struct sysmmu_prefbuf prefbuf[],
+						int nbufs, bool check_size)
+{
+	int i;
+
+	for (i = 0; i < nbufs; i++) {
+		int j;
+		for (j = i + 1; j < nbufs; j++)
+			if (prefbuf[i].size < prefbuf[j].size)
+				swap(prefbuf[i], prefbuf[j]);
+	}
+
+	if (check_size) {
+		unsigned long sum = 0;
+		for (i = 1; i < nbufs; i++)
+			sum += prefbuf[i].size;
+
+		if (prefbuf[0].size < sum)
+			i = -1;
+		else if (prefbuf[0].size >= (sum * 2))
+			i = 1;
+		else
+			i = 0;
+	}
+
+	return i;
+}
+
+static void __exynos_sysmmu_set_pbuf_ver31(struct sysmmu_drvdata *data,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	unsigned long cfg =
+		__raw_readl(data->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	if (nbufs > 1) {
+		unsigned long base = prefbuf[1].base;
+		unsigned long end = prefbuf[1].base + prefbuf[1].size;
+
+		/* merging buffers from the second to the last */
+		while (nbufs-- > 2) {
+			base = min(base, prefbuf[nbufs - 1].base);
+			end = max(end, prefbuf[nbufs - 1].base +
+					prefbuf[nbufs - 1].size);
+		}
+
+		/* Separate PB mode */
+		cfg |= 2 << 28;
+
+		__sysmmu_set_prefbuf(data->sfrbases[idx] + pbuf_offset[1],
+					base, end - base, 1);
+
+		data->num_pbufs = 2;
+		data->pbufs[0] = prefbuf[0];
+		data->pbufs[1] = prefbuf[1];
+
+	} else {
+		/* Combined PB mode */
+		cfg |= 3 << 28;
+		data->num_pbufs = 1;
+		data->pbufs[0] = prefbuf[0];
+	}
+
+	__raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
+
+	__sysmmu_set_prefbuf(data->sfrbases[idx] + pbuf_offset[1],
+				prefbuf[0].base, prefbuf[0].size, 0);
+}
+
+static void __exynos_sysmmu_set_pbuf_ver32(struct sysmmu_drvdata *data,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	int i;
+	unsigned long cfg =
+		__raw_readl(data->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	cfg |= 7 << 16; /* enabling PB0 ~ PB2 */
+
+	/* This is common to all cases below */
+	data->pbufs[0] = prefbuf[0];
+
+	switch (nbufs) {
+	case 1:
+		/* Combined PB mode (0 ~ 2) */
+		cfg |= 1 << 19;
+		data->num_pbufs = 1;
+		break;
+	case 2:
+		/* Combined PB mode (0 ~ 1) */
+		cfg |= 1 << 21;
+		data->num_pbufs = 2;
+		data->pbufs[1] = prefbuf[1];
+		break;
+	case 3:
+		data->num_pbufs = 3;
+		data->pbufs[1] = prefbuf[1];
+		data->pbufs[2] = prefbuf[2];
+
+		__sysmmu_sort_prefbuf(data->pbufs, 3, false);
+		swap(data->pbufs[0], data->pbufs[2]);
+
+		break;
+	default:
+		data->pbufs[2].base = prefbuf[2].base;
+		/* data->size is used for end address temporarily */
+		data->pbufs[2].size = prefbuf[2].base + prefbuf[2].size;
+
+		/* Merging all buffers from the third to the last */
+		while (nbufs-- > 3) {
+			data->pbufs[2].base = min(data->pbufs[2].base,
+						prefbuf[nbufs - 1].base);
+			data->pbufs[2].size = max(data->pbufs[2].size,
+						prefbuf[nbufs - 1].base +
+						prefbuf[nbufs - 1].size);
+		}
+
+		data->num_pbufs = 3;
+		data->pbufs[1] = prefbuf[1];
+		data->pbufs[2].size = data->pbufs[2].size -
+					data->pbufs[2].base;
+	}
+
+	for (i = 0; i < data->num_pbufs; i++)
+		__sysmmu_set_prefbuf(data->sfrbases[idx] + pbuf_offset[2],
+			data->pbufs[i].base, data->pbufs[i].size, i);
+
+	__raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
+}
+
+static void __exynos_sysmmu_set_pbuf_ver33(struct sysmmu_drvdata *data,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
 {
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
+	static char pbcfg[6][6] = {
+		{7, 7, 7, 7, 7, 7}, {7, 7, 7, 7, 7, 7}, {2, 2, 3, 7, 7, 7},
+		{1, 2, 3, 4, 7, 7}, {7, 7, 7, 7, 7, 7}, {2, 2, 3, 4, 5, 6}
+		};
+	int pbselect;
+	int cmp, i;
+	long num_pb = __raw_readl(data->sfrbases[idx] + REG_PB_INFO) & 0xFF;
+
+	if (nbufs > num_pb)
+		nbufs = num_pb; /* ignoring the rest of buffers */
+
+	for (i = 0; i < nbufs; i++)
+		data->pbufs[i] = prefbuf[i];
+	data->num_pbufs = nbufs;
+
+	cmp = __sysmmu_sort_prefbuf(data->pbufs, nbufs, true);
+
+	pbselect = num_pb - nbufs;
+	if (num_pb == 6) {
+		if ((nbufs == 3) && (cmp == 1))
+			pbselect = 4;
+		else if (nbufs < 3)
+			pbselect = 5;
+	} else if ((num_pb == 3) && (nbufs < 3)) {
+			pbselect = 1;
+	}
+
+	__raw_writel(pbselect, data->sfrbases[idx] + REG_PB_LMM);
+
+	/* Configure prefech buffers */
+	for (i = 0; i < nbufs; i++) {
+		__raw_writel(i, data->sfrbases[idx] + REG_PB_INDICATE);
+		__raw_writel(data->pbufs[i].config | 1,
+				data->sfrbases[idx] + REG_PB_CFG);
+		__sysmmu_set_prefbuf(data->sfrbases[idx] + pbuf_offset[3],
+			data->pbufs[i].base, data->pbufs[i].size, 0);
+	}
+
+	/* Disable prefetch buffers that is not set */
+	for (cmp = pbcfg[num_pb - 1][nbufs - 1] - nbufs; cmp > 0; cmp--) {
+		__raw_writel(cmp + nbufs - 1,
+				data->sfrbases[idx] + REG_PB_INDICATE);
+		__raw_writel(0, data->sfrbases[idx] + REG_PB_CFG);
+	}
 }
 
-void exynos_sysmmu_set_prefbuf(struct device *dev,
-				unsigned long base0, unsigned long size0,
-				unsigned long base1, unsigned long size1)
+static void (*func_set_pbuf[NUM_MINOR_OF_SYSMMU_V3])
+	(struct sysmmu_drvdata *, int, int, struct sysmmu_prefbuf []) = {
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver32,
+		__exynos_sysmmu_set_pbuf_ver33,
+};
+
+void exynos_sysmmu_set_pbuf(struct device *dev, int nbufs,
+				struct sysmmu_prefbuf prefbuf[])
 {
 	struct device *sysmmu;
+	int nsfrs;
+
+	if (WARN_ON(nbufs < 1))
+		return;
 
 	for_each_sysmmu(dev, sysmmu) {
-		int i;
 		unsigned long flags;
-		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+		struct sysmmu_drvdata *data;
 
-		BUG_ON((base0 + size0) <= base0);
-		BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
+		data = dev_get_drvdata(sysmmu);
 
 		spin_lock_irqsave(&data->lock, flags);
 		if (!is_sysmmu_active(data)) {
@@ -278,33 +525,35 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 			continue;
 		}
 
-		for (i = 0; i < data->nsfrs; i++) {
-			if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28)
-									== 3) {
-				if (!sysmmu_block(data->sfrbases[i]))
-					continue;
-
-				if (size1 == 0) {
-					if (size0 <= SZ_128K) {
-						base1 = base0;
-						size1 = size0;
-					} else {
-						size1 = size0 -
-						ALIGN(size0 / 2, SZ_64K);
-						size0 = size0 - size1;
-						base1 = base0 + size0;
-					}
-				}
+		for (nsfrs = 0; nsfrs < data->nsfrs; nsfrs++) {
+			unsigned int maj, min;
 
-				__sysmmu_set_prefbuf(
-					data->sfrbases[i], base0, size0, 0);
-				__sysmmu_set_prefbuf(
-					data->sfrbases[i], base1, size1, 1);
+			maj = __sysmmu_version(data, nsfrs, &min);
 
+			BUG_ON(min > 3);
+
+			if (sysmmu_block(data->sfrbases[nsfrs])) {
+				func_set_pbuf[min](data, nsfrs,
+							nbufs, prefbuf);
+				sysmmu_unblock(data->sfrbases[nsfrs]);
+			}
+		} /* while (nsfrs < data->nsfrs) */
+		spin_unlock_irqrestore(&data->lock, flags);
+	}
+}
+
+static void __sysmmu_restore_state(struct sysmmu_drvdata *data)
+{
+	int i, min;
+
+	for (i = 0; i < data->nsfrs; i++) {
+		if (__sysmmu_version(data, i, &min) == 3) {
+			if (sysmmu_block(data->sfrbases[i])) {
+				func_set_pbuf[min](data, i,
+					data->num_pbufs, data->pbufs);
 				sysmmu_unblock(data->sfrbases[i]);
 			}
 		}
-		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -424,6 +673,32 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	return disabled;
 }
 
+static void __sysmmu_init_config(struct sysmmu_drvdata *data, int idx)
+{
+	unsigned long cfg = CFG_LRU | CFG_QOS(15);
+	int maj, min = 0;
+
+	maj = __sysmmu_version(data, idx, &min);
+	if ((maj == 1) || (maj == 2))
+		goto set_cfg;
+
+	BUG_ON(maj != 3);
+
+	cfg |= CFG_SHAREABLE;
+	if (min < 2)
+		goto set_cfg;
+
+	BUG_ON(min > 3);
+
+	cfg |= CFG_FLPDCACHE;
+	cfg |= (min == 2) ? CFG_SYSSEL : CFG_ACGEN;
+
+	func_set_pbuf[min](data, idx, data->num_pbufs, data->pbufs);
+set_cfg:
+	cfg |= __raw_readl(data->sfrbases[idx] + REG_MMU_CFG) & ~CFG_MASK;
+	__raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
+}
+
 static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 {
 	int i;
@@ -431,18 +706,12 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 	clk_enable(data->clk);
 
 	for (i = 0; i < data->nsfrs; i++) {
-		unsigned long cfg = 1;
+		BUG_ON(__raw_readl(data->sfrbases[i] + REG_MMU_CTRL)
+								& CTRL_ENABLE);
 
-		__sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			cfg |= (1 << 12) | (2 << 28);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
-		}
+		__sysmmu_init_config(data, i);
 
-		__raw_writel(cfg, data->sfrbases[i] + REG_MMU_CFG);
+		__sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
 
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
@@ -666,6 +935,10 @@ static int __init __sysmmu_setup(struct device *sysmmu,
 	u32 master_inst_no = -1;
 	int ret;
 
+	drvdata->pbufs[0].base = 0;
+	drvdata->pbufs[0].size = ~0;
+	drvdata->num_pbufs = 1;
+
 	master_node = of_parse_phandle(sysmmu->of_node, "mmu-master", 0);
 	if (!master_node && !of_property_read_string(
 			sysmmu->of_node, "mmu-master-compat", &compat)) {
@@ -818,6 +1091,7 @@ static int sysmmu_resume(struct device *dev)
 	if (is_sysmmu_active(drvdata) &&
 		(!pm_runtime_enabled(dev) || drvdata->runtime_active)) {
 		__sysmmu_enable_nocount(drvdata);
+		__sysmmu_restore_state(drvdata);
 	}
 	spin_unlock_irqrestore(&drvdata->lock, flags);
 	return 0;
-- 
1.8.0


