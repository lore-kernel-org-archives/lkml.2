Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0GBFvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:51:32 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50896 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab0GBFto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:49:44 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] hugepage migration
Date: Fri,  2 Jul 2010 14:47:19 +0900
Message-Id: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patchset for hugepage migration.

There are many users of page migration such as soft offlining,
memory hotplug, memory policy and memory compaction,
but this patchset adds hugepage support only for soft offlining
as the first step.

This patchset is based on 2.6.35-rc3 applied with "HWPOISON for
hugepage" patchset I previously posted (see Andi's git tree.)
http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=summary

I tested this patchset with 'make func' in libhugetlbfs and
have gotten the same result as one from 2.6.35-rc3.

 [PATCH 1/7] hugetlb: add missing unlock in avoidcopy path in hugetlb_cow()
 [PATCH 2/7] hugetlb, HWPOISON: move PG_HWPoison bit check
 [PATCH 3/7] hugetlb: add allocate function for hugepage migration
 [PATCH 4/7] hugetlb: add hugepage check in mem_cgroup_{register,end}_migration()
 [PATCH 5/7] hugetlb: pin oldpage in page migration
 [PATCH 6/7] hugetlb: hugepage migration core
 [PATCH 7/7] hugetlb, HWPOISON: soft offlining for hugepage

 fs/hugetlbfs/inode.c    |    2 +
 include/linux/hugetlb.h |    6 ++
 mm/hugetlb.c            |  138 +++++++++++++++++++++++++++++++++++-----------
 mm/memcontrol.c         |    5 ++
 mm/memory-failure.c     |   57 +++++++++++++++-----
 mm/migrate.c            |   70 ++++++++++++++++++++++--
 6 files changed, 226 insertions(+), 52 deletions(-)

Thanks,
Naoya Horiguchi
