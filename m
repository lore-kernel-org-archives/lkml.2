Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2FIMCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:02:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2FIMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:02:39 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] pinctrl: pinctrl-mxs: set platform driver data to NULL at errpath and at unregister
Date: Sat,  9 Jun 2012 17:32:31 +0530
Message-Id: <1339243351-28115-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear the platform data pointer when mxs_pinctrl_probe_dt fails,
and also before the unregistering with pinctrl subsystem.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-mxs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index 9d46303..afb50ee 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -516,6 +516,7 @@ int __devinit mxs_pinctrl_probe(struct platform_device *pdev,
 	return 0;
 
 err:
+	platform_set_drvdata(pdev, NULL);
 	iounmap(d->base);
 	return ret;
 }
@@ -525,6 +526,7 @@ int __devexit mxs_pinctrl_remove(struct platform_device *pdev)
 {
 	struct mxs_pinctrl_data *d = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
 	pinctrl_unregister(d->pctl);
 	iounmap(d->base);
 
-- 
1.7.9.5

