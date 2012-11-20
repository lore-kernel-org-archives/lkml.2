Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2KTIaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:30:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46901 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2KTIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:30:19 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCHSET REPOST v2 cgroup/for-3.8] netcls/prio_cgroup: update hierarchy support
Date: Tue, 20 Nov 2012 00:30:04 -0800
Message-Id: <1353400211-5182-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Reposting w/ cc to netdev added as requested by David.  Sorry about
the noise.)

Hello, guys.

This patchset replaces the following two patchsets.

 [1] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"
 [2] "[PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy support"

It turns out that we'll have to live with attributes which are
inherited only while creating a new cgroup - such attributes are
already in wide use in cpuset, and there doesn't seem to be much point
in trying to implement fully hierarchical behavior on all attributes
especially as it requires an otherwise-unnecessary userland behavior
change on netcls_cgroup.

This patchset drop .broken_hierarchy from netcls_cgroup while
retaining the current behavior, and implements the same behavior on
netprio_cgroup.

 0001-netcls_cgroup-move-config-inheritance-to-css_online-.patch
 0002-netprio_cgroup-simplify-write_priomap.patch
 0003-netprio_cgroup-shorten-variable-names-in-extend_netd.patch
 0004-netprio_cgroup-reimplement-priomap-expansion.patch
 0005-netprio_cgroup-use-cgroup-id-instead-of-cgroup_netpr.patch
 0006-netprio_cgroup-implement-netprio-_set-_prio-helpers.patch
 0007-netprio_cgroup-allow-nesting-and-inherit-config-on-c.patch

0001 drops .broken_hierarchy from netcls_cgroup.

0002-0006 prepare for inheritance implementation.  These patches are
identical from the previous posting[1].

0007 implements inheritance on cgroup creation.

This patchset is on top of cgroup/for-3.8 0a950f65e1 ("cgroup: add
cgroup->id").

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-net-cls-prio-hierarchy

diffstat follows.

 Documentation/cgroups/net_prio.txt |    2
 include/net/netprio_cgroup.h       |   11 -
 net/core/netprio_cgroup.c          |  254 ++++++++++++++++---------------------
 net/sched/cls_cgroup.c             |   20 +-
 4 files changed, 124 insertions(+), 163 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/11/16/514
[2] http://thread.gmane.org/gmane.linux.kernel.cgroups/5094
