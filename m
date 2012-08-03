Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2HCPki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:40:38 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:43437 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab2HCPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:40:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,706,1336341600"; 
   d="scan'208";a="169023109"
From: Damien Cassou <damien.cassou@lifl.fr>
To: David Brown <davidb@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/video/msm/mddi_client_dummy.c: use devm_ functions
Date: Fri,  3 Aug 2012 17:40:14 +0200
Message-Id: <1344008414-2894-6-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches. This patch replaces the use of kzalloc by devm_kzalloc.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/msm/mddi_client_dummy.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/video/msm/mddi_client_dummy.c b/drivers/video/msm/mddi_client_dummy.c
index d2a091c..4c31325 100644
--- a/drivers/video/msm/mddi_client_dummy.c
+++ b/drivers/video/msm/mddi_client_dummy.c
@@ -51,7 +51,7 @@ static int mddi_dummy_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
 	struct panel_info *panel =
-		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
+		devm_kzalloc(&pdev->dev, sizeof(struct panel_info), GFP_KERNEL);
 	int ret;
 	if (!panel)
 		return -ENOMEM;
@@ -67,18 +67,11 @@ static int mddi_dummy_probe(struct platform_device *pdev)
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
