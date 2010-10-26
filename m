Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0JZGpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:45:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:46046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab0JZGp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:45:28 -0400
Date: Tue, 26 Oct 2010 06:44:58 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1288015419-29543-3-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] mce, amd: Shorten local variables mci_misc_{hi,lo}
Message-ID: <tip-7203a0494084541575bac6dfc4e153f9e28869b8@git.kernel.org>
Git-Commit-ID: 7203a0494084541575bac6dfc4e153f9e28869b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:44:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7203a0494084541575bac6dfc4e153f9e28869b8
Gitweb:     http://git.kernel.org/tip/7203a0494084541575bac6dfc4e153f9e28869b8
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 25 Oct 2010 16:03:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 18:59:42 +0200

mce, amd: Shorten local variables mci_misc_{hi,lo}

Shorten this variables to make later changes more readable.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1288015419-29543-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f438318..eb771b9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -93,37 +93,37 @@ struct thresh_restart {
 static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr = _tr;
-	u32 mci_misc_hi, mci_misc_lo;
+	u32 hi, lo;
 
-	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	rdmsr(tr->b->address, lo, hi);
 
-	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
+	if (tr->b->threshold_limit < (hi & THRESHOLD_MAX))
 		tr->reset = 1;	/* limit cannot be lower than err count */
 
 	if (tr->reset) {		/* reset err count and overflow bit */
-		mci_misc_hi =
-		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
+		hi =
+		    (hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
 		    (THRESHOLD_MAX - tr->b->threshold_limit);
 	} else if (tr->old_limit) {	/* change limit w/o reset */
-		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
+		int new_count = (hi & THRESHOLD_MAX) +
 		    (tr->old_limit - tr->b->threshold_limit);
 
-		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
+		hi = (hi & ~MASK_ERR_COUNT_HI) |
 		    (new_count & THRESHOLD_MAX);
 	}
 
 	if (tr->set_lvt_off) {
 		/* set new lvt offset */
-		mci_misc_hi &= ~MASK_LVTOFF_HI;
-		mci_misc_hi |= tr->lvt_off << 20;
+		hi &= ~MASK_LVTOFF_HI;
+		hi |= tr->lvt_off << 20;
 	}
 
 	tr->b->interrupt_enable ?
-	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
-	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
+	    (hi = (hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
+	    (hi &= ~MASK_INT_TYPE_HI);
 
-	mci_misc_hi |= MASK_COUNT_EN_HI;
-	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	hi |= MASK_COUNT_EN_HI;
+	wrmsr(tr->b->address, lo, hi);
 }
 
 static void mce_threshold_block_init(struct threshold_block *b, int offset)
