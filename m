Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0KAVru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:47:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34718 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0KAVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:47:48 -0400
From: Thomas Weber <weber@corscience.de>
To: tony@atomide.com
Cc: Thomas Weber <weber@corscience.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP2: Devkit8000: Fix mmc regulator failure
Date: Mon,  1 Nov 2010 23:48:11 +0100
Message-Id: <1288651691-14914-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following error:

>regulator: VMMC1: 1850 <--> 3150 mV at 3000 mV normal
standby
>twl_reg twl_reg.6: can't register VMMC1, -22
>twl_reg: probe of twl_reg.6 failed with error -22

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 067f437..53ac762 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -242,9 +242,6 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 	mmc[0].gpio_cd = gpio + 0;
 	omap2_hsmmc_init(mmc);
 
-	/* link regulators to MMC adapters */
-	devkit8000_vmmc1_supply.dev = mmc[0].dev;
-
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
 
-- 
1.7.3.2

