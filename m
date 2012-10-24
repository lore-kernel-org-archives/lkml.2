Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab2JXKBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:01:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2JXKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:00:58 -0400
Date: Wed, 24 Oct 2012 02:59:38 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-7991c9ca40d3127dd2ffa3a9c1e33f7d4005495a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210191728570.14552@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210191728570.14552@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix P6 FP_ASSIST event constraint
Git-Commit-ID: 7991c9ca40d3127dd2ffa3a9c1e33f7d4005495a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:59:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7991c9ca40d3127dd2ffa3a9c1e33f7d4005495a
Gitweb:     http://git.kernel.org/tip/7991c9ca40d3127dd2ffa3a9c1e33f7d4005495a
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 19 Oct 2012 17:30:01 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:31:57 +0200

perf/x86: Fix P6 FP_ASSIST event constraint

According to Intel SDM Volume 3B, FP_ASSIST is limited to Counter 1 only,
not Counter 0.

Tested on a Pentium II.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210191728570.14552@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_p6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index e4dd0f7..0ff5f7f 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -34,7 +34,7 @@ static struct event_constraint p6_event_constraints[] =
 {
 	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
 	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
 	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
