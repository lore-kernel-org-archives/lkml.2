Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1G0Dzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:55:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57460 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1G0Dzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:55:52 -0400
Date: Wed, 27 Jul 2011 13:55:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20110727135545.7875bcfb5e9d207901b8d7f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

arch/sparc/lib/atomic32.c:58:5: error: redefinition of 'atomic_add_unless'
include/linux/atomic.h:15:19: note: previous definition of 'atomic_add_unless' was here

Presumably caused by commit 1af08a1407f4 ("This is in preparation for
more generic atomic").

That commit is now in Linus' tree as commit f24219b4e90c ("atomic: move
atomic_add_unless to generic code"), so this patch is probably applicable
there, now.

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Jul 2011 13:48:55 +1000
Subject: [PATCH] sparc: rename atomic_add_unless

Should have been done in commit 1af08a1407f4 ("This is in preparation
for more generic atomic").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/lib/atomic32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index 1a371f8..8600eb2 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -55,7 +55,7 @@ int atomic_cmpxchg(atomic_t *v, int old, int new)
 }
 EXPORT_SYMBOL(atomic_cmpxchg);
 
-int atomic_add_unless(atomic_t *v, int a, int u)
+int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -67,7 +67,7 @@ int atomic_add_unless(atomic_t *v, int a, int u)
 	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 	return ret != u;
 }
-EXPORT_SYMBOL(atomic_add_unless);
+EXPORT_SYMBOL(__atomic_add_unless);
 
 /* Atomic operations are already serializing */
 void atomic_set(atomic_t *v, int i)
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
