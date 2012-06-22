Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab2FVMgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:36:24 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60743 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab2FVMgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:36:22 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        s-guiriec@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 1/3] MFD: palmas fix regulator pdata missing
Date: Fri, 22 Jun 2012 13:36:18 +0100
Message-Id: <1340368581-11882-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a merge error the section of code passing the pdata for the
regulator driver to the mfd_add_devices via the children structure
was missing. This corrects this problem.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 00c0aba..7dfb018 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -441,6 +441,9 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 		goto err;
 	}
 
+	children[PALMAS_PMIC_ID].platform_data = pdata->pmic_pdata;
+	children[PALMAS_PMIC_ID].pdata_size = sizeof(*pdata->pmic_pdata);
+
 	ret = mfd_add_devices(palmas->dev, -1,
 			      children, ARRAY_SIZE(palmas_children),
 			      NULL, regmap_irq_chip_get_base(palmas->irq_data));
-- 
1.7.9.5

