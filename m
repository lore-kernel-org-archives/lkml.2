Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2JBHoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:44:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2JBHoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:44:15 -0400
Date: Tue, 2 Oct 2012 16:44:07 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>
Subject: [GIT PULL] cgroup hierarchy changes for v3.7-rc1
Message-ID: <20121002074407.GD6144@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is another v3.7-rc1 pull request for cgroup.  Currently,
different cgroup subsystems handle nested cgroups completely
differently.  There's no consistency among subsystems and the
behaviors often are outright broken.

People at least seem to agree that the broken hierarhcy behaviors need
to be weeded out if any progress is gonna be made on this front and
that the fallouts from deprecating the broken behaviors should be
acceptable especially given that the current behaviors don't make much
sense when nested.

This patch makes cgroup emit warning messages if cgroups for
subsystems with broken hierarchy behavior are nested to prepare for
fixing them in the future.  This was put in a separate branch because
more related changes were expected (didn't make it this round) and the
memory cgroup wanted to pull in this and make changes on top.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-hierarchy

Thanks.

Tejun Heo (1):
      cgroup: mark subsystems with broken hierarchy support and whine if cgroups are nested for them

 block/blk-cgroup.c        |    8 ++++++++
 include/linux/cgroup.h    |   15 +++++++++++++++
 kernel/cgroup.c           |   12 +++++++++++-
 kernel/cgroup_freezer.c   |    8 ++++++++
 kernel/events/core.c      |    7 +++++++
 mm/memcontrol.c           |    7 +++++++
 net/core/netprio_cgroup.c |   12 +++++++++++-
 net/sched/cls_cgroup.c    |    9 +++++++++
 security/device_cgroup.c  |    9 +++++++++
 9 files changed, 85 insertions(+), 2 deletions(-)

--
tejun
