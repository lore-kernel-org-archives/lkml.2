Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab2GYDxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:53:16 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab2GYDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kevin Hilman <khilman@ti.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 12/52] cpuidle: remove unused hrtimer_peek_ahead_timers() call
Date: Tue, 24 Jul 2012 23:41:08 -0400
Message-Id: <0aeb9cac6f8a6fc68acfb07d30b62ad6106a6384.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

  commit 9a6558371bcd01c2973b7638181db4ccc34eab4f
  Author: Arjan van de Ven <arjan@linux.intel.com>
  Date:   Sun Nov 9 12:45:10 2008 -0800

     regression: disable timer peek-ahead for 2.6.28

     It's showing up as regressions; disabling it very likely just papers
     over an underlying issue, but time is running out for 2.6.28, lets get
     back to this for 2.6.29

 Many years has passed since 2008, so it seems ok to remove whole `#if 0' block.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Trinabh Gupta <g.trinabh@gmail.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/cpuidle.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..588b44a 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -124,15 +124,6 @@ int cpuidle_idle_call(void)
 	if (!dev || !dev->enabled)
 		return -EBUSY;
 
-#if 0
-	/* shows regressions, re-enable for 2.6.29 */
-	/*
-	 * run any timers that can be run now, at this point
-	 * before calculating the idle duration etc.
-	 */
-	hrtimer_peek_ahead_timers();
-#endif
-
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
-- 
1.7.12.rc0

