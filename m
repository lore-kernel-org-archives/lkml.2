Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1GHGYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:24:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43441 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1GHGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:24:41 -0400
Subject: [PATCH 2/2] cpufreq: s5pv210: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
In-Reply-To: <1310106044.27158.0.camel@phoenix>
References: <1310106044.27158.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 14:24:36 +0800
Message-ID: <1310106276.27158.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are needlessly defined global:
  s5pv210_verify_speed
  s5pv210_getspeed

Make them static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/s5pv210-cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index a7cb338..806408e 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -121,7 +121,7 @@ static void s5pv210_set_refresh(enum s5pv210_dmc_port ch, unsigned long freq)
 	__raw_writel(tmp1, reg);
 }
 
-int s5pv210_verify_speed(struct cpufreq_policy *policy)
+static int s5pv210_verify_speed(struct cpufreq_policy *policy)
 {
 	if (policy->cpu)
 		return -EINVAL;
@@ -129,7 +129,7 @@ int s5pv210_verify_speed(struct cpufreq_policy *policy)
 	return cpufreq_frequency_table_verify(policy, s5pv210_freq_table);
 }
 
-unsigned int s5pv210_getspeed(unsigned int cpu)
+static unsigned int s5pv210_getspeed(unsigned int cpu)
 {
 	if (cpu)
 		return 0;
-- 
1.7.4.1



