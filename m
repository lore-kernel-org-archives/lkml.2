Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2HCPkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:40:40 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21921 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910Ab2HCPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:40:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,706,1336341600"; 
   d="scan'208";a="169023108"
From: Damien Cassou <damien.cassou@lifl.fr>
To: David Brown <davidb@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/video/msm/mddi_client_nt35399.c: use devm_ functions
Date: Fri,  3 Aug 2012 17:40:13 +0200
Message-Id: <1344008414-2894-5-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches. This patch replaces the use of kzalloc by devm_kzalloc.

Additionally, this patch fixes a memory leak: some memory was allocated for
'panel' but not released when the subsequent call to setup_vsync fails.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/msm/mddi_client_nt35399.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/msm/mddi_client_nt35399.c b/drivers/video/msm/mddi_client_nt35399.c
index 7fcd67e..66b314e 100644
--- a/drivers/video/msm/mddi_client_nt35399.c
+++ b/drivers/video/msm/mddi_client_nt35399.c
@@ -189,8 +189,9 @@ static int mddi_nt35399_probe(struct platform_device *pdev)

 	int ret;

-	struct panel_info *panel = kzalloc(sizeof(struct panel_info),
-					   GFP_KERNEL);
+	struct panel_info *panel = devm_kzalloc(&pdev->dev,
+						sizeof(struct panel_info),
+						GFP_KERNEL);

 	printk(KERN_DEBUG "%s: enter.\n", __func__);

@@ -233,7 +234,6 @@ static int mddi_nt35399_remove(struct platform_device *pdev)
 	struct panel_info *panel = platform_get_drvdata(pdev);

 	setup_vsync(panel, 0);
-	kfree(panel);
 	return 0;
 }
