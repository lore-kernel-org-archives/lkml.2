Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1DTIqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:46:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:63126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab1DTIqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,245,1301900400"; 
   d="scan'208";a="735939175"
Message-Id: <20110420080336.441157866@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 16:03:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] writeback: moving expire targets for background/kupdate works v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This aims to reduce possible pageout() calls by making the flusher
concentrate a bit more on old/expired dirty inodes.

Rationals and benchmark numbers are added in patches 05, 06.

It runs fine on simple workloads over ext3/4, xfs, btrfs and NFS.

code refactor
	[PATCH 1/6] writeback: pass writeback_control down to move_expired_inodes()

loop condition fixes
	[PATCH 2/6] writeback: introduce writeback_control.inodes_cleaned
	[PATCH 3/6] writeback: try more writeback as long as something was written

make dirty expire time a moving target
	[PATCH 4/6] writeback: the kupdate expire timestamp should be a moving target
	[PATCH 5/6] writeback: sync expired inodes first in background writeback

consistent requeue policy
it's not an integral part of this patchset, however do depends on patch 03
	[PATCH 6/6] writeback: refill b_io iff empty


Thanks,
Fengguang

