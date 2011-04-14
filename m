Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab1DNSYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:24:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:38243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1DNRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 037/209] mm: fix return value of scan_lru_pages in memory unplug
Date: Thu, 14 Apr 2011 13:41:07 -0400
Message-Id: <1302803039-9400-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit f8f72ad5396987e05a42cf7eff826fb2a15ff148 upstream.

scan_lru_pages returns pfn. So, it's type should be "unsigned long"
not "int".

Note: I guess this has been work until now because memory hotplug tester's
      machine has not very big memory....
      physical address < 32bit << PAGE_SHIFT.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/memory_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 91f7c26..a577318 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -633,7 +633,7 @@ static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
  * Scanning pfn is much easier than scanning lru list.
  * Scan pfn from start to end and Find LRU page.
  */
-int scan_lru_pages(unsigned long start, unsigned long end)
+unsigned long scan_lru_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;
-- 
1.7.4.4

