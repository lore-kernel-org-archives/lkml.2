Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2DWJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:15:37 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:59867 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110Ab2DWJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:15:35 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Templing <magnus.templing@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 7/9] ARM: ux500: remove a bunch of internal pull-ups
Date: Mon, 23 Apr 2012 11:14:57 +0200
Message-ID: <1335172497-27720-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The default configuration for a number of I2C and keypad pins was
to pull-up. However on most reference designs the electronics
already contain external pull-ups which means the internal
pull-ups will lower the common resistance and increase power
consumption on these lines, and in some reference designs the
keypad inputs are not used so this will just cause problems. So
remove these pull-ups and add them on demand instead if needed.

Signed-off-by: Magnus Templing <magnus.templing@stericsson.com>
Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/pins-db8500.h |   72 ++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-ux500/pins-db8500.h b/arch/arm/mach-ux500/pins-db8500.h
index 8b1d1a7..062c7ac 100644
--- a/arch/arm/mach-ux500/pins-db8500.h
+++ b/arch/arm/mach-ux500/pins-db8500.h
@@ -35,40 +35,40 @@
 
 #define GPIO4_GPIO		PIN_CFG(4, GPIO)
 #define GPIO4_U1_RXD		PIN_CFG(4, ALT_A)
-#define GPIO4_I2C4_SCL		PIN_CFG_INPUT(4, ALT_B, PULLUP)
+#define GPIO4_I2C4_SCL		PIN_CFG(4, ALT_B)
 #define GPIO4_IP_TRSTn		PIN_CFG(4, ALT_C)
 
 #define GPIO5_GPIO		PIN_CFG(5, GPIO)
 #define GPIO5_U1_TXD		PIN_CFG(5, ALT_A)
-#define GPIO5_I2C4_SDA		PIN_CFG_INPUT(5, ALT_B, PULLUP)
+#define GPIO5_I2C4_SDA		PIN_CFG(5, ALT_B)
 #define GPIO5_IP_GPIO6		PIN_CFG(5, ALT_C)
 
 #define GPIO6_GPIO		PIN_CFG(6, GPIO)
 #define GPIO6_U1_CTSn		PIN_CFG(6, ALT_A)
-#define GPIO6_I2C1_SCL		PIN_CFG_INPUT(6, ALT_B, PULLUP)
+#define GPIO6_I2C1_SCL		PIN_CFG(6, ALT_B)
 #define GPIO6_IP_GPIO0		PIN_CFG(6, ALT_C)
 
 #define GPIO7_GPIO		PIN_CFG(7, GPIO)
 #define GPIO7_U1_RTSn		PIN_CFG(7, ALT_A)
-#define GPIO7_I2C1_SDA		PIN_CFG_INPUT(7, ALT_B, PULLUP)
+#define GPIO7_I2C1_SDA		PIN_CFG(7, ALT_B)
 #define GPIO7_IP_GPIO1		PIN_CFG(7, ALT_C)
 
 #define GPIO8_GPIO		PIN_CFG(8, GPIO)
-#define GPIO8_IPI2C_SDA		PIN_CFG_INPUT(8, ALT_A, PULLUP)
-#define GPIO8_I2C2_SDA		PIN_CFG_INPUT(8, ALT_B, PULLUP)
+#define GPIO8_IPI2C_SDA		PIN_CFG(8, ALT_A)
+#define GPIO8_I2C2_SDA		PIN_CFG(8, ALT_B)
 
 #define GPIO9_GPIO		PIN_CFG(9, GPIO)
-#define GPIO9_IPI2C_SCL		PIN_CFG_INPUT(9, ALT_A, PULLUP)
-#define GPIO9_I2C2_SCL		PIN_CFG_INPUT(9, ALT_B, PULLUP)
+#define GPIO9_IPI2C_SCL		PIN_CFG(9, ALT_A)
+#define GPIO9_I2C2_SCL		PIN_CFG(9, ALT_B)
 
 #define GPIO10_GPIO		PIN_CFG(10, GPIO)
