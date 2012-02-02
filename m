Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2BBTaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:30:46 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:35411 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757007Ab2BBTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:30:45 -0500
From: stigge@antcom.de
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 5/7] ARM: LPC32xx: clock.c: Clock registration fixes
Date: Thu,  2 Feb 2012 20:19:46 +0100
Message-Id: <1328210388-21296-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328210388-21296-1-git-send-email-stigge@antcom.de>
References: <1328210388-21296-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the clock registration list, ported from the latest version
of Kevin Wells' latest version of clock.c: i2s0_ck, i2s1_ck and dev:mmc0 have
NULL pointers associated as the .dev_id and .con_id, respectively. The old
values were not useful.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -1076,10 +1098,10 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("dev:ssp1", NULL, clk_ssp1)
 	_REGISTER_CLOCK("lpc32xx_keys.0", NULL, clk_kscan)
 	_REGISTER_CLOCK("lpc32xx-nand.0", "nand_ck", clk_nand)
-	_REGISTER_CLOCK("tbd", "i2s0_ck", clk_i2s0)
-	_REGISTER_CLOCK("tbd", "i2s1_ck", clk_i2s1)
+	_REGISTER_CLOCK(NULL, "i2s0_ck", clk_i2s0)
+	_REGISTER_CLOCK(NULL, "i2s1_ck", clk_i2s1)
 	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)
-	_REGISTER_CLOCK("dev:mmc0", "MCLK", clk_mmc)
+	_REGISTER_CLOCK("dev:mmc0", NULL, clk_mmc)
 	_REGISTER_CLOCK("lpc-net.0", NULL, clk_net)
 	_REGISTER_CLOCK("dev:clcd", NULL, clk_lcd)
 	_REGISTER_CLOCK("lpc32xx_udc", "ck_usbd", clk_usbd)

