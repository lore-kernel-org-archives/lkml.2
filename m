Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2HMLOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:14:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45946 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2HMLOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:14:05 -0400
Message-ID: <5028E167.8050605@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:13:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 02/12] thp: remove unnecessary check in start_khugepaged
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-5816-0000-0000-000003F8C6B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check is unnecessary since if mm_slot_cache or mm_slots_hash initialize
failed, no sysfs interface will be created

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 80bcd42..399e8c9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -140,10 +140,7 @@ static int start_khugepaged(void)
 	int err = 0;
 	if (khugepaged_enabled()) {
 		int wakeup;
-		if (unlikely(!mm_slot_cache || !mm_slots_hash)) {
-			err = -ENOMEM;
-			goto out;
-		}
+
 		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
@@ -163,7 +160,7 @@ static int start_khugepaged(void)
 	} else
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
-out:
+
 	return err;
 }

-- 
1.7.7.6