-#define GPIO10_IPI2C_SDA	PIN_CFG_INPUT(10, ALT_A, PULLUP)
-#define GPIO10_I2C2_SDA		PIN_CFG_INPUT(10, ALT_B, PULLUP)
+#define GPIO10_IPI2C_SDA	PIN_CFG(10, ALT_A)
+#define GPIO10_I2C2_SDA		PIN_CFG(10, ALT_B)
 #define GPIO10_IP_GPIO3		PIN_CFG(10, ALT_C)
 
 #define GPIO11_GPIO		PIN_CFG(11, GPIO)
-#define GPIO11_IPI2C_SCL	PIN_CFG_INPUT(11, ALT_A, PULLUP)
-#define GPIO11_I2C2_SCL		PIN_CFG_INPUT(11, ALT_B, PULLUP)
+#define GPIO11_IPI2C_SCL	PIN_CFG(11, ALT_A)
+#define GPIO11_I2C2_SCL		PIN_CFG(11, ALT_B)
 #define GPIO11_IP_GPIO2		PIN_CFG(11, ALT_C)
 
 #define GPIO12_GPIO		PIN_CFG(12, GPIO)
@@ -87,12 +87,12 @@
 
 #define GPIO16_GPIO		PIN_CFG(16, GPIO)
 #define GPIO16_MSP0_RFS		PIN_CFG(16, ALT_A)
-#define GPIO16_I2C1_SCL		PIN_CFG_INPUT(16, ALT_B, PULLUP)
+#define GPIO16_I2C1_SCL		PIN_CFG(16, ALT_B)
 #define GPIO16_SLIM0_DAT	PIN_CFG(16, ALT_C)
 
 #define GPIO17_GPIO		PIN_CFG(17, GPIO)
 #define GPIO17_MSP0_RCK		PIN_CFG(17, ALT_A)
-#define GPIO17_I2C1_SDA		PIN_CFG_INPUT(17, ALT_B, PULLUP)
+#define GPIO17_I2C1_SDA		PIN_CFG(17, ALT_B)
 #define GPIO17_SLIM0_CLK	PIN_CFG(17, ALT_C)
 
 #define GPIO18_GPIO		PIN_CFG(18, GPIO)
@@ -434,10 +434,10 @@
 #define GPIO146_SSP0_TXD	PIN_CFG(146, ALT_A)
 
 #define GPIO147_GPIO		PIN_CFG(147, GPIO)
-#define GPIO147_I2C0_SCL	PIN_CFG_INPUT(147, ALT_A, PULLUP)
+#define GPIO147_I2C0_SCL	PIN_CFG(147, ALT_A)
 
 #define GPIO148_GPIO		PIN_CFG(148, GPIO)
-#define GPIO148_I2C0_SDA	PIN_CFG_INPUT(148, ALT_A, PULLUP)
+#define GPIO148_I2C0_SDA	PIN_CFG(148, ALT_A)
 
 #define GPIO149_GPIO		PIN_CFG(149, GPIO)
 #define GPIO149_IP_GPIO0	PIN_CFG(149, ALT_A)
@@ -459,82 +459,82 @@
 #define GPIO152_KP_O9		PIN_CFG(152, ALT_C)
 
 #define GPIO153_GPIO		PIN_CFG(153, GPIO)
-#define GPIO153_KP_I7		PIN_CFG_INPUT(153, ALT_A, PULLDOWN)
+#define GPIO153_KP_I7		PIN_CFG(153, ALT_A)
 #define GPIO153_LCD_D24		PIN_CFG(153, ALT_B)
 #define GPIO153_U2_RXD		PIN_CFG(153, ALT_C)
 
 #define GPIO154_GPIO		PIN_CFG(154, GPIO)
-#define GPIO154_KP_I6		PIN_CFG_INPUT(154, ALT_A, PULLDOWN)
+#define GPIO154_KP_I6		PIN_CFG(154, ALT_A)
 #define GPIO154_LCD_D25		PIN_CFG(154, ALT_B)
 #define GPIO154_U2_TXD		PIN_CFG(154, ALT_C)
 
 #define GPIO155_GPIO		PIN_CFG(155, GPIO)
-#define GPIO155_KP_I5		PIN_CFG_INPUT(155, ALT_A, PULLDOWN)
+#define GPIO155_KP_I5		PIN_CFG(155, ALT_A)
 #define GPIO155_LCD_D26		PIN_CFG(155, ALT_B)
 #define GPIO155_STMAPE_CLK	PIN_CFG(155, ALT_C)
 
 #define GPIO156_GPIO		PIN_CFG(156, GPIO)
