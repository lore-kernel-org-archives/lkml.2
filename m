Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1I3MF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:05:58 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:60072 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758532Ab1I3MFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:05:43 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 0/6] cgroup: add isolation_root flag, poor man's namespaces for cgroups
Date: Fri, 30 Sep 2011 13:36:19 +0200
Message-Id: <1317382585-12172-1-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds namespace-like feature to the existing cgroup system.
When used with a container system (eg. lxc) it allows containers to have
its own cgroup hierarchy, enabling use of 'systemd' (using cgroups) inside 
a container. 

The behaviour is not changed at all when isolation_root flag is not set, 
no additional overhead is added.

I'm really not sure if the 'mount' part (patch 5) is done correctly, please 
review carefully.

Witold Krecicki (6):
  cgroup: add cgroup.isolation_root flag entry to the cgroup filesystem
  cgroup: make 'cgroup_is_descendant' function take cgroup as a
    'descendant of' argument
  cgroup: add 'root' parameter to cgroup_path function
  cgroup: disallow task from leaving cgroup isolated root
  cgroup: make cgroup filesystem mounts performed by task inside
    isolation root see its isolation root as top cgroup
  cgroup: documentation of isolation_root cgroup flag

 Documentation/cgroups/cgroups.txt |   20 +++++++-
 block/blk-cgroup.c                |    2 +-
 include/linux/cgroup.h            |   12 +++-
 kernel/cgroup.c                   |  102 +++++++++++++++++++++++++++++++-----
 kernel/cpuset.c                   |    2 +-
 kernel/sched_debug.c              |    2 +-
 mm/memcontrol.c                   |    6 +-
 7 files changed, 120 insertions(+), 26 deletions(-)

-- 
1.7.4.1

