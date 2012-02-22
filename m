Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2BVMfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:35:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58241 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2BVMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:35:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.220.148.146 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
Date: Wed, 22 Feb 2012 20:35:34 +0800
Message-ID: <CAJd=RBALNtedfq+PLPnGKd4i4D0mLiVPdW_7pWWopnSZNC_vqA@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: bail out unmapping after serving reference page
From: Hillf Danton <dhillf@gmail.com>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmapping given VM range, we could bail out if a reference page is
supplied and it is unmapped, which is a minor optimization.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Wed Feb 22 19:34:12 2012
+++ b/mm/hugetlb.c	Wed Feb 22 19:50:26 2012
@@ -2280,6 +2280,9 @@ void __unmap_hugepage_range(struct vm_ar
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
+
+		if (page == ref_page)
+			break;
 	}
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
--
