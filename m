Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab1D0P7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:59:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:59953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0P7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:59:19 -0400
Date: Wed, 27 Apr 2011 15:59:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-wpqwwvmhxucy5e718wnamjiv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf events, x86: Mark constrant tables read mostly
Git-Commit-ID: 5c543e3c442d6382db127152c7096ca6a55283de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:59:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c543e3c442d6382db127152c7096ca6a55283de
Gitweb:     http://git.kernel.org/tip/5c543e3c442d6382db127152c7096ca6a55283de
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 12:02:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:53 +0200

perf events, x86: Mark constrant tables read mostly

Various constraint tables were not marked read-mostly.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-wpqwwvmhxucy5e718wnamjiv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index efa2704..067a48b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -36,7 +36,7 @@ static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
-static struct event_constraint intel_core_event_constraints[] =
+static struct event_constraint intel_core_event_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -47,7 +47,7 @@ static struct event_constraint intel_core_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_core2_event_constraints[] =
+static struct event_constraint intel_core2_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -70,7 +70,7 @@ static struct event_constraint intel_core2_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_event_constraints[] =
+static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -86,19 +86,19 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct extra_reg intel_nehalem_extra_regs[] =
+static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_nehalem_percore_constraints[] =
+static struct event_constraint intel_nehalem_percore_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0xb7, 0),
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_westmere_event_constraints[] =
+static struct event_constraint intel_westmere_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -110,7 +110,7 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_snb_event_constraints[] =
+static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -123,21 +123,21 @@ static struct event_constraint intel_snb_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct extra_reg intel_westmere_extra_regs[] =
+static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_westmere_percore_constraints[] =
+static struct event_constraint intel_westmere_percore_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0xb7, 0),
 	INTEL_EVENT_CONSTRAINT(0xbb, 0),
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_gen_event_constraints[] =
+static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
