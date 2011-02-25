Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1BYUmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:42:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35317 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab1BYUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:42:01 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs pull request for 2.6.38
Date: Fri, 25 Feb 2011 15:40:58 -0500
Message-Id: <1298666031-sup-6071@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D681414.0060:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Someone just figured out an enospc regression for btrfs, and that patch
isn't ready for this pull request.

But, this pull has some important fixes, especially for btrfs fiemap and
I wanted to make sure it got out the door.  Linus, the master branch
of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a nice assortment of fixes for balance crashes, pinned block devices
that can never be reopened, LZO compression oopsen and my favorite -- a
fiemap fix that keeps newer versions of cp from thinking our recently
written files are full of zeros.

In terms of the diffstat, this is almost all fixing btrfs fiemap.

Chris Mason (3) commits (+253/-45):
    Btrfs: allow balance to explicitly allocate chunks as it relocates (+21/-1)
    Btrfs: put ENOSPC debugging under a mount option (+8/-2)
    Btrfs: fix fiemap bugs with delalloc (+224/-42)

Ilya Dryomov (2) commits (+10/-3):
    Btrfs: make btrfs_rm_device() fail gracefully (+9/-2)
    Btrfs: set FMODE_EXCL in btrfs_device->mode (+1/-1)

Li Zefan (2) commits (+19/-9):
    Btrfs: Avoid accessing unmapped kernel address (+14/-7)
    Btrfs: Fix BTRFS_IOC_SUBVOL_SETFLAGS ioctl (+5/-2)

Total: (7) commits (+282/-57)

 fs/btrfs/ctree.h       |    3 +
 fs/btrfs/extent-tree.c |    9 +++-
 fs/btrfs/extent_io.c   |  138 ++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h   |    2 +-
 fs/btrfs/inode.c       |  126 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c       |    7 ++-
 fs/btrfs/lzo.c         |   21 +++++---
 fs/btrfs/relocation.c  |   13 ++++-
 fs/btrfs/super.c       |    7 ++-
 fs/btrfs/volumes.c     |   13 ++++-
 10 files changed, 282 insertions(+), 57 deletions(-)
