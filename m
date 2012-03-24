Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2CXC4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:56:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53419 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2CXC4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:56:10 -0400
Message-ID: <1332557760.10528.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps65090: Use IS_ERR to check return value
 of regulator_register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 10:56:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_register never returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65090-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 6c28e3a..470ca7e 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -153,7 +153,7 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
 				&tps_pdata->regulator, ri, NULL);
-	if (IS_ERR_OR_NULL(rdev)) {
+	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
 		return PTR_ERR(rdev);
-- 
1.7.5.4



