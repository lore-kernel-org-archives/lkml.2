Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0E1Adk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:33:40 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47379 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab0E1Adh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:33:37 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/8] HWPOISON for hugepage (v6)
Date: Fri, 28 May 2010 09:29:14 +0900
Message-Id: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a "HWPOISON for hugepage" patchset which reflects
Mel's comments on hugepage rmapping code.
Only patch 1/8 and 2/8 are changed since the previous post.

Mel, could you please restart reviewing and testing?

 include/linux/hugetlb.h        |   14 +---
 include/linux/hugetlb_inline.h |   22 +++++++
 include/linux/pagemap.h        |    9 +++-
 include/linux/poison.h         |    9 ---
 include/linux/rmap.h           |    5 ++
 mm/hugetlb.c                   |  100 ++++++++++++++++++++++++++++++++-
 mm/hwpoison-inject.c           |   15 +++--
 mm/memory-failure.c            |  120 ++++++++++++++++++++++++++++++----------
 mm/rmap.c                      |   59 ++++++++++++++++++++
 9 files changed, 295 insertions(+), 58 deletions(-)

ChangeLog from v5:
- rebased to 2.6.34
- fix logic error (in case that private mapping and shared mapping coexist)
- move is_vm_hugetlb_page() into include/linux/mm.h to use this function
  from linear_page_index()
- define and use linear_hugepage_index() instead of compound_order()
- use page_move_anon_rmap() in hugetlb_cow()
- copy exclusive switch of __set_page_anon_rmap() into hugepage counterpart.
- revert commit 24be7468 completely
- create hugetlb_inline.h and move is_vm_hugetlb_index() in it.
- move functions setting up anon_vma for hugepage into mm/rmap.c.

ChangeLog from v4:
- rebased to 2.6.34-rc7
- add isolation code for free/reserved hugepage in me_huge_page()
- set/clear PG_hwpoison bits of all pages in hugepage.
- mce_bad_pages counts all pages in hugepage.
- rename __hugepage_set_anon_rmap() to hugepage_add_anon_rmap()
- add huge_pte_offset() dummy function in header file on !CONFIG_HUGETLBFS

ChangeLog from v3:
- rebased to 2.6.34-rc5
- support for privately mapped hugepage

ChangeLog from v2:
- rebase to 2.6.34-rc3
- consider mapcount of hugepage
- rename pointer "head" into "hpage"

ChangeLog from v1:
- rebase to 2.6.34-rc1
- add comment from Wu Fengguang

Thanks,
Naoya Horiguchi
