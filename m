Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0GKCiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:38:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:41016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0GKCiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:38:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,182,1278313200"; 
   d="scan'208";a="816867793"
Message-Id: <20100711020656.340075560@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 11 Jul 2010 10:06:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
cc: <linux-fsdevel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] writeback cleanups and trivial fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are some writeback cleanups to avoid unnecessary calculation overheads,
and relative simple bug fixes.

The patch applies to latest linux-next tree. The mmotm tree will need rebase
to include commit 32422c79 (writeback: Add tracing to balance_dirty_pages)
in order to avoid merge conflicts.

[PATCH 1/6] writeback: take account of NR_WRITEBACK_TEMP in balance_dirty_pages()
[PATCH 2/6] writeback: reduce calls to global_page_state in balance_dirty_pages()
[PATCH 3/6] writeback: avoid unnecessary calculation of bdi dirty thresholds

[PATCH 4/6] writeback: dont redirty tail an inode with dirty pages
[PATCH 5/6] writeback: fix queue_io() ordering
[PATCH 6/6] writeback: merge for_kupdate and !for_kupdate cases

 fs/fs-writeback.c         |   68 ++++-----------
 include/linux/writeback.h |    5 -
 mm/backing-dev.c          |    3 
 mm/page-writeback.c       |  158 ++++++++++++++----------------------
 4 files changed, 89 insertions(+), 145 deletions(-)

Thanks,
Fengguang

