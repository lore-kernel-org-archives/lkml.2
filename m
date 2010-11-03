Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0KCM73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 08:59:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55829 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755007Ab0KCM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:59:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Staticise mc13783_powermisc_rmw()
Date: Wed,  3 Nov 2010 00:08:04 -0400
Message-Id: <1288757284-15812-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/mc13783-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 5e6fa47..47ea999 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -471,8 +471,8 @@ static struct regulator_ops mc13783_fixed_regulator_ops = {
 	.get_voltage = mc13783_fixed_regulator_get_voltage,
 };
 
-int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
-									u32 val)
+static int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
+				 u32 val)
 {
 	struct mc13783 *mc13783 = priv->mc13783;
 	int ret;
-- 
1.7.1

