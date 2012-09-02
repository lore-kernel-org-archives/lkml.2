Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2IBKWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:22:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2IBKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:21:21 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] unicore32: pwm: Use module_platform_driver()
Date: Sun,  2 Sep 2012 12:21:09 +0200
Message-Id: <1346581273-7041-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:TbdmiWOBVAbyRzm5imYf8NIFw0xeiYRWrCuXvevqTLu
 lJC5UefPblmmT66p0l4hebbDNeO2geQlBgQ0ubHOTug7Hfcnyg
 08joeNmeJoezaGsmmx6skVGGIdLxSuMmuGu+vbWKRB+inLJv6N
 f3rkTNRpfgdFlOz9c+XehhLqUgb8HDqCFLA8wq4go4+RLMBXnm
 EU3J0b+aqv0kPiO26DaiCjhVXBai/X8LN/5NwIgcJ89tkhzIes
 tS0LaxOP0H39JXPbo4aUXaCItPx2ELOYT/FP/wSB9FlwtWOe/H
 XDtFDIXZ7Sp1mPvCOJ1knx/sfb8zocmarwuBQMX0LEU1KxVMea
 lvW2ReIDq19olwmyhT0pP1j5Gamm1NGFHXk0Zk9TYaZdRANpaS
 seFOKMJBKUe1Y2HkLnIvP3HmrcsM225IJXrqsvKA3Ly++IKsj9
 6QCXO
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
index 410b786..22a7098 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -258,25 +258,6 @@ static struct platform_driver puv3_pwm_driver = {
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

