Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2FFPOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:14:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2FFPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:14:52 -0400
Date: Wed, 6 Jun 2012 08:14:25 -0700
From: tip-bot for Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <tip-8a173b1476d126674104c7c5c6cef0bcd824b001@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        rusty@rustcorp.com.au, borntraeger@de.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, mst@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, borntraeger@de.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1338283124-7063-1-git-send-email-borntraeger@de.ibm.com>
References: <1338283124-7063-1-git-send-email-borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] spinlock:
  Indicate that a lockup is only suspected
Git-Commit-ID: 8a173b1476d126674104c7c5c6cef0bcd824b001
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:14:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a173b1476d126674104c7c5c6cef0bcd824b001
Gitweb:     http://git.kernel.org/tip/8a173b1476d126674104c7c5c6cef0bcd824b001
Author:     Christian Borntraeger <borntraeger@de.ibm.com>
AuthorDate: Tue, 29 May 2012 11:18:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:34:20 +0200

spinlock: Indicate that a lockup is only suspected

On an over-committed KVM system we got a:

  "BUG: spinlock lockup on CPU#2, swapper/2/0"

message on the heavily contended virtio blk spinlock.

While we might want to reconsider the locking of virtio-blk
(lock is held while switching to the host) this patch tries to
make the message clearer: the lockup is only suspected.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338283124-7063-1-git-send-email-borntraeger@de.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/spinlock_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index d0ec4f3..e91fbc2 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -118,7 +118,7 @@ static void __spin_lock_debug(raw_spinlock_t *lock)
 		/* lockup suspected: */
 		if (print_once) {
 			print_once = 0;
-			spin_dump(lock, "lockup");
+			spin_dump(lock, "lockup suspected");
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
