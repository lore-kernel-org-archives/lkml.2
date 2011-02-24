Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab1BXE5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab1BXE5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:57:11 -0500
Date: Thu, 24 Feb 2011 05:56:27 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/8] Use GFP_OTHER_NODE for transparent huge pages
Message-ID: <20110224045625.GH31195@random.random>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
 <1298425922-23630-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298425922-23630-8-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build with CONFIG_NUMA=n for patch 7 (noticed on my
laptop which isn't NUMA yet ;).

===
Subject: thp: add extra_gfp in alloc_hugepage non NUMA

From: Andrea Arcangeli <aarcange@redhat.com>

Add extra_gfp to avoid build failure with CONFIG_NUMA=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -660,7 +660,7 @@ static inline struct page *alloc_hugepag
 #ifndef CONFIG_NUMA
 static inline struct page *alloc_hugepage(int defrag)
 {
-	return alloc_pages(alloc_hugepage_gfpmask(defrag),
+	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
 			   HPAGE_PMD_ORDER);
 }
 #endif
