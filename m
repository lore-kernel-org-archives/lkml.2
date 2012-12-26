Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2LZByj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:54:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:38009 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2LZByd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:33 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e8-50da58d8489e
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
Subject: [PATCH v6 12/12] iommu/exynos: add debugfs entries for System MMU
Date: Wed, 26 Dec 2012 10:54:31 +0900
Message-id: <003f01cde30b$f2891d30$d79b5790$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC/JrLVK7dlFyQHa9LNuMl45Zcw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY90bEbcCDO5e5ra4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4+eoqW0GvfcW2a08YGxj/GXcxcnBICJhILF5f0sXI
	CWSKSVy4t56ti5GLQ0hgGaPEnU9b2CESJhKPJuxhArGFBBYxSnzaagtR9I9RouX+FhaQBJuA
	lsTquccZQWwRgbuMEi/P84AUMQv8BWo4c4gdZJuwgJfEnn8mICaLgKrEzw9GIOW8ArYS+55f
	ZIewBSV+TL4HNpJZwEDi/aw+VghbXmLzmrfMEDerSzz6qwuxSU/iR+9NZogSEYl9L96BXcAi
	ICDxbfIhFohyWYlNB5hBjpEQmMwu0d98lRHiLUmJgytusExgFJuFZPMsJJtnIdk8C8mKBYws
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzFC4kVqB+PKBotDjAIcjEo8vBu/3wwQYk0sK67M
	PcQowcGsJMLr/BEoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAWM4riTc0NjYxMzE1Mbc0
	NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgdFFS4o5Y2fldkPhCX3Of7xelDrtFitU
	fleoPDv3UaPNq2aTvWvd3/S1Td+fOcFi1p0Qo+k9/Ac35fG18L81ShNWOXGz4Ym+TlmIsekF
	meef7pzLzK9REDiSqJk0dZeNytOFHe/qn+V0/Iure+vy4+7cTBfn//HM19yOBF1fsFKwLOXi
	3HdHPyqxFGckGmoxFxUnAgAx2eQgxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd0bEbcCDA5sZrW4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuPnqKltBr33F
	tmtPGBsY/xl3MXJySAiYSDyasIcJwhaTuHBvPRuILSSwiFHi01bbLkYuIPsfo0TL/S0sIAk2
	AS2J1XOPM4LYIgJ3GSVenucBKWIW+AvUcOYQexcjB4ewgJfEnn8mICaLgKrEzw9GIOW8ArYS
	+55fZIewBSV+TL4HNpJZwEDi/aw+VghbXmLzmrfMIK0SAuoSj/7qQmzSk/jRe5MZokREYt+L
	d4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDw+k9rB
	uLLB4hCjAAejEg/vxu83A4RYE8uKK3MPMUpwMCuJ8Dp/BArxpiRWVqUW5ccXleakFh9i9AH6
	cyKzlGhyPjBV5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXA
	uCrq5uOJeecN/t5xnJi8YBEv97Yp2/Iu/XlikLZ/7Y7HnOedbJZ83qGnUFDbMWFzYqnevfeW
	Wi9ezFcxWbu6cdLR6JAVTPevhsh8vz2Dp1chPXuCVVr//FVVX2W3niu+9DKNVy80++eT85ER
	R5mdPuiIyF+qn/Li9bUP4vFnn9k3hiy3tWIJ+aLEUpyRaKjFXFScCACAmkbh9AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds debugfs directory and nodes for inspecting internal
state of System MMU.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 204 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 198 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9753e0e..78c0eb7 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,12 +26,17 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 #include <linux/string.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
 #include <asm/cacheflush.h>
 
+#define MODULE_NAME "exynos-sysmmu"
+
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
@@ -223,6 +228,7 @@ struct sysmmu_drvdata {
 	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
 	int num_pbufs;
 	struct sysmmu_version ver;
+	struct dentry *debugfs_root;
 	struct iommu_domain *domain;
 	unsigned long pgtable;
 	bool runtime_active;
@@ -1066,6 +1072,8 @@ static void __init __sysmmu_init_mmuname(struct device *sysmmu,
 	}
 }
 
+static void __create_debugfs_entry(struct sysmmu_drvdata *drvdata);
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1134,6 +1142,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 		data->runtime_active = !pm_runtime_enabled(dev);
 
+		__create_debugfs_entry(data);
+
 		platform_set_drvdata(pdev, data);
 
 		dev->archdata.iommu = &sysmmu_placeholder;
