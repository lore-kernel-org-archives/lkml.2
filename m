Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2GaR4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:56:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2GaR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:56:54 -0400
Date: Tue, 31 Jul 2012 10:56:39 -0700
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
Message-ID: <tip-h84qlqj02zrojmxxybzmy9hi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        zheng.z.yan@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore:
  Make UNCORE_PMU_HRTIMER_INTERVAL 64-bit
Git-Commit-ID: 7740dfc0363a70546ef25c0383aca252f95a91d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jul 2012 10:56:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7740dfc0363a70546ef25c0383aca252f95a91d2
Gitweb:     http://git.kernel.org/tip/7740dfc0363a70546ef25c0383aca252f95a91d2
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Sat, 21 Jul 2012 10:53:46 +1000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 31 Jul 2012 17:02:03 +0200

perf/x86/intel/uncore: Make UNCORE_PMU_HRTIMER_INTERVAL 64-bit

i386 allmodconfig:

 arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_hrtimer':
 arch/x86/kernel/cpu/perf_event_intel_uncore.c:728: warning: integer overflow in expression
 arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_start_hrtimer':
 arch/x86/kernel/cpu/perf_event_intel_uncore.c:735: warning: integer overflow in expression

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-h84qlqj02zrojmxxybzmy9hi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index f385189..c9e5dc5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -5,7 +5,7 @@
 #include "perf_event.h"
 
 #define UNCORE_PMU_NAME_LEN		32
-#define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
+#define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
