Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2KZXQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:16:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2852 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2KZXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:16:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Nov 2012 15:14:46 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps6586x: fix build warning in debug build
Date: Tue, 27 Nov 2012 04:44:28 +0530
Message-ID: <1353971668-18900-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the driver in debug mode, it generates
warning as

drivers/regulator/tps6586x-regulator.c: In function 'tps6586x_regulator_probe':
drivers/regulator/tps6586x-regulator.c:392:9: warning: 'id' is used uninitialized in this function [-Wuninitialized]

Fix this warning.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/tps6586x-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 9ce4410..f86da67 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -389,7 +389,7 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 	int id;
 	int err;
 
-	dev_dbg(&pdev->dev, "Probing regulator %d\n", id);
+	dev_dbg(&pdev->dev, "Probing regulator\n");
 
 	pdata = dev_get_platdata(pdev->dev.parent);
 	if ((!pdata) && (pdev->dev.parent->of_node))
-- 
1.7.1.1

