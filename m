Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2BHCho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:37:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab2BHChm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:37:42 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 1/2] cgroup: Remove wrong comment on cgroup_enable_task_cg_list()
Date: Wed,  8 Feb 2012 03:37:26 +0100
Message-Id: <1328668647-24125-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the stale comment about RCU protection. Many callers
(all of them?) of cgroup_enable_task_cg_list() don't seem
to be in an RCU read side critical section. Besides, RCU is
not helpful to protect against while_each_thread().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 865d89a..6e4eb43 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2701,9 +2701,6 @@ static void cgroup_advance_iter(struct cgroup *cgrp,
  * using their cgroups capability, we don't maintain the lists running
  * through each css_set to its tasks until we see the list actually
  * used - in other words after the first call to cgroup_iter_start().
- *
- * The tasklist_lock is not held here, as do_each_thread() and
- * while_each_thread() are protected by RCU.
  */
 static void cgroup_enable_task_cg_lists(void)
 {
-- 
1.7.5.4

