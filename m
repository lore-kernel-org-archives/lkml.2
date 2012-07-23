Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2GWPQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:16:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1465 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2GWPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:16:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 23 Jul 2012 08:16:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: core: increment open_count when regulator supply is set
Date: Mon, 23 Jul 2012 20:35:46 +0530
Message-ID: <1343055946-4205-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering the regulator and setting supply for the regulator
then increment open_count to reflect correct number of users.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f092588..b28221a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -974,6 +974,7 @@ static int set_supply(struct regulator_dev *rdev,
 		err = -ENOMEM;
 		return err;
 	}
+	supply_rdev->open_count++;
 
 	return 0;
 }
-- 
1.7.1.1

