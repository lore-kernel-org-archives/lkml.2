Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1ADI07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:26:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:59259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1ADI06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:26:58 -0500
Date: Tue, 4 Jan 2011 08:26:31 GMT
From: tip-bot for Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jean.pihet@newoldbits.com, arjan@linux.intel.com, j-pihet@ti.com,
        tglx@linutronix.de, trenn@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jean.pihet@newoldbits.com, arjan@linux.intel.com, j-pihet@ti.com,
        tglx@linutronix.de, trenn@suse.de, mingo@elte.hu
In-Reply-To: <1290072314-31155-2-git-send-email-trenn@suse.de>
References: <1294073445-14812-2-git-send-email-trenn@suse.de>
	<1290072314-31155-2-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Do not export power_frequency, but power_start event
Message-ID: <tip-61a0d49c33c7fd57c14895e5b0760bd02b65ac1f@git.kernel.org>
Git-Commit-ID: 61a0d49c33c7fd57c14895e5b0760bd02b65ac1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:26:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61a0d49c33c7fd57c14895e5b0760bd02b65ac1f
Gitweb:     http://git.kernel.org/tip/61a0d49c33c7fd57c14895e5b0760bd02b65ac1f
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Mon, 3 Jan 2011 17:50:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Jan 2011 08:16:54 +0100

perf: Do not export power_frequency, but power_start event

power_frequency moved to drivers/cpufreq/cpufreq.c which has
to be compiled in, no need to export it.

intel_idle can a be module though...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Jean Pihet <j-pihet@ti.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: rjw@sisk.pl
LKML-Reference: <1294073445-14812-2-git-send-email-trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1290072314-31155-2-git-send-email-trenn@suse.de>
---
 drivers/idle/intel_idle.c   |    2 --
 kernel/trace/power-traces.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index c131d58..15783d5 100644
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
 
