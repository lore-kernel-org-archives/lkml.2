Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1I0Dpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 23:45:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56190 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1I0Dpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 23:45:36 -0400
Date: Tue, 27 Sep 2011 13:45:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the mfd tree with the arm tree
Message-Id: <20110927134534.af4c3bdad6918111a2e03034@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-u300/include/mach/irqs.h between commit cc890cd78acd ("ARM:
7083/1: rewrite U300 GPIO to use gpiolib") from the  tree and commit
e085f9a2e27d ("mfd: Delete ab3550 driver") from the mfd tree.

I fixed it up (I think - see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-u300/include/mach/irqs.h
index d270fea,a6867b1..0000000
--- a/arch/arm/mach-u300/include/mach/irqs.h
+++ b/arch/arm/mach-u300/include/mach/irqs.h
@@@ -106,25 -106,9 +106,19 @@@
  #define IRQ_U300_NFIF			45
  #define IRQ_U300_NFIF2			46
  #define IRQ_U300_SYSCON_PLL_LOCK	47
 -#define U300_NR_IRQS			48
 +#define U300_VIC_IRQS_END		48
  #endif
  
 -#define NR_IRQS U300_NR_IRQS
 +/* Maximum 8*7 GPIO lines */
 +#ifdef CONFIG_GPIO_U300
 +#define IRQ_U300_GPIO_BASE		(U300_VIC_IRQS_END)
 +#define IRQ_U300_GPIO_END		(IRQ_U300_GPIO_BASE + 56)
 +#else
 +#define IRQ_U300_GPIO_END		(U300_VIC_IRQS_END)
 +#endif
 +
- /* Optional AB3550 mixsig chip */
- #ifdef CONFIG_AB3550_CORE
- #define IRQ_AB3550_BASE			(IRQ_U300_GPIO_END)
- #define IRQ_AB3550_END			(IRQ_AB3550_BASE + 38)
- #else
 +#define IRQ_AB3550_END			(IRQ_U300_GPIO_END)
- #endif
 +
 +#define NR_IRQS				(IRQ_AB3550_END)
  
  #endif
