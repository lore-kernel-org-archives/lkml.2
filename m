Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1HYWnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:43:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab1HYWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:43:31 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate subsys methods, take#2
Date: Fri, 26 Aug 2011 00:43:06 +0200
Message-Id: <1314312192-26885-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of cgroup_taskset patchset.  This patchset
introduces cgroup_taskset along with some accessors and iterator,
updates methods to use it, consolidates usages and drops superflous
methods.  For more info, please read the head message and discussions
from the last take[L].

Changes from the last take[L] are mostly minor.

* Acked-by's added
* patch contamination fixed
* local variable renamed
* documentation updated

It contains the following six patches.

 0001-cgroup-subsys-attach_task-should-be-called-after-mig.patch
 0002-cgroup-improve-old-cgroup-handling-in-cgroup_attach_.patch
 0003-cgroup-introduce-cgroup_taskset-and-use-it-in-subsys.patch
 0004-cgroup-don-t-use-subsys-can_attach_task-or-attach_ta.patch
 0005-cgroup-cpuset-don-t-use-ss-pre_attach.patch
 0006-cgroup-kill-subsys-can_attach_task-pre_attach-and-at.patch

and is based on the current linux-pm/pm-freezer (7b5b95b3f5 "freezer:
remove should_send_signal() and update frozen()"), and available in
the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

Any ideas on how to route these patches?  If we float these in -mm,
further freezer patches would have to be in -mm too which in turn will
force job control patches depending on them to -mm too.  It would be
really nice if we can find a stable git branch to host these.  Routing
through pm-freezer might not be such a bad idea either, I think.

Thank you.

 Documentation/cgroups/cgroups.txt |   51 +++------
 block/blk-cgroup.c                |   45 +++++---
 include/linux/cgroup.h            |   31 ++++-
 kernel/cgroup.c                   |  200 ++++++++++++++++++++++++--------------
 kernel/cgroup_freezer.c           |   16 ---
 kernel/cpuset.c                   |  105 +++++++++----------
 kernel/events/core.c              |   13 +-
 kernel/sched.c                    |   31 +++--
 mm/memcontrol.c                   |   16 +--
 security/device_cgroup.c          |    7 -
 10 files changed, 294 insertions(+), 221 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1183130
