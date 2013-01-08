Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3AHKvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:51:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65078 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3AHKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:51:12 -0500
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: rjw@sisk.pl, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH] cpufreq: exynos: Show list of available frequencies
Date: Tue,  8 Jan 2013 16:20:58 +0530
Message-Id: <1357642258-32421-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add freq_attr attribute to show list of available frequencies.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7012ea8..bc1e833 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -244,13 +244,26 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
 }
 
+static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+static struct freq_attr *exynos_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= exynos_verify_speed,
 	.target		= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
+	.exit           = exynos_cpufreq_cpu_exit,
 	.name		= "exynos_cpufreq",
+	.attr           = exynos_cpufreq_attr,
 #ifdef CONFIG_PM
 	.suspend	= exynos_cpufreq_suspend,
 	.resume		= exynos_cpufreq_resume,
-- 
1.7.9.5

