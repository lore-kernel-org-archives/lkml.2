Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2HMLOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:14:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51382 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2HMLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:14:40 -0400
Message-ID: <5028E192.9000005@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:14:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 04/12] thp: remove unnecessary khugepaged_thread check
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-2674-0000-0000-00000594BE47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, khugepaged creation and cancel are completely serial under the
protection of khugepaged_mutex, it is impossible that many khugepaged
entities are running

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3715c52..b218700 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2348,11 +2348,8 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);

-	while (!kthread_should_stop()) {
-		VM_BUG_ON(khugepaged_thread != current);
+	while (!kthread_should_stop())
 		khugepaged_loop();
-		VM_BUG_ON(khugepaged_thread != current);
-	}

 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = khugepaged_scan.mm_slot;
-- 
1.7.7.6

