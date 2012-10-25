Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab2JYNIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:08:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:51353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162Ab2JYNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:08:28 -0400
Message-Id: <20121025124832.996734608@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 07/31] sched, numa, mm, s390/thp: Implement pmd_pgprot() for s390
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0007-sched-numa-mm-s390-thp-Implement-pmd_pgprot-for-s390.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

This patch adds an implementation of pmd_pgprot() for s390,
in preparation to future THP changes.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/pgtable.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: tip/arch/s390/include/asm/pgtable.h
===================================================================
--- tip.orig/arch/s390/include/asm/pgtable.h
+++ tip/arch/s390/include/asm/pgtable.h
@@ -1240,6 +1240,19 @@ static inline void set_pmd_at(struct mm_
 	*pmdp = entry;
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	pgprot_t prot = PAGE_RW;
+
+	if (pmd_val(pmd) & _SEGMENT_ENTRY_RO) {
+		if (pmd_val(pmd) & _SEGMENT_ENTRY_INV)
+			prot = PAGE_NONE;
+		else
+			prot = PAGE_RO;
+	}
+	return prot;
+}
+
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
 	unsigned long pgprot_pmd = 0;


