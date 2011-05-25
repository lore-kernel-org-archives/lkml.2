Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1EYHLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:11:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36956 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EYHLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:11:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCABA0.4000207@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:11:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 4/4] pagewalk: fix code comment for THP
References: <4DDCAAC0.20102@jp.fujitsu.com>
In-Reply-To: <4DDCAAC0.20102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bae9c19bf1 (thp: split_huge_page_mm/vma) changed locking behavior
of walk_page_range(). Thus this patch changes comment too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/pagewalk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index f792940..2f5cf10 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -176,7 +176,8 @@ static int walk_hugetlb_range(struct vm_area_struct *vma,
  * associated range, and a copy of the original mm_walk for access to
  * the ->private or ->mm fields.
  *
- * No locks are taken, but the bottom level iterator will map PTE
+ * Usually no locks are taken, but splitting transparent huge page may
+ * take page table lock. And the bottom level iterator will map PTE
  * directories from highmem if necessary.
  *
  * If any callback returns a non-zero value, the walk is aborted and
-- 
1.7.3.1



