Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab2DLStV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:49:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50961 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762214Ab2DLSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 12 Apr 2012 20:45:22 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 03/13] s5p-g2d: Make it possible to instantiate driver from DT
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1334256332-29867-4-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.1
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver requires standard properties like (address and irq)
which are automatically marshalled for drivers by OF core.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/arm/trivial-devices.txt    |    1 +
 drivers/media/video/s5p-g2d/g2d.c                  |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/trivial-devices.txt b/Documentation/devicetree/bindings/arm/trivial-devices.txt
index 443814a..d0f6c45 100644
--- a/Documentation/devicetree/bindings/arm/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/arm/trivial-devices.txt
@@ -8,3 +8,4 @@ document for it just like any other devices.
 
 Compatible                      Vendor / Chip
 ========================        =============
+samsung,s5pv210-g2d		2D graphics accelerator found on s5pv210+ SoCs
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..96fd584 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -832,12 +833,21 @@ static int g2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id g2d_dt_match[] = {
+	{ .compatible = "samsung,s5pv210-g2d" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, g2d_dt_match);
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
1.7.9.1

