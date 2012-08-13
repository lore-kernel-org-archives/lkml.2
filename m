Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2HMLRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:17:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56276 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2HMLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:17:18 -0400
Message-ID: <5028E237.8020504@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:17:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 11/12] thp: use khugepaged_enabled to remove duplicate code
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-6102-0000-0000-0000020B3E41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use khugepaged_enabled to see whether thp is enabled

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6ddf671..6becf6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -102,10 +102,7 @@ static int set_recommended_min_free_kbytes(void)
 	unsigned long recommended_min;
 	extern int min_free_kbytes;

-	if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG,
-		      &transparent_hugepage_flags) &&
-	    !test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-		      &transparent_hugepage_flags))
+	if (!khugepaged_enabled())
 		return 0;

 	for_each_populated_zone(zone)
@@ -228,11 +225,7 @@ static ssize_t enabled_store(struct kobject *kobj,
 			ret = err;
 	}

-	if (ret > 0 &&
-	    (test_bit(TRANSPARENT_HUGEPAGE_FLAG,
-		      &transparent_hugepage_flags) ||
-	     test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-		      &transparent_hugepage_flags)))
+	if (ret > 0 && khugepaged_enabled())
 		set_recommended_min_free_kbytes();

 	return ret;
-- 
1.7.7.6

