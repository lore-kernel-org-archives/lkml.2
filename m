Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1J0DF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 23:05:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61438 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1J0DFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 23:05:55 -0400
Message-ID: <1319684744.4598.1.camel@phoenix>
Subject: [PATCH RESEND] cpufreq: db8500: remove unneeded for loop iteration
 for freq_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, cpufreq@vger.kernel.org
Date: Thu, 27 Oct 2011 11:05:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We alread did policy->cur = db8500_cpufreq_getspeed(policy->cpu);
Don't know why to do the loop iteration here. It looks useless.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/db8500-cpufreq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index 0da1625..5713f70 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -105,7 +105,6 @@ static unsigned int db8500_cpufreq_getspeed(unsigned int cpu)
 static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int res;
-	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(idx2opp) + 1 != ARRAY_SIZE(freq_table));
 
@@ -128,10 +127,6 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
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
1.7.5.4



