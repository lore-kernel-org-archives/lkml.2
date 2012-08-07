Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab2HGDja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:39:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964862Ab2HGDjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:05 -0400
Message-Id: <20120807032759.737149489@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Darren Hart <dvhart@linux.intel.com>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 25/70] futex: Fix bug in WARN_ON for NULL q.pi_state
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43 upstream.

The WARN_ON in futex_wait_requeue_pi() for a NULL q.pi_state was testing
the address (&q.pi_state) of the pointer instead of the value
(q.pi_state) of the pointer. Correct it accordingly.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


