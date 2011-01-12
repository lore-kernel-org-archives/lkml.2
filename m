Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1ALHam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:30:42 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:47112 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1ALHak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:30:40 -0500
Date: Wed, 12 Jan 2011 02:30:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        arjan@linux.intel.com, j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: processor_idle: delete use of NOP CPUIDLE_FLAGs
In-reply-to: <alpine.LFD.2.02.1101120159400.19140@x980>
Message-id: <alpine.LFD.2.02.1101120229060.19140@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-6-git-send-email-trenn@suse.de>
 <alpine.LFD.2.02.1101120159400.19140@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

CPUIDLE_FLAG_SHALLOW
CPUIDLE_FLAG_BALANCED
CPUIDLE_FLAG_DEEP
CPUIDLE_FLAG_CHECK_BM

were set by acpi_processor_setup_cpuidle(),
but never used by cpuidle or by acpi_idle.
So stop setting them.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index eefd4aa..70599d2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1023,7 +1023,6 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		state->flags = 0;
 		switch (cx->type) {
 			case ACPI_STATE_C1:
-			state->flags |= CPUIDLE_FLAG_SHALLOW;
 			if (cx->entry_method == ACPI_CSTATE_FFH)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
 
@@ -1032,16 +1031,13 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			break;
 
 			case ACPI_STATE_C2:
-			state->flags |= CPUIDLE_FLAG_BALANCED;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
 			dev->safe_state = state;
 			break;
 
 			case ACPI_STATE_C3:
-			state->flags |= CPUIDLE_FLAG_DEEP;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
-			state->flags |= CPUIDLE_FLAG_CHECK_BM;
 			state->enter = pr->flags.bm_check ?
 					acpi_idle_enter_bm :
 					acpi_idle_enter_simple;
-- 
1.7.4.rc1.7.g2cf08


