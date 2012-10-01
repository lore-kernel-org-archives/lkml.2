Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab2JAXC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35599 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211Ab2JAXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:52 -0400
Message-Id: <20121001225202.699701161@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 120/180] futex: Fix bug in WARN_ON for NULL q.pi_state
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6f745b6..7fd3dac 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2318,7 +2318,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
 		 * the pi_state.
 		 */
-		WARN_ON(!&q.pi_state);
+		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
-- 
1.7.2.1.45.g54fbc



