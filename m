Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1AGKbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:31:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:43264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1AGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:08 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] acpi: Use ACPI C-state type instead of enumeration value to export cpuidle state name
Date: Fri,  7 Jan 2011 11:29:42 +0100
Message-Id: <1294396190-23031-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the former /proc/acpi/processor/power/* there were Cx showing the
enumerated number/amount of C-states and type[Cy] which is
what should get shown as the cpuidle state name.

Typically on latest Nehalem and later CPUs, BIOS vendors miss
out C2 and C3 wrongly shows up as C2.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: arjan@linux.intel.com
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/acpi/processor_idle.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index dcb38f8..104ae77 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1008,7 +1008,6 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 #endif
 		cpuidle_set_statedata(state, cx);
 
-		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = cx->latency;
 		state->target_residency = cx->latency * latency_factor;
@@ -1016,6 +1015,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		state->flags = 0;
 		switch (cx->type) {
 			case ACPI_STATE_C1:
+			snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
 			state->flags |= CPUIDLE_FLAG_SHALLOW;
 			if (cx->entry_method == ACPI_CSTATE_FFH)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
@@ -1025,6 +1025,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			break;
 
 			case ACPI_STATE_C2:
+			snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
 			state->flags |= CPUIDLE_FLAG_BALANCED;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
@@ -1032,6 +1033,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			break;
 
 			case ACPI_STATE_C3:
+			snprintf(state->name, CPUIDLE_NAME_LEN, "C3");
 			state->flags |= CPUIDLE_FLAG_DEEP;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->flags |= CPUIDLE_FLAG_CHECK_BM;
-- 
1.7.3.1

