Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2GFG35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:29:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2GFG3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:29:55 -0400
Date: Thu, 5 Jul 2012 23:29:34 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-vsevd5g8lhcn129n3s7trl7r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, bp@amd64.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, bp@amd64.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Save a few bytes in 'struct x86_pmu'
Git-Commit-ID: 3e0091e2b6f8cd59e567f247e345a3a6ad1f6e7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:29:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e0091e2b6f8cd59e567f247e345a3a6ad1f6e7e
Gitweb:     http://git.kernel.org/tip/3e0091e2b6f8cd59e567f247e345a3a6ad1f6e7e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 Jun 2012 23:38:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:55:58 +0200

perf/x86: Save a few bytes in 'struct x86_pmu'

All these are basically boolean flags, use a bitfield to save a few
bytes.

Suggested-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-vsevd5g8lhcn129n3s7trl7r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3f5c669..a15df4b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -374,8 +374,11 @@ struct x86_pmu {
 	/*
 	 * Intel DebugStore bits
 	 */
-	int		bts, pebs;
-	int		bts_active, pebs_active, pebs_broken;
+	int		bts		:1,
+			bts_active	:1,
+			pebs		:1,
+			pebs_active	:1,
+			pebs_broken	:1;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
