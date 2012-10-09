Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2JIGDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:03:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2JIGDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:35 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 24/30] Thermal: Fix bug on cpu_cooling, cooling device's id conflict problem.
Date: Tue,  9 Oct 2012 01:54:14 -0400
Message-Id: <a4b6fec977020a508ff04b05f0fa01221a4ecf29.1349761836.git.len.brown@intel.com>
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

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

This patch fixes small bug on cpu_cooling. CPU cooling device has own
id generated with idr mathod. However in the previous version, it swapped
to all same id at last stage of probing as 0. This makes id's collision and
also occures error when it releases that id.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/thermal/cpu_cooling.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
1.8.0.rc1

