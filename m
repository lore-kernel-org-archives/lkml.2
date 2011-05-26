Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab1EZWjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:39:09 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:63421 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab1EZWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:39:07 -0400
Message-ID: <4DDED684.9070205@lougher.demon.co.uk>
Date: Thu, 26 May 2011 23:39:00 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 2.6.40 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs updates, which mostly
add some extra superblock sanity checks at mount time.  This fixes a
number of fsfuzzer corrupted filesystem warn_ons.

Thanks

Phillip


The following changes since commit 117a91e0f25fd7698e20ac3dfa62086be3dc82a3:

   Squashfs: Use vmalloc rather than kmalloc for zlib workspace (2011-03-22 23:01:26 +0000)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (8):
       Squashfs: move table allocation into squashfs_read_table()
       Squashfs: reverse order of filesystem table reading
       Squashfs: add sanity checks to xattr reading at mount time
       Squashfs: add sanity checks to id reading at mount time
       Squashfs: add sanity checks to lookup table reading at mount time
       Squashfs: add sanity checks to fragment reading at mount time
       Squashfs: add extra sanity checks at mount time
       Squashfs: update email address

  MAINTAINERS                  |    2 +-
  fs/squashfs/block.c          |    2 +-
  fs/squashfs/cache.c          |   31 +++++++++---
  fs/squashfs/decompressor.c   |    2 +-
  fs/squashfs/decompressor.h   |    2 +-
  fs/squashfs/dir.c            |    2 +-
  fs/squashfs/export.c         |   42 +++++++++------
  fs/squashfs/file.c           |    2 +-
  fs/squashfs/fragment.c       |   37 ++++++++------
  fs/squashfs/id.c             |   42 ++++++++++------
  fs/squashfs/inode.c          |    2 +-
  fs/squashfs/namei.c          |    2 +-
  fs/squashfs/squashfs.h       |   10 ++--
  fs/squashfs/squashfs_fs.h    |    2 +-
  fs/squashfs/squashfs_fs_i.h  |    2 +-
  fs/squashfs/squashfs_fs_sb.h |    2 +-
  fs/squashfs/super.c          |  112 ++++++++++++++++++++++++-----------------
  fs/squashfs/symlink.c        |    2 +-
  fs/squashfs/xattr.c          |    2 +-
  fs/squashfs/xattr.h          |    3 +-
  fs/squashfs/xattr_id.c       |   47 ++++++++----------
  fs/squashfs/xz_wrapper.c     |    2 +-
  fs/squashfs/zlib_wrapper.c   |    2 +-
  23 files changed, 203 insertions(+), 151 deletions(-)
