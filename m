Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1DSDKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:6529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab1DSDKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911423202"
Message-Id: <20110419030003.108796967@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 0/6] writeback: moving expire targets for background/kupdate works
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

This aims to reduce possible pageout() calls by making the flusher
concentrate a bit more on old/expired dirty inodes.

Patches 04, 05 have been updated since last post, please review.
The concerns from last review have been addressed.

It runs fine on simple workloads over ext3/4, xfs, btrfs and NFS.

Trond, will you take the last patch? The fixed "bug" has no real impact for now.

make dirty expire time a moving target
        [PATCH 1/6] writeback: pass writeback_control down to move_expired_inodes()
        [PATCH 2/6] writeback: the kupdate expire timestamp should be a moving target
        [PATCH 3/6] writeback: sync expired inodes first in background writeback

loop condition fixes (the most tricky part)
        [PATCH 4/6] writeback: introduce writeback_control.inodes_cleaned
        [PATCH 5/6] writeback: try more writeback as long as something was written

NFS fix
        [PATCH 6/6] NFS: return -EAGAIN when skipped commit in nfs_commit_unstable_pages()

Thanks,
Fengguang

