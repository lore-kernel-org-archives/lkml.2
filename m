Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1I0HLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:11:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47251 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1I0HLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:11:52 -0400
Subject: [RFC][PATCH] cpufreq: db8500: remove unneeded for loop iteration
 over freq_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 15:11:42 +0800
Message-ID: <1317107502.2327.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't know why to do the loop iteration here. It looks unneeded.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/db8500-cpufreq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index d90456a..bdb349a 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -104,7 +104,6 @@ static unsigned int db8500_cpufreq_getspeed(unsigned int cpu)
 static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int res;
-	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(idx2opp) + 1 != ARRAY_SIZE(freq_table));
 
@@ -127,10 +126,6 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
 	policy->cur = db8500_cpufreq_getspeed(policy->cpu);
-
-	for (i = 0; freq_table[i].frequency != policy->cur; i++)
-		;
-
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 
 	/*
-- 
1.7.4.1



