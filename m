Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1LUKYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:24:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1LUKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:24:36 -0500
Date: Wed, 21 Dec 2011 02:24:14 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-9c1497ea591b25d491f8e795f90a1405100b75ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323559734-3488-4-git-send-email-eranian@google.com>
References: <1323559734-3488-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events:
  Add Intel x86 mapping for PERF_COUNT_HW_REF_CPU_CYCLES
Git-Commit-ID: 9c1497ea591b25d491f8e795f90a1405100b75ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 02:24:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c1497ea591b25d491f8e795f90a1405100b75ef
Gitweb:     http://git.kernel.org/tip/9c1497ea591b25d491f8e795f90a1405100b75ef
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sun, 11 Dec 2011 00:28:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:26:39 +0100

perf events: Add Intel x86 mapping for PERF_COUNT_HW_REF_CPU_CYCLES

Add event maps for Intel x86 processors (with architected PMU v2 or later).

On AMD, there is frequency scaling but no Turbo. There is no core
cycle event not subject to frequency scaling, therefore we do not
provide a mapping.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323559734-3488-4-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 61f865f..cbfaaa2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -28,6 +28,7 @@ static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+  [PERF_COUNT_HW_REF_CPU_CYCLES]	= 0x0300, /* pseudo-encoding */
 };
 
 static struct event_constraint intel_core_event_constraints[] __read_mostly =
