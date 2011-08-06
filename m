Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1HFMUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 08:20:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:24755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1HFMUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 08:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,328,1309762800"; 
   d="scan'208";a="35776835"
Message-Id: <20110806084447.388624428@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 06 Aug 2011 16:44:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
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
Subject: [PATCH 0/5] IO-less dirty throttling v8 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The _core_ bits of the IO-less balance_dirty_pages().
Heavily simplified and re-commented to make it easier to review.

	git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v8

Only the bare minimal algorithms are presented, so you will find some rough
edges in the graphs below. But it's usable :)

	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/

And an introduction to the (more complete) algorithms:

	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf

Questions and reviews are highly appreciated!

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

	 include/linux/backing-dev.h      |    8 +
	 include/linux/sched.h            |    7 +
	 include/trace/events/writeback.h |   24 --
	 mm/backing-dev.c                 |    3 +
	 mm/memory_hotplug.c              |    3 -
	 mm/page-writeback.c              |  459 ++++++++++++++++++++++----------------
	 6 files changed, 290 insertions(+), 214 deletions(-)

Thanks,
Fengguang

