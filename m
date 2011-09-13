Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1IMKbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:31:10 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:54241 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1IMKbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:31:09 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 06:31:09 EDT
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] Trivial: Eliminate the ret variable from mm_take_all_locks
Date: Tue, 13 Sep 2011 15:55:31 +0530
Message-Id: <1315909531-13419-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ret variable is really not needed in mm_take_all_locks as per
the current flow of the mm_take_all_locks function.

So, eliminating this return variable.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/mmap.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index a65efd4..48bc056 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2558,7 +2558,6 @@ int mm_take_all_locks(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
-	int ret = -EINTR;
 
 	BUG_ON(down_read_trylock(&mm->mmap_sem));
 
@@ -2579,13 +2578,12 @@ int mm_take_all_locks(struct mm_struct *mm)
 				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
 
-	ret = 0;
+	return 0;
 
 out_unlock:
-	if (ret)
-		mm_drop_all_locks(mm);
+	mm_drop_all_locks(mm);
 
-	return ret;
+	return -EINTR;
 }
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
-- 
1.7.6

