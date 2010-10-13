Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0JMFX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:23:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50626 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0JMFX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:23:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Oct 2010 14:18:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
Subject: [BUGFIX][PATCH v2] fix return value of scan_lru_pages in memory
 unplug
Message-Id: <20101013141805.f54ab59f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101013140841.ADBA.A69D9226@jp.fujitsu.com>
References: <20101013135903.c505ff8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013140841.ADBA.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 14:08:57 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Also, this can be static. anyway
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
yes.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

scan_lru_pages returns pfn. So, it's type should be "unsigned long"
not "int".

Note: I guess this has been work until now because memory hotplug tester's
      machine has not very big memory....
      physical address < 32bit << PAGE_SHIFT.

Changelog v1->v2:
 - make the function static.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-1008/mm/memory_hotplug.c
===================================================================
--- mmotm-1008.orig/mm/memory_hotplug.c
+++ mmotm-1008/mm/memory_hotplug.c
@@ -646,7 +646,7 @@ static int test_pages_in_a_zone(unsigned
  * Scanning pfn is much easier than scanning lru list.
  * Scan pfn from start to end and Find LRU page.
  */
-int scan_lru_pages(unsigned long start, unsigned long end)
+static unsigned long scan_lru_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;

