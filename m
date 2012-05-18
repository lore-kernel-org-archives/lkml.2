Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966791Ab2ERMCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:02:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13589 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342Ab2ERMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:02:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 18 May 2012 05:02:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65910: fixed build error
Date: Fri, 18 May 2012 17:27:25 +0530
Message-ID: <1337342245-23154-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the api calls are not changed and it leads
to following build error:
/regulator/tps65910-regulator.c: In function 'tps65910_enable':
/regulator/tps65910-regulator.c:491:2: error: implicit declaration of
function 'tps65910_set_bits'
/regulator/tps65910-regulator.c: In function 'tps65910_disable':
/regulator/tps65910-regulator.c:504:2: error: implicit declaration of
function 'tps65910_clear_bits'
/regulator/tps65910-regulator.c: In function 'tps65910_get_voltage':
/regulator/tps65910-regulator.c:628:2: warning: passing argument 1 of
'tps65910_reg_read' from incompatible pointer type]
/linux/mfd/tps65910.h:856:19: note: expected 'struct tps65910 *' but
argument is of type 'struct tps65910_reg *'
/regulator/tps65910-regulator.c:628:2: error: too few arguments to
function 'tps65910_reg_read'

cc1: some warnings being treated as errors

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch fixes the compilation error in Samuel's tree and should go
through Samuel's for-next.
Some of the function is removed from the regulator for-next and so error
in line number 491 and 504 will not be there but still error at 628 will
be there.

 drivers/regulator/tps65910-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b38fb64..852b05b 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -488,7 +488,7 @@ static int tps65910_enable(struct regulator_dev *dev)
 	if (reg < 0)
 		return reg;
 
-	return tps65910_set_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
+	return tps65910_reg_set_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
 }
 
 static int tps65910_disable(struct regulator_dev *dev)
@@ -501,7 +501,7 @@ static int tps65910_disable(struct regulator_dev *dev)
 	if (reg < 0)
 		return reg;
 
-	return tps65910_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
+	return tps65910_reg_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
 }
 
 static int tps65910_enable_time(struct regulator_dev *dev)
@@ -625,7 +625,7 @@ static int tps65910_get_voltage(struct regulator_dev *dev)
 	if (reg < 0)
 		return reg;
 
-	value = tps65910_reg_read(pmic, reg);
+	value = tps65910_reg_read_locked(pmic, reg);
 	if (value < 0)
 		return value;
 
-- 
1.7.1.1

