Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0KRNBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:01:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab0KRNB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:01:29 -0500
From: Thomas Renninger <trenn@suse.de>
To: j-pihet@ti.com, arjan@linux.intel.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, trenn@suse.de
Subject: [PATCH 1/3] PERF: Do not export power_frequency, but power_start event
Date: Thu, 18 Nov 2010 14:01:24 +0100
Message-Id: <1290085286-9507-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1290085286-9507-1-git-send-email-trenn@suse.de>
References: <1290085286-9507-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_frequency moved to drivers/cpufreq/cpufreq.c which has
to be compiled in, no need to export it.

intel_idle can a be module though...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Jean Pihet <j-pihet@ti.com>
CC: Jean Pihet <j-pihet@ti.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
---
 drivers/idle/intel_idle.c   |    2 --
 kernel/trace/power-traces.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 41665d2..3c95325 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -220,9 +220,7 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
 	kt_before = ktime_get_real();
 
 	stop_critical_timings();
-#ifndef MODULE
 	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
-#endif
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index a22582a..0e0497d 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,5 +13,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
 
-- 
1.6.3

