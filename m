Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1HHIvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:51:12 -0400
Received: from mail0.scram.de ([78.47.204.202]:36547 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1HHIuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:50:44 -0400
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.378
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        bryan.wu@canonical.com, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, Jochen Friedrich <jochen@scram.de>
Subject: [PATCH 3.2 1/4] ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
Date: Mon,  8 Aug 2011 10:49:36 +0200
Message-Id: <1312793379-6020-2-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312793379-6020-1-git-send-email-jochen@scram.de>
References: <1312793379-6020-1-git-send-email-jochen@scram.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ucb1x00 GPIO definitions to simpad.h and add gpio_base
to ucb1x00 platform device so the pins are available using
the GPIO API.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/arm/mach-sa1100/include/mach/simpad.h |   13 +++++++++++++
 arch/arm/mach-sa1100/simpad.c              |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/simpad.h b/arch/arm/mach-sa1100/include/mach/simpad.h
index 9296c45..231550d 100644
--- a/arch/arm/mach-sa1100/include/mach/simpad.h
+++ b/arch/arm/mach-sa1100/include/mach/simpad.h
@@ -48,6 +48,19 @@
 #define GPIO_SMART_CARD		GPIO_GPIO10
 #define IRQ_GPIO_SMARD_CARD	IRQ_GPIO10
 
+/*--- ucb1x00 GPIO ---*/
+#define SIMPAD_UCB1X00_GPIO_BASE	(GPIO_MAX + 1)
+#define SIMPAD_UCB1X00_GPIO_PROG1	(SIMPAD_UCB1X00_GPIO_BASE)
+#define SIMPAD_UCB1X00_GPIO_PROG2	(SIMPAD_UCB1X00_GPIO_BASE + 1)
+#define SIMPAD_UCB1X00_GPIO_UP		(SIMPAD_UCB1X00_GPIO_BASE + 2)
+#define SIMPAD_UCB1X00_GPIO_DOWN	(SIMPAD_UCB1X00_GPIO_BASE + 3)
+#define SIMPAD_UCB1X00_GPIO_LEFT	(SIMPAD_UCB1X00_GPIO_BASE + 4)
+#define SIMPAD_UCB1X00_GPIO_RIGHT	(SIMPAD_UCB1X00_GPIO_BASE + 5)
+#define SIMPAD_UCB1X00_GPIO_6		(SIMPAD_UCB1X00_GPIO_BASE + 6)
+#define SIMPAD_UCB1X00_GPIO_7		(SIMPAD_UCB1X00_GPIO_BASE + 7)
+#define SIMPAD_UCB1X00_GPIO_HEADSET	(SIMPAD_UCB1X00_GPIO_BASE + 8)
+#define SIMPAD_UCB1X00_GPIO_SPEAKER	(SIMPAD_UCB1X00_GPIO_BASE + 9)
+
 // CS3 Latch is write only, a shadow is necessary
 
 #define CS3BUSTYPE unsigned volatile long
diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index cfb7607..718b802 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -132,6 +132,7 @@ static struct resource simpad_flash_resources [] = {
 static struct mcp_plat_data simpad_mcp_data = {
 	.mccr0		= MCCR0_ADM,
 	.sclk_rate	= 11981000,
+	.gpio_base	= SIMPAD_UCB1X00_GPIO_BASE,
 };
 
 
-- 
1.7.5.4

