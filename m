Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1EBVVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:21:13 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:46464 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab1EBVVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:21:10 -0400
Date: Mon, 2 May 2011 23:21:00 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/4] mm: pfn_to_section_nr()/section_nr_to_pfn() is valid only in CONFIG_SPARSEMEM context
Message-ID: <20110502212100.GD4623@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfn_to_section_nr()/section_nr_to_pfn() is valid only
in CONFIG_SPARSEMEM context. Move it to proper place.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 include/linux/mmzone.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e56f835..d715200 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -928,9 +928,6 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
-#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
-
 #ifdef CONFIG_SPARSEMEM
 
 /*
@@ -956,6 +953,9 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
 
+#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
+#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
+
 struct page;
 struct page_cgroup;
 struct mem_section {
-- 
1.5.6.5
