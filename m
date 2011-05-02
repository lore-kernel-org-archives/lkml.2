Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab1EBVs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:48:28 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:46619 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1EBVs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:48:27 -0400
Date: Mon, 2 May 2011 23:47:16 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH V2 1/1] mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
Message-ID: <20110502214716.GG4623@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro which aligns
given pfn to upper section and lower section boundary accordingly.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 include/linux/mmzone.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d715200..217bcf6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -956,6 +956,9 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
 #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
 
+#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
+#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
+
 struct page;
 struct page_cgroup;
 struct mem_section {
-- 
1.5.6.5
