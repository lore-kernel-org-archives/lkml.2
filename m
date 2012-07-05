Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2GETgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:36:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41977 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757311Ab2GETfh (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] mfd: arizona: Treat register read errors as non-fatal during resume
Date: Thu,  5 Jul 2012 20:35:30 +0100
Message-Id: <1341516933-16474-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're testing for a specific value and while SPI does not detect I/O
errors I2C can.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 2ca43a0..3a4ced2 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -197,7 +197,7 @@ static int arizona_wait_for_boot(struct arizona *arizona)
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to read boot state: %d\n",
 				ret);
-			return ret;
+			continue;
 		}
 
 		if (reg & ARIZONA_BOOT_DONE_STS)
-- 
1.7.10

