Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2KQDbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:31:10 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47794 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2KQDbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:31:09 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy support
Date: Fri, 16 Nov 2012 19:30:59 -0800
Message-Id: <1353123062-23193-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This patchset implements proper hierarchy support for netcls_cgroup.
Pretty simliar to the netprio one[3].  Simpler as each cgroup has
single config value instead of array of them.

This patchset contains the following three patches.

 0001-netcls_cgroup-introduce-netcls_mutex.patch
 0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
 0003-netcls_cgroup-implement-proper-hierarchy-support.patch

This patchset is on top of

cgroup/for-3.8 ef9fe980c6 ("cgroup_freezer: implement proper hierarchy support")
+ [1] "[PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail"
+ [2] "[PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/"
      "[PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()"
+ [3] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-netcls_cgroup-hierarchy

diffstat follows.

 include/net/cls_cgroup.h |    1
 net/sched/cls_cgroup.c   |  102 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 15 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5047
[2] http://thread.gmane.org/gmane.linux.kernel/1393151
[3] https://lkml.org/lkml/2012/11/16/514
