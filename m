Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2LKIEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:04:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50001 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2LKIEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:04:20 -0500
Message-ID: <1355213050.7387.1.camel@phoenix>
Subject: [PATCH] regulator: vexpress: Add missing n_voltages setting
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 16:04:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise regulator_can_change_voltage() return 0 for this driver.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/vexpress.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 4668c7f..9bb3aa0 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -86,10 +86,14 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	}
 
 	init_data->constraints.apply_uV = 0;
-	if (init_data->constraints.min_uV && init_data->constraints.max_uV)
+	if (init_data->constraints.min_uV && init_data->constraints.max_uV) {
 		reg->desc.ops = &vexpress_regulator_ops;
-	else
+		reg->desc.n_voltages = init_data->constraints.max_uV -
+				       init_data->constraints.min_uV + 1;
+	} else {
 		reg->desc.ops = &vexpress_regulator_ops_ro;
+		reg->desc.n_voltages = 1;
+	}
 
 	config.dev = &pdev->dev;
 	config.init_data = init_data;
-- 
1.7.9.5



