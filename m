Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1CSChz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 22:37:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:38902 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1CSChu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 22:37:50 -0400
Date: Sat, 19 Mar 2011 11:37:15 +0900 (JST)
Message-Id: <20110319.113715.163259181.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 updates for 2.6.39
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 19 Mar 2011 11:37:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull nilfs2 updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

One noticeable change is support of standard attributes set via chattr
and read via lsattr.  Another is block count per checkpoint which
enables users to know used amount of filesystem at each instant of
time via lscp command.

Also, there are a cleanup series simplifying hierarchy of on-memory
structures and a few small fixes.

Thanks!


Ryusuke Konishi
--
The following changes since commit a5abba989deceb731047425812d268daf7536575:

  Linux 2.6.38-rc8 (2011-03-07 21:09:37 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Jiro SEKIBA (1):
      nilfs2: move NILFS_SUPER_MAGIC to linux/magic.h

Ryusuke Konishi (18):
      nilfs2: decrement inodes count only if raw inode was successfully deleted
      nilfs2: add free entries count only if clear bit operation succeeded
      nilfs2: use common file attribute macros
      nilfs2: mark S_NOATIME on inodes only if NOATIME attribute is set
      nilfs2: tighten restrictions on inode flags
      nilfs2: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
      nilfs2: add compat ioctl
      nilfs2: append blocksize info to warnings during loading super blocks
      nilfs2: optimize rec_len functions
      nilfs2: record used amount of each checkpoint in checkpoint list
      nilfs2: move mount options to nilfs object
      nilfs2: move parameters on nilfs_sb_info into nilfs object
      nilfs2: move s_inode_lock and s_dirty_files into nilfs object
      nilfs2: move next generation counter into nilfs object
      nilfs2: move log writer onto nilfs object
      nilfs2: get rid of sc_sbi back pointer
      nilfs2: use sb instance instead of nilfs_sb_info struct
      nilfs2: get rid of nilfs_sb_info structure

 fs/nilfs2/alloc.c         |   12 ++-
 fs/nilfs2/bmap.c          |   12 --
 fs/nilfs2/bmap.h          |    3 -
 fs/nilfs2/btree.c         |    6 +-
 fs/nilfs2/dir.c           |    5 +-
 fs/nilfs2/direct.c        |    4 +-
 fs/nilfs2/file.c          |    4 +-
 fs/nilfs2/inode.c         |   83 +++++++++------
 fs/nilfs2/ioctl.c         |  115 ++++++++++++++++++--
 fs/nilfs2/mdt.h           |    2 +-
 fs/nilfs2/namei.c         |    2 +-
 fs/nilfs2/nilfs.h         |   33 +++++--
 fs/nilfs2/recovery.c      |   32 +++---
 fs/nilfs2/sb.h            |   85 ---------------
 fs/nilfs2/segment.c       |  258 ++++++++++++++++++++++-----------------------
 fs/nilfs2/segment.h       |   14 +--
 fs/nilfs2/super.c         |  214 ++++++++++++++++---------------------
 fs/nilfs2/the_nilfs.c     |   44 +++++---
 fs/nilfs2/the_nilfs.h     |   51 ++++++++-
 include/linux/magic.h     |    1 +
 include/linux/nilfs2_fs.h |   32 ++----
 21 files changed, 513 insertions(+), 499 deletions(-)
 delete mode 100644 fs/nilfs2/sb.h
