Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0E1Lm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:42:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56430 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab0E1Lmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:42:55 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: sha@pengutronix.de
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, Baruch Siach <baruch@tkos.co.il>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mx25: flexcan clock support
Date: Fri, 28 May 2010 13:42:15 +0200
Message-Id: <1275046938-8465-2-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
References: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/mach-mx25/clock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx25/clock.c b/arch/arm/mach-mx25/clock.c
index 1550149..158a29b 100644
--- a/arch/arm/mach-mx25/clock.c
+++ b/arch/arm/mach-mx25/clock.c
@@ -191,6 +191,8 @@ DEFINE_CLOCK(i2c_clk,	 0, CCM_CGCR0,  6, get_rate_i2c, NULL, NULL);
 DEFINE_CLOCK(fec_clk,	 0, CCM_CGCR1, 15, get_rate_ipg, NULL, &fec_ahb_clk);
 DEFINE_CLOCK(dryice_clk, 0, CCM_CGCR1,  8, get_rate_ipg, NULL, NULL);
 DEFINE_CLOCK(lcdc_clk,	 0, CCM_CGCR1, 29, get_rate_lcdc, NULL, &lcdc_per_clk);
+DEFINE_CLOCK(can1_clk,	 0, CCM_CGCR1,  2, get_rate_ipg, NULL, NULL);
+DEFINE_CLOCK(can2_clk,	 0, CCM_CGCR1,  3, get_rate_ipg, NULL, NULL);
 
 #define _REGISTER_CLOCK(d, n, c)	\
 	{				\
@@ -225,6 +227,8 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
 	_REGISTER_CLOCK("imxdi_rtc.0", NULL, dryice_clk)
 	_REGISTER_CLOCK("imx-fb.0", NULL, lcdc_clk)
+	_REGISTER_CLOCK("flexcan.0", NULL, can1_clk)
+	_REGISTER_CLOCK("flexcan.1", NULL, can2_clk)
 };
 
 int __init mx25_clocks_init(void)
-- 
1.7.1

