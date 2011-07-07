Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1GGSI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:08:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1GGSI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:08:57 -0400
Date: Thu, 7 Jul 2011 20:08:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] debugobjects fix
Message-ID: <20110707180845.GA13192@elte.hu>
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

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

 Thanks,

	Ingo

------------------>
Marcin Slusarz (1):
      debugobjects: Fix boot crash when kmemleak and debugobjects enabled


 lib/debugobjects.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 9d86e45..a78b7c6 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -198,7 +198,7 @@ static void free_object(struct debug_obj *obj)
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = !work_pending(&debug_obj_work);
+		sched = keventd_up() && !work_pending(&debug_obj_work);
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
