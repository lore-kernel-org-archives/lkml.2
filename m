Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1LZBae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 20:30:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:57400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1LZBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 20:30:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89434890"
Subject: [Fwd: [patch] intel_idle: Delete meaningless local_irq_disable()
 call in intel_idle.c.]
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: akpm@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
        len.brown@intel.com, mingmingx.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Mon, 26 Dec 2011 09:28:20 +0800
Message-ID: <1324862905.3860.1.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Would you like to accept the patch into your testing tree?

Thanks,
Yanmin

-------- Forwarded Message --------
From: Zhang, MingmingX <mingmingx.zhang@intel.com>
To: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
Cc: yanmin_zhang@linux.intel.com <yanmin_zhang@linux.intel.com>, Li,
Shaohua <shaohua.li@intel.com>, Brown, Len <len.brown@intel.com>
Subject: [patch] intel_idle: Delete meaningless local_irq_disable() call
in intel_idle.c.
Date: Fri, 23 Dec 2011 01:57:29 +0000

From: mzha38X <mingmingx.zhang@intel.com>

intel_idle.c is a bit misleading in a sense that local_irq_disable,it
actually does nothing. Real irq disable happens earlier in process_32.c:cpu_idle.
Basically, cpuidle_state->enter is called, cpu irq is disabled.
cpuidle_state->enter would turn on irq when exiting.

intel_idle doesn't follow this assumption. Although it doesn't
cause real issue, it misleads developers. Below patch deletes
the calling to local_irq_disable() at entry.

Signed-off-by: mzha38X <mingmingx.zhang@intel.com>
---
 drivers/idle/intel_idle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d2f8e1..28f0394 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -247,8 +247,6 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	local_irq_disable();
-
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
 	 * for flushing the user TLB's associated with the active mm.
-- 
1.7.1


