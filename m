Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2LLJkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:40:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49466 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2LLJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:38:27 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/7] dmaengine: ste_dma40: don't check for pm_runtime_suspended()
Date: Wed, 12 Dec 2012 10:37:19 +0100
Message-Id: <1355305041-2338-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>

The check for runtime suspend is not needed during a regular suspend, as
the framework takes care of this.  This fixes the issue of DMA driver
not letting the system to go to deepsleep in the first attempt.

Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Reviewed-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0b80ee9..d8d58d9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2783,8 +2783,6 @@ static int dma40_pm_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct d40_base *base = platform_get_drvdata(pdev);
 	int ret = 0;
-	if (!pm_runtime_suspended(dev))
-		return -EBUSY;
 
 	if (base->lcpa_regulator)
 		ret = regulator_disable(base->lcpa_regulator);
-- 
1.7.12.1

