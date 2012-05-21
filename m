Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2EUPbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:31:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2EUPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:31:18 -0400
Message-ID: <1337614268.15342.0.camel@phoenix>
Subject: [PATCH] regulator: palmas: Fix a typo that causes build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 21 May 2012 23:31:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/regulator/palmas-regulator.o
drivers/regulator/palmas-regulator.c:409:48: error: expected '}' before ';' token
make[2]: *** [drivers/regulator/palmas-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Just found a typo in my previous patch. Sorry about that.

Axel
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 4fd8333..92f475c 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -406,8 +406,8 @@ static struct regulator_ops palmas_ops_smps10 = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= regulator_list_voltage_linear;
-	.map_voltage		= regulator_map_voltage_linear;
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 };
 
 static int palmas_is_enabled_ldo(struct regulator_dev *dev)
-- 
1.7.5.4



