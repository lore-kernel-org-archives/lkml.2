Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1LTT22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:28:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59040 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1LTT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:28:21 -0500
Date: Tue, 20 Dec 2011 11:28:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [GIT PULL] cgroup fixes for v3.2-rc6
Message-ID: <20111220192816.GF10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Trying to migrating a zombie task hits BUG.  This is already fixed in
the devel branch with the threadgroup locking and this is only for
v3.2 and -stable.  The fix is simple - not skipping PF_EXITING tasks
in cgroup_attach_proc() preparation steps is enough.

Please pull from the following git branch to receive the fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.2-fixes

Thank you.

Mandeep Singh Baines (1):
      cgroups: fix a css_set not found bug in cgroup_attach_proc

 kernel/cgroup.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..a184470 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2098,11 +2098,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			continue;
 		/* get old css_set pointer */
 		task_lock(tsk);
-		if (tsk->flags & PF_EXITING) {
-			/* ignore this task if it's going away */
-			task_unlock(tsk);
-			continue;
-		}
 		oldcg = tsk->cgroups;
 		get_css_set(oldcg);
 		task_unlock(tsk);
