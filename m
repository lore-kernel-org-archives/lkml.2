Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2KWMZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:25:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2KWMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:25:03 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        srinidhi.kasagar@stericsson.com, patches@linaro.org
Subject: [PATCH] mfd: ab8500-core: Fix invalid free of devm_ allocated data
Date: Fri, 23 Nov 2012 17:48:43 +0530
Message-Id: <1353673123-32340-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The objects allocated by devm_* APIs are managed by devres and are
freed when the device is detached. Hence there is no need to remove
them explicitly in remove function.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/mfd/ab8500-core.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 148d2ee..af7a6ba 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1428,11 +1428,6 @@ static int __devexit ab8500_remove(struct platform_device *pdev)
 		sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 
 	mfd_remove_devices(ab8500->dev);
-	free_irq(ab8500->irq, ab8500);
-
-	kfree(ab8500->oldmask);
-	kfree(ab8500->mask);
-	kfree(ab8500);
 
 	return 0;
 }
-- 
1.7.4.1

