Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0JYOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:40:17 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55141 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0JYOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:40:15 -0400
X-SpamScore: 4
X-BigFish: VS4(z37d5kzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAUOPS-02-CXP-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/5] mce, amd: Shorten local variables mci_misc_{hi,lo}
Date: Mon, 25 Oct 2010 16:03:36 +0200
Message-ID: <1288015419-29543-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten this variables to make later changes more readable.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.3.1


