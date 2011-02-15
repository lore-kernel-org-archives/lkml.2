Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1BODui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:50:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60021 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1BODuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:50:35 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 14 Feb 2011 22:49:04 -0500
Message-Id: <1297740560-sup-7799@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020B.4D59F7E4.002B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The master branch of the btrfs unstable tree has some important btrfs
fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

I was seeing very rare metadata corruptions during long stress runs, and
eventually tracked it down to two different races in the btrfs
releasepage code.  One was making btrfs think pages were up to date when
they really weren't and the other lead to corrupted csum fields in
metadata.

Chris Mason (2) commits (+50/-6):
    Btrfs: don't release pages when we can't clear the uptodate bits (+9/-1)
    Btrfs: fix page->private races (+41/-5)

Zheng Yan (1) commits (+1/-0):
    Btrfs: Fix balance panic

Dan Rosenberg (1) commits (+8/-2):
    btrfs: prevent heap corruption in btrfs_ioctl_space_info()

Tsutomu Itoh (1) commits (+7/-3):
    Btrfs: check return value of alloc_extent_map()

Ilya Dryomov (1) commits (+2/-0):
    Btrfs - Fix memory leak in btrfs_init_new_device()

Total: (6) commits (+68/-11)

 fs/btrfs/disk-io.c     |    8 ++++++--
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_map.c  |    4 ++--
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |    3 +++
 fs/btrfs/ioctl.c       |   10 ++++++++--
 fs/btrfs/relocation.c  |    1 +
 fs/btrfs/volumes.c     |    2 ++
 9 files changed, 68 insertions(+), 11 deletions(-)
