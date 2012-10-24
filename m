Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2JXL7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:59:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58687 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304Ab2JXL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:59:08 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V2 2/6] Thermal: make sure cpufreq cooling register after cpufreq driver
Date: Wed, 24 Oct 2012 19:58:16 +0800
Message-Id: <1351079900-32236-3-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
 <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

The cpufreq works as a cooling device, so the cooling layer should check if the
cpufreq driver is initialized or not.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/cpu_cooling.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index b6b4c2a..7519a0b 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -354,6 +354,10 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	int ret = 0, i;
 	struct cpufreq_policy policy;
 
+	/* make sure cpufreq driver has been initialized */
+	if (!cpufreq_frequency_get_table(cpumask_any(clip_cpus)))
+		return ERR_PTR(-EPROBE_DEFER);
+
 	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
 		cpufreq_dev_count++;
 
-- 
1.7.11.3

