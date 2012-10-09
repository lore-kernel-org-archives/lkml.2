Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2JIGGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:06:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34159 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2JIGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:33 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        jonghwa lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 22/30] ARM: exynos: add thermal sensor driver platform data support
Date: Tue,  9 Oct 2012 01:54:12 -0400
Message-Id: <17be868e04a1b98d72756ce7b51a95d03e7df49b.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Add necessary default platform data support needed for TMU driver.  The
supplied dt/non-dt values are tested for origen exynos4210 and smdk exynos5250
platforms and only compile tested for exynos4412.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: jonghwa lee <jonghwa3.lee@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/exynos_thermal.c | 111 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index e79cdc9..03a99e4 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -723,14 +723,121 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 static struct thermal_sensor_conf exynos_sensor_conf = {
 	.name			= "exynos-therm",
 	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+};
+
+#if defined(CONFIG_CPU_EXYNOS4210)
+static struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
+	.threshold = 80,
+	.trigger_levels[0] = 5,
+	.trigger_levels[1] = 20,
+	.trigger_levels[2] = 30,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 15,
+	.reference_voltage = 7,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 100,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS4210,
+};
+#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
+#else
+#define EXYNOS4210_TMU_DRV_DATA (NULL)
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
+static struct exynos_tmu_platform_data const exynos_default_tmu_data = {
+	.trigger_levels[0] = 85,
+	.trigger_levels[1] = 103,
+	.trigger_levels[2] = 110,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 8,
+	.reference_voltage = 16,
+	.noise_cancel_mode = 4,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.efuse_value = 55,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 103,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS,
+};
+#define EXYNOS_TMU_DRV_DATA (&exynos_default_tmu_data)
+#else
+#define EXYNOS_TMU_DRV_DATA (NULL)
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_tmu_match[] = {
+	{
+		.compatible = "samsung,exynos4210-tmu",
+		.data = (void *)EXYNOS4210_TMU_DRV_DATA,
+	},
+	{
+		.compatible = "samsung,exynos5250-tmu",
+		.data = (void *)EXYNOS_TMU_DRV_DATA,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_tmu_match);
+#else
+#define  exynos_tmu_match NULL
+#endif
+
+static struct platform_device_id exynos_tmu_driver_ids[] = {
+	{
+		.name		= "exynos4210-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS4210_TMU_DRV_DATA,
+	},
+	{
+		.name		= "exynos5250-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS_TMU_DRV_DATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
+
+static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
+			struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (struct exynos_tmu_platform_data *) match->data;
+	}
+#endif
+	return (struct exynos_tmu_platform_data *)
+			platform_get_device_id(pdev)->driver_data;
 }
-;
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
 	int ret, i;
 
+	if (!pdata)
+		pdata = exynos_get_driver_data(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
@@ -899,9 +1006,11 @@ static struct platform_driver exynos_tmu_driver = {
 		.name   = "exynos-tmu",
 		.owner  = THIS_MODULE,
 		.pm     = EXYNOS_TMU_PM,
+		.of_match_table = exynos_tmu_match,
 	},
 	.probe = exynos_tmu_probe,
 	.remove	= __devexit_p(exynos_tmu_remove),
+	.id_table = exynos_tmu_driver_ids,
 };
 
 module_platform_driver(exynos_tmu_driver);
-- 
1.8.0.rc1

