Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1C1JXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:23:49 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47213 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1C1JXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:23:35 -0400
Date: Mon, 28 Mar 2011 11:23:10 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3] mm: Optimize pfn calculation in online_page()
Message-ID: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_FLATMEM is enabled pfn is calculated in online_page()
more than once. It is possible to optimize that and use value
established at beginning of that function.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 mm/memory_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 321fc74..f0651ae 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ void online_page(struct page *page)
 #endif
 
 #ifdef CONFIG_FLATMEM
-	max_mapnr = max(page_to_pfn(page), max_mapnr);
+	max_mapnr = max(pfn, max_mapnr);
 #endif
 
 	ClearPageReserved(page);
-- 
1.5.6.5
