Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2EGH5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:57:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55729 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2EGH5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:57:30 -0400
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
Subject: [PATCH] regulator: da9052: fix bug in device tree iteration loop
Date: Mon,  7 May 2012 15:57:23 +0800
Message-Id: <1336377443-5926-1-git-send-email-paulliu@debian.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>

The driver of da9052 is buggy due to the iteration loop of device tree.
This patch fix the loop condition to make the driver work with device tree.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
---
 drivers/regulator/da9052-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index eaa91cc5..f8ad24a 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -444,7 +444,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 		if (!nproot)
 			return -ENODEV;
 
-		for (np = of_get_next_child(nproot, NULL); !np;
+		for (np = of_get_next_child(nproot, NULL); np;
 		     np = of_get_next_child(nproot, np)) {
 			if (!of_node_cmp(np->name,
 					 regulator->info->reg_desc.name)) {
-- 
1.7.10

