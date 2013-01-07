Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3AGLYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:01 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65034 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3AGLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:23:59 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 05/16] dmaengine: ste_dma40: don't check for pm_runtime_suspended()
Date: Mon,  7 Jan 2013 12:21:47 +0100
Message-Id: <1357557718-15676-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
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
index 2d0c63d..760576b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2782,8 +2782,6 @@ static int dma40_pm_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct d40_base *base = platform_get_drvdata(pdev);
 	int ret = 0;
-	if (!pm_runtime_suspended(dev))
-		return -EBUSY;
 
 	if (base->lcpa_regulator)
 		ret = regulator_disable(base->lcpa_regulator);
-- 
1.7.12.1

