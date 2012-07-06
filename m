Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2GFGbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:31:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GFGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:31:32 -0400
Date: Thu, 5 Jul 2012 23:31:21 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-3b19e4c98c035c9ab218fc64ef26f4f7a30eafb9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1340866596-22502-2-git-send-email-zheng.z.yan@intel.com>
References: <1340866596-22502-2-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix event constraint for SandyBridge-EP C-Box
Git-Commit-ID: 3b19e4c98c035c9ab218fc64ef26f4f7a30eafb9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:31:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b19e4c98c035c9ab218fc64ef26f4f7a30eafb9
Gitweb:     http://git.kernel.org/tip/3b19e4c98c035c9ab218fc64ef26f4f7a30eafb9
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Thu, 28 Jun 2012 14:56:36 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:55:59 +0200

perf/x86: Fix event constraint for SandyBridge-EP C-Box

The constraint for C-Box event 0x1f should have overlap flag set.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340866596-22502-2-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c42a3f7..7d755d2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -239,7 +239,7 @@ static struct event_constraint snbep_uncore_cbox_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x1c, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1d, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1e, 0xc),
-	UNCORE_EVENT_CONSTRAINT(0x1f, 0xe),
+	EVENT_CONSTRAINT_OVERLAP(0x1f, 0xe, 0xff),
 	UNCORE_EVENT_CONSTRAINT(0x21, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x31, 0x3),
