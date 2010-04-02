Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0DBTKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:10:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:38673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0DBTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:10:39 -0400
Date: Fri, 2 Apr 2010 19:10:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add Nehalem programming quirk to Westmere
Message-ID: <tip-40b91cd10f000b4c4934e48e2e5c0bec66def144@git.kernel.org>
Git-Commit-ID: 40b91cd10f000b4c4934e48e2e5c0bec66def144
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:10:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40b91cd10f000b4c4934e48e2e5c0bec66def144
Gitweb:     http://git.kernel.org/tip/40b91cd10f000b4c4934e48e2e5c0bec66def144
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 29 Mar 2010 16:37:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:52:06 +0200

perf, x86: Add Nehalem programming quirk to Westmere

According to the Xeon-5600 errata the Westmere suffers the same PMU
programming bug as the original Nehalem did.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1957e3f..f168b40 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -488,6 +488,7 @@ static void intel_pmu_enable_all(int added)
  * Workaround for:
  *   Intel Errata AAK100 (model 26)
  *   Intel Errata AAP53  (model 30)
+ *   Intel Errata BD53   (model 44)
  *
  * These chips need to be 'reset' when adding counters by programming
  * the magic three (non counting) events 0x4300D2, 0x4300B1 and 0x4300B5
@@ -980,6 +981,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
+		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		pr_cont("Westmere events, ");
 		break;
 
