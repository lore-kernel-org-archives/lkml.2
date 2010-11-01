Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0KAGxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 02:53:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60158 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0KAGxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 02:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JG+6njxo7kNFBP/dwGaVBtP3e/uPpeyzRv8MN7pTHTtY4AallFDtUfg14oUNrMTfNW
         SuLQmPK1Ohuhr+ibE4xEq/Dt0W6YK6efsxAJ6zEyF3fGdcKtTxOVVWCnyKN+tic3lbkN
         GBrnPeB3ZKiIJUvJR5lgygTm8tLqIGvuq07Zo=
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 12:53:50 +0600
Message-ID: <AANLkTinWQRG=HA9uB3ad0KAqRRTinL6L_4iKgF84coph@mail.gmail.com>
Subject: [PATCH] x86, mm: Fix section mismatch in tlb.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark tlb_cpuhp_notify as __cpuinit. It's basically a callback
function, which is called from __cpuinit init_smp_flash(). So - it's
safe.

We were warned by the following warning:

WARNING: arch/x86/mm/built-in.o(.text+0x356d): Section mismatch in
reference from the function tlb_cpuhp_notify() to the function
.cpuinit.text:calculate_tlb_offset()
The function tlb_cpuhp_notify() references
the function __cpuinit calculate_tlb_offset().
This is often because tlb_cpuhp_notify lacks a __cpuinit
annotation or the annotation of calculate_tlb_offset is wrong.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 4935848..12cdbb1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -251,7 +251,7 @@ static void __cpuinit calculate_tlb_offset(void)
 	}
 }

-static int tlb_cpuhp_notify(struct notifier_block *n,
+static int __cpuinit tlb_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	switch (action & 0xf) {
