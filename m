Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1DHExM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:53:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:20165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1DHExL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,322,1299484800"; 
   d="scan'208";a="676660806"
Subject: [PATCH trival]sched: delete duplicate code
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 12:53:09 +0800
Message-ID: <1302238389.3981.92.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calc_delta_fair checks NICE_0_LOAD already, delete duplicate check.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..55375d8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1788,10 +1788,7 @@ wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 	 * This is especially important for buddies when the leftmost
 	 * task is higher priority than the buddy.
 	 */
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		gran = calc_delta_fair(gran, se);
-
-	return gran;
+	return calc_delta_fair(gran, se);
 }
 
 /*


