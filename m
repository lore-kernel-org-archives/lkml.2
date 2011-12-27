Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab1L0Fql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:46:41 -0500
Received: from shutemov.name ([188.40.19.243]:37421 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1L0Fq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:46:28 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: cgroups@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] cgroup: mark cgroup_rmdir_waitq and cgroup_attach_proc() as static
Date: Tue, 27 Dec 2011 07:46:25 +0200
Message-Id: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4936d88..98990dd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -938,7 +938,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
  *
  * CGRP_WAIT_ON_RMDIR flag is set under cgroup's inode->i_mutex;
  */
-DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
+static DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
 
 static void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
 {
@@ -2070,7 +2070,7 @@ static int css_set_prefetch(struct cgroup *cgrp, struct css_set *cg,
  * Call holding cgroup_mutex and the group_rwsem of the leader. Will take
  * task_lock of each thread in leader's threadgroup individually in turn.
  */
-int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
+static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 {
 	int retval, i, group_size, nr_migrating_tasks;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
-- 
1.7.7.3

