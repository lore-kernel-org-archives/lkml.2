Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1K1OLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:11:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:49496 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1K1OJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:09:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79787542"
Message-Id: <20111128135338.249672012@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 21:53:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] dirty throttling bits for 3.3 (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are now 7 dirty throttling improvements targeting for Linux 3.3.

Changes since v1:
- added many comments and enriched changelog 
- rename dirty_leaks to dirty_throttle_leaks
- add the btrfs accounting fix for sub-page writes
- account bdp_ratelimits at page dirty time (and use this_cpu_inc)

 [PATCH 1/7] writeback: balanced_rate cannot exceed write bandwidth
 [PATCH 2/7] writeback: charge leaked page dirties to active tasks
 [PATCH 3/7] writeback: fix dirtied pages accounting on sub-page writes
 [PATCH 4/7] writeback: fix dirtied pages accounting on redirty
 [PATCH 5/7] btrfs: fix dirtied pages accounting on sub-page writes
 [PATCH 6/7] writeback: dirty ratelimit - think time compensation
 [PATCH 7/7] writeback: comment on the bdi dirty threshold

 fs/btrfs/file.c                  |    3 
 include/linux/sched.h            |    1 
 include/linux/writeback.h        |    4 +
 include/trace/events/writeback.h |   14 ++-
 kernel/exit.c                    |    2 
 kernel/fork.c                    |    1 
 mm/page-writeback.c              |  116 +++++++++++++++++++++++++----
 7 files changed, 123 insertions(+), 18 deletions(-)

Thanks,
Fengguang


