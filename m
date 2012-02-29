Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031089Ab2B2OwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:52:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41400 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2B2OwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:52:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 29 Feb 2012 15:51:47 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 3/3] [media] s5p-tv: Add initial DT-support for TV mixer
In-reply-to: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
To: t.stanislaws@samsung.com
Cc: m.szyprowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        thomas.abraham@linaro.org,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1330527107-21222-4-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
References: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/media/video/s5p-tv/mixer_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index a2c0c25..6bf4a9e 100644
--- a/drivers/media/video/s5p-tv/mixer_drv.c
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -448,6 +448,14 @@ static int __devexit mxr_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id mxr_dt_match[] = {
+	{ .compatible = "samsung,exynos4210-tvmixer" },
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
1.7.8.3

