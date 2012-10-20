Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2JTMVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:21:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55543 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2JTMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:21:20 -0400
Message-ID: <508295AF.60606@gmail.com>
Date: Sat, 20 Oct 2012 14:14:39 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Evgeniy Dushistov <dushistov@mail.ru>, reiserfs-devel@vger.kernel.org,
        Bob Copeland <me@bobcopeland.com>, ocfs2-devel@oss.oracle.com,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        jfs-discussion@lists.sourceforge.net, logfs@logfs.org,
        Petr Vandrovec <petr@vandrovec.name>, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: [PATCH 00/21 v3] drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I sent the third version of the patch series. After a couple of comments 
by Al and Christoph, now the patches are no more 1:1 replace of 
vmtruncate. A lot of inode_newsize_ok() and truncate_setsize() are now 
gone. For each fs, where needed, I wrote a new fs_write_failed() (as 
suggested by Al watching the ext2 code). The modifications are a bit 
deeper and they are *not* tested. I ask for comments to each fs 
maintainers. I hope the series can be pushed for 3.8.

Changes:
v3: reworked after Al and Christoph comments
v2: add documentation cleaning
v1: first draft

Marco Stornelli (21):
   ufs: drop vmtruncate
   sysv: drop vmtruncate
   reiserfs: drop vmtruncate
   procfs: drop vmtruncate
   omfs: drop vmtruncate
   ocfs2: drop vmtruncate
   adfs: drop vmtruncate
   affs: drop vmtruncate
   bfs: drop vmtruncate
   hfs: drop vmtruncate
   hpfs: drop vmtruncate
   jfs: drop vmtruncate
   hfsplus: drop vmtruncate
   logfs: drop vmtruncate
   minix: drop vmtruncate
   ncpfs: drop vmtruncate
   nilfs2: drop vmtruncate
   ntfs: drop vmtruncate
   vfs: drop vmtruncate
   mm: drop vmtruncate
   Documentation: drop vmtruncate

  Documentation/filesystems/Locking |    6 ------
  Documentation/filesystems/porting |    2 +-
  Documentation/filesystems/vfs.txt |   11 -----------
  fs/adfs/inode.c                   |   15 ++++++++++-----
  fs/affs/file.c                    |   18 ++++++++++++------
  fs/affs/inode.c                   |    5 ++++-
  fs/bfs/file.c                     |   15 ++++++++++-----
  fs/hfs/inode.c                    |   26 ++++++++++++++++++--------
  fs/hfsplus/inode.c                |   27 ++++++++++++++++-----------
  fs/hpfs/file.c                    |   18 ++++++++++++------
  fs/hpfs/inode.c                   |    5 ++++-
  fs/jfs/file.c                     |    6 ++++--
  fs/jfs/inode.c                    |   20 ++++++++++++++------
  fs/libfs.c                        |    2 --
  fs/logfs/readwrite.c              |   10 ++++++++--
  fs/minix/file.c                   |    6 ++++--
  fs/minix/inode.c                  |   17 ++++++++++++-----
  fs/ncpfs/inode.c                  |    4 +---
  fs/nilfs2/file.c                  |    1 -
  fs/nilfs2/inode.c                 |   24 +++++++++++++++---------
  fs/nilfs2/nilfs.h                 |    1 +
  fs/nilfs2/recovery.c              |    3 ++-
  fs/ntfs/file.c                    |   16 +++++++++++++---
  fs/ntfs/inode.c                   |    8 ++++++--
  fs/ntfs/inode.h                   |    4 ++++
  fs/ocfs2/file.c                   |   19 +------------------
  fs/omfs/file.c                    |   22 +++++++++++++++-------
  fs/proc/base.c                    |    3 ++-
  fs/proc/generic.c                 |    3 ++-
  fs/proc/proc_sysctl.c             |    3 ++-
  fs/reiserfs/file.c                |    3 +--
  fs/reiserfs/inode.c               |   15 +++++++++++----
  fs/reiserfs/reiserfs.h            |    1 +
  fs/sysv/file.c                    |    5 +++--
  fs/sysv/itree.c                   |   17 ++++++++++++-----
  fs/ufs/inode.c                    |   15 ++++++++++-----
  include/linux/fs.h                |    1 -
  include/linux/mm.h                |    1 -
  mm/truncate.c                     |   23 -----------------------
  39 files changed, 231 insertions(+), 170 deletions(-)

-- 
1.7.3.4
---

