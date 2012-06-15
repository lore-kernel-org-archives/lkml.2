Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab2FOBZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:25:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39770 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2FOBZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:25:40 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/vmscan: cleanup on the comments of do_try_to_free_pages
Date: Fri, 15 Jun 2012 09:25:24 +0800
Message-Id: <1339723524-6332-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since lumpy reclaim algorithm is removed by Mel Gorman, cleanup the
footprint of lumpy reclaim.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 603c96f..2fc16cf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2065,8 +2065,9 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 * Try to write back as many pages as we just scanned.  This
 		 * tends to cause slow streaming writers to write data to the
 		 * disk smoothly, at the dirtying rate, which is nice.   But
-		 * that's undesirable in laptop mode, where we *want* lumpy
-		 * writeout.  So in laptop mode, write out the whole world.
+		 * that's undesirable in laptop mode, where as much I/O as
+		 * possible should be trigged if the disk needs to be spun up.
+		 * So in laptop mode, write out the whole world.
 		 */
 		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
 		if (total_scanned > writeback_threshold) {
-- 
1.7.9.5

