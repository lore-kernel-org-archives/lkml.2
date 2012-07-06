Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2GFOTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:19:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44467 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2GFOTi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 6 Jul 2012 10:19:38 -0400
Message-Id: <4FF71053020000780008E1B5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 15:20:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: slightly simplify print_mtrr_state()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

high_width can be easily calculated in a single expression when making
use of __ffs64().

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- 3.5-rc5/arch/x86/kernel/cpu/mtrr/generic.c
+++ 3.5-rc5-x86-mtrr-print-simplify/arch/x86/kernel/cpu/mtrr/generic.c
@@ -361,11 +361,7 @@ static void __init print_mtrr_state(void
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



