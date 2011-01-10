Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1AJMGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:06:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:47764 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1AJMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:06:41 -0500
Date: Mon, 10 Jan 2011 21:06:34 +0900 (JST)
Message-Id: <20110110.210634.69343822.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 updates for 2.6.38
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 Jan 2011 21:06:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following nilfs2 updates.  The only noticeable change
is fiemap support, otherwise it's mostly cleanups and minor fixes.

Thanks!

Ryusuke Konishi
--
The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus (2011-01-07 17:16:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Joe Perches (1):
      fs/nilfs2/super.c: Use printf extension %pV

Ryusuke Konishi (10):
      MAINTAINERS: add nilfs2 git tree entry
      nilfs2: call nilfs_error inside bmap routines
      nilfs2: mark buffer heads as delayed until the data is written to disk
      nilfs2: fiemap support
      nilfs2: fix a checkpatch error in page.c
      nilfs2: get rid of loaded flag from nilfs object
      nilfs2: simplify nilfs_mdt_freeze_buffer
      nilfs2: get rid of nilfs_mount_options structure
      nilfs2: do not pass sbi to functions which can get it from inode
      nilfs2: unfold nilfs_dat_inode function

 MAINTAINERS           |    1 +
 fs/nilfs2/bmap.c      |   47 ++++++++++---
 fs/nilfs2/btnode.c    |    3 +-
 fs/nilfs2/dir.c       |    3 +-
 fs/nilfs2/file.c      |    1 +
 fs/nilfs2/ifile.c     |   11 +--
 fs/nilfs2/inode.c     |  180 ++++++++++++++++++++++++++++++++++++++++--------
 fs/nilfs2/ioctl.c     |   12 ++--
 fs/nilfs2/mdt.c       |   32 +++------
 fs/nilfs2/namei.c     |    1 +
 fs/nilfs2/nilfs.h     |   13 +---
 fs/nilfs2/page.c      |   86 +++++++++++++++++++++++-
 fs/nilfs2/page.h      |    3 +
 fs/nilfs2/recovery.c  |    2 +-
 fs/nilfs2/sb.h        |    8 --
 fs/nilfs2/segment.c   |   43 +++---------
 fs/nilfs2/super.c     |   29 +++++---
 fs/nilfs2/the_nilfs.c |    6 +-
 fs/nilfs2/the_nilfs.h |    3 -
 19 files changed, 337 insertions(+), 147 deletions(-)
