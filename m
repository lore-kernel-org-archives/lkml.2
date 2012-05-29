Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2E2JTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:19:39 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:33813 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2E2JTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:19:38 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] spinlock: indicate that a lockup is only suspected
Date: Tue, 29 May 2012 11:18:44 +0200
Message-Id: <1338283124-7063-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.7.10.3
x-cbid: 12052909-8372-0000-0000-000002B31A9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an over-committed KVM system we got a
"BUG: spinlock lockup on CPU#2, swapper/2/0" on the heavily contended
virtio blk spinlock.
While we might want to reconsider the locking of virtio-blk (lock is
held while switching to the host) this patch tries to make the message
clearer: the lockup is only suspected

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/spinlock_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 525d160..1d2be56 100644
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
-- 
1.7.10.3

