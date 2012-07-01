Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab2GAE5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 00:57:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53838 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GAE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 00:57:08 -0400
Message-ID: <1341118620.8998.1.camel@phoenix>
Subject: [PATCH 1/2] pwm: pwm-bfin: Return proper error if pwmchip_remove()
 fails
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 12:57:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-bfin.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-bfin.c b/drivers/pwm/pwm-bfin.c
index a0c6bf9..d53c4e7 100644
--- a/drivers/pwm/pwm-bfin.c
+++ b/drivers/pwm/pwm-bfin.c
@@ -146,9 +146,7 @@ static int __devexit bfin_pwm_remove(struct platform_device *pdev)
 {
 	struct bfin_pwm_chip *pwm = platform_get_drvdata(pdev);
 
-	pwmchip_remove(&pwm->chip);
-
-	return 0;
+	return pwmchip_remove(&pwm->chip);
 }
 
 static struct platform_driver bfin_pwm_driver = {
-- 
1.7.9.5



