Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2ALTaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2ALTaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:30:03 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 3/6] pagemap: export KPF_THP
Date: Thu, 12 Jan 2012 14:34:55 -0500
Message-Id: <1326396898-5579-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag shows that a given pages is a subpage of transparent hugepage.
It helps us debug and test kernel by showing physical address of thp.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Changes since v2:
  - replace if with else-if not to set KPF_THP for hugetlbfs page

Changes since v1:
  - remove unnecessary ifdefs
  - fix confusing patch description
---
 fs/proc/page.c                    |    2 ++
 include/linux/kernel-page-flags.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git 3.2-rc5.orig/fs/proc/page.c 3.2-rc5/fs/proc/page.c
index 6d8e6a9..7fcd0d6 100644
--- 3.2-rc5.orig/fs/proc/page.c
+++ 3.2-rc5/fs/proc/page.c
@@ -115,6 +115,8 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
+	else if (PageTransCompound(page))
+		u |= 1 << KPF_THP;
 
 	/*
 	 * Caveats on high order pages: page->_count will only be set
diff --git 3.2-rc5.orig/include/linux/kernel-page-flags.h 3.2-rc5/include/linux/kernel-page-flags.h
index bd92a89..26a6571 100644
--- 3.2-rc5.orig/include/linux/kernel-page-flags.h
+++ 3.2-rc5/include/linux/kernel-page-flags.h
@@ -30,6 +30,7 @@
 #define KPF_NOPAGE		20
 
 #define KPF_KSM			21
+#define KPF_THP			22
 
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
-- 
1.7.6.5

