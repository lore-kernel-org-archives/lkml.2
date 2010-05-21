Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0EUT3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:29:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58272 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0EUT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:29:04 -0400
Date: Fri, 21 May 2010 21:29:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block tree for 2.6.35
Message-ID: <20100521192902.GD23411@kernel.dk>
References: <20100521192026.GB23411@kernel.dk> <20100521192433.GC23411@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521192433.GC23411@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21 2010, Jens Axboe wrote:
> On Fri, May 21 2010, Jens Axboe wrote:
> > Hi Linus,
> > 
> > This is the initial (and big) part of the bits stashed in the block git
> > tree for 2.6.35.
> > 
> > - A good bunch of IO controller updates. I apologize for the quality of
> >   the changelog for those, I should have caught that in due time. Will
> >   not happen again.
> > - Updates and additions to the discard requests.
> > - A big drbd update.
> > - Fixes for a few writeback bugs and regressions.
> > - The pipe grow/shrink support with the default 256 page limit and
> >   a proc file for root to modify that limit.
> > - Make laptop mode per-device instead of a global setting.
> > - And of course a good bunch of bug fixes.
> > 
> > Please pull.
> > 
> >   git://git.kernel.dk/linux-2.6-block.git for-2.6.35
> 
> So one of your very latest pulls causes a merge conflict in
> ext3/fsync.c. Did not happen an hour or two ago :-)
> 
> I'll pull in your latest and send a new diffstat.

OK, it was trivial. The new diffstat looks like this:

 Documentation/cgroups/blkio-controller.txt |  151 +++++-
 block/Kconfig                              |   23 -
 block/Kconfig.iosched                      |   16 +-
 block/Makefile                             |    2 +-
 block/blk-barrier.c                        |  147 +-----
 block/blk-cgroup.c                         |  791 +++++++++++++++++++++++++---
 block/blk-cgroup.h                         |  178 ++++++-
 block/blk-core.c                           |   31 +-
 block/blk-lib.c                            |  233 ++++++++
 block/cfq-iosched.c                        |   81 +++-
 block/elevator.c                           |   11 +
 block/genhd.c                              |    2 +-
 block/ioctl.c                              |    2 +-
 drivers/block/Kconfig                      |   22 +-
 drivers/block/drbd/drbd_bitmap.c           |   21 +-
 drivers/block/drbd/drbd_int.h              |  151 +++++-
 drivers/block/drbd/drbd_main.c             |  158 +++++-
 drivers/block/drbd/drbd_nl.c               |   52 +-
 drivers/block/drbd/drbd_proc.c             |   19 +-
 drivers/block/drbd/drbd_receiver.c         |  666 +++++++++++++++---------
 drivers/block/drbd/drbd_req.c              |   40 +-
 drivers/block/drbd/drbd_strings.c          |    2 +-
 drivers/block/drbd/drbd_worker.c           |  206 +++++---
 drivers/block/drbd/drbd_wrappers.h         |   16 +-
 drivers/ide/ide-disk.c                     |   40 +-
 drivers/ide/ide-gd.c                       |   11 +-
 fs/block_dev.c                             |  257 ++++++++--
 fs/btrfs/extent-tree.c                     |    2 +-
 fs/buffer.c                                |    1 +
 fs/ext3/fsync.c                            |    3 +-
 fs/ext4/fsync.c                            |    6 +-
 fs/fcntl.c                                 |    5 +
 fs/fs-writeback.c                          |   98 +++-
 fs/gfs2/rgrp.c                             |    5 +-
 fs/jbd2/checkpoint.c                       |    3 +-
 fs/jbd2/commit.c                           |    6 +-
 fs/nilfs2/the_nilfs.c                      |    4 +-
 fs/partitions/acorn.c                      |   68 ++--
 fs/partitions/acorn.h                      |   10 +-
 fs/partitions/amiga.c                      |   13 +-
 fs/partitions/amiga.h                      |    2 +-
 fs/partitions/atari.c                      |    8 +-
 fs/partitions/atari.h                      |    2 +-
 fs/partitions/check.c                      |   84 +++-
 fs/partitions/check.h                      |   12 +
 fs/partitions/efi.c                        |   91 ++--
 fs/partitions/efi.h                        |    2 +-
 fs/partitions/ibm.c                        |   21 +-
 fs/partitions/ibm.h                        |    2 +-
 fs/partitions/karma.c                      |    4 +-
 fs/partitions/karma.h                      |    2 +-
 fs/partitions/ldm.c                        |   89 ++--
 fs/partitions/ldm.h                        |    2 +-
 fs/partitions/mac.c                        |   11 +-
 fs/partitions/mac.h                        |    2 +-
 fs/partitions/msdos.c                      |   85 ++--
 fs/partitions/msdos.h                      |    2 +-
 fs/partitions/osf.c                        |    4 +-
 fs/partitions/osf.h                        |    2 +-
 fs/partitions/sgi.c                        |    6 +-
 fs/partitions/sgi.h                        |    2 +-
 fs/partitions/sun.c                        |    6 +-
 fs/partitions/sun.h                        |    2 +-
 fs/partitions/sysv68.c                     |    6 +-
 fs/partitions/sysv68.h                     |    2 +-
 fs/partitions/ultrix.c                     |    4 +-
 fs/partitions/ultrix.h                     |    2 +-
 fs/pipe.c                                  |  122 ++++-
 fs/reiserfs/file.c                         |    3 +-
 fs/splice.c                                |  151 ++++--
 fs/sync.c                                  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c               |    3 +-
 include/linux/backing-dev.h                |    6 +-
 include/linux/blkdev.h                     |   70 ++-
 include/linux/drbd.h                       |    5 +-
 include/linux/drbd_limits.h                |   16 +
 include/linux/drbd_nl.h                    |    5 +
 include/linux/elevator.h                   |    6 +
 include/linux/fcntl.h                      |    6 +
 include/linux/fs.h                         |    1 +
 include/linux/ide.h                        |    2 +-
 include/linux/pipe_fs_i.h                  |   13 +-
 include/linux/splice.h                     |    7 +
 include/linux/writeback.h                  |   18 +-
 init/Kconfig                               |   27 +
 kernel/relay.c                             |   15 +-
 kernel/sched_clock.c                       |    1 +
 kernel/sysctl.c                            |    9 +
 kernel/trace/trace.c                       |   60 ++-
 mm/backing-dev.c                           |   15 +-
 mm/page-writeback.c                        |   44 +-
 mm/swapfile.c                              |    9 +-
 net/core/skbuff.c                          |   38 +-
 93 files changed, 3423 insertions(+), 1241 deletions(-)
 create mode 100644 block/blk-lib.c

-- 
Jens Axboe

