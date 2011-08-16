Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1HPDaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 23:30:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:51679 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1HPDaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 23:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,378,1309762800"; 
   d="scan'208";a="7606068"
Message-Id: <20110816022006.348714319@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Aug 2011 10:20:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 0/5] IO-less dirty throttling v9 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The core bits of the IO-less balance_dirty_pages().

        git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v9

Changes since v8:

- a lot of renames and comment/changelog rework
- use 3rd order polynomial as the global control line (Peter)
- stabilize dirty_ratelimit by decreasing update step size on small errors
- limit per-CPU dirtied pages to avoid dirty pages run away on 1k+ tasks (Peter)

Thanks a lot to Peter and Andrea, Vivek for the careful reviews!

shortlog:
        
        Wu Fengguang (5):
              writeback: account per-bdi accumulated dirtied pages
              writeback: dirty position control
              writeback: dirty rate control
              writeback: per task dirty rate limit
              writeback: IO-less balance_dirty_pages()

        The last 4 patches are one single logical change, but splitted here to
        make it easier to review the different parts of the algorithm.

diffstat:

	 fs/fs-writeback.c                |    2 
	 include/linux/backing-dev.h      |    8 
	 include/linux/sched.h            |    7 
	 include/linux/writeback.h        |    1 
	 include/trace/events/writeback.h |   24 -
	 kernel/fork.c                    |    3 
	 mm/backing-dev.c                 |    3 
	 mm/page-writeback.c              |  544 ++++++++++++++++++++---------
	 8 files changed, 414 insertions(+), 178 deletions(-)

Thanks,
Fengguang


