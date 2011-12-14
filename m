Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab1LNWn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:43:27 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59796 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab1LNWn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:43:26 -0500
Date: Wed, 14 Dec 2011 14:39:26 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] sched: mark parent and real_parent as __rcu
Message-ID: <20111214223925.GA27578@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parent and real_parent pointers should be considered __rcu, since
they should be held under either tasklist_lock or rcu_read_lock.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/sched.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..b05e8af 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1315,8 +1315,8 @@ struct task_struct {
 	 * older sibling, respectively.  (p->father can be replaced with 
 	 * p->real_parent->pid)
 	 */
-	struct task_struct *real_parent; /* real parent process */
-	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	struct task_struct __rcu *real_parent; /* real parent process */
+	struct task_struct __rcu *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
 	 * children/sibling forms the list of my natural children
 	 */
-- 
1.7.0.4

