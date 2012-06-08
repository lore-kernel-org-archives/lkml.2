Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab2FHQC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:02:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60637 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627Ab2FHQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:02:51 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: lenb@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: [RFC 3/4] cpuidle : move tlb flag to the cpuidle header
Date: Fri,  8 Jun 2012 18:02:44 +0200
Message-Id: <1339171365-4098-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this specific flag to the header file.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/idle/intel_idle.c |    8 --------
 include/linux/cpuidle.h   |    7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index d0f59c3..3456fc9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -100,14 +100,6 @@ static int intel_idle(struct cpuidle_device *dev,
 static struct cpuidle_state *cpuidle_state_table;
 
 /*
- * Set this flag for states where the HW flushes the TLB for us
- * and so we don't need cross-calls to keep it consistent.
- * If this flag is set, SW flushes the TLB, so even if the
- * HW doesn't do the flushing, this flag is safe to use.
- */
-#define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
-
-/*
  * States are indexed by the cstate number,
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index f5915e9..aafacd4 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -64,9 +64,16 @@ struct cpuidle_state {
  *                            the cpuidle core the specified state can use the  *
  *                            enter_dead function.                              *
  *                                                                              *
+ * CPUIDLE_FLAG_TLB_FLUSHED : Set this flag for states where the HW flushes the *
+ *                            TLB for us and so we don't need cross-calls to    *
+ *                            keep it consistent. If this flag is set, SW       *
+ *                            flushes the TLB, so even if the HW doesn't do the *
+ *                            flushing, this flag is safe to use.               *
+ *                                                                              *
  *******************************************************************************/
 #define CPUIDLE_FLAG_TIME_VALID  0x01
 #define CPUIDLE_FLAG_DEAD_VALID  0x02
+#define CPUIDLE_FLAG_TLB_FLUSHED 0x04
 
 /**
  * cpuidle_get_statedata - retrieves private driver state data
-- 
1.7.5.4

