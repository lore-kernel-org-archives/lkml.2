Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1HQPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:47:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:58657 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1HQPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:46:55 -0400
Date: Wed, 17 Aug 2011 17:46:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: [GIT pull] core fixes for 3.1
Message-ID: <alpine.LFD.2.02.1108171746050.2807@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	tglx

------------------>
Peter Zijlstra (1):
      lockdep: Fix wrong assumption in match_held_lock


 kernel/lockdep.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8c24294..91d67ce 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3111,7 +3111,13 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		if (!class)
 			class = look_up_lock_class(lock, 0);
 
-		if (DEBUG_LOCKS_WARN_ON(!class))
+		/*
+		 * If look_up_lock_class() failed to find a class, we're trying
+		 * to test if we hold a lock that has never yet been acquired.
+		 * Clearly if the lock hasn't been acquired _ever_, we're not
+		 * holding it either, so report failure.
+		 */
+		if (!class)
 			return 0;
 
 		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
