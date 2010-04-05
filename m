Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0DEThG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:37:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:56142 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0DEThA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:37:00 -0400
Date: Mon, 5 Apr 2010 15:36:37 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates
Message-ID: <20100405193637.GC21620@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBA3BCF.0001:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch of the btrfs-unstable repo has a collection of fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Josef fixed a few different ENOSPC problems, and removed the mount -o
max_extent mount option, which was not used and didn't fit in well with
enospc at all.

Sage fixed up when and how we add the directory entries that go with
snapshots, which will avoid dangling directory entries if we crash at
the wrong time during snapshot creation.

Nick Piggin made the btrfs page cache code a little bit less of a special
snowflake, switching us back to the proper API.

Zhao Lei and Miao Xie contributed a long series of cleanups and fixes.
I've put the cleanups into a .35 queue and the fixes are here.

Josef Bacik (4) commits (+32/-91):
    Btrfs: fail to mount if we have problems reading the block groups (+12/-4)
    Btrfs: fix small race with delalloc flushing waitqueue's (+4/-5)
    Btrfs: fix chunk allocate size calculation (+3/-1)
    Btrfs: kill max_extent mount option (+13/-81)

Zhao Lei (3) commits (+9/-12):
    Btrfs: Simplify num_stripes's calculation logical for __btrfs_alloc_chunk() (+2/-2)
    Btrfs: Add error handle for btrfs_search_slot() in btrfs_read_chunk_tree() (+2/-0)
    Btrfs: Remove unnecessary finish_wait() in wait_current_trans() (+5/-10)

Dan Carpenter (3) commits (+5/-1):
    Btrfs: handle kmalloc() failure in inode lookup ioctl (+3/-0)
    Btrfs: check btrfs_get_extent return for IS_ERR() (+1/-1)
    Btrfs: dereferencing freed memory (+1/-0)

Sage Weil (1) commits (+31/-66):
    Btrfs: create snapshot references in same commit as snapshot

Andrea Gelmini (1) commits (+0/-1):
    Btrfs: remove duplicate include in ioctl.c

Chris Mason (1) commits (+4/-0):
    Btrfs: add check for changed leaves in setup_leaf_for_split

Miao Xie (1) commits (+4/-1):
    Btrfs: add NULL check for do_walk_down()

Nick Piggin (1) commits (+5/-32):
    Btrfs: use add_to_page_cache_lru, use __page_cache_alloc

Total: (15) commits

 fs/btrfs/transaction.c  |  112 +++++++++++++++---------------------------------
 fs/btrfs/inode.c        |   59 +------------------------
 fs/btrfs/super.c        |   23 +--------
 fs/btrfs/extent-tree.c  |   23 ++++++---
 fs/btrfs/compression.c  |   22 +--------
 fs/btrfs/extent_io.c    |   15 ------
 fs/btrfs/disk-io.c      |   12 +++--
 fs/btrfs/volumes.c      |   10 +++-
 fs/btrfs/ioctl.c        |    7 ++-
 fs/btrfs/ordered-data.c |    6 +-
 fs/btrfs/ctree.c        |    4 +
 fs/btrfs/ctree.h        |    1 
 12 files changed, 90 insertions(+), 204 deletions(-)

