Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2GFJUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:20:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42796 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2GFJUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:20:36 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 6/6] regulator: max77686: Initialise rmatch.of_node to NULL.
Date: Fri,  6 Jul 2012 14:50:08 +0530
Message-Id: <1341566408-17105-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now of_regulator_match() returns without finding the match if match->of_node
is not NULL.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index fc695eb..c564af6 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -262,6 +262,7 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 	for (i = 0; i < pdata->num_regulators; i++) {
 		rmatch.name = regulators[i].name;
 		rmatch.init_data = NULL;
+		rmatch.of_node = NULL;
 		of_regulator_match(iodev->dev, regulators_np, &rmatch, 1);
 		rdata[i].initdata = rmatch.init_data;
 	}
-- 
1.7.0.4

