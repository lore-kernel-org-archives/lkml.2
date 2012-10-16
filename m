Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2JPLqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:46:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab2JPLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:46:41 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH 3/5] Thermal: fix empty list checking method.
Date: Tue, 16 Oct 2012 19:44:47 +0800
Message-Id: <1350387889-15324-4-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

Is is not reliable to check the list entry pointer after
list_for_each_entry loop, list_empty should be used instead.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/cpu_cooling.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index b6b4c2a..d196230 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -247,12 +247,13 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 	struct cpufreq_frequency_table *table;
 
 	mutex_lock(&cooling_cpufreq_lock);
+	if (list_empty(&cooling_cpufreq_list))
+		goto return_get_max_state;
+
 	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
 		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
 			break;
 	}
-	if (cpufreq_device == NULL)
-		goto return_get_max_state;
 
 	maskPtr = &cpufreq_device->allowed_cpus;
 	cpu = cpumask_any(maskPtr);
-- 
1.7.11.3

