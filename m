Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1KSTzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:55:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1KSTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:55:05 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm: compaction: Use synchronous compaction for /proc/sys/vm/compact_memory
Date: Sat, 19 Nov 2011 20:54:14 +0100
Message-Id: <1321732460-14155-3-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321635524-8586-1-git-send-email-mgorman@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

When asynchronous compaction was introduced, the
/proc/sys/vm/compact_memory handler should have been updated to always
use synchronous compaction. This did not happen so this patch addresses
it. The assumption is if a user writes to /proc/sys/vm/compact_memory,
they are willing for that process to stall.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
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
