Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2GTQJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:09:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab2GTQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:09:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@liniux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Add debug trace on entering and leaving runtime suspend
Date: Fri, 20 Jul 2012 17:09:12 +0100
Message-Id: <1342800552-10436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't appear to be any useful diagnostic information from the
core.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 6e70d3d..c7983e8 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -223,6 +223,8 @@ static int arizona_runtime_resume(struct device *dev)
 	struct arizona *arizona = dev_get_drvdata(dev);
 	int ret;
 
+	dev_dbg(arizona->dev, "Leaving AoD mode\n");
+
 	ret = regulator_enable(arizona->dcvdd);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to enable DCVDD: %d\n", ret);
@@ -246,6 +248,8 @@ static int arizona_runtime_suspend(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
 
+	dev_dbg(arizona->dev, "Entering AoD mode\n");
+
 	regulator_disable(arizona->dcvdd);
 	regcache_cache_only(arizona->regmap, true);
 	regcache_mark_dirty(arizona->regmap);
-- 
1.7.10.4

