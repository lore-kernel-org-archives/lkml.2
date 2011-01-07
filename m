Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1AGKaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:30:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:43278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:08 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] cpuidle: Rename X86 specific idle poll state[0] from C0 to POLL
Date: Fri,  7 Jan 2011 11:29:43 +0100
Message-Id: <1294396190-23031-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C0 means and is well know as "not idle".
All documentation out there uses this term as "running"/"not idle"
state. Also Linux userspace tools (e.g. cpufreq-aperf and turbostat)
show C0 residency which there is correct, but means something totally
else than cpuidle "POLL" state.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: arjan@linux.intel.com
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
---
 drivers/cpuidle/cpuidle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 08d5f05..99cc8fc 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -260,7 +260,7 @@ static void poll_idle_init(struct cpuidle_device *dev)
 
 	cpuidle_set_statedata(state, NULL);
 
-	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
+	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
 	state->exit_latency = 0;
 	state->target_residency = 0;
-- 
1.7.3.1

