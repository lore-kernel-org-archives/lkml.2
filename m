Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2BAQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:09:27 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41145 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588Ab2BAQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: [PATCH 1/4] mfd/ab8500: fix error path bug
Date: Wed, 1 Feb 2012 17:09:15 +0100
Message-ID: <1328112555-32459-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/mfd/ab8500-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 53e2a80..bf823d2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -956,9 +956,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	return ret;
 
 out_freeirq:
-	if (ab8500->irq_base) {
+	if (ab8500->irq_base)
 		free_irq(ab8500->irq, ab8500);
 out_removeirq:
+	if (ab8500->irq_base)
 		ab8500_irq_remove(ab8500);
 	}
 	return ret;
-- 
1.7.8

