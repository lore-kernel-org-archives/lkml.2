Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1LSKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:36:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:64152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1LSKgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87190437"
Message-Id: <20111219102308.488847921@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 19 Dec 2011 18:23:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/10] readahead stats/tracing, backwards prefetching and more (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This introduces the per-cpu readahead stats, tracing, backwards prefetching,
fixes context readahead for SSD random reads and does some other minor changes.

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

 [PATCH 01/10] block: limit default readahead size for small devices
 [PATCH 02/10] readahead: make context readahead more conservative
 [PATCH 03/10] readahead: record readahead patterns
 [PATCH 04/10] readahead: tag mmap page fault call sites
 [PATCH 05/10] readahead: tag metadata call sites
 [PATCH 06/10] readahead: add vfs/readahead tracing event
 [PATCH 07/10] readahead: add /debug/readahead/stats
 [PATCH 08/10] readahead: basic support for backwards prefetching
 [PATCH 09/10] readahead: dont do start-of-file readahead after lseek()
 [PATCH 10/10] readahead: snap readahead request to EOF

 block/genhd.c              |   20 ++
 fs/Makefile                |    1 
 fs/ext3/dir.c              |    1 
 fs/ext4/dir.c              |    1 
 fs/read_write.c            |    3 
 fs/trace.c                 |    2 
 include/linux/fs.h         |   41 ++++
 include/linux/mm.h         |    4 
 include/trace/events/vfs.h |   78 +++++++++
 mm/Kconfig                 |   15 +
 mm/filemap.c               |    9 -
 mm/readahead.c             |  301 +++++++++++++++++++++++++++++++++--
 12 files changed, 461 insertions(+), 15 deletions(-)

Thanks,
Fengguang



