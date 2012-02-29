Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2B2NzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:55:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58009 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030583Ab2B2NzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:55:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 29 Feb 2012 14:54:32 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] [media] s5p-g2d: Make it possible to instantiate driver from DT
To: k.debski@samsung.com
Cc: m.szyprowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1330523672-16453-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver requires standard properties only (address and irq)
which are automatically marshalled into plain old resources by OF core.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index febaa67..e7c0020 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -795,12 +796,20 @@ static int g2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id g2d_dt_match[] = {
+	{ .compatible = "samsung,exynos4210-g2d" },
+	{},
+};
+#endif
+
 static struct platform_driver g2d_pdrv = {
 	.probe		= g2d_probe,
 	.remove		= g2d_remove,
 	.driver		= {
 		.name = G2D_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(g2d_dt_match),
 	},
 };
 
-- 
1.7.8.3

