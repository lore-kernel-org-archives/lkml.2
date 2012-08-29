Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2H2Pd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:33:56 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:59188 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2H2Pdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:33:50 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [RFC v2 PATCH 0/7] thp: transparent hugepages on s390
Date: Wed, 29 Aug 2012 17:32:57 +0200
Message-Id: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
x-cbid: 12082915-0342-0000-0000-000002B2BA7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for transparent hugepages on System z.
Small changes to common code are necessary with regard to a different
pgtable_t, tlb flushing and kvm behaviour on s390, see patches 1 to 3.

Changes to v2:
  [PATCH 1/7] Fix build problem on non-s390 architecture.
  [PATCH 2/7] Fix build problem on non-s390 architecture.
  [PATCH 7/7] Make use of rrbm instruction if available.

Gerald Schaefer (7):
  thp: remove assumptions on pgtable_t type
  thp: introduce pmdp_invalidate()
  thp: make MADV_HUGEPAGE check for mm->def_flags
  thp, s390: thp splitting backend for s390
  thp, s390: thp pagetable pre-allocation for s390
  thp, s390: disable thp for kvm host on s390
  thp, s390: architecture backend for thp on s390

 arch/s390/include/asm/hugetlb.h |  18 +---
 arch/s390/include/asm/pgtable.h | 208 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/include/asm/setup.h   |   3 +
 arch/s390/include/asm/tlb.h     |   1 +
 arch/s390/kernel/early.c        |   2 +
 arch/s390/mm/gup.c              |  11 ++-
 arch/s390/mm/pgtable.c          | 108 +++++++++++++++++++++
 include/asm-generic/pgtable.h   |  13 +++
 include/linux/huge_mm.h         |   1 -
 mm/Kconfig                      |   2 +-
 mm/huge_memory.c                |  53 +++-------
 mm/pgtable-generic.c            |  50 ++++++++++
 12 files changed, 408 insertions(+), 62 deletions(-)

-- 
1.7.11.5

