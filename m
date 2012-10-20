Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2JTBHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:07:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2JTBHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:07:39 -0400
Date: Fri, 19 Oct 2012 18:07:16 -0700
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-8cd7680d8b7241941fd51d83302677d58b447223@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, schwidefsky@de.ibm.com, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, peterz@infradead.org, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <20121018145101.GA17439@linux-mips.org>
References: <20121018145101.GA17439@linux-mips.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] MIPS/thp: Add pmd_pgprot() implementation
Git-Commit-ID: 8cd7680d8b7241941fd51d83302677d58b447223
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:07:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cd7680d8b7241941fd51d83302677d58b447223
Gitweb:     http://git.kernel.org/tip/8cd7680d8b7241941fd51d83302677d58b447223
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Thu, 18 Oct 2012 16:51:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Oct 2012 23:46:11 +0200

MIPS/thp: Add pmd_pgprot() implementation

Resolve the semantic conflict between the new THP code
on MIPS and the new NUMA code, in linux-next, by adding
the pmd_pgprot() method needed by the NUMA code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20121018145101.GA17439@linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/include/asm/pgtable.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index c02158b..bbe4cda 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -89,6 +89,8 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 extern void paging_init(void);
 
+#define pmd_pgprot(x)		__pgprot(pmd_val(x) & ~_PAGE_CHG_MASK)
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
