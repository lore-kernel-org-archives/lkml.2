Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2GRQmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:42:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52417 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2GRQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:42:15 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/3] rtc/rtc-88pm80x: remove unneed devm_kfree
Date: Wed, 18 Jul 2012 22:12:08 +0530
Message-Id: <1342629728-12944-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kzalloc doesn't need a matching devm_kfree, the freeing mechanism will trigger
when driver unloads.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/rtc/rtc-88pm80x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 7e050b4..6367984 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -339,7 +339,6 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
 out_rtc:
 	pm80x_free_irq(chip, info->irq, info);
 out:
-	devm_kfree(&pdev->dev, info);
 	return ret;
 }
 
@@ -349,7 +348,6 @@ static int __devexit pm80x_rtc_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
-	devm_kfree(&pdev->dev, info);
 	return 0;
 }
 
-- 
1.7.0.4

