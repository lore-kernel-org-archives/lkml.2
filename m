Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2HMU3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:29:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2HMUY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 69/82] ARM: clk-imx31: Fix the keypad clock name
Date: Mon, 13 Aug 2012 13:19:45 -0700
Message-Id: <20120813201752.507990490@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 8cc7a2b9f75355f60922db4adf27742ba7f2f6bc upstream.

Fix the keypad clock name, in order to fix the following error:

imx-keypad imx-keypad: failed to get keypad clock
imx-keypad: probe of imx-keypad failed with error -2

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx31.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-imx/clk-imx31.c
+++ b/arch/arm/mach-imx/clk-imx31.c
@@ -129,7 +129,7 @@ int __init mx31_clocks_init(unsigned lon
 	clk_register_clkdev(clk[nfc], NULL, "mxc_nand.0");
 	clk_register_clkdev(clk[ipu_gate], NULL, "ipu-core");
 	clk_register_clkdev(clk[ipu_gate], NULL, "mx3_sdc_fb");
-	clk_register_clkdev(clk[kpp_gate], "kpp", NULL);
+	clk_register_clkdev(clk[kpp_gate], NULL, "imx-keypad");
 	clk_register_clkdev(clk[usb_div_post], "per", "mxc-ehci.0");
 	clk_register_clkdev(clk[usb_gate], "ahb", "mxc-ehci.0");
 	clk_register_clkdev(clk[ipg], "ipg", "mxc-ehci.0");


