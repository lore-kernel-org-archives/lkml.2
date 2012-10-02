Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2JBXvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:51:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:31357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab2JBXtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="200845784"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 31/31] perf, x86: Add a Haswell precise instructions event
Date: Tue,  2 Oct 2012 16:48:51 -0700
Message-Id: <1349221731-15665-32-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a instructions-p event alias that uses the PDIR randomized instruction
retirement event. This is useful to avoid some systematic sampling shadow
problems. Normally PEBS sampling has a systematic shadow. With PDIR
enabled the hardware adds some randomization that statistically avoids
this problem. In this sense, it's more precise over a whole sampling
interval, but an individual sample can be less precise. But since we
sample overall it's a more precise event.

This could be used before using the explicit event code syntax, but it's easier
and more user friendly to use with an "instructions-p" alias. I expect
this will eventually become a common use case.

Right now for Haswell, will add to Ivy Bridge later too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 67b7095..28534ae 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2085,6 +2085,7 @@ PMU_EVENT(cycles_t,       "cycles-t",       "event=0x3c,intx=1");
 PMU_EVENT(cycles_ct,      "cycles-ct",      "event=0x3c,intx=1,intx_cp=1");
 PMU_EVENT(insns_t,        "instructions-t", "event=0xc0,intx=1");
 PMU_EVENT(insns_ct,       "instructions-ct","event=0xc0,intx=1,intx_cp=1");
+PMU_EVENT(insns_prec,     "instructions-p", "event=0xc0,umask=0x01,precise=2");
 
 #define PMU_EVENT_PTR(x) &attr_ ## x .attr.attr
 
@@ -2107,6 +2108,7 @@ static struct attribute *hsw_events_attrs[] = {
 	PMU_EVENT_PTR(cycles_ct),
 	PMU_EVENT_PTR(insns_t),
 	PMU_EVENT_PTR(insns_ct),
+	PMU_EVENT_PTR(insns_prec),
 	NULL
 };
 
-- 
1.7.7.6

