Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2GXOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:23:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab2GXOXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:23:50 -0400
Date: Tue, 24 Jul 2012 07:23:37 -0700
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Message-ID: <tip-f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com>
References: <1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix bug in WARN_ON for NULL q.pi_state
Git-Commit-ID: f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:23:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43
Gitweb:     http://git.kernel.org/tip/f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Fri, 20 Jul 2012 11:53:30 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 24 Jul 2012 16:02:57 +0200

futex: Fix bug in WARN_ON for NULL q.pi_state

The WARN_ON in futex_wait_requeue_pi() for a NULL q.pi_state was testing
the address (&q.pi_state) of the pointer instead of the value
(q.pi_state) of the pointer. Correct it accordingly.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
