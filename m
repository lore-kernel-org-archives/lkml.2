Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2H1Ijy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:39:54 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:33272 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab2H1Ijw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:39:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,325,1344204000"; 
   d="scan'208";a="171022468"
From: Damien Cassou <damien.cassou@lifl.fr>
To: David Brown <davidb@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/msm/mddi_client_dummy.c: use devm_kzalloc function
Date: Tue, 28 Aug 2012 10:39:57 +0200
Message-Id: <1346143197-10038-1-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches. This patch replaces the use of kzalloc by devm_kzalloc.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/msm/mddi_client_dummy.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/msm/mddi_client_dummy.c b/drivers/video/msm/mddi_client_dummy.c
index d2a091c..5faa37f 100644
--- a/drivers/video/msm/mddi_client_dummy.c
+++ b/drivers/video/msm/mddi_client_dummy.c
@@ -51,8 +51,7 @@ static int mddi_dummy_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
 	struct panel_info *panel =
-		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
-	int ret;
+		devm_kzalloc(&pdev->dev, sizeof(struct panel_info), GFP_KERNEL);
 	if (!panel)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, panel);
@@ -67,18 +66,11 @@ static int mddi_dummy_probe(struct platform_device *pdev)
 				      client_data->fb_resource, 1);
 	panel->panel_data.fb_data = client_data->private_client_data;
 	panel->pdev.dev.platform_data = &panel->panel_data;
-	ret = platform_device_register(&panel->pdev);
-	if (ret) {
-		kfree(panel);
-		return ret;
-	}
-	return 0;
+	return platform_device_register(&panel->pdev);
 }

 static int mddi_dummy_remove(struct platform_device *pdev)
 {
-	struct panel_info *panel = platform_get_drvdata(pdev);
-	kfree(panel);
 	return 0;
 }

