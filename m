Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2GTSsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:48:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:22096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2GTSsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:48:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124864000"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] futex: Fix bug in WARN_ON for NULL q.pi_state
Date: Fri, 20 Jul 2012 11:46:30 -0700
Message-Id: <1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WARN_ON in futex_wait_requeue_pi() for a NULL q.pi_state was testing
the address (&q.pi_state) of the pointer instead of the value
(q.pi_state) of the pointer. Correct it accordingly.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Dave Jones <davej@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 05018bf..5551ada 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2343,7 +2343,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
 		 * the pi_state.
 		 */
-		WARN_ON(!&q.pi_state);
+		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
-- 
1.7.10.4

