Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2HFPL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:11:56 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:55874 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab2HFPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:11:55 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] regulator: ab3100: add missing voltage table
Date: Mon, 6 Aug 2012 17:11:40 +0200
Message-ID: <1344265900-17726-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The conversion to voltage tables in

commit a3beb74261f26142019847128b2441b0301797ac
"regulator: ab3100: Use regulator_list_voltage_table()"

missed to add the voltage table to the buck. Fix this and
it works like a charm.

Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab3100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 182b553..c151fd5 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -486,6 +486,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_BUCK,
 		.ops  = &regulator_ops_variable_sleepable,
 		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
+		.volt_table = ldo_e_buck_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_time = 1000,
-- 
1.7.11.3

