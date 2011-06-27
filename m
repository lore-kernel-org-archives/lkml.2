Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1F0SQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:16:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18262 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1F0SQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:16:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Btrfs mailing list" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 27 Jun 2011 14:15:25 -0400
Message-Id: <1309197689-sup-653@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E08C8C8.0019:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has our current set of fixes.  Linus will probably notice the head
commit was from this morning.  I reordered a refcount bump inside the
lock that protects the delayed inode tree and did a commit --amend.

This is just for clarity, the delayed_inode can't go away because it is
pinned by the inode itself.  But, I don't want that code copy & pasted
elsewhere to create bugs later on.

These fix a regression in the new delayed_inode code where inodes that
are dropped from ram need to check for a delayed inode before we load
them back in.

Josef's commit avoids oopsen if the free extent cache had
to be discarded, and my commit makes sure a newly created empty file
gets logged properly if someone calls fsync on it.

Miao Xie (1) commits (+91/-26):
    btrfs: fix inconsonant inode information

Josef Bacik (1) commits (+6/-3):
    Btrfs: make sure to update total_bitmaps when freeing cache V3

Ilya Dryomov (1) commits (+2/-2):
    Btrfs: fix type mismatch in find_free_extent()

Chris Mason (1) commits (+1/-0):
    Btrfs: make sure to record the transid in new inodes

Total: (4) commits (+100/-31)

 fs/btrfs/delayed-inode.c    |  104 +++++++++++++++++++++++++++++++++----------
 fs/btrfs/delayed-inode.h    |    1 +
 fs/btrfs/extent-tree.c      |    4 +-
 fs/btrfs/free-space-cache.c |    9 +++-
 fs/btrfs/inode.c            |   13 +++++-
 5 files changed, 100 insertions(+), 31 deletions(-)