@@ -1238,7 +1248,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.probe		= exynos_sysmmu_probe,
 	.driver		= {
 		.owner		= THIS_MODULE,
-		.name		= "exynos-sysmmu",
+		.name		= MODULE_NAME,
 		.pm		= &__pm_ops,
 		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
@@ -1631,6 +1641,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
+static struct dentry *sysmmu_debugfs_root; /* /sys/kernel/debug/sysmmu */
+
 static int __init exynos_iommu_init(void)
 {
 	int ret;
@@ -1642,17 +1654,197 @@ static int __init exynos_iommu_init(void)
 		return -ENOMEM;
 	}
 
-	ret = platform_driver_register(&exynos_sysmmu_driver);
+	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	if (ret) {
+		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register IOMMU ops\n", __func__);
+		return -EFAULT;
+	}
 
-	if (ret == 0)
-		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	sysmmu_debugfs_root = debugfs_create_dir("sysmmu", NULL);
+	if (!sysmmu_debugfs_root)
+		pr_err("%s: Failed to create debugfs entry, 'sysmmu'\n",
+							__func__);
+	if (IS_ERR(sysmmu_debugfs_root))
+		sysmmu_debugfs_root = NULL;
 
+	ret = platform_driver_register(&exynos_sysmmu_driver);
 	if (ret) {
-		pr_err("%s: Failed to register exynos-iommu driver.\n",
-								__func__);
 		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register System MMU driver\n", __func__);
 	}
 
 	return ret;
 }
 subsys_initcall(exynos_iommu_init);
+
+static int debug_string_show(struct seq_file *s, void *unused)
+{
+	char *str = s->private;
+
+	seq_printf(s, "%s\n", str);
+
+	return 0;
+}
+
+static int debug_sysmmu_list_show(struct seq_file *s, void *unused)
+{
+	struct sysmmu_drvdata *drvdata = s->private;
+	struct platform_device *pdev = to_platform_device(drvdata->sysmmu);
+	int idx, maj, min, ret;
+
+	seq_printf(s, "SysMMU Name | Ver | SFR Base\n");
+
+	if (pm_runtime_enabled(drvdata->sysmmu)) {
+		ret = pm_runtime_get_sync(drvdata->sysmmu);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (idx = 0; idx < drvdata->nsfrs; idx++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, idx);
+		if (!res)
+			break;
+
+		maj = __sysmmu_version(drvdata, idx, &min);
+
+		if (drvdata->mmuname) {
+			if (maj == 0)
+				seq_printf(s, "%11.s | N/A | 0x%08x\n",
+					drvdata->mmuname[idx], res->start);
+			else
+				seq_printf(s, "%11.s | %d.%d | 0x%08x\n",
+				drvdata->mmuname[idx], maj, min, res->start);
+		} else {
+			if (maj == 0)
+				seq_printf(s, "N/A | 0x%08x\n", res->start);
+			else
+				seq_printf(s, "%d.%d | 0x%08x\n",
+							maj, min, res->start);
+		}
+	}
+
+	if (pm_runtime_enabled(drvdata->sysmmu))
+		pm_runtime_put(drvdata->sysmmu);
+
+	return 0;
+}
+
+static int debug_next_sibling_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	if (dev->parent &&
+		!strncmp(dev_name(dev->parent),
+			MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev->parent));
+	return 0;
+}
+
+static int __show_master(struct device *dev, void *data)
+{
+	struct seq_file *s = data;
+
+	if (strncmp(dev_name(dev), MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev));
+	return 0;
+}
+
+static int debug_master_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	device_for_each_child(dev, s, __show_master);
+	return 0;
+}
+
+static int debug_string_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_string_show, inode->i_private);
+}
+
+static int debug_sysmmu_list_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_sysmmu_list_show, inode->i_private);
+}
+
+static int debug_next_sibling_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_next_sibling_show, inode->i_private);
+}
+
+static int debug_master_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_master_show, inode->i_private);
+}
+
+static const struct file_operations debug_string_fops = {
+	.open = debug_string_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_sysmmu_list_fops = {
+	.open = debug_sysmmu_list_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_next_sibling_fops = {
+	.open = debug_next_sibling_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_master_fops = {
+	.open = debug_master_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void __init __create_debugfs_entry(struct sysmmu_drvdata *drvdata)
+{
+	if (!sysmmu_debugfs_root)
+		return;
+
+	drvdata->debugfs_root = debugfs_create_dir(dev_name(drvdata->sysmmu),
+							sysmmu_debugfs_root);
+	if (!drvdata->debugfs_root)
+		dev_err(drvdata->sysmmu, "Failed to create debugfs dentry\n");
+	if (IS_ERR(drvdata->debugfs_root))
+		drvdata->debugfs_root = NULL;
+
+	if (!drvdata->debugfs_root)
+		return;
+
+	if (!debugfs_create_u32("enable", 0664, drvdata->debugfs_root,
+						&drvdata->activations))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'enable'\n");
+
+	if (!debugfs_create_x32("pagetable", 0664, drvdata->debugfs_root,
+						(u32 *)&drvdata->pgtable))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'pagetable'\n");
+
+	if (!debugfs_create_file("sysmmu_list", 0444, drvdata->debugfs_root,
+					drvdata, &debug_sysmmu_list_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'sysmmu_list'\n");
+
+	if (!debugfs_create_file("next_sibling", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_next_sibling_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+
+	if (!debugfs_create_file("master", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_master_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+}
-- 
1.8.0


