Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0LBQmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:42:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab0LBQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:40 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] acpi: processor->cpuidle: Only set cpuidle check_bm flag if pr->flags.bm_check is set
Date: Thu,  2 Dec 2010 17:42:26 +0100
Message-Id: <1291308148-28628-7-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-6-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
 <1291308148-28628-3-git-send-email-trenn@suse.de>
 <1291308148-28628-4-git-send-email-trenn@suse.de>
 <1291308148-28628-5-git-send-email-trenn@suse.de>
 <1291308148-28628-6-git-send-email-trenn@suse.de>
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
index e74f72c..d4d2c5d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1046,7 +1046,8 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
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
1.6.0.2

