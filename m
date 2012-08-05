Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2HEQdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:33:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:33:32 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 5/5] ARM: mmp: enable 88pm860x in ttc dkb
Date: Mon,  6 Aug 2012 00:32:53 +0800
Message-Id: <1344184373-9670-6-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable backlight & led components of 88pm860x PMIC in ttc dkb board.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 arch/arm/mach-mmp/ttc_dkb.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 7a7de2b..1b51b81 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -138,8 +138,23 @@ static struct pca953x_platform_data max7312_data[] = {
 	},
 };
 
+static struct pm860x_backlight_pdata ttc_dkb_backlight[] = {
+	{ .iset	= PM8606_WLED_CURRENT(4), },
+};
+
+static struct pm860x_led_pdata ttc_dkb_led[] = {
+	{ .iset = PM8606_LED_CURRENT(12), },
+	{ .iset = PM8606_LED_CURRENT(12), },
+	{ .iset = PM8606_LED_CURRENT(12), },
+};
+
 static struct pm860x_platform_data ttc_dkb_pm8607_info = {
 	.irq_base       = IRQ_BOARD_START,
+	.companion_addr	= 0x11,
+	.backlight	= &ttc_dkb_backlight[0],
+	.num_backlights	= ARRAY_SIZE(ttc_dkb_backlight),
+	.led		= &ttc_dkb_led[0],
+	.num_leds	= ARRAY_SIZE(ttc_dkb_led),
 };
 
 static struct i2c_board_info ttc_dkb_i2c_info[] = {
-- 
1.7.9.5

