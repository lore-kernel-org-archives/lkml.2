Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2LRFUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:20:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:22911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab2LRFUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:20:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,305,1355126400"; 
   d="scan'208";a="258689031"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] x86,idle: pr_debug information need separated
Date: Tue, 18 Dec 2012 12:26:02 -0500
Message-Id: <1355851562-28407-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debug kernel, the the below information is found:
intel_idle: unaware of model 0x1a MWAIT 4 please contact lenb@kernel.orgACPI: Device input0 -> No ACPI support

so this patch separates it.

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index b0f6b4c..eae6e3b 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -518,7 +518,7 @@ static int intel_idle_cpuidle_driver_init(void)
 			if (*cpuidle_state_table[cstate].name == '\0')
 				pr_debug(PREFIX "unaware of model 0x%x"
 					" MWAIT %d please"
-					" contact lenb@kernel.org",
+					" contact lenb@kernel.org\n",
 				boot_cpu_data.x86_model, cstate);
 			continue;
 		}
-- 
1.6.4.2

