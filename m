Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab1GZSOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:14:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1GZSOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:14:36 -0400
Date: Tue, 26 Jul 2011 20:14:18 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
Message-ID: <20110726181418.GA27993@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

Interesting patches in the queue:
  Fix of a long standing data corruption in data=journal mode (or a symlink
corruption in all journalling modes).
  Fix of a NULL pointer dereference in ext3 block reservation code.
  Fix of a NULL pointer dereference in jbd.
The rest is mostly minor fixes and cleanups to ext2, ext3, jbd, and quota.

The full shortlog is:

Akinobu Mita (1):
      ext3: use proper little-endian bitops

Bernd Schubert (1):
      ext3: Fix compilation with -DDX_DEBUG

Ding Dinghua (1):
      jbd: fix a bug of leaking jh->b_jcount

H Hartley Sweeten (1):
      ext3/ioctl.c: silence sparse warnings about different address spaces

Jan Kara (7):
      ext3: Convert ext3 to new truncate calling convention
      jbd: remove dependency on __GFP_NOFAIL
      ext3: Fix oops in ext3_try_to_allocate_with_rsv()
      ext3: Improve truncate error handling
      jbd: Fix oops in journal_remove_journal_head()
      quota: Remove unused declaration
      ext3: Fix data corruption in inodes with journalled data

Lukas Czerner (4):
      ext3: Add fixed tracepoints
      jbd: Add fixed tracepoints
      ext3/ext4 Documentation: remove bh/nobh since it has been deprecated
      ext3: Return -EINVAL when start is beyond the end of fs in ext3_trim_fs()

Petr Uzel (1):
      ext2: include fs.h into ext2_fs.h

Tao Ma (1):
      jbd: Use WRITE_SYNC in journal checkpoint.

Wang Sheng-Hui (3):
      ext2: check xattr name_len before acquiring xattr_sem in ext2_xattr_get
      ext3.txt: update the links in the section "useful links" to the latest ones
      jbd: change the field "b_cow_tid" of struct journal_head from type unsigned to tid_t

The diffstat is

 Documentation/filesystems/ext3.txt |   13 +-
 Documentation/filesystems/ext4.txt |   23 +-
 fs/ext2/xattr.c                    |   10 +-
 fs/ext3/balloc.c                   |   38 +-
 fs/ext3/file.c                     |    1 -
 fs/ext3/fsync.c                    |   15 +-
 fs/ext3/ialloc.c                   |    4 +
 fs/ext3/inode.c                    |  193 ++++++---
 fs/ext3/ioctl.c                    |    4 +-
 fs/ext3/namei.c                    |    7 +-
 fs/ext3/super.c                    |   13 +
 fs/ext3/xattr.c                    |   12 +-
 fs/jbd/checkpoint.c                |   37 +-
 fs/jbd/commit.c                    |   57 ++-
 fs/jbd/journal.c                   |   99 ++---
 fs/jbd/transaction.c               |   83 ++--
 include/linux/ext2_fs.h            |    1 +
 include/linux/ext3_fs.h            |    7 +-
 include/linux/jbd.h                |    1 -
 include/linux/journal-head.h       |    2 +-
 include/linux/quota.h              |    8 -
 include/trace/events/ext3.h        |  864 ++++++++++++++++++++++++++++++++++++
 include/trace/events/jbd.h         |  203 +++++++++
 23 files changed, 1423 insertions(+), 272 deletions(-)
 create mode 100644 include/trace/events/ext3.h
 create mode 100644 include/trace/events/jbd.h

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
