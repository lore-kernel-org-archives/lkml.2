Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2JBH3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:29:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2JBH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:29:48 -0400
Date: Tue, 2 Oct 2012 16:29:40 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [GIT PULL] cgroup changes for v3.7-rc1
Message-ID: <20121002072940.GC6144@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This is cgroup updates for v3.7-rc1.

* xattr support is added.  The implementation is shared with tmpfs.
  The usage is restricted and intended to be used to manage per-cgroup
  metadata by system software.  tmpfs changes are routed through this
  branch with Hugh's permission.

* cgroup subsystem ID handling simplified.

Please pull from the following branch to receive the above changes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7

Thanks.

Aristeu Rozanski (7):
      xattr: extract simple_xattr code from tmpfs
      cgroup: revise how we re-populate root directory
      cgroup: add xattr support
      cgroup: rename subsys_bits to subsys_mask
      cgroup: add documentation on extended attributes usage
      fs: add missing documentation to simple_xattr functions
      xattr: mark variable as uninitialized to make both gcc and smatch happy

Daniel Wagner (8):
      cgroup: net_cls: Move sock_update_classid() declaration to cls_cgroup.h
      cgroup: net_cls: Do not define task_cls_classid() when not selected
      cgroup: net_prio: Do not define task_netpioidx() when not selected
      cgroup: Remove CGROUP_BUILTIN_SUBSYS_COUNT
      cgroup: Wrap subsystem selection macro
      cgroup: Do not depend on a given order when populating the subsys array
      cgroup: Assign subsystem IDs during compile time
      cgroup: Define CGROUP_SUBSYS_COUNT according the configuration

Michael Kerrisk (1):
      cgroup: trivial fixes for Documentation/cgroups/cgroups.txt

 Documentation/cgroups/cgroups.txt |   92 +++++++----
 drivers/net/tun.c                 |    1 +
 fs/xattr.c                        |  180 +++++++++++++++++++++
 include/linux/cgroup.h            |   25 ++--
 include/linux/cgroup_subsys.h     |   24 ++--
 include/linux/shmem_fs.h          |    3 +-
 include/linux/xattr.h             |   48 ++++++
 include/net/cls_cgroup.h          |   27 ++--
 include/net/netprio_cgroup.h      |   30 ++---
 include/net/sock.h                |    8 -
 kernel/cgroup.c                   |  320 +++++++++++++++++++++++++------------
 mm/shmem.c                        |  171 ++------------------
 net/core/netprio_cgroup.c         |   11 --
 net/core/sock.c                   |   15 +--
 net/sched/cls_cgroup.c            |   13 --
 15 files changed, 575 insertions(+), 393 deletions(-)

--
tejun
