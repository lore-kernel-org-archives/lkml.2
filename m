Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0IJXUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:20:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34663 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0IJXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hdBvGzZypW4jtlHb8fwdOTR55kovxWzdZvvKxocDxCuxlrkc/cfKlECM+ZSDWuvnlN
         dzMGg5V0VuxWagPuTk9opYL304ito8QnOkJevvjPYxBKft32pKmpqpcKVq/GqK4q2dxJ
         cIL0O8I6qb1kfZ4pEE0xH2MLaNriMnv509wZo=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com, Kevin Wells <wellsk40@gmail.com>
Subject: [PATCH 2/5] ARM: LPC32XX: Add missing SPI mode and remove unused fields
Date: Fri, 10 Sep 2010 09:19:36 -0700
Message-Id: <1284135579-13578-3-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Wells <wellsk40@gmail.com>

Some of the fields in the pl022_chip_info structure used with
the amba pl022 driver are no longer used. This patch removes
those unused fields and adds the missing .mode flags to the
spi_board_info structure.

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
---
 arch/arm/mach-lpc32xx/phy3250.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index bc9a42d..0c936cf 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -172,18 +172,12 @@ static void phy3250_spi_cs_set(u32 control)
 }
 
 static struct pl022_config_chip spi0_chip_info = {
-	.lbm			= LOOPBACK_DISABLED,
 	.com_mode		= INTERRUPT_TRANSFER,
 	.iface			= SSP_INTERFACE_MOTOROLA_SPI,
 	.hierarchy		= SSP_MASTER,
 	.slave_tx_disable	= 0,
-	.endian_tx		= SSP_TX_LSB,
-	.endian_rx		= SSP_RX_LSB,
-	.data_size		= SSP_DATA_BITS_8,
 	.rx_lev_trig		= SSP_RX_4_OR_MORE_ELEM,
 	.tx_lev_trig		= SSP_TX_4_OR_MORE_EMPTY_LOC,
-	.clk_phase		= SSP_CLK_FIRST_EDGE,
-	.clk_pol		= SSP_CLK_POL_IDLE_LOW,
 	.ctrl_len		= SSP_BITS_8,
 	.wait_state		= SSP_MWIRE_WAIT_ZERO,
 	.duplex			= SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
@@ -239,6 +233,7 @@ static int __init phy3250_spi_board_register(void)
 			.max_speed_hz = 5000000,
 			.bus_num = 0,
 			.chip_select = 0,
+			.mode = SPI_MODE_0,
 			.platform_data = &eeprom,
 			.controller_data = &spi0_chip_info,
 		},
-- 
1.7.2.2

