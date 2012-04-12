Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612Ab2DLSse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:48:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44852 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093Ab2DLSpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:23 -0400
Date: Thu, 12 Apr 2012 20:45:26 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 07/13] s5p-tv: Add initial DT-support for TV mixer
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1334256332-29867-8-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 .../devicetree/bindings/arm/exynos/tvmixer.txt     |   26 ++++++++++++++++++++
 drivers/media/video/s5p-tv/mixer_drv.c             |    9 +++++++
 2 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/exynos/tvmixer.txt

diff --git a/Documentation/devicetree/bindings/arm/exynos/tvmixer.txt b/Documentation/devicetree/bindings/arm/exynos/tvmixer.txt
new file mode 100644
index 0000000..5b4f02e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/exynos/tvmixer.txt
@@ -0,0 +1,26 @@
+* Samsung video/graphics mixer and blender
+
+Mixer blends graphics data from multiple sources and sends resulting
+data to TVOUT module.
+
+
+Required properties:
+
+ - compatible : "samsung,s5pv210-tvmixer"
+ - reg : shall contain memory addresses and sizes of mixer and video
+   processor devices
+ - reg-names : "mxr" for mixer's address/size and "vp" to for video
+   processor's.
+ - interrupt-names : shall contain "irq"
+
+
+Example:
+
+	tvmixer@12c10000 {
+		compatible = "samsung,s5pv210-tvmixer";
+		reg = <0x12c10000 0x10000>,
+		      <0x12c00000 0x10000>;
+		reg-names = "mxr", "vp";
+		interrupts = <0 123 0>;
+		interrupt-names = "irq";
+	};
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index a2c0c25..80b7755 100644
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
1.7.9.1

