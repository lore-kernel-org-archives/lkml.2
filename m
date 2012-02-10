Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2BJOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:09:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34784 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab2BJOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:09:26 -0500
Date: Fri, 10 Feb 2012 17:05:14 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: remove unused hrtimer_peek_ahead_timers() call
Message-ID: <20120210140514.GA7650@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 cpuidle: remove unused hrtimer_peek_ahead_timers() call

  commit 9a6558371bcd01c2973b7638181db4ccc34eab4f
  Author: Arjan van de Ven <arjan@linux.intel.com>
  Date:   Sun Nov 9 12:45:10 2008 -0800

     regression: disable timer peek-ahead for 2.6.28
    
     It's showing up as regressions; disabling it very likely just papers
     over an underlying issue, but time is running out for 2.6.28, lets get
     back to this for 2.6.29

 Many years has passed since 2008, so it seems ok to remove whole `#if 0' block.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/cpuidle/cpuidle.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..654aba3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -76,15 +76,6 @@ int cpuidle_idle_call(void)
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

