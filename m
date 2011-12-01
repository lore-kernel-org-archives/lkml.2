Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1LAPkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:40:08 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:23108 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1LAPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:40:06 -0500
Date: Thu, 1 Dec 2011 10:39:55 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20111201153955.GL5587@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4ED79FD4.0064,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has our current set of fixes.  This is fairly small, Alexandre Oliva has
been chasing problems in our block allocator and kicked out important
fixes.

Jan Schmidt fixed a merge error in the raid repair code, we're now
properly repairing failed blocks (io errors or crc errors) without
having to run a scrub.

Alexandre Oliva (5) commits (+8/-8):
    Btrfs: skip block groups without enough space for a cluster (+1/-1)
    Btrfs: start search for new cluster at the beginning (+2/-4)
    Btrfs: reset cluster's max_size when creating bitmap (+1/-0)
    Btrfs: skip allocation attempt from empty cluster (+3/-3)
    Btrfs: initialize new bitmaps' list (+1/-0)

Li Zefan (1) commits (+3/-3):
    Btrfs: fix oops when calling statfs on readonly device

Arnd Hannemann (1) commits (+2/-2):
    Fix URL of btrfs-progs git repository in docs

Jan Schmidt (1) commits (+20/-7):
    Btrfs: fix meta data raid-repair merge problem

Dan Carpenter (1) commits (+5/-0):
    btrfs scrub: handle -ENOMEM from init_ipath()

Mike Fleetwood (1) commits (+1/-1):
    Btrfs: Don't error on resizing FS to same size

Miao Xie (1) commits (+22/-5):
    Btrfs: fix deadlock on metadata reservation when evicting a inode

Total: (11) commits (+60/-25)

 Documentation/filesystems/btrfs.txt |    4 ++--
 fs/btrfs/ctree.h                    |    3 +++
 fs/btrfs/extent-tree.c              |   34 +++++++++++++++++++++++-----------
 fs/btrfs/extent_io.c                |   27 ++++++++++++++++++++-------
 fs/btrfs/free-space-cache.c         |    2 ++
 fs/btrfs/inode.c                    |    2 +-
 fs/btrfs/ioctl.c                    |    2 +-
 fs/btrfs/scrub.c                    |    5 +++++
 fs/btrfs/super.c                    |    6 +++---
 9 files changed, 60 insertions(+), 25 deletions(-)
