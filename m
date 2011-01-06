Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1AFA3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:36 -0500
Received: from kroah.org ([198.145.64.141]:35619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1AFA3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:33 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.696109593@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [043/152] SPARC/LEON: removed constant timer initialization as if HZ=100, now it reflects the value of HZ
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Daniel Hellstrom <daniel@gaisler.com>

[ Upstream commit b690c425fe07c725e7f1f7d40303588416cba67f ]

Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/leon_kernel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
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
 


