Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2JELzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:55:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49546 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JELzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:55:12 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-bd-506eca9dc3c7
From: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
To: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Fri, 05 Oct 2012 20:55:07 +0900
Message-id: <000701cda2f0$43ef2810$cbcd7830$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2i8EPJbb/IeikcRBO4V/N6RCAJrw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd15p/ICDN4tZbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZP07uYC2YrVrxfMYO1gbGDukuRk4OCQETicWTJjNB2GISF+6t
	Z+ti5OIQEpjOKPH+8R9mCGc+k8SOi1NZuxg5ONgELCTaL7uDxEUE7jFKXFo2E6xbWMBR4uLp
	q8wgNouAqsT6h7OYQOp5BWwltl6qBwnzCghK/Jh8jwUkzCygLjFlSi5ImFlAXmLzmrfMIGEJ
	oPCjv7ogYREBPYmJu08yQZSISOx78Y5xAiP/LCSDZiEMmoVk0CwkHQsYWVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBIfeM6kdjCsbLA4xCnAwKvHwJjzMDRBiTSwrrsw9xCjBwawkwms9
	Oy9AiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJg1OqgXH7xz69
	BKMoaY4Wy3kCRf5u7HxPP06IS1w523LJbM8w5eqiIx98Vx9eJtnVUX9o07TbcU96KxMtL7U/
	O9b7x/xXvHxjK9uctq9Nti7MMzULN0gs/Zhl9+vcn9P98o7XT7uc+y736cQCLrWXDV/r5xak
	bp/fqaI1t8etsPUzx/dV85W7FAtuXVdiKc5INNRiLipOBABF5K72OQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new patch set for the f2fs file system.

What is F2FS?
=============

NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
been widely being used for ranging from mobile to server systems. Since they are
known to have different characteristics from the conventional rotational disks,
a file system, an upper layer to the storage device, should adapt to the changes
from the sketch.

F2FS is a new file system carefully designed for the NAND flash memory-based storage
devices. We chose a log structure file system approach, but we tried to adapt it
to the new form of storage. Also we remedy some known issues of the very old log
structured file system, such as snowball effect of wandering tree and high cleaning
overhead.

Because a NAND-based storage device shows different characteristics according to
its internal geometry or flash memory management scheme aka FTL, we add various
parameters not only for configuring on-disk layout, but also for selecting allocation
and cleaning algorithms.

Patch set
=========

The patch #1 adds a document to Documentation/filesystems/.
The patch #2 adds a header file of on-disk layout to include/linux/.
The patches #3-#15 adds f2fs source files to fs/f2fs/.
The Last patch, patch #16, updates Makefile and Kconfig.

mkfs.f2fs
=========

The file system formatting tool, "mkfs.f2fs", is available from the following
download page:		http://sourceforge.net/projects/f2fs-tools/

Usage
=====

If you'd like to experience f2fs, simply:
 # mkfs.f2fs /dev/sdb1
 # mount -t f2fs /dev/sdb1 /mnt/f2fs

Short log
=========

Jaegeuk Kim (16):
  f2fs: add document
  f2fs: add on-disk layout
  f2fs: add superblock and major in-memory structure
  f2fs: add super block operations
  f2fs: add checkpoint operations
  f2fs: add node operations
  f2fs: add segment operations
  f2fs: add file operations
  f2fs: add address space operations for data
  f2fs: add core inode operations
  f2fs: add inode operations for special inodes
  f2fs: add core directory operations
  f2fs: add xattr and acl functionalities
  f2fs: add garbage collection functions
  f2fs: add recovery routines for roll-forward
  f2fs: update Kconfig and Makefile

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/f2fs.txt |  314 +++++++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/f2fs/Kconfig                    |   55 ++
 fs/f2fs/Makefile                   |    6 +
 fs/f2fs/acl.c                      |  402 ++++++++
 fs/f2fs/acl.h                      |   57 ++
 fs/f2fs/checkpoint.c               |  791 ++++++++++++++++
 fs/f2fs/data.c                     |  700 ++++++++++++++
 fs/f2fs/dir.c                      |  657 +++++++++++++
 fs/f2fs/f2fs.h                     |  981 ++++++++++++++++++++
 fs/f2fs/file.c                     |  643 +++++++++++++
 fs/f2fs/gc.c                       | 1140 +++++++++++++++++++++++
 fs/f2fs/gc.h                       |  203 +++++
 fs/f2fs/hash.c                     |   98 ++
 fs/f2fs/inode.c                    |  258 ++++++
 fs/f2fs/namei.c                    |  549 +++++++++++
 fs/f2fs/node.c                     | 1773 ++++++++++++++++++++++++++++++++++++
 fs/f2fs/node.h                     |  331 +++++++
 fs/f2fs/recovery.c                 |  372 ++++++++
 fs/f2fs/segment.c                  | 1755 +++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h                  |  627 +++++++++++++
 fs/f2fs/super.c                    |  550 +++++++++++
 fs/f2fs/xattr.c                    |  387 ++++++++
 fs/f2fs/xattr.h                    |  142 +++
 include/linux/f2fs_fs.h            |  359 ++++++++
 27 files changed, 13154 insertions(+)
 create mode 100644 Documentation/filesystems/f2fs.txt
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile
 create mode 100644 fs/f2fs/acl.c
 create mode 100644 fs/f2fs/acl.h
 create mode 100644 fs/f2fs/checkpoint.c
 create mode 100644 fs/f2fs/data.c
 create mode 100644 fs/f2fs/dir.c
 create mode 100644 fs/f2fs/f2fs.h
 create mode 100644 fs/f2fs/file.c
 create mode 100644 fs/f2fs/gc.c
 create mode 100644 fs/f2fs/gc.h
 create mode 100644 fs/f2fs/hash.c
 create mode 100644 fs/f2fs/inode.c
 create mode 100644 fs/f2fs/namei.c
 create mode 100644 fs/f2fs/node.c
 create mode 100644 fs/f2fs/node.h
 create mode 100644 fs/f2fs/recovery.c
 create mode 100644 fs/f2fs/segment.c
 create mode 100644 fs/f2fs/segment.h
 create mode 100644 fs/f2fs/super.c
 create mode 100644 fs/f2fs/xattr.c
 create mode 100644 fs/f2fs/xattr.h
 create mode 100644 include/linux/f2fs_fs.h

-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



