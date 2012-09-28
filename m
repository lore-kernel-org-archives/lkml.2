Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2I1T6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:58:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2I1S4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 052/262] ARM: clk-imx35: Fix SSI clock registration
Date: Fri, 28 Sep 2012 11:49:41 -0700
Message-Id: <20120928183004.063567827@linuxfoundation.org>
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

commit 48540058612786d365602f3324ed97f9071092de upstream.

SSI block has two types of clock:

ipg: bus clock, the clock needed for accessing registers.
per: peripheral clock, the clock needed for generating the bit rate.

Currently SSI driver only supports slave mode and only need to handle
the ipg clock, because the peripheral clock comes from the master codec.

Only register the ipg clock and do not register the peripheral clock for ssi.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx35.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -230,10 +230,8 @@ int __init mx35_clocks_init()
 	clk_register_clkdev(clk[ipu_gate], NULL, "mx3_sdc_fb");
 	clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1");
 	clk_register_clkdev(clk[sdma_gate], NULL, "imx35-sdma");
-	clk_register_clkdev(clk[ipg], "ipg", "imx-ssi.0");
-	clk_register_clkdev(clk[ssi1_div_post], "per", "imx-ssi.0");
-	clk_register_clkdev(clk[ipg], "ipg", "imx-ssi.1");
-	clk_register_clkdev(clk[ssi2_div_post], "per", "imx-ssi.1");
+	clk_register_clkdev(clk[ssi1_gate], NULL, "imx-ssi.0");
+	clk_register_clkdev(clk[ssi2_gate], NULL, "imx-ssi.1");
 	/* i.mx35 has the i.mx21 type uart */
 	clk_register_clkdev(clk[uart1_gate], "per", "imx21-uart.0");
 	clk_register_clkdev(clk[ipg], "ipg", "imx21-uart.0");


