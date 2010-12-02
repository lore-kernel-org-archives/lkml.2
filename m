Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0LBQml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:42:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab0LBQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:40 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, arjan@linux.intel.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] cpuidle: Rename X86 specific idle poll state[0] from C0 to CPUIDLE
Date: Thu,  2 Dec 2010 17:42:22 +0100
Message-Id: <1291308148-28628-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-2-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
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
1.6.0.2

