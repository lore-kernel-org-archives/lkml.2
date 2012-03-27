Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2C0PhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:37:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2C0PhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:37:01 -0400
Date: Tue, 27 Mar 2012 08:36:48 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-n6vf6grjv94vnzvuccu0clcv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, stable@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        stable@kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Add SNB offcore event constraints
Git-Commit-ID: c370117c978adba861fad467427a9301c2c7082b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 27 Mar 2012 08:36:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c370117c978adba861fad467427a9301c2c7082b
Gitweb:     http://git.kernel.org/tip/c370117c978adba861fad467427a9301c2c7082b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 22 Mar 2012 11:41:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 27 Mar 2012 14:53:46 +0200

perf/x86: Add SNB offcore event constraints

As found in the Intel SDM (March 2012 edition) in Volume 3
section 18.8.5, the offcore response events are constrained
to PMC0 and PMC3 resp..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/n/tip-n6vf6grjv94vnzvuccu0clcv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 26b3e2f..bab8c6d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -96,12 +96,14 @@ static struct event_constraint intel_westmere_event_constraints[] __read_mostly
 
 static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 {
-	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
-	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
-	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4),	/* L1D_PEND_MISS.PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2),	/* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),	/* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	INTEL_UEVENT_CONSTRAINT(0x01b7, 0x1),	/* OFFCORE_RSP_0 */
+	INTEL_UEVENT_CONSTRAINT(0x01bb, 0x8),	/* OFFCORE_RSP_1 */
 	EVENT_CONSTRAINT_END
 };
 
