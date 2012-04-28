Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2D1Ge0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:34:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:51762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab2D1GeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="134657119"
From: Alex Shi <alex.shi@intel.com>
To: aarcange@redhat.com, riel@redhat.com, mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH] THP: need is_vma_temporary_stack() when reference transparent_hugepage_enabled
Date: Sat, 28 Apr 2012 14:33:15 +0800
Message-Id: <1335594795-30876-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the transparent_hugepage_enabled() used out of mm/,
is_vma_temporary_stack() need be referenced. Otherwise, it has compile
error.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/huge_mm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c8af7a2..10254ac 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -59,6 +59,7 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
+extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 #define transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
-- 
1.7.5.4

