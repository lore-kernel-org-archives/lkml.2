Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1D1HAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:00:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:39794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1D1HAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:00:30 -0400
Date: Thu, 28 Apr 2011 06:54:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n1eqio7hjpn2dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf event, x86: Use better stalled cycles metric
Git-Commit-ID: 8a850cadca0e387c87a0911a61e99fd66aeb57ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Apr 2011 06:54:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a850cadca0e387c87a0911a61e99fd66aeb57ec
Gitweb:     http://git.kernel.org/tip/8a850cadca0e387c87a0911a61e99fd66aeb57ec
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 28 Apr 2011 11:16:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 Apr 2011 08:39:33 +0200

perf event, x86: Use better stalled cycles metric

Use the UOPS_EXECUTED.*,c=1,i=1 event on Intel CPUs - it is a rather
good indicator of CPU execution stalls, more sensitive and more inclusive
than the 0xa2 resource stalls event (which does not count nearly as many
stall types).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n1eqio7hjpn2dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 067a48b..1ea9422 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1413,8 +1413,8 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
-		/* Install the stalled-cycles event: 0xff: All reasons, 0xa2: Resource stalls */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES] = 0xffa2;
+		/* Install the stalled-cycles event: UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES] = 0x1803fb1;
 
 		if (ebx & 0x40) {
 			/*
