Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2IDSwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:52:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2IDSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:52:30 -0400
Date: Tue, 4 Sep 2012 11:52:15 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-3ec18cd8b8f8395d0df604c62ab3bc2cf3a966b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <20120820092421.GA11284@quad>
References: <20120820092421.GA11284@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Enable Intel Cedarview Atom suppport
Git-Commit-ID: 3ec18cd8b8f8395d0df604c62ab3bc2cf3a966b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:52:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ec18cd8b8f8395d0df604c62ab3bc2cf3a966b4
Gitweb:     http://git.kernel.org/tip/3ec18cd8b8f8395d0df604c62ab3bc2cf3a966b4
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 20 Aug 2012 11:24:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 17:29:23 +0200

perf/x86: Enable Intel Cedarview Atom suppport

This patch enables perf_events support for Intel Cedarview
Atom (model 54) processors. Support includes PEBS and LBR.
Tested on my Atom N2600 netbook.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120820092421.GA11284@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c     |    1 +
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7f2739e..0d3d63a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2008,6 +2008,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
+	case 54: /* Cedariew */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..da02e9c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -686,7 +686,8 @@ void intel_pmu_lbr_init_atom(void)
 	 * to have an operational LBR which can freeze
 	 * on PMU interrupt
 	 */
-	if (boot_cpu_data.x86_mask < 10) {
+	if (boot_cpu_data.x86_model == 28
+	    && boot_cpu_data.x86_mask < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
