Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0HSC0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:26:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37608 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0HSC0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Gih/uRDjlZ0+GpcXQkYtd/weFJ9isS+lkU77qhiyXpECz2FJxbgPOUVC9eC90agG/V
         rN9SrVsV0ccMQXTV/l5Cnw78LTgFnPRY6YDdXDDnEnG9FUCP14fwnJIT6owQyVLHuuih
         xPKpIJsIIZHqvNyTEJ+f2Aa8KeGSBlQXoRjNQ=
Subject: [PATCH RESEND] regulator: max8998 - fix memory allocation size for
	max8998->rdev
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain
Date: Thu, 19 Aug 2010 10:29:19 +0800
Message-Id: <1282184959.17508.3.camel@mola>
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
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Looks like this patch is missing. So here is a resend for Liam.

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



