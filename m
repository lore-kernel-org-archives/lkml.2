Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1KRRAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:00:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab1KRQ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:58:48 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] mm: compaction: Use synchronous compaction for /proc/sys/vm/compact_memory
Date: Fri, 18 Nov 2011 16:58:41 +0000
Message-Id: <1321635524-8586-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1321635524-8586-1-git-send-email-mgorman@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When asynchronous compaction was introduced, the
/proc/sys/vm/compact_memory handler should have been updated to always
use synchronous compaction. This did not happen so this patch addresses
it. The assumption is if a user writes to /proc/sys/vm/compact_memory,
they are willing for that process to stall.

Signed-off-by: Mel Gorman <mgorman@suse.de>
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

