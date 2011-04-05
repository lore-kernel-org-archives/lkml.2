Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1DEINq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:13:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38139 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1DEINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:13:44 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs pull for 2.6.39-rc2
Date: Tue, 05 Apr 2011 04:12:27 -0400
Message-Id: <1301990214-sup-7585@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D9ACF33.00CA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs unstable tree has some bug fixes for
btrfs.  One fixes a regression from readonly snapshot support (2.6.38),
where we can incorrectly treat a subvolume as readonly.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Tsutomu Itoh (3) commits (+21/-4):
    Btrfs: fix memory leak in btrfs_ioctl_start_sync() (+3/-1)
    Btrfs: fix compiler warning in file.c (+1/-1)
    Btrfs: fix /proc/mounts info. (+17/-2)

Li Zefan (2) commits (+38/-10):
    Btrfs: Fix oops for defrag with compression turned on (+8/-9)
    Btrfs: Fix uninitialized root flags for subvolumes (+30/-1)

Josef Bacik (2) commits (+78/-6):
    Btrfs: fix free space cache when there are pinned extents and clusters V2 (+78/-4)
    Btrfs: don't warn in btrfs_add_orphan (+0/-2)

Yoshinori Sano (1) commits (+1/-0):
    Btrfs: fix memory leak in start_transaction()

Johann Lombardi (1) commits (+5/-3):
    Btrfs: fix subvol_sem leak in btrfs_rename()

Miao Xie (1) commits (+2/-2):
    btrfs: clear __GFP_FS flag in the space cache inode

-chris

Total: (10) commits (+145/-25)

 fs/btrfs/ctree.h            |    4 ++
 fs/btrfs/disk-io.c          |    4 ++-
 fs/btrfs/file.c             |    2 +-
 fs/btrfs/free-space-cache.c |   84 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c            |   29 +++++++--------
 fs/btrfs/ioctl.c            |    8 ++++-
 fs/btrfs/root-tree.c        |   18 +++++++++
 fs/btrfs/super.c            |   19 +++++++++-
 fs/btrfs/transaction.c      |    2 +
 9 files changed, 145 insertions(+), 25 deletions(-)
