Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2GJJ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:57:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2GJJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:57:13 -0400
Date: Tue, 10 Jul 2012 02:56:54 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-a7101d152665817bf7cafc47e7f5dcb1f54664fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FF71053020000780008E1B5@nat28.tlf.novell.com>
References: <4FF71053020000780008E1B5@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/mm/mtrr: Slightly simplify print_mtrr_state()
Git-Commit-ID: a7101d152665817bf7cafc47e7f5dcb1f54664fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Jul 2012 02:56:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7101d152665817bf7cafc47e7f5dcb1f54664fe
Gitweb:     http://git.kernel.org/tip/a7101d152665817bf7cafc47e7f5dcb1f54664fe
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 6 Jul 2012 15:20:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 10 Jul 2012 10:38:15 +0200

x86/mm/mtrr: Slightly simplify print_mtrr_state()

high_width can be easily calculated in a single expression when
making use of __ffs64().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/4FF71053020000780008E1B5@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 75772ae..e9fe907 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -361,11 +361,7 @@ static void __init print_mtrr_state(void)
 	}
 	pr_debug("MTRR variable ranges %sabled:\n",
 		 mtrr_state.enabled & 2 ? "en" : "dis");
-	if (size_or_mask & 0xffffffffUL)
-		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
-	else
-		high_width = ffs(size_or_mask>>32) + 32 - 1;
-	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
+	high_width = (__ffs64(size_or_mask) - (32 - PAGE_SHIFT) + 3) / 4;
 
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
