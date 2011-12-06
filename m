Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1LFGlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:41:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:44779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1LFGlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:41:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,304,1320652800"; 
   d="scan'208";a="82635685"
From: "Zhang, MingmingX" <mingmingx.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Date: Tue, 6 Dec 2011 14:40:29 +0800
Subject: [PATCH]  intel_idle: delete meaningless local_irq_disable() call 
Thread-Topic: [PATCH]  intel_idle: delete meaningless local_irq_disable()
 call 
Thread-Index: Acyz4fHTtpkyxH1VSPemY4MVE9MsSw==
Message-ID: <625BA99ED14B2D499DC4E29D8138F1506C27997A12@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete meaningless local_irq_disable() call in intel_idle.c.
                                      
intel_idle.c is a bit misleading in a sense that local_irq_disable in
it actually does nothing. Real irq disable happens earlier in process_32.c:cpu_idle.

Signed-off-by: Mingming Zhang <mingmingx.zhang@intel.com>
---
drivers/idle/intel_idle.c |    2 --
1 file changed, 2 deletions(-)

--- linux-3.1.4/drivers/idle/intel_idle.c     2011-11-29 07:48:14.000000000 +0900
+++ linux/drivers/idle/intel_idle.c   2011-12-06 13:40:52.161155012 +0900
@@ -223,8 +223,6 @@ static int intel_idle(struct cpuidle_dev

        cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;

-        local_irq_disable();
-
       /*
        * leave_mm() to avoid costly and often unnecessary wakeups
        * for flushing the user TLB's associated with the active mm.

Thanks
Mingming
