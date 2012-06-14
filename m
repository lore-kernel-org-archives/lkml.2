Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2FNQvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:49 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31141 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932116Ab2FNQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:32 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform data
Date: Thu, 14 Jun 2012 18:50:54 +0200
Message-Id: <1339692673-7848-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA channel configuration to the LPC32xx platform file.  The
configured DMA signalling is generic for LPC32xx SoC and is not board specific.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Changes since v1:
* Don't use pointers to functions in struct init

 arch/arm/mach-lpc32xx/phy3250.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -226,7 +226,38 @@ static int __init phy3250_spi_board_regi
 }
 arch_initcall(phy3250_spi_board_register);
 
+static struct pl08x_channel_data pl08x_slave_channels[] = {
+	{
+		.bus_id = "nand-slc",
+		.min_signal = 1, /* SLC NAND Flash */
+		.max_signal = 1,
+		.periph_buses = PL08X_AHB1,
+	},
+	{
+		.bus_id = "nand-mlc",
+		.min_signal = 12, /* MLC NAND Flash */
+		.max_signal = 12,
+		.periph_buses = PL08X_AHB1,
+	},
+};
+
+/* NOTE: These will change, according to RMK */
+static int pl08x_get_signal(struct pl08x_dma_chan *ch)
+{
+	return ch->cd->min_signal;
+}
+
+static void pl08x_put_signal(struct pl08x_dma_chan *ch)
+{
+}
+
 static struct pl08x_platform_data pl08x_pd = {
+	.slave_channels = &pl08x_slave_channels[0],
+	.num_slave_channels = ARRAY_SIZE(pl08x_slave_channels),
+	.get_signal = pl08x_get_signal,
+	.put_signal = pl08x_put_signal,
+	.lli_buses = PL08X_AHB1,
+	.mem_buses = PL08X_AHB1,
 };
 
 static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
