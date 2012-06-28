Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2F1M6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab2F1M55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:57:57 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 03/40] autonuma: export is_vma_temporary_stack() even if CONFIG_TRANSPARENT_HUGEPAGE=n
Date: Thu, 28 Jun 2012 14:55:43 +0200
Message-Id: <1340888180-15355-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_vma_temporary_stack() is needed by mm/autonuma.c too, and without
this the build breaks with CONFIG_TRANSPARENT_HUGEPAGE=n.

Reported-by: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/huge_mm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4c59b11..ad4e2e0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -54,13 +54,13 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
+extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
-extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
-
 #define transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
