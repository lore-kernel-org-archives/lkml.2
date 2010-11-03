Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0KCQel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:34:41 -0400
Received: from portal.weinmann.de ([62.8.140.122]:5517 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0KCQej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:34:39 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 12:34:38 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
CC: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Haavard Skinnemoen'" <hskinnemoen@atmel.com>
Date: Wed, 3 Nov 2010 17:17:59 +0100
Subject: [PATCH] atmel_tc: tcb_clksrc: fix init sequence
Thread-Topic: [PATCH] atmel_tc: tcb_clksrc: fix init sequence
Thread-Index: Act7aZpbhHgt1McfS6aHr+N/GyI35g==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D068D0F0615@wm021.weinmann.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_irq() was called before clockevents_register_device() which
is needed by the irq handler. Bug was reproducible by restarting
the kernel using kexec (reliable crash).

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/clocksource/tcb_clksrc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 01b886e..79c47e8 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -196,9 +196,9 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	setup_irq(irq, &tc_irqaction);
-
 	clockevents_register_device(&clkevt.clkevt);
+
+	setup_irq(irq, &tc_irqaction);
 }
 
 #else /* !CONFIG_GENERIC_CLOCKEVENTS */
-- 
1.5.4.3

