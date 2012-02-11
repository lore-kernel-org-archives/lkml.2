Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2BKJvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 04:51:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:32463 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab2BKJvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 04:51:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105714166"
Message-Id: <20120211043140.108656864@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 11 Feb 2012 12:31:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] readahead stats/tracing, backwards prefetching and more (v5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This introduces the per-cpu readahead stats, tracing, backwards prefetching,
fixes context readahead for SSD random reads and does some other minor changes.

Changes since v4:
- fix changelog for readahead stats

Changes since v3:
- default to CONFIG_READAHEAD_STATS=n
- drop "block: limit default readahead size for small devices"
  (and expect some distro udev rules to do the job)
- use percpu_counter for the readahead stats

Changes since v2:
- use per-cpu counters for readahead stats
- make context readahead more conservative
- simplify readahead tracing format and use __print_symbolic()
- backwards prefetching and snap to EOF fixes and cleanups

Changes since v1:
- use bit fields: pattern, for_mmap, for_metadata, lseek
- comment the various readahead patterns
- drop boot options "readahead=" and "readahead_stats="
- add for_metadata
- add snapping to EOF

 [PATCH 1/9] readahead: make context readahead more conservative
 [PATCH 2/9] readahead: record readahead patterns
 [PATCH 3/9] readahead: tag mmap page fault call sites
 [PATCH 4/9] readahead: tag metadata call sites
 [PATCH 5/9] readahead: add vfs/readahead tracing event
 [PATCH 6/9] readahead: add /debug/readahead/stats
 [PATCH 7/9] readahead: dont do start-of-file readahead after lseek()
 [PATCH 8/9] readahead: snap readahead request to EOF
 [PATCH 9/9] readahead: basic support for backwards prefetching

 fs/Makefile                |    1 
 fs/ext3/dir.c              |    1 
 fs/ext4/dir.c              |    1 
 fs/read_write.c            |    3 
 fs/trace.c                 |    2 
 include/linux/fs.h         |   41 ++++
 include/linux/mm.h         |    4 
 include/trace/events/vfs.h |   78 ++++++++
 mm/Kconfig                 |   15 +
 mm/filemap.c               |    9 -
 mm/readahead.c             |  310 +++++++++++++++++++++++++++++++++--
 11 files changed, 450 insertions(+), 15 deletions(-)

Thanks,
Fengguang

