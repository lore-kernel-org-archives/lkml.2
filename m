Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2BTUmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:42:17 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:57912 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312Ab2BTUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:42:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: [PATCH 1/4 v2] mfd/ab8500: fix error path bug
Date: Mon, 20 Feb 2012 21:42:03 +0100
Message-ID: <1329770523-9490-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We were not freeing the irq properly in the error path in
the AB8500 driver.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Signed-off-by: Alex Macro <alex.macro@stericsson.com>
Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Make the patch bisectable and isolated the fix after comment
  from Maxime.
---
 drivers/mfd/ab8500-core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 53e2a80..d295941 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -956,11 +956,12 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	return ret;
 
 out_freeirq:
-	if (ab8500->irq_base) {
+	if (ab8500->irq_base)
 		free_irq(ab8500->irq, ab8500);
 out_removeirq:
+	if (ab8500->irq_base)
 		ab8500_irq_remove(ab8500);
-	}
+
 	return ret;
 }
 
-- 
1.7.8

