Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2J1RRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:17:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2J1RRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:17:13 -0400
Date: Sun, 28 Oct 2012 10:16:39 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-9b718e758ac91f28b6cdd354ad5ee9c767daae74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, schwidefsky@de.ibm.com,
        gerald.schaefer@de.ibm.com, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, peterz@infradead.org,
        gerald.schaefer@de.ibm.com, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de
In-Reply-To: <20121028131014.GA10754@gmail.com>
References: <20121028131014.GA10754@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm, s390/thp: Add pmd_mknotpresent()
Git-Commit-ID: 9b718e758ac91f28b6cdd354ad5ee9c767daae74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 28 Oct 2012 10:16:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b718e758ac91f28b6cdd354ad5ee9c767daae74
Gitweb:     http://git.kernel.org/tip/9b718e758ac91f28b6cdd354ad5ee9c767daae74
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sun, 28 Oct 2012 14:10:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 28 Oct 2012 17:31:21 +0100

sched, numa, mm, s390/thp: Add pmd_mknotpresent()

We'd like to make use of pmd_mknotpresent() in mm/, but
not all architectures have it. This patch adds the s390
version.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Link: http://lkml.kernel.org/r/20121028131014.GA10754@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/pgtable.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 098fc5a..b820ff1 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1310,6 +1310,12 @@ static inline pmd_t pmd_mkyoung(pmd_t pmd)
 	return pmd;
 }
 
+static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_SEGMENT_ENTRY_ORIGIN;
+	return pmd;
+}
+
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address, pmd_t *pmdp)
