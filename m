Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1EWFgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:36:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:43248 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1EWFgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:36:07 -0400
Date: Mon, 23 May 2011 14:35:53 +0900 (JST)
Message-Id: <20110523.143553.149410245.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 updates for 2.6.40
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 23 May 2011 14:35:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following nilfs2 updates.  A noticeable change in this
cycle is support of filesystem resizing, otherwise it's mostly
cleanups and minor fixes.

Thanks!

Ryusuke Konishi
--
The following changes since commit 349dbc3669d043e656f3ed48c7bfe073ca1c6326:

  nilfs2: fix infinite loop in nilfs_palloc_freev function (2011-05-10 22:19:50 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Nicolas Kaiser (1):
      nilfs2: merge list_del()/list_add_tail() to list_move_tail()

Ryusuke Konishi (12):
      nilfs2: get rid of private page allocator
      nilfs2: super root size should change depending on inode size
      nilfs2: zero fill unused portion of super root block
      nilfs2: add ioctl which limits range of segment to be allocated
      nilfs2: add routine to move secondary super block
      nilfs2: add truncation routine of segment usage file
      nilfs2: implement resize ioctl
      nilfs2: use empty_aops for gc-inodes
      nilfs2: use list_first_entry
      nilfs2: get rid of NILFS_I_NILFS
      nilfs2: always set back pointer to host inode in mapping->host
      nilfs2: use mark_buffer_dirty to mark btnode or meta data dirty

 fs/nilfs2/alloc.c         |   12 +-
 fs/nilfs2/bmap.c          |    4 +-
 fs/nilfs2/btnode.c        |   19 +--
 fs/nilfs2/btnode.h        |    4 -
 fs/nilfs2/btree.c         |   38 +++---
 fs/nilfs2/cpfile.c        |   24 ++--
 fs/nilfs2/dat.c           |    4 +-
 fs/nilfs2/file.c          |    1 -
 fs/nilfs2/gcinode.c       |   25 ++---
 fs/nilfs2/ifile.c         |    4 +-
 fs/nilfs2/inode.c         |   23 +++-
 fs/nilfs2/ioctl.c         |   61 ++++++++++
 fs/nilfs2/mdt.c           |    8 +-
 fs/nilfs2/mdt.h           |    9 +--
 fs/nilfs2/nilfs.h         |    7 +-
 fs/nilfs2/page.c          |   79 +------------
 fs/nilfs2/page.h          |    7 +-
 fs/nilfs2/recovery.c      |   12 +-
 fs/nilfs2/segbuf.c        |   17 +--
 fs/nilfs2/segment.c       |  190 ++++++--------------------------
 fs/nilfs2/segment.h       |    2 -
 fs/nilfs2/sufile.c        |  274 +++++++++++++++++++++++++++++++++++++++++----
 fs/nilfs2/sufile.h        |    4 +-
 fs/nilfs2/super.c         |  131 +++++++++++++++++++++-
 fs/nilfs2/the_nilfs.c     |   24 +++-
 fs/nilfs2/the_nilfs.h     |    2 +
 include/linux/nilfs2_fs.h |    4 +-
 27 files changed, 603 insertions(+), 386 deletions(-)
