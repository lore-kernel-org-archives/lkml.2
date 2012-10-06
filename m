Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab2JFUGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:06:19 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:54734 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2JFUGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:06:15 -0400
Message-ID: <1349553966.12699.132.camel@kjgkr>
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: jaegeuk.kim@samsung.com, Al Viro <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Date: Sun, 07 Oct 2012 05:06:06 +0900
In-Reply-To: <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-06 (토), 17:54 +0400, Vyacheslav Dubeyko:
> Hi Jaegeuk,

Hi.
We know each other, right? :)

> 
> > From:	 	김재극 <jaegeuk.kim@samsung.com>
> > To:	 	viro@zeniv.linux.org.uk, 'Theodore Ts'o' <tytso@mit.edu>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com, jooyoung.hwang@samsung.com
> > Subject:	 	[PATCH 00/16] f2fs: introduce flash-friendly file system
> > Date:	 	Fri, 05 Oct 2012 20:55:07 +0900
> > 
> > This is a new patch set for the f2fs file system.
> > 
> > What is F2FS?
> > =============
> > 
> > NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
> > been widely being used for ranging from mobile to server systems. Since they are
> > known to have different characteristics from the conventional rotational disks,
> > a file system, an upper layer to the storage device, should adapt to the changes
> > from the sketch.
> > 
> > F2FS is a new file system carefully designed for the NAND flash memory-based storage
> > devices. We chose a log structure file system approach, but we tried to adapt it
> > to the new form of storage. Also we remedy some known issues of the very old log
> > structured file system, such as snowball effect of wandering tree and high cleaning
> > overhead.
> > 
> > Because a NAND-based storage device shows different characteristics according to
> > its internal geometry or flash memory management scheme aka FTL, we add various
> > parameters not only for configuring on-disk layout, but also for selecting allocation
> > and cleaning algorithms.
> > 
> 
> What about F2FS performance? Could you share benchmarking results of the new file system?
> 
> It is very interesting the case of aged file system. How is GC's implementation efficient? Could you share benchmarking results for the very aged file system state?
> 

Although I have benchmark results, currently I'd like to see the results
measured by community as a black-box. As you know, the results are very
dependent on the workloads and parameters, so I think it would be better
to see other results for a while.
Thanks,

> With the best regards,
> Vyacheslav Dubeyko.
> 
> > Patch set
> > =========
> > 
> > The patch #1 adds a document to Documentation/filesystems/.
> > The patch #2 adds a header file of on-disk layout to include/linux/.
> > The patches #3-#15 adds f2fs source files to fs/f2fs/.
> > The Last patch, patch #16, updates Makefile and Kconfig.
> > 
> > mkfs.f2fs
> > =========
> > 
> > The file system formatting tool, "mkfs.f2fs", is available from the following
> > download page:		
> > http://sourceforge.net/projects/f2fs-tools/
> > 
> > 
> > Usage
> > =====
> > 
> > If you'd like to experience f2fs, simply:
> > # mkfs.f2fs /dev/sdb1
> > # mount -t f2fs /dev/sdb1 /mnt/f2fs
> > 
> > Short log
> > =========
> > 
> > Jaegeuk Kim (16):
> >  f2fs: add document
> >  f2fs: add on-disk layout
> >  f2fs: add superblock and major in-memory structure
> >  f2fs: add super block operations
> >  f2fs: add checkpoint operations
> >  f2fs: add node operations
> >  f2fs: add segment operations
> >  f2fs: add file operations
> >  f2fs: add address space operations for data
> >  f2fs: add core inode operations
> >  f2fs: add inode operations for special inodes
> >  f2fs: add core directory operations
> >  f2fs: add xattr and acl functionalities
> >  f2fs: add garbage collection functions
> >  f2fs: add recovery routines for roll-forward
> >  f2fs: update Kconfig and Makefile
> > 
> > Documentation/filesystems/00-INDEX |    2 +
> > Documentation/filesystems/f2fs.txt |  314 +++++++
> > fs/Kconfig                         |    1 +
> > fs/Makefile                        |    1 +
> > fs/f2fs/Kconfig                    |   55 ++
> > fs/f2fs/Makefile                   |    6 +
> > fs/f2fs/acl.c                      |  402 ++++++++
> > fs/f2fs/acl.h                      |   57 ++
> > fs/f2fs/checkpoint.c               |  791 ++++++++++++++++
> > fs/f2fs/data.c                     |  700 ++++++++++++++
> > fs/f2fs/dir.c                      |  657 +++++++++++++
> > fs/f2fs/f2fs.h                     |  981 ++++++++++++++++++++
> > fs/f2fs/file.c                     |  643 +++++++++++++
> > fs/f2fs/gc.c                       | 1140 +++++++++++++++++++++++
> > fs/f2fs/gc.h                       |  203 +++++
> > fs/f2fs/hash.c                     |   98 ++
> > fs/f2fs/inode.c                    |  258 ++++++
> > fs/f2fs/namei.c                    |  549 +++++++++++
> > fs/f2fs/node.c                     | 1773 ++++++++++++++++++++++++++++++++++++
> > fs/f2fs/node.h                     |  331 +++++++
> > fs/f2fs/recovery.c                 |  372 ++++++++
> > fs/f2fs/segment.c                  | 1755 +++++++++++++++++++++++++++++++++++
> > fs/f2fs/segment.h                  |  627 +++++++++++++
> > fs/f2fs/super.c                    |  550 +++++++++++
> > fs/f2fs/xattr.c                    |  387 ++++++++
> > fs/f2fs/xattr.h                    |  142 +++
> > include/linux/f2fs_fs.h            |  359 ++++++++
> > 27 files changed, 13154 insertions(+)
> > create mode 100644 Documentation/filesystems/f2fs.txt
> > create mode 100644 fs/f2fs/Kconfig
> > create mode 100644 fs/f2fs/Makefile
> > create mode 100644 fs/f2fs/acl.c
> > create mode 100644 fs/f2fs/acl.h
> > create mode 100644 fs/f2fs/checkpoint.c
> > create mode 100644 fs/f2fs/data.c
> > create mode 100644 fs/f2fs/dir.c
> > create mode 100644 fs/f2fs/f2fs.h
> > create mode 100644 fs/f2fs/file.c
> > create mode 100644 fs/f2fs/gc.c
> > create mode 100644 fs/f2fs/gc.h
> > create mode 100644 fs/f2fs/hash.c
> > create mode 100644 fs/f2fs/inode.c
> > create mode 100644 fs/f2fs/namei.c
> > create mode 100644 fs/f2fs/node.c
> > create mode 100644 fs/f2fs/node.h
> > create mode 100644 fs/f2fs/recovery.c
> > create mode 100644 fs/f2fs/segment.c
> > create mode 100644 fs/f2fs/segment.h
> > create mode 100644 fs/f2fs/super.c
> > create mode 100644 fs/f2fs/xattr.c
> > create mode 100644 fs/f2fs/xattr.h
> > create mode 100644 include/linux/f2fs_fs.h
> > 
> > -- 
> > 1.7.9.5
> > 
> > 
> > 
> > 
> > ---
> > Jaegeuk Kim
> > Samsung
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  
> > http://vger.kernel.org/majordomo-info.html
> > 
> > Please read the FAQ at http://www.tux.org/lkml/
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

