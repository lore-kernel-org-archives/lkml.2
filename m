Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab2CSW6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:58:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241Ab2CSW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:58:47 -0400
Date: Mon, 19 Mar 2012 15:58:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [GIT PULL] cgroup changes for v3.4
Message-ID: <20120319225843.GA2873@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive cgroup changes for
v3.4.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.4

Out of the 8 commits, one fixes a long-standing locking issue around
tasklist walking and others are cleanups.

Thanks.

Frederic Weisbecker (2):
      cgroup: Remove wrong comment on cgroup_enable_task_cg_list()
      cgroup: Walk task list under tasklist_lock in cgroup_enable_task_cg_list

Li Zefan (3):
      cgroup: remove cgroup_attach_task_current_cg()
      cgroup: move struct cgroup_pidlist out from the header file
      cgroup: remove cgroup_subsys argument from callbacks

Mandeep Singh Baines (3):
      cgroup: simplify double-check locking in cgroup_attach_proc
      cgroup: replace tasklist_lock with rcu_read_lock
      cgroup: remove extra calls to find_existing_css_set

 Documentation/cgroups/cgroups.txt |   26 ++--
 block/blk-cgroup.c                |   22 +--
 include/linux/cgroup.h            |   70 ++-------
 include/net/sock.h                |    7 +-
 include/net/tcp_memcontrol.h      |    2 +-
 kernel/cgroup.c                   |  327 +++++++++++++++---------------------
 kernel/cgroup_freezer.c           |   11 +-
 kernel/cpuset.c                   |   16 +--
 kernel/events/core.c              |   13 +-
 kernel/sched/core.c               |   20 +--
 mm/memcontrol.c                   |   48 ++----
 net/core/netprio_cgroup.c         |   10 +-
 net/core/sock.c                   |    6 +-
 net/ipv4/tcp_memcontrol.c         |    2 +-
 net/sched/cls_cgroup.c            |   10 +-
 security/device_cgroup.c          |   10 +-
 16 files changed, 228 insertions(+), 372 deletions(-)

--
tejun
