Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1DZQ1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:27:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60952 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab1DZQ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bTjWhEP92hfYwdRzc28f/L+cd4JBMAXI3vPO/TZXRJqTTz8poXkKMUF+XsLUh+l1uB
         51tzdWywri14zB5PEpF4Lafh1vS3towI6tX438oJ7z14Q7ZfocOuSPYZovR8he5izaRI
         TrKOw3ZX09dwE2p+5Gn6wJ12t8zBs4iGy4Gc0=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC 5/8] compaction: remove active list counting
Date: Wed, 27 Apr 2011 01:25:22 +0900
Message-Id: <2b79bbf9ddceb73624f49bbe9477126147d875fd.1303833417.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acct_isolated of compaction uses page_lru_base_type which returns only
base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9f80b5a..653b02b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -219,8 +219,8 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
 		count[lru]++;
 	}
 
-	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+	cc->nr_anon = count[LRU_INACTIVE_ANON];
+	cc->nr_file = count[LRU_INACTIVE_FILE];
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
 }
-- 
1.7.1

