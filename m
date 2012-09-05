Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2IEJ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:59:55 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60071 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758410Ab2IEJ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:48 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 06/17] arm: ux500: Add u9540 PRCMU TCDM configuration
Date: Wed, 5 Sep 2012 11:59:02 +0200
Message-ID: <1346839153-6465-7-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u9540 dedicated prcmu configuration to use legacy driver

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a38493b..0869c58 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -723,6 +723,12 @@ static void __init mop500_init_irq(void)
 	ux500_init_irq();
 }
 
+static void __init ccu9540_init_irq(void)
+{
+	prcmu_early_init(&db9540_tcdm_map);
+	ux500_init_irq();
+}
+
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	/* Maintainer: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com> */
 	.atag_offset	= 0x100,
@@ -763,7 +769,7 @@ MACHINE_START(U9540, "ST-Ericsson 9540 platform")
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
 	.nr_irqs	= UX500_NR_IRQS,
-	.init_irq	= mop500_init_irq,
+	.init_irq	= ccu9540_init_irq,
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= u9540_init_machine,
-- 
1.7.11.1

