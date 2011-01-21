Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1AUGdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:33:14 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53040 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1AUGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:33:11 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <tatsu@ab.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH 0/7] HWPOISON for hugepage backed KVM guest
Date: Fri, 21 Jan 2011 15:28:53 +0900
Message-Id: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote "HWPOISON for hugepage" patchset last year, but it didn't
cover the hugepages used by KVM guest because follow_hugetlb_pages()
called in a guest page fault code path didn't know about swap entry
formatted pmd entry.
This patchset fixes it and makes both soft and hard offline available
on hugepage backed KVM guest.

I appreciate all of your comments and reviews.

Thanks,
Naoya Horiguchi

Summary:

  [PATCH 1/7] hugetlb: check swap entry in follow_hugetlb_page()
  [PATCH 2/7] check hugepage swap entry in get_user_pages_fast()
  [PATCH 3/7] remove putback_lru_pages() in hugepage migration context
  [PATCH 4/7] hugetlb, migration: add migration_hugepage_entry_wait()
  [PATCH 5/7] hugetlb: fix race condition between hugepage soft offline and page fault
  [PATCH 6/7] HWPOISON: pass order to set/clear_page_hwpoison_huge_page()
  [PATCH 7/7] HWPOISON, hugetlb: fix hard offline for hugepage backed KVM guest

  arch/x86/mm/gup.c       |    9 +++++++++
  include/linux/swapops.h |   20 ++++++++++++++++++++
  mm/hugetlb.c            |   39 +++++++++++++++++++++++++++++----------
  mm/memory-failure.c     |   24 +++++++++++++-----------
  mm/migrate.c            |   33 +++++++++++++++++++++++++++++++++
  5 files changed, 104 insertions(+), 21 deletions(-)
