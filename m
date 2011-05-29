Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1E2HeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:34:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61032 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1E2HeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=b3rjA3BCAsEdBMEtJi68xNN+uZ/I3iNZvAUkdM1kerxDQAk7NRB81kj39gipEkGl7j
         i6sONNJGB0kmzSVJbvtZwLZopYMwQehzTDPDGQt4Kwg0en9XQEdw1xGwAHu1jqSMbKo5
         ojpJBXWOEE9L2331y/GP/kHOO4nfcAlwaic1E=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110524051411.924582719@intel.com>
References: <20110524051411.924582719@intel.com>
Date: Sun, 29 May 2011 09:34:16 +0200
Message-ID: <BANLkTinRXW9Ds6kW-W+7G0eqLCNTHudPUQ@mail.gmail.com>
Subject: Re: [PATCH 00/18] writeback fixes and cleanups for 2.6.40 (v4)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( Sorry for top-posting. )
I have this patchset v4 since 24-May in my series.
Is this going to be accepted within merge-window for 2.6.40 (or 3.0)?

- Sedat -

On Tue, May 24, 2011 at 7:14 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>
> Andrew,
>
> The first 10 patches are already in -mm tree, with updates:
>
> - remove "writeback: pass writeback_control down to move_expired_inodes()", and
>  resolve the resulting merge conflicts in other patches.
> - move ahead the sync livelock prevention patches (01, 02) so that (04) won't livelock sync
> - merge the three -mm fixes to (08)
> - fixed changelog of (01)
> - rename .for_sync to .tagged_writepages
>
>        [PATCH 01/18] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
>        [PATCH 02/18] writeback: update dirtied_when for synced inode to prevent livelock
>        [PATCH 03/18] writeback: introduce writeback_control.inodes_cleaned
>        [PATCH 04/18] writeback: try more writeback as long as something was written
>        [PATCH 05/18] writeback: the kupdate expire timestamp should be a moving target
>        [PATCH 06/18] writeback: sync expired inodes first in background writeback
>        [PATCH 07/18] writeback: refill b_io iff empty
>        [PATCH 08/18] writeback: split inode_wb_list_lock into bdi_writeback.list_lock
>        [PATCH 09/18] writeback: elevate queue_io() into wb_writeback()
>        [PATCH 10/18] writeback: avoid extra sync work at enqueue time
>
> The following 6 patches are trivial and safe
>
>        [PATCH 11/18] writeback: add bdi_dirty_limit() kernel-doc
>        [PATCH 12/18] writeback: skip balance_dirty_pages() for in-memory fs
>        [PATCH 13/18] writeback: remove writeback_control.more_io
>        [PATCH 14/18] writeback: remove .nonblocking and .encountered_congestion
>        [PATCH 15/18] writeback: trace event writeback_single_inode
>        [PATCH 16/18] writeback: trace event writeback_queue_io
>
> Patch 17 is a bit more complex
>
>        [PATCH 17/18] writeback: make writeback_control.nr_to_write straight
>        [PATCH 18/18] writeback: rearrange the wb_writeback() loop
>
> Thanks to Jan and Dave for the careful reviews!
>
> The patches are git pullable from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback
>
>  fs/block_dev.c                   |   16 +-
>  fs/btrfs/extent_io.c             |    2 -
>  fs/ext4/inode.c                  |    4 +-
>  fs/fs-writeback.c                |  411 +++++++++++++++++++++-----------------
>  fs/inode.c                       |    5 +-
>  fs/nfs/write.c                   |    3 +-
>  fs/xfs/linux-2.6/xfs_aops.c      |    2 +-
>  include/linux/backing-dev.h      |    2 +
>  include/linux/writeback.h        |   14 +-
>  include/trace/events/btrfs.h     |    6 +-
>  include/trace/events/ext4.h      |    6 +-
>  include/trace/events/writeback.h |  137 ++++++++++++--
>  mm/backing-dev.c                 |   30 ++-
>  mm/filemap.c                     |    6 +-
>  mm/page-writeback.c              |   42 ++--
>  mm/rmap.c                        |    4 +-
>  16 files changed, 420 insertions(+), 270 deletions(-)
>
> Thanks,
> Fengguang
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
