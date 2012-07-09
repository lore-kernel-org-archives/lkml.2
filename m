Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2GIK4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:56:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60886 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193Ab2GIK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:56:45 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Error out if initial boot fails
Date: Mon,  9 Jul 2012 11:56:43 +0100
Message-Id: <1341831403-4275-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index ed2de7b..011d80e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -418,7 +418,11 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		}
 	}
 
-	arizona_wait_for_boot(arizona);
+	ret = arizona_wait_for_boot(arizona);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Device failed initial boot: %d\n", ret);
+		goto err_reset;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
 		if (!arizona->pdata.gpio_defaults[i])
-- 
1.7.10