-#define GPIO156_KP_I4		PIN_CFG_INPUT(156, ALT_A, PULLDOWN)
+#define GPIO156_KP_I4		PIN_CFG(156, ALT_A)
 #define GPIO156_LCD_D27		PIN_CFG(156, ALT_B)
 #define GPIO156_STMAPE_DAT3	PIN_CFG(156, ALT_C)
 
 #define GPIO157_GPIO		PIN_CFG(157, GPIO)
-#define GPIO157_KP_O7		PIN_CFG_INPUT(157, ALT_A, PULLUP)
+#define GPIO157_KP_O7		PIN_CFG(157, ALT_A)
 #define GPIO157_LCD_D28		PIN_CFG(157, ALT_B)
 #define GPIO157_STMAPE_DAT2	PIN_CFG(157, ALT_C)
 
 #define GPIO158_GPIO		PIN_CFG(158, GPIO)
-#define GPIO158_KP_O6		PIN_CFG_INPUT(158, ALT_A, PULLUP)
+#define GPIO158_KP_O6		PIN_CFG(158, ALT_A)
 #define GPIO158_LCD_D29		PIN_CFG(158, ALT_B)
 #define GPIO158_STMAPE_DAT1	PIN_CFG(158, ALT_C)
 
 #define GPIO159_GPIO		PIN_CFG(159, GPIO)
-#define GPIO159_KP_O5		PIN_CFG_INPUT(159, ALT_A, PULLUP)
+#define GPIO159_KP_O5		PIN_CFG(159, ALT_A)
 #define GPIO159_LCD_D30		PIN_CFG(159, ALT_B)
 #define GPIO159_STMAPE_DAT0	PIN_CFG(159, ALT_C)
 
 #define GPIO160_GPIO		PIN_CFG(160, GPIO)
-#define GPIO160_KP_O4		PIN_CFG_INPUT(160, ALT_A, PULLUP)
+#define GPIO160_KP_O4		PIN_CFG(160, ALT_A)
 #define GPIO160_LCD_D31		PIN_CFG(160, ALT_B)
 #define GPIO160_NONE		PIN_CFG(160, ALT_C)
 
 #define GPIO161_GPIO		PIN_CFG(161, GPIO)
-#define GPIO161_KP_I3		PIN_CFG_INPUT(161, ALT_A, PULLDOWN)
+#define GPIO161_KP_I3		PIN_CFG(161, ALT_A)
 #define GPIO161_LCD_D32		PIN_CFG(161, ALT_B)
 #define GPIO161_UARTMOD_RXD	PIN_CFG(161, ALT_C)
 
 #define GPIO162_GPIO		PIN_CFG(162, GPIO)
-#define GPIO162_KP_I2		PIN_CFG_INPUT(162, ALT_A, PULLDOWN)
+#define GPIO162_KP_I2		PIN_CFG(162, ALT_A)
 #define GPIO162_LCD_D33		PIN_CFG(162, ALT_B)
 #define GPIO162_UARTMOD_TXD	PIN_CFG(162, ALT_C)
 
 #define GPIO163_GPIO		PIN_CFG(163, GPIO)
-#define GPIO163_KP_I1		PIN_CFG_INPUT(163, ALT_A, PULLDOWN)
+#define GPIO163_KP_I1		PIN_CFG(163, ALT_A)
 #define GPIO163_LCD_D34		PIN_CFG(163, ALT_B)
 #define GPIO163_STMMOD_CLK	PIN_CFG(163, ALT_C)
 
 #define GPIO164_GPIO		PIN_CFG(164, GPIO)
-#define GPIO164_KP_I0		PIN_CFG_INPUT(164, ALT_A, PULLUP)
+#define GPIO164_KP_I0		PIN_CFG(164, ALT_A)
 #define GPIO164_LCD_D35		PIN_CFG(164, ALT_B)
 #define GPIO164_STMMOD_DAT3	PIN_CFG(164, ALT_C)
 
 #define GPIO165_GPIO		PIN_CFG(165, GPIO)
