Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab2ESOTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:19:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15851 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2ESOTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:19:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 07:19:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: core: use correct device for device supply lookup
Date: Sat, 19 May 2012 19:44:06 +0530
Message-ID: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering the regulator driver, use the rdev->dev for
getting the regulator device of given supply instead of parent
device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7584a74..f820137 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3150,7 +3150,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	if (supply) {
 		struct regulator_dev *r;
 
-		r = regulator_dev_lookup(dev, supply, &ret);
+		r = regulator_dev_lookup(&rdev->dev, supply, &ret);
 
 		if (!r) {
 			dev_err(dev, "Failed to find supply %s\n", supply);
-- 
1.7.1.1

