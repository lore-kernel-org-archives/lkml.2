Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2DJFrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:47:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61127 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2DJFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:47:33 -0400
Message-ID: <1334036844.15859.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: Fix build error for ab8500
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 10 Apr 2012 13:47:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build errors which is introduced by commit c172708
"regulator: core: Use a struct to pass in regulator runtime configuration".

  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
drivers/regulator/ab8500.c:783: error: invalid type argument of '->' (have 'struct regulator_config')
drivers/regulator/ab8500.c:784: error: invalid type argument of '->' (have 'struct regulator_config')
drivers/regulator/ab8500.c:785: error: invalid type argument of '->' (have 'struct regulator_config')
make[2]: *** [drivers/regulator/ab8500.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 93feada..d156390 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -780,9 +780,9 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 		info = &ab8500_regulator_info[i];
 		info->dev = &pdev->dev;
 
-		config->dev = &pdev->dev;
-		config->init_data = &pdata->regulator[i];
-		config->driver_data = info;
+		config.dev = &pdev->dev;
+		config.init_data = &pdata->regulator[i];
+		config.driver_data = info;
 
 		/* fix for hardware before ab8500v2.0 */
 		if (abx500_get_chip_id(info->dev) < 0x20) {
-- 
1.7.5.4



