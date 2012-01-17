Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2AQUGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:06:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:56886 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab2AQUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:06:41 -0500
Date: Tue, 17 Jan 2012 15:06:36 -0500
From: Chris Mason <chris.mason@oracle.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [GIT PULL 2/2] Btrfs changes from vfs.git
Message-ID: <20120117200636.GD3658@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F15D4CF.00D1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is pull request #2 of 2, and it's actually for a branch off Al's
tree.

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git btrfs

There's one minor conflict in the ioctl.c, which I've resolved here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git viro

I did the split pull like this because Al's changes are on 3.3-pre-rc
and the rest of my stuff is on 3.2.  But I did test Al's code against
the your current master.

Al Viro (16) commits:
    btrfs: kill pointless reassignment of ->s_fs_info in btrfs_fill_super() (+2/-5)
    btrfs: make free_fs_info() call ->kill_sb() unconditional (+2/-6)
    btrfs: take allocation of ->tree_root into open_ctree() (+5/-10)
    btrfs: consolidate failure exits in btrfs_mount() a bit (+5/-16)
    btrfs: merge free_fs_info() calls on fill_super failures (+1/-3)
    btrfs: let ->s_fs_info point to fs_info, not root... (+45/-45)
    btrfs: fix a deadlock in btrfs_scan_one_device() (+2/-3)
    btrfs: preparation to fixing mount/umount race (+6/-3)
    btrfs: make open_ctree() return int (+13/-13)
    btrfs: sanitizing ->fs_info, part 5 (+11/-11)
    btrfs: sanitizing ->fs_info, part 4 (+18/-20)
    btrfs: sanitizing ->fs_info, part 3 (+5/-7)
    btrfs: sanitizing ->fs_info, part 2 (+4/-1)
    btrfs: sanitizing ->fs_info, part 1 (+6/-1)
    btrfs: get ->kill_sb() of its own (+18/-9)
    btrfs: fix mount/umount race (+4/-9)

Total: (16) commits (+110/-125)

 fs/btrfs/ctree.h   |    2 +-
 fs/btrfs/disk-io.c |   70 +++++++++++++------------
 fs/btrfs/disk-io.h |    6 +-
 fs/btrfs/export.c  |    2 +-
 fs/btrfs/ioctl.c   |    7 +--
 fs/btrfs/super.c   |  143 +++++++++++++++++++++++-----------------------------
 fs/btrfs/volumes.c |    5 +-
 7 files changed, 110 insertions(+), 125 deletions(-)

