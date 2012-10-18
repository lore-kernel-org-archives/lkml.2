Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2JRQHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:07:05 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36652 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753290Ab2JRQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:07:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: mach-imx: Support for DryIce RTC in i.MX53
Date: Thu, 18 Oct 2012 18:06:10 +0200
Message-Id: <1350576370-29098-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350576370-29098-1-git-send-email-stigge@antcom.de>
References: <1350576370-29098-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for i.MX53 in addition to i.MX25 by providing a
dummy clock on i.MX53 since this one doesn't have a separate clock for internal
RTC but the driver requests one.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-imx/clk-imx51-imx53.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/arch/arm/mach-imx/clk-imx51-imx53.c
+++ linux-2.6/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -467,6 +467,7 @@ int __init mx53_clocks_init(unsigned lon
 	clk_register_clkdev(clk[can1_serial_gate], "per", "53fc8000.can");
 	clk_register_clkdev(clk[can2_ipg_gate], "ipg", "53fcc000.can");
 	clk_register_clkdev(clk[can2_serial_gate], "per", "53fcc000.can");
+	clk_register_clkdev(clk[dummy], NULL, "53fa4000.rtc");
 
 	/* set SDHC root clock to 200MHZ*/
 	clk_set_rate(clk[esdhc_a_podf], 200000000);
