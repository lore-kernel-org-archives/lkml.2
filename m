Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab0HLBbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:31:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53931 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0HLBbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=yBAGz4UgPg+Ppb26LITBn43jUx1bATGjR4+UkzKrpZ5py9RGE5ao2mLAGEnx0CIf32
         8UzxUPCRGulN6g1cb2obnfu5eF95eRqPB0UqjCz2NgXjkYa8E2dNA7zS/Q4HgaCbhpcK
         JGFFbZ0Ys0sDbIHtwNGDbHPpU9oWAng7xuwXk=
Subject: [PATCH] regulator: max8998 - fix memory allocation size for
	max8998->rdev
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain
Date: Thu, 12 Aug 2010 09:32:59 +0800
Message-Id: <1281576779.25972.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only use max8998->rdev[0] .. max8998->rdev[pdata->num_regulators-1],
max8998->rdev[pdata->num_regulators] is not used.
Thus fix the memory allocation size.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index ab67298..fbcb385 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -549,7 +549,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	if (!max8998)
 		return -ENOMEM;
 
-	size = sizeof(struct regulator_dev *) * (pdata->num_regulators + 1);
+	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
 	max8998->rdev = kzalloc(size, GFP_KERNEL);
 	if (!max8998->rdev) {
 		kfree(max8998);
@@ -583,7 +583,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	for (i = 0; i <= max8998->num_regulators; i++)
+	for (i = 0; i < max8998->num_regulators; i++)
 		if (rdev[i])
 			regulator_unregister(rdev[i]);
 
@@ -599,7 +599,7 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
 	struct regulator_dev **rdev = max8998->rdev;
 	int i;
 
-	for (i = 0; i <= max8998->num_regulators; i++)
+	for (i = 0; i < max8998->num_regulators; i++)
 		if (rdev[i])
 			regulator_unregister(rdev[i]);
 
-- 
1.7.2



