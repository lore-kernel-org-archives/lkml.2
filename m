Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1ITNqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1ITNqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:46:48 -0400
From: Johannes Weiner <jweiner@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page allocations
Date: Tue, 20 Sep 2011 15:45:15 +0200
Message-Id: <1316526315-16801-5-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell the page allocator that pages allocated for a buffered write are
expected to become dirty soon.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 fs/btrfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..ea1b892 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1084,7 +1084,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
-					       GFP_NOFS);
+					       GFP_NOFS | __GFP_WRITE);
 		if (!pages[i]) {
 			faili = i - 1;
 			err = -ENOMEM;
-- 
1.7.6

