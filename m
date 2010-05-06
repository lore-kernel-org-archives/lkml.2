Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0EFDdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:33:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34448 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0EFDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NNcOXbAddlMf28aWgqDilKkD+Ata1d70z+kpTCxOcAwIT+ebKrbsQrVzDpF2/bsTkH
         /+kdkrMKF4fobeV//XwJ5KDaEKrIxdLCqw1su0fgXOb1h6xG2ZKbgQTFsXTzg1f2bCvo
         6yf6PxbVcmqKcw38USHO0PoBC9C8wj5bmiH5E=
Subject: [PATCH RESEND] mc13783-regulator: fix vaild voltage range checking
	for mc13783_fixed_regulator_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain
Date: Thu, 06 May 2010 11:33:36 +0800
Message-Id: <1273116816.26133.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of "min_uV == max_uV == mc13783_regulators[id].voltages[0]",
mc13783_fixed_regulator_set_voltage should return 0 instead of -EINVAL.

This patch also adds a missing ">" character for MODULE_AUTHOR, a trivial fix.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/mc13783-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index ad036dd..4597d50 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -440,8 +440,8 @@ static int mc13783_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
 		__func__, id, min_uV, max_uV);
 
-	if (min_uV > mc13783_regulators[id].voltages[0] &&
-	    max_uV < mc13783_regulators[id].voltages[0])
+	if (min_uV >= mc13783_regulators[id].voltages[0] &&
+	    max_uV <= mc13783_regulators[id].voltages[0])
 		return 0;
 	else
 		return -EINVAL;
@@ -649,6 +649,6 @@ static void __exit mc13783_regulator_exit(void)
 module_exit(mc13783_regulator_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de");
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("Regulator Driver for Freescale MC13783 PMIC");
 MODULE_ALIAS("platform:mc13783-regulator");
-- 
1.5.4.3



