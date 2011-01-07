Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1AGKaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:30:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:43274 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab1AGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:08 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] acpi: processor->cpuidle: Only set cpuidle check_bm flag if pr->flags.bm_check is set
Date: Fri,  7 Jan 2011 11:29:46 +0100
Message-Id: <1294396190-23031-6-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
---
 drivers/acpi/processor_idle.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b28693e..82f74c9 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1039,7 +1039,8 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C3");
 			state->flags |= CPUIDLE_FLAG_DEEP;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
-			state->flags |= CPUIDLE_FLAG_CHECK_BM;
+			if (pr->flags.bm_check)
+				state->flags |= CPUIDLE_FLAG_CHECK_BM;
 			state->enter = pr->flags.bm_check ?
 					acpi_idle_enter_bm :
 					acpi_idle_enter_simple;
-- 
1.7.3.1

