Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2HDQvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:51:37 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:63697
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab2HDQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:51:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152439853"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drivers/video/backlight/da9052_bl.c: drop devm_kfree of devm_kzalloc'd data
Date: Sat,  4 Aug 2012 18:50:48 +0200
Message-Id: <1344099049-15212-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kfree should not have to be explicitly used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/backlight/da9052_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index b628d68..7c8626a 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -129,7 +129,6 @@ static int da9052_backlight_probe(struct platform_device *pdev)
 				       &da9052_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "Failed to register backlight\n");
-		devm_kfree(&pdev->dev, wleds);
 		return PTR_ERR(bl);
 	}
 
@@ -149,7 +148,6 @@ static int da9052_backlight_remove(struct platform_device *pdev)
 	wleds->state = DA9052_WLEDS_OFF;
 	da9052_adjust_wled_brightness(wleds);
 	backlight_device_unregister(bl);
-	devm_kfree(&pdev->dev, wleds);
 
 	return 0;
 }

