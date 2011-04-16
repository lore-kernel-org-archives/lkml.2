Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab1DPOGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:06:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:65046 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1DPODf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="629740664"
Message-Id: <20110416132546.765212221@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] IO-less dirty throttling v7 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This revision undergoes a number of simplifications, cleanups and fixes.
Independent patches are separated out. The core patches (07, 08) now have
easier to understand changelog. Detailed rationals can be found in patch 08.

In response to the complexity complaints, an introduction document is
written explaining the rationals, algorithm and visual case studies:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf

The full patchset is accessible in

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v7

Questions, reviews and independent tests will be highly appreciated.

supporting functionalities

	[PATCH 01/12] writeback: account per-bdi accumulated written pages
	[PATCH 02/12] writeback: account per-bdi accumulated dirtied pages
	[PATCH 03/12] writeback: bdi write bandwidth estimation
	[PATCH 04/12] writeback: smoothed global/bdi dirty pages
	[PATCH 05/12] writeback: smoothed dirty threshold and limit
	[PATCH 06/12] writeback: enforce 1/4 gap between the dirty/background thresholds

core changes

	[PATCH 07/12] writeback: base throttle bandwidth and position ratio
	[PATCH 08/12] writeback: IO-less balance_dirty_pages()

tracing

	[PATCH 09/12] writeback: show bdi write bandwidth in debugfs
	[PATCH 10/12] writeback: trace dirty_ratelimit
	[PATCH 11/12] writeback: trace balance_dirty_pages
	[PATCH 12/12] writeback: trace global_dirty_state

 fs/fs-writeback.c                |    3 
 include/linux/backing-dev.h      |   23 
 include/linux/sched.h            |    8 
 include/linux/writeback.h        |   49 +
 include/trace/events/writeback.h |  179 +++++
 mm/backing-dev.c                 |   51 +
 mm/memory_hotplug.c              |    3 
 mm/page-writeback.c              |  980 +++++++++++++++++++++++------
 8 files changed, 1085 insertions(+), 211 deletions(-)

Thanks,
Fengguang

