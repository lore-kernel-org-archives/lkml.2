Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0G1K2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:28:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34637 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0G1K11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:27:27 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 4/9] vmscan: tracing: Correct units in post-processing script
Date: Wed, 28 Jul 2010 11:27:18 +0100
Message-Id: <1280312843-11789-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280312843-11789-1-git-send-email-mel@csn.ul.ie>
References: <1280312843-11789-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The post-processing script is reporting the wrong units. Correct it.  This
patch updates vmscan-tracing-add-trace-event-when-a-page-is-written.patch
to include that information. The patches can be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 .../trace/postprocess/trace-vmscan-postprocess.pl  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
index f87f56e..f1b70a8 100644
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -584,7 +584,7 @@ sub dump_stats {
 	print "Direct reclaim write file async I/O:	$total_direct_writepage_file_async\n";
 	print "Direct reclaim write anon async I/O:	$total_direct_writepage_anon_async\n";
 	print "Wake kswapd requests:			$total_wakeup_kswapd\n";
-	printf "Time stalled direct reclaim: 		%-1.2f ms\n", $total_direct_latency;
+	printf "Time stalled direct reclaim: 		%-1.2f seconds\n", $total_direct_latency;
 	print "\n";
 	print "Kswapd wakeups:				$total_kswapd_wake\n";
 	print "Kswapd pages scanned:			$total_kswapd_nr_scanned\n";
@@ -592,7 +592,7 @@ sub dump_stats {
 	print "Kswapd reclaim write anon sync I/O:	$total_kswapd_writepage_anon_sync\n";
 	print "Kswapd reclaim write file async I/O:	$total_kswapd_writepage_file_async\n";
 	print "Kswapd reclaim write anon async I/O:	$total_kswapd_writepage_anon_async\n";
-	printf "Time kswapd awake:			%-1.2f ms\n", $total_kswapd_latency;
+	printf "Time kswapd awake:			%-1.2f seconds\n", $total_kswapd_latency;
 }
 
 sub aggregate_perprocesspid() {
-- 
1.7.1

