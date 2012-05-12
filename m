Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2ELLxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:53:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2ELLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:53:14 -0400
Date: Sat, 12 May 2012 04:52:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, Cong Wang <amwang@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] shmem/tmpfs: misc and fallocate
Message-ID: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a bunch of shmem/tmpfs updates: mostly completed in January,
then put aside while I attended to other stuff.  But the more recent
1/10 has some urgency, so I'm expediting the descriptions, and shipping
them off to you now for v3.5.

They're diffed against 3.4.0-rc5-next-20120504, but
apply and build and work on most v3.4-rc and v3.4-rc-next.

The fallocate ones were prompted by posts from Cong Wang in November:
I've attributed four of those with Based-on-patch-by, but could not
put From or Signed-off-by, since the originals were somewhat flawed,
and I needed to start again and reorder it all.

Whether 10/10 should go any further than exposure in -next
is in doubt: we shall have to see if it's useful to anyone.

 1/10 shmem: replace page if mapping excludes its zone
 2/10 tmpfs: enable NOSEC optimization
 3/10 tmpfs: optimize clearing when writing
 4/10 tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE
 5/10 mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
 6/10 mm/fs: remove truncate_range
 7/10 tmpfs: support fallocate preallocation
 8/10 tmpfs: undo fallocation on failure
 9/10 tmpfs: quit when fallocate fills memory
10/10 tmpfs: support SEEK_DATA and SEEK_HOLE

 Documentation/filesystems/Locking |    2 
 Documentation/filesystems/vfs.txt |   13 
 drivers/staging/android/ashmem.c  |    8 
 fs/bad_inode.c                    |    1 
 include/linux/fs.h                |    1 
 include/linux/mm.h                |    4 
 include/linux/swap.h              |    6 
 mm/madvise.c                      |   15 
 mm/memcontrol.c                   |   17 
 mm/shmem.c                        |  513 +++++++++++++++++++++++++---
 mm/swapfile.c                     |    2 
 mm/truncate.c                     |   25 -
 12 files changed, 500 insertions(+), 107 deletions(-)

Hugh
