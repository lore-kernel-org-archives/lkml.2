Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1KWFzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:55:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37124 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1KWFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:55:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:71/87=82%),
        Mel Gorman <mgorman@suse.de> (commit_signer:39/87=45%),
        Minchan Kim <minchan.kim@gmail.com> (commit_signer:32/87=37%),
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> (commit_signer:26/87=30%),
        Johannes Weiner <jweiner@redhat.com> (commit_signer:21/87=24%),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] vmscan: add task name to warn_scan_unevictable() messages
Date: Wed, 23 Nov 2011 00:55:20 -0500
Message-Id: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
X-Mailer: git-send-email 1.7.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we need to know a usecase, caller program name is critical important.
Show it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1893c0..29d163e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3448,9 +3448,10 @@ void scan_mapping_unevictable_pages(struct address_space *mapping)
 static void warn_scan_unevictable_pages(void)
 {
 	printk_once(KERN_WARNING
-		    "The scan_unevictable_pages sysctl/node-interface has been "
+		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
 		    "disabled for lack of a legitimate use case.  If you have "
-		    "one, please send an email to linux-mm@kvack.org.\n");
+		    "one, please send an email to linux-mm@kvack.org.\n",
+		    current->comm);
 }
 
 /*
-- 
1.7.1

