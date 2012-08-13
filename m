Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2HMLRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:17:02 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47441 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2HMLRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:17:00 -0400
Message-ID: <5028E222.8020005@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:16:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 10/12] thp: remove khugepaged_loop
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-1396-0000-0000-000001B4494D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge khugepaged_loop into khugepaged

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 82f6cce..6ddf671 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2354,14 +2354,6 @@ static void khugepaged_wait_work(void)
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }

-static void khugepaged_loop(void)
-{
-	while (likely(khugepaged_enabled())) {
-		khugepaged_do_scan();
-		khugepaged_wait_work();
-	}
-}
-
 static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
@@ -2369,8 +2361,10 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);

-	while (!kthread_should_stop())
-		khugepaged_loop();
+	while (!kthread_should_stop()) {
+		khugepaged_do_scan();
+		khugepaged_wait_work();
+	}

 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = khugepaged_scan.mm_slot;
-- 
1.7.7.6

