Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2L1CAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 21:00:47 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:54714 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2L1CAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 21:00:46 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1356659666.9202.4.camel@kjgkr>
References: <1356659666.9202.4.camel@kjgkr>
Date: Fri, 28 Dec 2012 03:00:44 +0100
Message-ID: <CA+icZUWXMJ9oEgNDsJ=syBn8MmLL=hVhBKUqUs=GM4ZMHrgQaA@mail.gmail.com>
Subject: Re: [GIT PULL] f2fs fixes for 3.8-rc2
From: Sedat Dilek <sedat.dilek@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like you didn't S-o-b-ed all patches in your tree (see Leon's or
Geert's patch).

- Sedat -

On Fri, Dec 28, 2012 at 2:54 AM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Hi Linus,
>
> Please pull the following patches for bug fixes on the f2fs file system.
> Thank you very much.
>
> --
> Jaegeuk Kim
> Samsung
>
> The following changes since commit
> 637704cbc95c02d18741b4a6e7a5d2397f8b28ce:
>
>   Merge branch 'i2c-embedded/for-next' of
> git://git.pengutronix.de/git/wsa/linux (2012-12-23 09:48:33 -0800)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
> tags/for-linus
>
> for you to fetch changes up to 782c92d129775840cf9c1ad334f0722df9c76dc0:
>
>   f2fs: unify string length declarations and usage (2012-12-28 09:57:55
> +0900)
>
> ----------------------------------------------------------------
> f2fs: bug fixes for 3.8-rc2
>
> This patch-set includes two major bug fixes:
> - incorrect IUsed provided by *df -i*, and
> - lookup failure of parent inodes in corner cases.
>
> [Other Bug Fixes]
> - Fix error handling routines
> - Trigger recovery process correctly
> - Resolve build failures due to missing header files
>
> [Etc]
> - Add a MAINTAINERS entry for f2fs
> - Fix and clean up variables, functions, and equations
> - Avoid warnings during compilation
>
> ----------------------------------------------------------------
> Geert Uytterhoeven (1):
>       f2fs: add missing #include <linux/prefetch.h>
>
> Jaegeuk Kim (11):
>       f2fs: remove set_page_dirty for atomic f2fs_end_io_write
>       f2fs: fix wrong calculation on f_files in statfs
>       f2fs: fix handling errors got by f2fs_write_inode
>       f2fs: should recover orphan and fsync data
>       f2fs: do f2fs_balance_fs in front of dir operations
>       f2fs: invalidate the node page if allocation is failed
>       f2fs: return a default value for non-void function
>       f2fs: add MAINTAINERS entry
>       f2fs: fix equation of has_not_enough_free_secs()
>       f2fs: clean up the start_bidx_of_node function
>       f2fs: clean up unused variables and return values
>
> Leon Romanovsky (1):
>       f2fs: unify string length declarations and usage
>
> Namjae Jeon (5):
>       f2fs: fix up f2fs_get_parent issue to retrieve correct parent
> inode number
>       f2fs: handle error from f2fs_iget_nowait
>       f2fs: remove unneeded initialization of nr_dirty in
> dirty_seglist_info
>       f2fs: fix fsync_inode list addition logic and avoid invalid access
> to memory
>       f2fs: remove unneeded variable from f2fs_sync_fs
>
>  MAINTAINERS        | 10 ++++++++++
>  fs/f2fs/data.c     |  1 +
>  fs/f2fs/dir.c      | 16 +++++++++-------
>  fs/f2fs/f2fs.h     |  2 +-
>  fs/f2fs/file.c     | 10 ++++++----
>  fs/f2fs/gc.c       | 34 +++++++++++-----------------------
>  fs/f2fs/hash.c     | 18 +++++++++++-------
>  fs/f2fs/inode.c    |  1 +
>  fs/f2fs/namei.c    | 34 +++++++++++++++++-----------------
>  fs/f2fs/node.c     | 37 ++++++++++++++-----------------------
>  fs/f2fs/recovery.c | 10 +++++++---
>  fs/f2fs/segment.c  | 46 ++++++----------------------------------------
>  fs/f2fs/segment.h  | 15 ++++++++++++++-
>  fs/f2fs/super.c    | 15 ++++++---------
>  fs/f2fs/xattr.c    |  5 +++--
>  15 files changed, 117 insertions(+), 137 deletions(-)
>
