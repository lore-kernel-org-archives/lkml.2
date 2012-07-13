Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2GMPBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:01:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34921 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab2GMPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:01:43 -0400
Message-ID: <1342191674.10881.2.camel@phoenix>
Subject: [PATCH RFC] regulator: mc13xxx: Populate selector from
 mc13xxx_fixed_regulator_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 23:01:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was missing until now and the underlying
_regulator_do_set_voltage is using this value when calling list_voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Not very sure if we should implement set_voltage callback for fixed voltage.
( Other drivers do not implement set_voltage callback for fixed voltage.
Since the voltage is fixed, implement set_voltage callback seems does not make sense.)

If we do implement the callback, we need to populate selector.
Or alternative, we can just remove mc13xxx_fixed_regulator_set_voltage.

Axel
 drivers/regulator/mc13xxx-regulator-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index d6eda28..8151889 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -143,10 +143,12 @@ int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 		__func__, id, min_uV, max_uV);
 
 	if (min_uV <= rdev->desc->volt_table[0] &&
-	    rdev->desc->volt_table[0] <= max_uV)
+	    rdev->desc->volt_table[0] <= max_uV) {
+		*selector = 0;
 		return 0;
-	else
+	} else {
 		return -EINVAL;
+	}
 }
 EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_set_voltage);
 
-- 
1.7.9.5



