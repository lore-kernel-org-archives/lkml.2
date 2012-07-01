Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2GAE6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 00:58:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53819 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GAE6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 00:58:06 -0400
Message-ID: <1341118680.8998.2.camel@phoenix>
Subject: [PATCH 2/2] pwm: pwm-mxs: Return proper error if pwmchip_remove()
 fails
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Date: Sun, 01 Jul 2012 12:58:00 +0800
In-Reply-To: <1341118620.8998.1.camel@phoenix>
References: <1341118620.8998.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-mxs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index 269d7c2..e585264 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -178,9 +178,7 @@ static int __devexit mxs_pwm_remove(struct platform_device *pdev)
 {
 	struct mxs_pwm_chip *mxs = platform_get_drvdata(pdev);
 
-	pwmchip_remove(&mxs->chip);
-
-	return 0;
+	return pwmchip_remove(&mxs->chip);
 }
 
 static struct of_device_id mxs_pwm_dt_ids[] = {
-- 
1.7.9.5



