Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0IFOhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:37:22 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33655 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750Ab0IFOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:37:07 -0400
Date: Mon, 6 Sep 2010 16:37:05 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 13/14] kernel/: Removing undead ifdef CONFIG_SMP
Message-ID: <7a3a39ef3f765a4473cb026b1f204059568a7098.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_SMP ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 kernel/sched.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..8eef8e5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -426,9 +426,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
-#ifdef CONFIG_SMP
 	struct cpupri cpupri;
-#endif
 };
 
 /*
@@ -437,7 +435,7 @@ struct root_domain {
  */
 static struct root_domain def_root_domain;
 
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * This is the main, per-CPU runqueue data structure.
-- 
1.7.0.4

