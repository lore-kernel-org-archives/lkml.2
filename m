Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1FISWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:22:00 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:37589 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1FISV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:21:57 -0400
Date: Thu, 9 Jun 2011 20:20:35 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: rientjes@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: Simplify code by SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro usage
Message-ID: <20110609182035.GC23592@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit a539f3533b78e39a22723d6d3e1e11b6c14454d9 (mm: add SECTION_ALIGN_UP()
and SECTION_ALIGN_DOWN() macro) introduced SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
macro. Use those macros to increase code readability.

This patch applies to Linus' git tree, v3.0-rc2 tag.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 mm/page_cgroup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 74ccff6..d818525 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -222,8 +222,8 @@ int __meminit online_page_cgroup(unsigned long start_pfn,
 	unsigned long start, end, pfn;
 	int fail = 0;
 
-	start = start_pfn & ~(PAGES_PER_SECTION - 1);
-	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
 		if (!pfn_present(pfn))
@@ -245,8 +245,8 @@ int __meminit offline_page_cgroup(unsigned long start_pfn,
 {
 	unsigned long start, end, pfn;
 
-	start = start_pfn & ~(PAGES_PER_SECTION - 1);
-	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_cgroup(pfn);
-- 
1.5.6.5
