Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2KWNMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:12:51 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50098 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2KWNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:12:49 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: ondemand: fix wrong delay sampling rate
Date: Fri, 23 Nov 2012 14:12:38 +0100
Message-Id: <1353676358-4385-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the correct delay value for ondemand's od_dbs_timer, as it was
changed erroneously in 83f0e55.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_ondemand.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index bdaab92..cca3e9f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -234,7 +234,8 @@ static void od_dbs_timer(struct work_struct *work)
 			dbs_info->sample_type = OD_SUB_SAMPLE;
 			delay = dbs_info->freq_hi_jiffies;
 		} else {
-			delay = delay_for_sampling_rate(dbs_info->rate_mult);
+			delay = delay_for_sampling_rate(od_tuners.sampling_rate
+						* dbs_info->rate_mult);
 		}
 	}
 
-- 
1.7.12.1

