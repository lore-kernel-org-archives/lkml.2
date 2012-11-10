Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2KJBaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:30:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:26777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab2KJB2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="244848912"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 30/32] perf, x86: Add a Haswell precise instructions event v2
Date: Fri,  9 Nov 2012 17:27:46 -0800
Message-Id: <1352510868-7911-31-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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

v2: Use new sysfs infrastructure
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e8fb4e2..d177d88 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2033,6 +2033,7 @@ EVENT_ATTR_STR(cycles-t,       cycles_t,       "event=0x3c,intx=1");
 EVENT_ATTR_STR(cycles-ct,      cycles_ct,      "event=0x3c,intx=1,intx_cp=1");
 EVENT_ATTR_STR(instructions-t, instructions_t, "event=0xc0,intx=1");
 EVENT_ATTR_STR(instructions-ct,instructions_ct,"event=0xc0,intx=1,intx_cp=1");
+EVENT_ATTR_STR(instructions-p, instructions_p, "event=0xc0,umask=0x01,precise=2");
 
 static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(tx_start),
@@ -2053,6 +2054,7 @@ static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(cycles_ct),
 	EVENT_PTR(instructions_t),
 	EVENT_PTR(instructions_ct),
+	EVENT_PTR(instructions_p),
 	NULL
 };
 
-- 
1.7.7.6

