Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0EQVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:17:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab0EQVRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:17:14 -0400
Date: Mon, 17 May 2010 23:16:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/debugobjects cleanup for v2.6.35
Message-ID: <20100517211645.GA17610@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-debugobjects-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-debugobjects-for-linus

 Thanks,

	Ingo

------------------>
Henrik Kretzschmar (1):
      debugobjects: Section mismatch cleanup


 lib/debugobjects.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a9a8996..c4ecd3c 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -773,7 +773,7 @@ static int __init fixup_free(void *addr, enum debug_obj_state state)
 	}
 }
 
-static int
+static int __init
 check_results(void *addr, enum debug_obj_state state, int fixups, int warnings)
 {
 	struct debug_bucket *db;
@@ -916,7 +916,7 @@ void __init debug_objects_early_init(void)
 /*
  * Convert the statically allocated objects to dynamic ones:
  */
-static int debug_objects_replace_static_objects(void)
+static int __init debug_objects_replace_static_objects(void)
 {
 	struct debug_bucket *db = obj_hash;
 	struct hlist_node *node, *tmp;
