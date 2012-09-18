Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2IRIYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:24:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2IRIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:24:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] unicore32: pwm: Use module_platform_driver()
Date: Tue, 18 Sep 2012 10:23:50 +0200
Message-Id: <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:U/Ln3rQ+nNz69qPat4dm+1kkJr5U0tZVOssoqyFTXOd
 eDEEUzvz/7SC62+PEAij8SnC2FtQIfm5e34YcRPXbxl79/8jQ3
 KM0nmpmqPCFmOjQP7sLZhN1xhlvCbn/MpIsXZaYM++fqoloiLN
 zkU/PTVTXcoX5Gmg9wSPypXFHGiCVpoGSPUr9U2YMKip6owgGn
 QdcAJDm8UvMVZL4+3crHuHopi6yq69xEz9ht4LpSqhGG0vBnE8
 ocEK2k7imNvv30oEWipk2g29PyCllWruc7peCe8qarHpKgNIWx
 d4ibe4Bqny2zLRAYvE9TJZWv19EL5rn9twi0xOeR8vr1IErCsQ
 6GwRExRiUw3bCQSiUVTGHYVYUXFir7ib4q6agmR//2C+0+L+Z9
 C3g51k3YbY7a17uFE1dvMNskRSEKbXgUZSIGWWlnfoJFXygUQp
 0wtYO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the boilerplate code can be eliminated by using this macro. The
driver was previously registered with an arch_initcall(), so technically
this is no longer the same, but when the driver is moved to the PWM
framework, deferred probing will take care of any driver probe ordering
issues.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/unicore32/kernel/pwm.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
index 885bbcd..012c54a 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -254,25 +254,6 @@ static struct platform_driver puv3_pwm_driver = {
 	.probe		= puv3_pwm_probe,
 	.remove		= __devexit_p(pwm_remove),
 };
-
-static int __init pwm_init(void)
-{
-	int ret = 0;
-
-	ret = platform_driver_register(&puv3_pwm_driver);
-	if (ret) {
-		printk(KERN_ERR "failed to register puv3_pwm_driver\n");
-		return ret;
-	}
-
-	return ret;
-}
-arch_initcall(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&puv3_pwm_driver);
-}
-module_exit(pwm_exit);
+module_platform_driver(puv3_pwm_driver);
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.12

