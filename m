Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0IFOhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:37:39 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33684 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab0IFOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:37:14 -0400
Date: Mon, 6 Sep 2010 16:37:12 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Josh Triplett <josh@joshtriplett.org>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 14/14] kernel/: Removing undead ifdef
 CONFIG_DEBUG_LOCK_ALLOC
Message-ID: <dc92672f508081ee95b603244e992d2f3119c451.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_DEBUG_LOCK_ALLOC ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 kernel/srcu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2980da3..c71e075 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -46,11 +46,9 @@ static int init_srcu_struct_fields(struct srcu_struct *sp)
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 		       struct lock_class_key *key)
 {
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Don't re-initialize a lock while it is held. */
 	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
 	lockdep_init_map(&sp->dep_map, name, key, 0);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(__init_srcu_struct);
-- 
1.7.0.4

