Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2I1S4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2I1S4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 051/262] ARM: clk-imx25: Fix SSI clock registration
Date: Fri, 28 Sep 2012 11:49:40 -0700
Message-Id: <20120928183003.935825183@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 912bfe76528c287bc4812521b8d53366954b39a5 upstream.

SSI block has two types of clock:

ipg: bus clock, the clock needed for accessing registers.
per: peripheral clock, the clock needed for generating the bit rate.

Currently SSI driver only supports slave mode and only need to handle
the ipg clock, because the peripheral clock comes from the master codec.

Only register the ipg clock and do not register the peripheral clock for ssi.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx25.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-imx/clk-imx25.c
+++ b/arch/arm/mach-imx/clk-imx25.c
@@ -222,10 +222,8 @@ int __init mx25_clocks_init(void)
 	clk_register_clkdev(clk[lcdc_ipg], "ipg", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ahb], "ahb", "imx-fb.0");
 	clk_register_clkdev(clk[wdt_ipg], NULL, "imx2-wdt.0");
-	clk_register_clkdev(clk[ssi1_ipg_per], "per", "imx-ssi.0");
-	clk_register_clkdev(clk[ssi1_ipg], "ipg", "imx-ssi.0");
-	clk_register_clkdev(clk[ssi2_ipg_per], "per", "imx-ssi.1");
-	clk_register_clkdev(clk[ssi2_ipg], "ipg", "imx-ssi.1");
+	clk_register_clkdev(clk[ssi1_ipg], NULL, "imx-ssi.0");
+	clk_register_clkdev(clk[ssi2_ipg], NULL, "imx-ssi.1");
 	clk_register_clkdev(clk[esdhc1_ipg_per], "per", "sdhci-esdhc-imx25.0");
 	clk_register_clkdev(clk[esdhc1_ipg], "ipg", "sdhci-esdhc-imx25.0");
 	clk_register_clkdev(clk[esdhc1_ahb], "ahb", "sdhci-esdhc-imx25.0");


