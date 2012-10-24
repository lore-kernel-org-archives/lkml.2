Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab2JXTyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:54:54 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57723 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934201Ab2JXTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:54:49 -0400
Date: Wed, 24 Oct 2012 12:54:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.7-rc2
Message-ID: <20121024195441.GI12182@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains three fixes.  Two are reverts of
task_lock() removal in cgroup fork path.  The optimizations
incorrectly assumed that threadgroup_lock can protect process forks
(as opposed to thread creations) too.  Further cleanup of cgroup fork
path is scheduled.  The third fixes cgroup emptiness notification
loss.

Please pull from the following git branch to receive the above
changes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-fixes

for you to fetch changes up to d87838321124061f6c935069d97f37010fa417e6:

  Revert "cgroup: Remove task_lock() from cgroup_post_fork()" (2012-10-19 14:09:35 -0700)

----------------------------------------------------------------
Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Tejun Heo (2):
      Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"
      Revert "cgroup: Remove task_lock() from cgroup_post_fork()"

 kernel/cgroup.c | 41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

Thanks.

--
tejun
