Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2DJFtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:49:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37782 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2DJFt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:49:29 -0400
Message-ID: <1334036964.15859.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: Fix a typo in da903x.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 13:49:24 +0800
In-Reply-To: <1334036844.15859.1.camel@phoenix>
References: <1334036844.15859.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build errors which is introduced by commit c172708
"regulator: core: Use a struct to pass in regulator runtime configuration".

  CC      drivers/regulator/da903x.o
drivers/regulator/da903x.c: In function 'da903x_regulator_probe':
drivers/regulator/da903x.c:541: error: 'conifg' undeclared (first use in this function)
drivers/regulator/da903x.c:541: error: (Each undeclared identifier is reported only once
drivers/regulator/da903x.c:541: error: for each function it appears in.)
make[2]: *** [drivers/regulator/da903x.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 4630b1e..682bdb3 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -538,7 +538,7 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
 	config.dev = &pdev->dev;
-	conifg.init_data = pdev->dev.platform_data;
+	config.init_data = pdev->dev.platform_data;
 	config.driver_data = ri;
 
 	rdev = regulator_register(&ri->desc, &config);
-- 
1.7.5.4



