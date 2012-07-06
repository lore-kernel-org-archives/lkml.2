Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2GFON5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:13:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38695 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2GFONz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 6 Jul 2012 10:13:55 -0400
Message-Id: <4FF70EFC020000780008E195@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 15:14:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust generic_get_mtrr() for 64-bit
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needing to deal with potentially large memory configurations, the
variables here should be "unsigned long" instead of "unsigned int".

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 3.5-rc5/arch/x86/kernel/cpu/mtrr/generic.c
+++ 3.5-rc5-x86-mtrr-generic-types/arch/x86/kernel/cpu/mtrr/generic.c
@@ -514,8 +514,8 @@ generic_get_free_region(unsigned long ba
 static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 			     unsigned long *size, mtrr_type *type)
 {
-	unsigned int mask_lo, mask_hi, base_lo, base_hi;
-	unsigned int tmp, hi;
+	unsigned long mask_lo, mask_hi, base_lo, base_hi, tmp;
+	unsigned int hi;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
@@ -540,9 +540,9 @@ static void generic_get_mtrr(unsigned in
 	mask_lo = size_or_mask | tmp;
 
 	/* Expand tmp with high bits to all 1s: */
-	hi = fls(tmp);
+	hi = fls_long(tmp);
 	if (hi > 0) {
-		tmp |= ~((1<<(hi - 1)) - 1);
+		tmp |= ~((1UL<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");



