Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2K1W1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:27:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33613 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2K1W1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:27:12 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.8] cpuset: drop cpuset->stack_list and ->parent
Date: Wed, 28 Nov 2012 14:26:58 -0800
Message-Id: <1354141621-11906-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

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

cgroup/for-3.8 fddfb02ad0 ("cgroup: move list add after list head initilization")
+ [1] "[PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from cgroup core"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cpuset-iter

 include/linux/cgroup.h |    1
 kernel/cgroup.c        |   26 ++++++++
 kernel/cpuset.c        |  151 +++++++++++++++++++++----------------------------
 3 files changed, 92 insertions(+), 86 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5251
