Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2K0StV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:49:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab2K0StU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:49:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Say what unsupportable voltage constraints are
Date: Tue, 27 Nov 2012 18:49:18 +0000
Message-Id: <1354042158-11184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3db1e01..b701352 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -880,7 +880,9 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* final: [min_uV..max_uV] valid iff constraints valid */
 		if (max_uV < min_uV) {
-			rdev_err(rdev, "unsupportable voltage constraints\n");
+			rdev_err(rdev,
+				 "unsupportable voltage constraints %u-%uuV\n",
+				 min_uV, max_uV);
 			return -EINVAL;
 		}
 
-- 
1.7.10.4

