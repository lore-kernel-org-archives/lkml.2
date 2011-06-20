Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1FTBNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 21:13:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20506 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1FTBNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 21:13:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Date: Sun, 19 Jun 2011 21:12:53 -0400
Message-Id: <1308531566-sup-1586@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DFE9E9E.00B2:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has our current queue of fixes.  One of the fixes removes our unused
sysfs code, mostly because gcc likes to complain about it since
we removed some dead code in rc1.  We do plan on eventually putting more
info into the sysfs dir, so the directory itself is still there.

Otherwise these are regression fixes.  The new delayed metadata
insertion code and the new transaction locking code had races with the
code to balance space between drives, and races against snapshot
creation.  There are also two ENOSPC regression fixes included as well.

Chris Mason (4) commits (+136/-28):
    Btrfs: drop the delalloc_bytes check in shrink_delalloc (+0/-4)
    Btrfs: avoid delayed metadata items during commits (+28/-10)
    Btrfs: check the return value from set_anon_super (+3/-1)
    Btrfs: fix relocation races (+105/-13)

Josef Bacik (3) commits (+14/-3):
    Btrfs: set no_trans_join after trying to expand the transaction (+11/-3)
    Btrfs: protect the pending_snapshots list with trans_lock (+2/-0)
    Btrfs: fix path leakage on subvol deletion (+1/-0)

David Sterba (2) commits (+4/-4):
    btrfs: fix dereference of ERR_PTR value (+1/-1)
    btrfs: fix uninitialized return value (+3/-3)

Miao Xie (1) commits (+20/-6):
    btrfs: fix wrong reservation when doing delayed inode operations

Maarten Lankhorst (1) commits (+0/-148):
    btrfs: Remove unused sysfs code

Total: (11) commits (+174/-189)

 fs/btrfs/ctree.h         |   15 +++++-
 fs/btrfs/delayed-inode.c |   32 +++++++++--
 fs/btrfs/delayed-inode.h |    5 +-
 fs/btrfs/disk-io.c       |   12 ++--
 fs/btrfs/extent-tree.c   |    4 -
 fs/btrfs/inode.c         |    1 +
 fs/btrfs/ioctl.c         |    2 +
 fs/btrfs/relocation.c    |   30 +++++++---
 fs/btrfs/sysfs.c         |  146 ----------------------------------------------
 fs/btrfs/transaction.c   |  114 ++++++++++++++++++++++++++++++-----
 fs/btrfs/tree-log.c      |    2 +-
 11 files changed, 174 insertions(+), 189 deletions(-)
