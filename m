Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab2J2WC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:02:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:47886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab2J2Vhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [ 077/101] ARM: at91: fix external interrupt specification in board code
Date: Mon, 29 Oct 2012 14:35:30 -0700
Message-Id: <20121029213248.867467157@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 69e7ea04c9365626c0963ff09bbaa3a1b49e293a upstream.

Since the switch to sparse irq, we have to add the NR_IRQS_LEGACY
offset to static irq numbers. It has been forgotten on these
SPI irq definitions in board code.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/board-neocore926.c |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c  |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@ -129,7 +129,7 @@ static struct spi_board_info neocore926_
 		.max_speed_hz	= 125000 * 16,
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9263_ID_IRQ1,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9263_ID_IRQ1,
 	},
 #endif
 };
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -309,7 +309,7 @@ static struct spi_board_info ek_spi_devi
 		.max_speed_hz	= 125000 * 26,	/* (max sample rate @ 3V) * (cmd + data + overhead) */
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9261_ID_IRQ0,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9261_ID_IRQ0,
 		.controller_data = (void *) AT91_PIN_PA28,	/* CS pin */
 	},
 #endif
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -132,7 +132,7 @@ static struct spi_board_info ek_spi_devi
 		.max_speed_hz	= 125000 * 26,	/* (max sample rate @ 3V) * (cmd + data + overhead) */
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9263_ID_IRQ1,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9263_ID_IRQ1,
 	},
 #endif
 };


