Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab1EBVXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:23:24 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:46498 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab1EBVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:23:23 -0400
Date: Mon, 2 May 2011 23:22:26 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/4] mm: Do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM
Message-ID: <20110502212226.GE4623@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 include/linux/mm.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 23465e1..d1f8cb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -603,10 +603,6 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
-#ifndef PFN_SECTION_SHIFT
-#define PFN_SECTION_SHIFT 0
-#endif
-
 /*
  * Define the bit shifts to access each section.  For non-existent
  * sections we define the shift as 0; that plus a 0 mask ensures
-- 
1.5.6.5
