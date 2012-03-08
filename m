Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2CHCC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:02:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43892 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2CHCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:02:28 -0500
Message-ID: <1331172137.14592.1.camel@phoenix>
Subject: [PATCH] regulator: Fix setting selector in tps6524x set_voltage
 function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 08 Mar 2012 10:02:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't assign the voltage to selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 70b7b1f..2e94686 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -481,7 +481,7 @@ static int set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if (i >= info->n_voltages)
 		i = info->n_voltages - 1;
 
-	*selector = info->voltages[i];
+	*selector = i;
 
 	return write_field(hw, &info->voltage, i);
 }
-- 
1.7.5.4



