Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2IFNLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:11:30 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33493 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2IFNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:28 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 0/8] thp: transparent hugepages on s390
Date: Thu,  6 Sep 2012 15:10:35 +0200
Message-Id: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
x-cbid: 12090613-5024-0000-0000-000003B76D5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for transparent hugepages on s390.
Small changes to common code are necessary with regard to a different
pgtable_t, tlb flushing and kvm behaviour on s390, see patches 2 to 4.
Also, (x86) Kconfig is touched by patch 1.

Changes since RFC v2:
  [PATCH 1/8] introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE in Kconfig
  [PATCH 2/8] rename pgtable_deposit/withdraw
  [PATCH 6/8] rename pgtable_deposit/withdraw
  [PATCH 8/8] rename pgtable_deposit/withdraw

Gerald Schaefer (8):
  thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE in Kconfig
  thp: remove assumptions on pgtable_t type
  thp: introduce pmdp_invalidate()
  thp: make MADV_HUGEPAGE check for mm->def_flags
  thp, s390: thp splitting backend for s390
  thp, s390: thp pagetable pre-allocation for s390
  thp, s390: disable thp for kvm host on s390
  thp, s390: architecture backend for thp on s390

 arch/Kconfig                    |   3 +
 arch/s390/Kconfig               |   1 +
 arch/s390/include/asm/hugetlb.h |  18 +---
 arch/s390/include/asm/pgtable.h | 208 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/include/asm/setup.h   |   3 +
 arch/s390/include/asm/tlb.h     |   1 +
 arch/s390/kernel/early.c        |   2 +
 arch/s390/mm/gup.c              |  11 ++-
 arch/s390/mm/pgtable.c          | 108 +++++++++++++++++++++
 arch/x86/Kconfig                |   1 +
 include/asm-generic/pgtable.h   |  13 +++
 include/linux/huge_mm.h         |   1 -
 mm/Kconfig                      |   2 +-
 mm/huge_memory.c                |  53 +++-------
 mm/pgtable-generic.c            |  50 ++++++++++
 15 files changed, 413 insertions(+), 62 deletions(-)

-- 
1.7.11.5

