Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0LGPBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:01:39 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:48911 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0LGPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HB2wu0EMtLFoKu+RHggzgWEgLfvGaAem/AfSO/s3YcIy6LTWyKjgKJpjH7LyodUjxi
         kIkD6G/8Hp7jAsqK9FWplm9XVOsD67JMCNjUBRXZQ7vicZ903113UcDUuzlBllH1zcCa
         0FWRnGY01jR33ZL6ewCj7yhHRyQOuh6Ggxh0I=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] compaction: Remove mem_cgroup_del_lru
Date: Wed,  8 Dec 2010 00:01:26 +0900
Message-Id: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

del_page_from_lru_list alreay called mem_cgroup_del_lru.
So we need to call it again. It makes wrong stat of memcg and
even happen VM_BUG_ON hit.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 50b0a90..b0fbfdf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -302,7 +302,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		/* Successfully isolated */
 		del_page_from_lru_list(zone, page, page_lru(page));
 		list_add(&page->lru, migratelist);
-		mem_cgroup_del_lru(page);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-- 
1.7.0.4

