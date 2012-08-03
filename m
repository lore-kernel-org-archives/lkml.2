Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2HCNoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:44:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45814 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2HCNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:44:00 -0400
Message-ID: <1344001434.25906.5.camel@phoenix>
Subject: [PATCH] pwm: Remove a redundant error message when
 devm_request_and_ioremap fails
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Philip Avinash <avinashphilip@ti.com>
Date: Fri, 03 Aug 2012 21:43:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in devm_request_and_ioremap() already shows error message,
so no need to show dev_err again if devm_request_and_ioremap() fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Philip, Avinash <avinashphilip@ti.com>
---
 drivers/pwm/pwm-tegra.c    |    4 +---
 drivers/pwm/pwm-tiecap.c   |    4 +---
 drivers/pwm/pwm-tiehrpwm.c |    4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 02ce18d..057465e 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -187,10 +187,8 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 	}
 
 	pwm->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pwm->mmio_base) {
-		dev_err(&pdev->dev, "failed to ioremap() region\n");
+	if (!pwm->mmio_base)
 		return -EADDRNOTAVAIL;
-	}
 
 	platform_set_drvdata(pdev, pwm);
 
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 3c2ad28..0b66d0f 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -192,10 +192,8 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 	}
 
 	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pc->mmio_base) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
+	if (!pc->mmio_base)
 		return -EADDRNOTAVAIL;
-	}
 
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 010d232..c3756d1 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -371,10 +371,8 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 	}
 
 	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pc->mmio_base) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
+	if (!pc->mmio_base)
 		return  -EADDRNOTAVAIL;
-	}
 
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
-- 
1.7.9.5



