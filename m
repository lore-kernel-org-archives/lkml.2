Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1LARjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:39:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab1LARg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:36:26 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] mm: compaction: Use synchronous compaction for /proc/sys/vm/compact_memory
Date: Thu,  1 Dec 2011 17:36:12 +0000
Message-Id: <1322760981-28719-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322760981-28719-1-git-send-email-mgorman@suse.de>
References: <1322760981-28719-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When asynchronous compaction was introduced, the
/proc/sys/vm/compact_memory handler should have been updated to always
use synchronous compaction. This did not happen so this patch addresses
it. The assumption is if a user writes to /proc/sys/vm/compact_memory,
they are willing for that process to stall.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 237560e..615502b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -666,6 +666,7 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
+			.sync = true,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
-- 
1.7.3.4

