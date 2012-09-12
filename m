Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2ILM4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:23 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:54983 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2ILM4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:17 -0400
Message-ID: <50508666.90605@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 20:56:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] thp: fix forgetting to reset the page alloc indicator
References: <50508632.9090003@linux.vnet.ibm.com>
In-Reply-To: <50508632.9090003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091212-1396-0000-0000-000001DCFDAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NUMA is enabled, the indicator is not reset if the previous page
request is failed, then it will trigger the VM_BUG_ON in khugepaged_alloc_page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e366ca5..66d2bc6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1825,6 +1825,7 @@ static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 			return false;

 		*wait = false;
+		*hpage = NULL;
 		khugepaged_alloc_sleep();
 	} else if (*hpage) {
 		put_page(*hpage);
-- 
1.7.7.6

