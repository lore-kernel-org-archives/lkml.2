Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1ALICl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:02:41 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:48416 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1ALICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:02:38 -0500
Date: Wed, 12 Jan 2011 03:02:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        arjan@linux.intel.com, j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: CPUIDLE_FLAG_TLB_FLUSHED is specific to intel_idle
In-reply-to: <alpine.LFD.2.02.1101120258550.19140@x980>
Message-id: <alpine.LFD.2.02.1101120301530.19140@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-6-git-send-email-trenn@suse.de>
 <alpine.LFD.2.02.1101120159400.19140@x980>
 <alpine.LFD.2.02.1101120229060.19140@x980>
 <alpine.LFD.2.02.1101120235390.19140@x980>
 <alpine.LFD.2.02.1101120258550.19140@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |    8 ++++++++
 include/linux/cpuidle.h   |    1 -
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 21d3871..8256309 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -82,6 +82,14 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state);
 static struct cpuidle_state *cpuidle_state_table;
 
 /*
+ * Set this flag for states where the HW flushes the TLB for us
+ * and so we don't need cross-calls to keep it consistent.
+ * If this flag is set, SW flushes the TLB, so even if the
+ * HW doesn't do the flushing, this flag is safe to use.
+ */
+#define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
+
+/*
  * States are indexed by the cstate number,
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index c252953..6be722c 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -49,7 +49,6 @@ struct cpuidle_state {
 #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
 #define CPUIDLE_FLAG_CHECK_BM	(0x02) /* BM activity will exit state */
 #define CPUIDLE_FLAG_IGNORE	(0x100) /* ignore during this idle period */
-#define CPUIDLE_FLAG_TLB_FLUSHED (0x200) /* tlb will be flushed */
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
-- 
1.7.4.rc1.7.g2cf08

