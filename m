Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1APDXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 22:23:10 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:36617 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab1APDXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 22:23:09 -0500
Message-ID: <4D326494.7060707@lougher.demon.co.uk>
Date: Sun, 16 Jan 2011 03:23:00 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 2.6.38
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please consider pulling the following Squashfs update which adds
support for XZ compressed file systems.  In addition to that there's
some minor code improvements/tidying and the addition of a missing
error check to the zlib decompression wrapper code.

Thanks

Phillip

-------------------------

The following changes since commit 581548db3b3c0f6e25b500329eb02e3c72e7acbe:
   Linus Torvalds (1):
         Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (7):
       Squashfs: add XZ compression support
       Squashfs: Add XZ compression configuration option
       Squashfs: remove unnecessary variable in zlib_wrapper
       Squashfs: add missing check in zlib_wrapper
       Squashfs: get rid of default n in Kconfig
       Squashfs: move squashfs_i() definition from squashfs.h
       Squashfs: simplify CONFIG_SQUASHFS_LZO handling

  fs/squashfs/Kconfig         |   18 ++++-
  fs/squashfs/Makefile        |    1 +
  fs/squashfs/block.c         |    1 -
  fs/squashfs/cache.c         |    1 -
  fs/squashfs/decompressor.c  |   16 +++--
  fs/squashfs/decompressor.h  |    9 +++
  fs/squashfs/fragment.c      |    1 -
  fs/squashfs/id.c            |    1 -
  fs/squashfs/lzo_wrapper.c   |    1 -
  fs/squashfs/squashfs.h      |    8 --
  fs/squashfs/squashfs_fs.h   |    1 +
  fs/squashfs/squashfs_fs_i.h |    6 ++
  fs/squashfs/xattr_id.c      |    1 -
  fs/squashfs/xz_wrapper.c    |  153 +++++++++++++++++++++++++++++++++++++++++++
  fs/squashfs/zlib_wrapper.c  |   15 +++--
  15 files changed, 203 insertions(+), 30 deletions(-)
  create mode 100644 fs/squashfs/xz_wrapper.c
