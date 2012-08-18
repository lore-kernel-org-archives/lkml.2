Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2HRGd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 02:33:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2HRGdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 02:33:23 -0400
Message-ID: <1345271585.7986.0.camel@phoenix>
Subject: [PATCH] regulator: max8907: Properly set pmic pointer in
 max8907_regulator_remove()
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Sat, 18 Aug 2012 14:33:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing platform_get_drvdata() call in max8907_regulator_remove(), this
fixes below build warning:

  CC [M]  drivers/regulator/max8907-regulator.o
drivers/regulator/max8907-regulator.c: In function 'max8907_regulator_remove':
drivers/regulator/max8907-regulator.c:353:23: warning: 'pmic' is used uninitialized in this function [-Wuninitialized]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8907-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index bd3b28b..831488f 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -346,7 +346,7 @@ err_unregister_regulator:
 
 static __devexit int max8907_regulator_remove(struct platform_device *pdev)
 {
-	struct max8907_regulator *pmic;
+	struct max8907_regulator *pmic = platform_get_drvdata(pdev);
 	int i;
 
 	for (i = 0; i < MAX8907_NUM_REGULATORS; i++)
-- 
1.7.9.5



