Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2H1Kur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:50:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13711 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2H1Kuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:50:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Aug 2012 03:50:38 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <lrg@ti.com>
CC: <swarren@wwwdotorg.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65910: register regulator even if no init data
Date: Tue, 28 Aug 2012 15:59:27 +0530
Message-ID: <1346149767-31602-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com>
References: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register all TPS65910 regulators even if there is no regulator
init data for platform i.e. without any user-supplied constraints.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch make sure that all chip regulators get registered
even there is no user-supplied.
This is based on discussion on following patch about registering
rails without init data.
        max8907: fix use of possibly NULL idata

 drivers/regulator/tps65910-regulator.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 793adda..1f758c9 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1105,11 +1105,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 
 		reg_data = pmic_plat_data->tps65910_pmic_init_data[i];
 
-		/* Regulator API handles empty constraints but not NULL
-		 * constraints */
-		if (!reg_data)
-			continue;
-
 		/* Register the regulators */
 		pmic->info[i] = info;
 
-- 
1.7.1.1

