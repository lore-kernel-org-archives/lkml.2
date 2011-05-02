Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1EBVTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:19:32 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:46417 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab1EBVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:19:30 -0400
Date: Mon, 2 May 2011 23:19:15 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from online_page()
Message-ID: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
It means that code depending on CONFIG_FLATMEM in online_page()
is never compiled. Remove it because it is not needed anymore.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 mm/memory_hotplug.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9ca1d60..a807ccb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -374,10 +374,6 @@ void online_page(struct page *page)
 		totalhigh_pages++;
 #endif
 
-#ifdef CONFIG_FLATMEM
-	max_mapnr = max(pfn, max_mapnr);
-#endif
-
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
-- 
1.5.6.5
