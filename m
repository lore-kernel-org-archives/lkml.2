Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab0HMTpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:45:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:29599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab0HMTp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="596189540"
Message-Id: <20100813193911.909546779@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 Aug 2010 12:45:41 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: chris@frostnet.net, debian00@aliceadsl.fr, hpa@zytor.com,
        jonathan.protzenko@gmail.com, mans@mansr.com, psastudio@mail.ru,
        rjw@sisk.pl, stephan.eicher@web.de, sxxe@gmx.de, thomas@archlinux.org,
        venki@google.com, wonghow@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] sched: fix minimum power returned by update_cpu_power()
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=fix_update_cpu_power.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default cpu_power needs to be multiples of SCHED_LOAD_SCALE and not '1'.
Fix it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tree/kernel/sched_fair.c
===================================================================
--- tree.orig/kernel/sched_fair.c
+++ tree/kernel/sched_fair.c
@@ -2309,7 +2309,7 @@ static void update_cpu_power(struct sche
 	power >>= SCHED_LOAD_SHIFT;
 
 	if (!power)
-		power = 1;
+		power = SCHED_LOAD_SCALE;
 
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;


