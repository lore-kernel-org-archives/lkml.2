Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab2FHHjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:39:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2FHHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:39:41 -0400
Message-ID: <1339141174.16616.2.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: mc13xxx: Fix voltage checking for
 mc13xxx_fixed_regulator_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 15:39:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage range checking should be to ensure mc13xxx_regulators[id].voltages[0]
falls with min_uV and max_uV.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13xxx-regulator-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 4fa9704..3e19171 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -158,8 +158,8 @@ int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
 		__func__, id, min_uV, max_uV);
 
-	if (min_uV >= mc13xxx_regulators[id].voltages[0] &&
-	    max_uV <= mc13xxx_regulators[id].voltages[0])
+	if (min_uV <= mc13xxx_regulators[id].voltages[0] &&
+	    mc13xxx_regulators[id].voltages[0] <= max_uV)
 		return 0;
 	else
 		return -EINVAL;
-- 
1.7.9.5



