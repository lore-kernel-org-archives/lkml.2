Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1LESzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:55:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab1LESzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:55:06 -0500
Date: Mon, 5 Dec 2011 19:53:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [GIT PULL] lockdep/slab fix
Message-ID: <20111205185327.GA23833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      slab, lockdep: Fix silly bug


 mm/slab.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 708efe8..83311c9a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -595,6 +595,7 @@ static enum {
 	PARTIAL_AC,
 	PARTIAL_L3,
 	EARLY,
+	LATE,
 	FULL
 } g_cpucache_up;
 
@@ -671,7 +672,7 @@ static void init_node_lock_keys(int q)
 {
 	struct cache_sizes *s = malloc_sizes;
 
-	if (g_cpucache_up != FULL)
+	if (g_cpucache_up < LATE)
 		return;
 
 	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
@@ -1666,6 +1667,8 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
+	g_cpucache_up = LATE;
+
 	/* Annotate slab for lockdep -- annotate the malloc caches */
 	init_lock_keys();
 
