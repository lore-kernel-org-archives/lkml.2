Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1KAWYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:24:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab1KAWYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:24:32 -0400
Date: Tue, 1 Nov 2011 23:24:30 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] ext2, ext3, UDF fixes for 3.2-rc1
Message-ID: <20111101222430.GD18701@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

The repository contains various minor ext2, ext3, and UDF cleanups and fixes.

Top of the tree is ed47a7d which I've also signed as tag jack_linux-fs-v3.2-rc1
(anyone has a suggestion for sane naming?). The full shortlog is:

Dmitry Monakhov (1):
      ext3: Allow quota file use root reservation

H Hartley Sweeten (1):
      ext3/balloc.c: local functions should be static

Jan Kara (4):
      ext3: Remove i_mutex from ext3_sync_file()
      quota: Drop path reference on error exit from quotactl
      udf: Remove web reference from UDF MAINTAINERS entry
      udf: Cleanup metadata flags handling

Joe Perches (6):
      udf: Promote some debugging messages to udf_error
      udf: Rename udf_error to udf_err
      udf: Rename udf_warning to udf_warn
      udf: Convert printks to pr_<level>
      udf: Neaten logging output, use vsprintf extension %pV
      udf: Neaten udf_debug uses

Julia Lawall (2):
      fs/ext2/balloc.c: delete useless initialization
      fs/ext3/balloc.c: delete useless initialization

Li Haifeng (1):
      ext2: fix the outdated comment in ext2_nfs_get_inode()

Lukas Czerner (1):
      ext3: remove deprecated oldalloc

Namjae Jeon (2):
      udf: Add readpages support for udf.
      udf: Skip mirror metadata FE loading when metadata FE is ok

Tao Ma (1):
      ext3: Remove the obsolete broken EXT3_IOC32_WAIT_FOR_READONLY.

Toshiyuki Okajima (1):
      ext3: fix message in ext3_remount for rw-remount case

The diffstat is

 Documentation/filesystems/ext3.txt |    8 -
 MAINTAINERS                        |    1 -
 fs/ext2/balloc.c                   |    2 +-
 fs/ext2/super.c                    |    8 +-
 fs/ext3/balloc.c                   |   17 ++-
 fs/ext3/fsync.c                    |   10 --
 fs/ext3/ialloc.c                   |   45 +------
 fs/ext3/ioctl.c                    |   24 ---
 fs/ext3/super.c                    |   12 +-
 fs/quota/quota.c                   |    7 +-
 fs/udf/balloc.c                    |   14 +-
 fs/udf/directory.c                 |    8 +-
 fs/udf/inode.c                     |   48 ++++---
 fs/udf/lowlevel.c                  |    2 +-
 fs/udf/misc.c                      |   19 ++-
 fs/udf/namei.c                     |    5 +-
 fs/udf/partition.c                 |   19 ++-
 fs/udf/super.c                     |  280 ++++++++++++++++--------------------
 fs/udf/truncate.c                  |   22 ++--
 fs/udf/udf_sb.h                    |    5 +-
 fs/udf/udfdecl.h                   |   37 +++--
 fs/udf/udftime.c                   |    3 +-
 fs/udf/unicode.c                   |    6 +-
 include/linux/ext3_fs.h            |    2 +-
 include/linux/ext3_fs_sb.h         |    4 -
 25 files changed, 261 insertions(+), 347 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
