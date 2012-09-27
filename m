Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2I0HjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:39:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab2I0HjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:39:03 -0400
Date: Thu, 27 Sep 2012 00:38:50 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-402537fd9f5499d1a50a6f20cdd9031d24ee2e47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1348709606-2759-1-git-send-email-zheng.z.yan@intel.com>
References: <1348709606-2759-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix typo in uncore_pmu_to_box
Git-Commit-ID: 402537fd9f5499d1a50a6f20cdd9031d24ee2e47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 00:38:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  402537fd9f5499d1a50a6f20cdd9031d24ee2e47
Gitweb:     http://git.kernel.org/tip/402537fd9f5499d1a50a6f20cdd9031d24ee2e47
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Thu, 27 Sep 2012 09:33:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 08:05:13 +0200

perf/x86: Fix typo in uncore_pmu_to_box

The variable box should not be declared as static.

This could probably cause crashes with sufficiently parallel
uncore PMU use.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Cc: eranian@google.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/1348709606-2759-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 38e4894..c7c55e7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1950,7 +1950,7 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
 static struct intel_uncore_box *
 uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
-	static struct intel_uncore_box *box;
+	struct intel_uncore_box *box;
 
 	box = *per_cpu_ptr(pmu->box, cpu);
 	if (box)
