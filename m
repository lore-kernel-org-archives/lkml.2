Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0ICPI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:08:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63884 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab0ICPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:08:25 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Christoph Lameter <clameter@sgi.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] mm: fix typo in mm.h when NODE_NOT_IN_PAGE_FLAGS
Date: Fri,  3 Sep 2010 16:07:49 +0100
Message-Id: <1283526469-12328-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 03 Sep 2010 15:07:56.0482 (UTC) FILETIME=[CA263A20:01CB4B79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NODE_NOT_IN_PAGE_FLAGS is defined in mm.h when the node information
is not stored in the page flags bitmap.

Unfortunately, there's a typo in one of the checks for it. This patch
fixes it (s/NODE_NOT_IN_PAGEFLAGS/NODE_NOT_IN_PAGE_FLAGS/). Since this
has been around for ages, I doubt it's been causing any serious problems.

Patch taken against 2.6.36-rc3.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/linux/mm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e6b1210..87f8c5b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -497,8 +497,8 @@ static inline void set_compound_order(struct page *page, unsigned long order)
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
 
-/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allcator */
-#ifdef NODE_NOT_IN_PAGEFLAGS
+/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
+#ifdef NODE_NOT_IN_PAGE_FLAGS
 #define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
 #define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF)? \
 						SECTIONS_PGOFF : ZONES_PGOFF)
-- 
1.6.3.3

