Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966Ab2JXPeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11124 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942Ab2JXPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:27 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 4/8] ARM: at91: fix external interrupt specification in board code
Date: Wed, 24 Oct 2012 17:33:53 +0200
Message-ID: <ecf01c6afd3969c9af1839ccbe64cdf5357d0433.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the switch to sparse irq, we have to add the NR_IRQS_LEGACY
offset to static irq numbers. It has been forgotten on these
SPI irq definitions in board code.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> [v3.6]
---
 arch/arm/mach-at91/board-neocore926.c | 2 +-
 arch/arm/mach-at91/board-sam9261ek.c  | 2 +-
 arch/arm/mach-at91/board-sam9263ek.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/board-neocore926.c b/arch/arm/mach-at91/board-neocore926.c
index 9cda3fd..6960778 100644
--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@ -129,7 +129,7 @@ static struct spi_board_info neocore926_spi_devices[] = {
 		.max_speed_hz	= 125000 * 16,
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9263_ID_IRQ1,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9263_ID_IRQ1,
 	},
 #endif
 };
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 27b3af1..a9167dd 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -309,7 +309,7 @@ static struct spi_board_info ek_spi_devices[] = {
 		.max_speed_hz	= 125000 * 26,	/* (max sample rate @ 3V) * (cmd + data + overhead) */
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9261_ID_IRQ0,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9261_ID_IRQ0,
 		.controller_data = (void *) AT91_PIN_PA28,	/* CS pin */
 	},
 #endif
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 073e174..b87dbe2 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -132,7 +132,7 @@ static struct spi_board_info ek_spi_devices[] = {
 		.max_speed_hz	= 125000 * 26,	/* (max sample rate @ 3V) * (cmd + data + overhead) */
 		.bus_num	= 0,
 		.platform_data	= &ads_info,
-		.irq		= AT91SAM9263_ID_IRQ1,
+		.irq		= NR_IRQS_LEGACY + AT91SAM9263_ID_IRQ1,
 	},
 #endif
 };
-- 
1.7.11.3

