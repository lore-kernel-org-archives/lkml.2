Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1BBAno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:28597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab1BBAnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622336"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: daniel@gaisler.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [35/139] SPARC/LEON: removed constant timer initialization as if HZ=100, now it reflects the value of HZ
Message-Id: <20110202004350.6F2943E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hellstrom <daniel@gaisler.com>

[ Upstream commit b690c425fe07c725e7f1f7d40303588416cba67f ]

Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/kernel/leon_kernel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/sparc/kernel/leon_kernel.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/kernel/leon_kernel.c
+++ linux-2.6.35.y/arch/sparc/kernel/leon_kernel.c
@@ -114,7 +114,7 @@ void __init leon_init_timers(irq_handler
 	if (leon3_gptimer_regs && leon3_irqctrl_regs) {
 		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[0].val, 0);
 		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[0].rld,
-				      (((1000000 / 100) - 1)));
+				      (((1000000 / HZ) - 1)));
 		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[0].ctrl, 0);
 
 #ifdef CONFIG_SMP
@@ -128,7 +128,7 @@ void __init leon_init_timers(irq_handler
 		}
 
 		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[1].val, 0);
-		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[1].rld, (((1000000/100) - 1)));
+		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[1].rld, (((1000000/HZ) - 1)));
 		LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[1].ctrl, 0);
 # endif
 
