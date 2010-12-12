Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0LMASe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:18:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0LLXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:11 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: kamezawa.hiroyu@jp.fujitsu.com, ak@linux.intel.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [71/223] mm: fix return value of scan_lru_pages in memory unplug
Message-Id: <20101212234609.BC6F8B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit f8f72ad5396987e05a42cf7eff826fb2a15ff148 upstream.

scan_lru_pages returns pfn. So, it's type should be "unsigned long"
not "int".

Note: I guess this has been work until now because memory hotplug tester's
      machine has not very big memory....
      physical address < 32bit << PAGE_SHIFT.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/memory_hotplug.c
===================================================================
--- linux.orig/mm/memory_hotplug.c
+++ linux/mm/memory_hotplug.c
@@ -659,7 +659,7 @@ static int test_pages_in_a_zone(unsigned
  * Scanning pfn is much easier than scanning lru list.
  * Scan pfn from start to end and Find LRU page.
  */
-int scan_lru_pages(unsigned long start, unsigned long end)
+unsigned long scan_lru_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;
