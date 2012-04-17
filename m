Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2DQM2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:28:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48974 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab2DQM2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:28:24 -0400
Subject: [PATCH linux-next] mm/hugetlb: fix warning in
 alloc_huge_page/dequeue_huge_page_vma
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Date: Tue, 17 Apr 2012 16:28:19 +0400
Message-ID: <20120417122819.7438.26117.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes gcc warning (and bug?) introduced in linux-next commit cc9a6c877
("cpuset: mm: reduce large amounts of memory barrier related damage v3")

Local variable "page" can be uninitialized if nodemask from vma policy does not
intersects with nodemask from cpuset. Even if it wouldn't happens it's better to
initialize this variable explicitly than to introduce kernel oops on weird corner case.

mm/hugetlb.c: In function ‘alloc_huge_page’:
mm/hugetlb.c:1135:5: warning: ‘page’ may be used uninitialized in this function

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4314a88..dcf4a55 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -532,7 +532,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;

