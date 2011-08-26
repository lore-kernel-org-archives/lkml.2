Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1HZLrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:47:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:39650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1HZLrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42702461"
Message-Id: <20110826113813.895522398@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Aug 2011 19:38:13 +0800
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
Subject: [PATCH 00/10] IO-less dirty throttling v10 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The core algorithms for IO-less balance_dirty_pages().

        git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v10

Changes since v9:

- a lot of renames and comment/changelog rework, again
- seperate out the dirty_ratelimit update policy (as patch 04)
- add think time compensation
- add 3 trace events

Changes since v8:

- a lot of renames and comment/changelog rework
- use 3rd order polynomial as the global control line (Peter)
- stabilize dirty_ratelimit by decreasing update step size on small errors
- limit per-CPU dirtied pages to avoid dirty pages run away on 1k+ tasks (Peter)

Thanks a lot to Peter, Vivek and Andrea for the careful reviews!

shortlog:

	Wu Fengguang (10):
	      writeback: account per-bdi accumulated dirtied pages
	      writeback: dirty position control
	      writeback: dirty rate control
	      writeback: stabilize bdi->dirty_ratelimit
	      writeback: per task dirty rate limit
	      writeback: IO-less balance_dirty_pages()
	      writeback: dirty ratelimit - think time compensation
	      writeback: trace balance_dirty_pages
	      writeback: trace dirty_ratelimit
	      trace task_io (RFC)

diffstat:

	 fs/fs-writeback.c                |    2 +-
	 include/linux/backing-dev.h      |    8 +
	 include/linux/sched.h            |    8 +
	 include/linux/writeback.h        |    1 +
	 include/trace/events/writeback.h |  181 +++++++++--
	 kernel/fork.c                    |    4 +
	 mm/backing-dev.c                 |    3 +
	 mm/page-writeback.c              |  664 +++++++++++++++++++++++++++++---------
	 8 files changed, 693 insertions(+), 178 deletions(-)

Thanks,
Fengguang

