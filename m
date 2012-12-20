Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2LTTNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:13:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2LTTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools, power: correct precedence of operators in init_maxfreq_mode
Date: Thu, 20 Dec 2012 14:11:09 -0500
Message-Id: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current code, the condition in the if() doesn't make much sense due to
precedence of operators.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/power/cpupower/utils/idle_monitor/mperf_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index 5650ab5..90a8c4f 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -237,7 +237,7 @@ static int init_maxfreq_mode(void)
 	unsigned long long hwcr;
 	unsigned long min;
 
-	if (!cpupower_cpu_info.caps & CPUPOWER_CAP_INV_TSC)
+	if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_INV_TSC))
 		goto use_sysfs;
 
 	if (cpupower_cpu_info.vendor == X86_VENDOR_AMD) {
-- 
1.8.0

