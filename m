Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2KPJvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:51:37 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60865 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2KPJvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:51:35 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 resend hot_track 00/16] vfs: hot data tracking
Date: Fri, 16 Nov 2012 17:51:02 +0800
Message-Id: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-5806-0000-0000-00001BD842C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

HI, guys,

  Any comments or ideas are appreciated, thanks.

NOTE:

  The patchset can be obtained via my kernel dev git on github:
git://github.com/wuzhy/kernel.git hot_tracking
  If you're interested, you can also review them via
https://github.com/wuzhy/kernel/commits/hot_tracking

  For more info, please check hot_tracking.txt in Documentation

TODO List:

 1.) Need to do scalability or performance tests. - Required
 2.) Need one simpler but efficient temp calculation function
 3.) How to save the file temperature among the umount to be able to
     preserve the file tempreture after reboot - Optional

Changelog:

 - Solved 64 bits inode number issue. [David Sterba]
 - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
 - Cleanup Some issues [David Sterba]
 - Use a static hot debugfs root [Greg KH]
 - Rewritten debugfs support based on seq_file operation. [Dave Chinner]
 - Refactored workqueue support. [Dave Chinner]
 - Turn some Micro into be tunable   [Zhiyong, Zheng Liu]
       TIME_TO_KICK, and HEAT_UPDATE_DELAY
 - Introduce hot func registering framework [Zhiyong]
 - Remove global variable for hot tracking [Zhiyong]
 - Add xfs hot tracking support [Dave Chinner]
 - Add ext4 hot tracking support [Zheng Liu]
 - Cleanedup a lot of other issues [Dave Chinner]
 - Added memory shrinker [Dave Chinner]
 - Converted to one workqueue to update map info periodically [Dave Chinner]
 - Cleanedup a lot of other issues [Dave Chinner]
 - Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 - Add btrfs hot tracking support [Zhiyong]
 - The first three patches can probably just be flattened into one.
                                        [Marco Stornelli , Dave Chinner]

Zhi Yong Wu (16):
  vfs: introduce some data structures
  vfs: add init and cleanup functions
  vfs: add I/O frequency update function
  vfs: add two map arrays
  vfs: add hooks to enable hot tracking
  vfs: add temp calculation function
  vfs: add map info update function
  vfs: add aging function
  vfs: add one work queue
  vfs: add FS hot type support
  vfs: register one shrinker
  vfs: add one ioctl interface
  vfs: add debugfs support
  proc: add two hot_track proc files
  btrfs: add hot tracking support
  vfs: add documentation

 Documentation/filesystems/00-INDEX         |    2 +
 Documentation/filesystems/hot_tracking.txt |  263 ++++++
 fs/Makefile                                |    2 +-
 fs/btrfs/ctree.h                           |    1 +
 fs/btrfs/super.c                           |   22 +-
 fs/compat_ioctl.c                          |    5 +
 fs/dcache.c                                |    2 +
 fs/direct-io.c                             |    6 +
 fs/hot_tracking.c                          | 1306 ++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |   52 ++
 fs/ioctl.c                                 |   74 ++
 include/linux/fs.h                         |    5 +
 include/linux/hot_tracking.h               |  152 ++++
 kernel/sysctl.c                            |   14 +
 mm/filemap.c                               |    6 +
 mm/page-writeback.c                        |   12 +
 mm/readahead.c                             |    7 +
 17 files changed, 1929 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.6.5

