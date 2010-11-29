Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0K2Kit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:38:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:20959 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab0K2Kis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:38:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,275,1288594800"; 
   d="scan'208";a="354358103"
Date: Mon, 29 Nov 2010 18:38:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [BUGFIX] vmstat: fix dirty threshold ordering
Message-ID: <20101129103845.GA1195@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_dirty_[background_]threshold fields are misplaced before the
numa_* fields, and users will read strange values.

This is the right order. Before patch, nr_dirty_background_threshold
will read as 0 (the value from numa_miss).

	numa_hit 128501
	numa_miss 0
	numa_foreign 0
	numa_interleave 7388
	numa_local 128501
	numa_other 0
	nr_dirty_threshold 144291
	nr_dirty_background_threshold 72145

Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/vmstat.c	2010-11-28 16:02:12.000000000 +0800
+++ linux-next/mm/vmstat.c	2010-11-28 16:02:24.000000000 +0800
@@ -750,8 +750,6 @@ static const char * const vmstat_text[] 
 	"nr_shmem",
 	"nr_dirtied",
 	"nr_written",
-	"nr_dirty_threshold",
-	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
@@ -761,6 +759,8 @@ static const char * const vmstat_text[] 
 	"numa_local",
 	"numa_other",
 #endif
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 	"pgpgin",
