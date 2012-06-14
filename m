Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2FNMjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:39:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57498 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2FNMjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:39:45 -0400
From: =?UTF-8?B?G1tB?= <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm: fix page reclaim comment error
Date: Thu, 14 Jun 2012 20:38:59 +0800
Message-Id: <4fd9db8d.c4e2440a.6bf6.4a46@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since there are five lists in LRU cache, the array nr in get_scan_count
should be:

nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
nr[2] = file inactive pages to scan; nr[3] = file active pages to scan

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeb3bc9..ed823df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1567,7 +1567,8 @@ static int vmscan_swappiness(struct scan_control *sc)
  * by looking at the fraction of the pages scanned we did rotate back
  * onto the active list instead of evict.
  *
- * nr[0] = anon pages to scan; nr[1] = file pages to scan
+ * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
+ * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
-- 
1.7.9.5

