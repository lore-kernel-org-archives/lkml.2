Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1LJX3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:29:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1LJX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:28:49 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: [PATCH 3/4] perf_events: add Intel X86 mapping for PERF_COUNT_HW_REF_CPU_CYCLES
Date: Sun, 11 Dec 2011 00:28:53 +0100
Message-Id: <1323559734-3488-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323559734-3488-1-git-send-email-eranian@google.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add event mapps for Intel X86 processors (with architected PMU v2 or later)
and AMD.

On AMD, there is frequency scaling but no Turbo. There is no core
cycle event not subject to frequency scaling, therefore we do not provide
a mapping.

Signed-off-by: Stephane Eranian <eranian@google.com>
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
-- 
1.7.1

