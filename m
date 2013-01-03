Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3ACVoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:44:14 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49357 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3ACVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:44:11 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCHSET] cpuset: drop cpuset->stack_list and ->parent, take#2
Date: Thu,  3 Jan 2013 13:44:03 -0800
Message-Id: <1357249446-25075-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This is the second take of "drop cpuset->stack_list and ->parent"
patchset.  Other than being rebased on top of v3.8-rc2 + "cpuset:
decouple cpuset locking from cgroup core, take#2", nothing really has
changed.

The original patchset description follows.

cpuset implements its own descendant iteration using
cpuset->stack_list and has its own ->parent pointer.  There's nothing
cpuset specific about descendant walking or finding the parent.  This
patchset makes cpuset use cgroup generic API instead.

 0001-cpuset-implement-cgroup_rightmost_descendant.patch
 0002-cpuset-replace-cpuset-stack_list-with-cpuset_for_eac.patch
 0003-cpuset-remove-cpuset-parent.patch

0001 implements cgroup_rightmost_descendant() which can be used to
skip subtree during pre-order tree walk.  Michal, maybe memcg can use
it too?

0002 replaces cpuset->stack_list with generic
for_each_descendasnt_pre().

0003 replaces cpuset->parent with cgroup->parent.

This patchset is on top of

v3.8-rc2 d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
+ [1] "[PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from cgroup core, take#2"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cpuset-iter

 include/linux/cgroup.h |    1 
 kernel/cgroup.c        |   26 ++++++++
 kernel/cpuset.c        |  151 +++++++++++++++++++++----------------------------
 3 files changed, 92 insertions(+), 86 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5629
