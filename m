Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1FTQff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1FTQfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:35:32 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 3/3] mm: print information when THP is disabled automatically
Date: Tue, 21 Jun 2011 00:34:30 +0800
Message-Id: <1308587683-2555-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1308587683-2555-1-git-send-email-amwang@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print information when THP is disabled automatically so that
users can find this info in dmesg.

Signed-off-by: WANG Cong <amwang@redhat.com>
---
 mm/huge_memory.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7fb44cc..07679da 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -544,8 +544,11 @@ static int __init hugepage_init(void)
 	 * where the extra memory used could hurt more than TLB overhead
 	 * is likely to save.  The admin can still enable it through /sys.
 	 */
-	if (totalram_pages < (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD << (20 - PAGE_SHIFT)))
+	if (totalram_pages < (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD
+					<< (20 - PAGE_SHIFT))) {
+		printk(KERN_INFO "hugepage: disabled auotmatically\n");
 		transparent_hugepage_flags = 0;
+	}
 
 	start_khugepaged();
 
-- 
1.7.4.4

