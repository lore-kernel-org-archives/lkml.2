Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GHGU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:20:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1GHGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:20:54 -0400
Subject: [PATCH 1/2] cpufreq: exynos4210: make needlessly global symbols
 static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 14:20:44 +0800
Message-ID: <1310106044.27158.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are needlessly defined global:
  exynos4_verify_speed
  exynos4_getspeed
  exynos4_set_clkdiv

Make them static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/exynos4210-cpufreq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index 54025fc..b7c3a84 100644
--- a/drivers/cpufreq/exynos4210-cpufreq.c
+++ b/drivers/cpufreq/exynos4210-cpufreq.c
@@ -191,17 +191,17 @@ static unsigned int exynos4_apll_pms_table[CPUFREQ_LEVEL_END] = {
 	((200 << 16) | (6 << 8) | 4),
 };
 
-int exynos4_verify_speed(struct cpufreq_policy *policy)
+static int exynos4_verify_speed(struct cpufreq_policy *policy)
 {
 	return cpufreq_frequency_table_verify(policy, exynos4_freq_table);
 }
 
-unsigned int exynos4_getspeed(unsigned int cpu)
+static unsigned int exynos4_getspeed(unsigned int cpu)
 {
 	return clk_get_rate(cpu_clk) / 1000;
 }
 
-void exynos4_set_clkdiv(unsigned int div_index)
+static void exynos4_set_clkdiv(unsigned int div_index)
 {
 	unsigned int tmp;
 
-- 
1.7.4.1



