Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab2EHRQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:16:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757693Ab2EHRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:16:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: core: Warn on missing struct device
Date: Tue,  8 May 2012 18:16:20 +0100
Message-Id: <1336497380-8341-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336497380-8341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336497380-8341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core really wants a struct device to be supplied for regulators and
there's no reason this should be impossible so provide one so complain
if we didn't get one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c597868..f899af5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2981,6 +2981,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		return ERR_PTR(-EINVAL);
 
 	dev = config->dev;
+	WARN_ON(!dev);
 
 	if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
 		return ERR_PTR(-EINVAL);
-- 
1.7.10