-#define GPIO165_KP_O3		PIN_CFG_INPUT(165, ALT_A, PULLUP)
+#define GPIO165_KP_O3		PIN_CFG(165, ALT_A)
 #define GPIO165_LCD_D36		PIN_CFG(165, ALT_B)
 #define GPIO165_STMMOD_DAT2	PIN_CFG(165, ALT_C)
 
 #define GPIO166_GPIO		PIN_CFG(166, GPIO)
-#define GPIO166_KP_O2		PIN_CFG_INPUT(166, ALT_A, PULLUP)
+#define GPIO166_KP_O2		PIN_CFG(166, ALT_A)
 #define GPIO166_LCD_D37		PIN_CFG(166, ALT_B)
 #define GPIO166_STMMOD_DAT1	PIN_CFG(166, ALT_C)
 
 #define GPIO167_GPIO		PIN_CFG(167, GPIO)
-#define GPIO167_KP_O1		PIN_CFG_INPUT(167, ALT_A, PULLUP)
+#define GPIO167_KP_O1		PIN_CFG(167, ALT_A)
 #define GPIO167_LCD_D38		PIN_CFG(167, ALT_B)
 #define GPIO167_STMMOD_DAT0	PIN_CFG(167, ALT_C)
 
 #define GPIO168_GPIO		PIN_CFG(168, GPIO)
-#define GPIO168_KP_O0		PIN_CFG_INPUT(168, ALT_A, PULLUP)
+#define GPIO168_KP_O0		PIN_CFG(168, ALT_A)
 #define GPIO168_LCD_D39		PIN_CFG(168, ALT_B)
 #define GPIO168_NONE		PIN_CFG(168, ALT_C)
 
@@ -637,7 +637,7 @@
 #define GPIO216_GPIO		PIN_CFG(216, GPIO)
 #define GPIO216_MC1_DAT2DIR	PIN_CFG(216, ALT_A)
 #define GPIO216_MC3_CMDDIR	PIN_CFG(216, ALT_B)
-#define GPIO216_I2C3_SDA	PIN_CFG_INPUT(216, ALT_C, PULLUP)
+#define GPIO216_I2C3_SDA	PIN_CFG(216, ALT_C)
 #define GPIO216_SPI2_FRM	PIN_CFG(216, ALT_C)
 
 #define GPIO217_GPIO		PIN_CFG(217, GPIO)
@@ -649,7 +649,7 @@
 #define GPIO218_GPIO		PIN_CFG(218, GPIO)
 #define GPIO218_MC1_DAT31DIR	PIN_CFG(218, ALT_A)
 #define GPIO218_MC3_DAT0DIR	PIN_CFG(218, ALT_B)
-#define GPIO218_I2C3_SCL	PIN_CFG_INPUT(218, ALT_C, PULLUP)
+#define GPIO218_I2C3_SCL	PIN_CFG(218, ALT_C)
 #define GPIO218_SPI2_RXD	PIN_CFG(218, ALT_C)
 
 #define GPIO219_GPIO		PIN_CFG(219, GPIO)
@@ -698,12 +698,12 @@
 #define GPIO229_GPIO		PIN_CFG(229, GPIO)
 #define GPIO229_CLKOUT1		PIN_CFG(229, ALT_A)
 #define GPIO229_PWL		PIN_CFG(229, ALT_B)
-#define GPIO229_I2C3_SDA	PIN_CFG_INPUT(229, ALT_C, PULLUP)
+#define GPIO229_I2C3_SDA	PIN_CFG(229, ALT_C)
 
 #define GPIO230_GPIO		PIN_CFG(230, GPIO)
 #define GPIO230_CLKOUT2		PIN_CFG(230, ALT_A)
 #define GPIO230_PWL		PIN_CFG(230, ALT_B)
-#define GPIO230_I2C3_SCL	PIN_CFG_INPUT(230, ALT_C, PULLUP)
+#define GPIO230_I2C3_SCL	PIN_CFG(230, ALT_C)
 
 #define GPIO256_GPIO		PIN_CFG(256, GPIO)
 #define GPIO256_USB_NXT		PIN_CFG(256, ALT_A)
-- 
1.7.9.2

