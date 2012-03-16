Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423020Ab2CPPmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:42:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60850 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332Ab2CPPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:42:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 16 Mar 2012 16:42:11 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/2] s5p-tv: Add initial DT-support for TV mixer
In-reply-to: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
To: t.stanislaws@samsung.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331912532-7798-2-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9
References: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index 0064309..2eb48ea 100644
--- a/drivers/media/video/s5p-tv/mixer_drv.c
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -448,6 +448,14 @@ static int __devexit mxr_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id mxr_dt_match[] = {
+	{ .compatible = "samsung,s5pv210-tvmixer" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, mxr_dt_match);
+#endif
+
 static struct platform_driver mxr_driver __refdata = {
 	.probe = mxr_probe,
 	.remove = __devexit_p(mxr_remove),
@@ -455,6 +463,7 @@ static struct platform_driver mxr_driver __refdata = {
 		.name = MXR_DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &mxr_pm_ops,
+		.of_match_table = of_match_ptr(mxr_dt_match),
 	}
 };
 
-- 
1.7.9

