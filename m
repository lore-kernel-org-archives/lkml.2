Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2H1LZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:25:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2H1LZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:25:31 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-ed-503caaa90c4c
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        yadi.brar@samsung.com, jonghwa3.lee@samsung.com
Subject: [PATCH] regulator: max77686: add of_node assignment
Date: Tue, 28 Aug 2012 20:25:30 +0900
Message-id: <1346153130-29038-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jQd2Vq2wCDCattLK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZD67eYCr4z12x+cIc9gbGPq4uRk4OCQETibbv7xghbDGJC/fW
	s3UxcnEICUxnlDi44wgThLOUSWLq5jUsIFVsAnoSd7YdB0pwcIgIqEtsPa4DEmYWyJO4faEH
	rERYwEZi1+WrYENZBFQlXv78DmbzCrhLrOlsYQZplRBQkJgzyWYCI/cCRoZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMH+eya1g3Flg8UhRgEORiUe3oBd1gFCrIllxZW5hxglOJiVRHhX
	VdkECPGmJFZWpRblxxeV5qQWH2KU5mBREufl7zMMEBJITyxJzU5NLUgtgskycXBKNTAaCVoF
	FIV928r1Ud/+xbHYWWY6cy/O+n2msuCMZr9In1TGzGVFEt5XmxnZ7OJsuHZXWx92qNnwZrGA
	5Ppp5YysmtdK90hLXKzwf+N8Qek5rzFXlHJOoG/+yfsPmYKfpG8oeCz51nIeq7Pz+xunHvmr
	f3wufa7xrJNuAXdt7uSd7AuMY1PPMCixFGckGmoxFxUnAgAA6UTu2wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consumer nodes can reference regulators using <name>-supply from dts
file with this patch.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max77686.c |    2 ++
 include/linux/mfd/max77686.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index c564af6..87544b3 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -265,6 +265,7 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 		rmatch.of_node = NULL;
 		of_regulator_match(iodev->dev, regulators_np, &rmatch, 1);
 		rdata[i].initdata = rmatch.init_data;
+		rdata[i].of_node = rmatch.of_node;
 	}
 
 	pdata->regulators = rdata;
@@ -325,6 +326,7 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		config.init_data = pdata->regulators[i].initdata;
+		config.of_node = pdata->regulators[i].of_node;
 
 		rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(rdev[i])) {
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index 3d7ae4d..46c0f32 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -74,6 +74,7 @@ enum max77686_regulators {
 struct max77686_regulator_data {
 	int id;
 	struct regulator_init_data *initdata;
+	struct device_node *of_node;
 };
 
 enum max77686_opmode {
-- 
1.7.9.5

