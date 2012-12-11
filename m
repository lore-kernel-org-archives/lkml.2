Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2LKLMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:12:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34374 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2LKLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:11:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f3-50c714f88076
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
Subject: [PATCH v5 14/14] iommu/exynos: add debugfs entries for System MMU
Date: Tue, 11 Dec 2012 20:11:51 +0900
Message-id: <003e01cdd790$523267f0$f69737d0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjIeZh0vL9PKDSuW1dZosoQwlsgAA8RFg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zfd0fIscDDL5sFbS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4+eoqW0GvfcW2a08YGxj/GXcxcnJICJhIHOx+zg5h
	i0lcuLeerYuRi0NIYBmjxLGVZ1hgip6t6GKCSCxilGjZdhfK+cco8X3bC7AqNgEtidVzjzOC
	2CICdxklXp7nASliFjjCJLHz/jmwImEBL4lLC/eA2SwCqhKt7yeB7eYVsJV4MHURK4QtKPFj
	8j2wGmagoet3HmeCsOUlNq95y9zFyAF0krrEo7+6ELuMJA78vMYOUSIise/FO0aI8QIS3yYf
	YoEol5XYdIAZ5BwJgX52ia+zFjNCfCYpcXDFDZYJjGKzkGyehWTzLCSbZyFZsYCRZRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGSNxI72Bc1WBxiFGAg1GJh1dD61iAEGtiWXFl7iFGCQ5m
	JRHeSKHjAUK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqcD4zpvJJ4Q2NjEzMTUxNzS1NzUxzC
	SuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYtXcf8z4T0PY+5fnZZaZvi7JMuoM2pCr/XK0y
	TepKiNXd7R2Lr76ZlDjzHbP/mVzzZw7T+FvFj75fmhBj/pTZtlRNM0CvjtWHNS3lzeLrZfHv
	Lmhe0Y+cVlLf9+3BvJUture5F39fvEJJKud/IOPyebPORctv+bg0QGXhnkzxM/HREV0i9l1/
	lFiKMxINtZiLihMBsTfA98gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd0fIscDDLZc4ra4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuPnqKltBr33F
	tmtPGBsY/xl3MXJySAiYSDxb0cUEYYtJXLi3nq2LkYtDSGARo0TLtrtMEM4/Ronv216wgFSx
	CWhJrJ57nBHEFhG4yyjx8jwPSBGzwBEmiZ33z4EVCQt4SVxauAfMZhFQlWh9P4kdxOYVsJV4
	MHURK4QtKPFj8j2wGmagoet3HmeCsOUlNq95y9zFyAF0krrEo7+6ELuMJA78vMYOUSIise/F
	O8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCqfSe9g
	XNVgcYhRgINRiYdXQ+tYgBBrYllxZe4hRgkOZiUR3kih4wFCvCmJlVWpRfnxRaU5qcWHGH2A
	Hp3ILCWanA9MGHkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1
	MCpGeC5YZGKyVECybVLSgRWJLW0nEh7xsGg+rTq12/nFXj524bK7Sz+n7T6wVjX1reM8idmy
	psZH79jP8dHLMd+6wnzfi45vlnFTvqr83rSs5tPWq8HpDNL1N0vP559UelIy0epYd11r5RfB
	oqdHlrdwTmrRsz5o4fShQeuSn31wd+/icOnif0osxRmJhlrMRcWJAEcx09D3AgAA
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


