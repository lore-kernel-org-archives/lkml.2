Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2GTWfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 18:35:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2GTWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:34:59 -0400
Date: Fri, 20 Jul 2012 15:34:43 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-7efa1c87963d23cc57ba40c07316d3e28cc75a3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, alex.shi@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de,
        alex.shi@intel.com
In-Reply-To: <1342747103-19765-1-git-send-email-alex.shi@intel.com>
References: <1342747103-19765-1-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb:
  Fix build warning and crash when building for !SMP
Git-Commit-ID: 7efa1c87963d23cc57ba40c07316d3e28cc75a3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Jul 2012 15:34:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7efa1c87963d23cc57ba40c07316d3e28cc75a3a
Gitweb:     http://git.kernel.org/tip/7efa1c87963d23cc57ba40c07316d3e28cc75a3a
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Fri, 20 Jul 2012 09:18:23 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Jul 2012 15:01:48 -0700

x86/tlb: Fix build warning and crash when building for !SMP

The incompatible parameter of flush_tlb_mm_range cause build warning.
Fix it by correct parameter.

Ingo Molnar found that this could also cause a user space crash.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1342747103-19765-1-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/tlbflush.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index b5a27bd..74a4433 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -105,10 +105,10 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
-static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
+static inline void flush_tlb_mm_range(struct mm_struct *mm,
 	   unsigned long start, unsigned long end, unsigned long vmflag)
 {
-	if (vma->vm_mm == current->active_mm)
+	if (mm == current->active_mm)
 		__flush_tlb();
 }
 
