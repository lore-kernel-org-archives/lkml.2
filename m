Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2EFNfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:35:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48914 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2EFNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:35:46 -0400
Date: Sun, 6 May 2012 09:35:41 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20120506133541.GB30809@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch in the btrfs git repo has some fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The big ones here are a memory leak we introduced in rc1, and 
a scheduling while atomic if the transid on disk doesn't match the
transid we expected.  This happens for corrupt blocks, or out of date
disks.

It also fixes up the ioctl definition for our ioctl to resolve logical
inode numbers.  The __u32 was a merging error and doesn't match what we
ship in the progs.

Chris Mason (2) commits (+36/-17):
    Btrfs: avoid sleeping in verify_parent_transid while atomic (+34/-17)
    Btrfs: Add properly locking around add_root_to_dirty_list (+2/-0)

Stefan Behrens (1) commits (+7/-0):
    Btrfs: fix crash in scrub repair code when device is missing

Josef Bacik (1) commits (+2/-2):
    Btrfs: fix page leak when allocing extent buffers

Alexander Block (1) commits (+2/-2):
    btrfs: Fix mismatching struct members in ioctl.h

Total: (5) commits (+47/-21)

 fs/btrfs/ctree.c       |   28 +++++++++++++++++++---------
 fs/btrfs/disk-io.c     |   18 +++++++++++++-----
 fs/btrfs/disk-io.h     |    3 ++-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |    4 ++--
 fs/btrfs/ioctl.h       |    4 ++--
 fs/btrfs/scrub.c       |    7 +++++++
 fs/btrfs/tree-log.c    |    2 +-
 8 files changed, 47 insertions(+), 21 deletions(-)
