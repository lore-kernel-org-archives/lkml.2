Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab2LZVnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 16:43:04 -0500
Received: from mail-ye0-f171.google.com ([209.85.213.171]:50137 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2LZVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 16:42:59 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 16:42:59 EST
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] cpufreq: exynos: Add the missing cpufreq_cpu_put function
Date: Wed, 26 Dec 2012 13:35:34 -0800
Message-Id: <1356557734-15640-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing cpufreq_cpu_put function needed for
returning the cpufreq policy instance.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7012ea8..a2b7adc 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -208,6 +208,7 @@ static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
 	}
 out:
 	mutex_unlock(&cpufreq_lock);
+	cpufreq_cpu_put(policy);
 
 	return NOTIFY_OK;
 }
-- 
1.7.5.4

