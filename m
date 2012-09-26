Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2IZAno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:43:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56018 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2IZAnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:43:42 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-00-50624fb85b38
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] Thermal: Fix bug on cpu_cooling,
 cooling device's id conflict problem.
Date: Wed, 26 Sep 2012 09:43:31 +0900
Message-id: <1348620211-1409-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jAd0d/kkBBqeO6Ftc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ6m0+yF3zjrJi+4yZTA+MCji5GTg4JAROJC2v2M0PY
	YhIX7q1n62Lk4hASWMQosa5lGiuE08Ik0fphOxNIFZuAjsT/fTfZQWwRARmJqVf2gxUxC7Qx
	Sfy91sTSxcjBISwQKfF0sQ1IDYuAqkTD9W9g9bwC7hKNc5sZIbYpSCy495ZtAiP3AkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjB3nwmtYNxZYPFIUYBDkYlHt6GX4kBQqyJZcWVuYcY
	JTiYlUR4jZ8DhXhTEiurUovy44tKc1KLDzFKc7AoifMKfwoMEBJITyxJzU5NLUgtgskycXBK
	NTDOev0lPE+n88sukdc+c1mY81aIre/4/5p7XfyWoCuyXHOlpF8f5zPJmPn32UKmb9Ev/tpt
	nyTG25Y72Y8z+PuTA+G97mJt39jtElq4hYx//Lj9kvtp5TGJbyc7nfW07FNKt6/5zcbLoz7l
	OseSCstIKTu+Wf8MlqS3MUR8cNipKPzUZ41v0hYlluKMREMt5qLiRACfRdNu4gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes small bug on cpu_cooling. CPU cooling device has own
id generated with idr mathod. However in the previous version, it swapped
to all same id at last stage of probing as 0. This makes id's collision and
also occures error when it releases that id.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/thermal/cpu_cooling.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 99a5d75..9050c1b 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -351,7 +351,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
 	unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
 	char dev_name[THERMAL_NAME_LENGTH];
-	int ret = 0, id = 0, i;
+	int ret = 0, i;
 	struct cpufreq_policy policy;
 
 	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
@@ -396,7 +396,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 		kfree(cpufreq_dev);
 		return ERR_PTR(-EINVAL);
 	}
-	cpufreq_dev->id = id;
 	cpufreq_dev->cool_dev = cool_dev;
 	cpufreq_dev->cpufreq_state = 0;
 	mutex_lock(&cooling_cpufreq_lock);
-- 
1.7.4.1

