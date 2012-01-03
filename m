Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2ACHNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:13:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16896 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2ACHNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:13:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 02 Jan 2012 23:13:30 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2] regulator: Add check for supply rail
Date: Tue,  3 Jan 2012 12:41:40 +0530
Message-Id: <1325574700-3798-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

When consumer of any rails query about whether rail is enabled
or not, the function regulator_is_enabled() should return enabled
only if requested rail and supply rail (both) are enabled.
If any one of these rails is enabled then function should return as
not enabled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The commit message and synopsis is changed in this patch.

 drivers/regulator/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbdebed..d914435 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1701,6 +1701,12 @@ int regulator_is_enabled(struct regulator *regulator)
 {
 	int ret;
 
+	if (regulator->rdev->supply) {
+		ret = regulator_is_enabled(regulator->rdev->supply);
+		if (ret <= 0)
+			return ret;
+	}
+
 	mutex_lock(&regulator->rdev->mutex);
 	ret = _regulator_is_enabled(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
-- 
1.7.1.1

