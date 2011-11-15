Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1KOMjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:39:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33684 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1KOMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:39:41 -0500
Message-ID: <4EC25D72.4070909@gmail.com>
Date: Tue, 15 Nov 2011 20:39:14 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: NUC900: add and change some device clk definitions.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to modify usb, audio and add i2c clk setting in cpu.c.
Also, add DMA, FMI definition to nuc900_iodesc, since I will use them
in the corresponding driver.

---
 arch/arm/mach-w90x900/cpu.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 0a235e5..6eeadfc 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -46,6 +46,8 @@ static struct map_desc nuc900_iodesc[] __initdata = {
 	IODESC_ENT(TIMER),
 	IODESC_ENT(EBI),
 	IODESC_ENT(GPIO),
+	IODESC_ENT(DMA),
+	IODESC_ENT(FMI),
 };

 /* Initial clock declarations. */
@@ -74,10 +76,13 @@ static DEFINE_CLK(timer1, 20);
 static DEFINE_CLK(timer2, 21);
 static DEFINE_CLK(timer3, 22);
 static DEFINE_CLK(timer4, 23);
+static DEFINE_CLK(i2c0, 30);
+static DEFINE_CLK(i2c1, 31);

 static struct clk_lookup nuc900_clkregs[] = {
 	DEF_CLKLOOK(&clk_lcd, "nuc900-lcd", NULL),
-	DEF_CLKLOOK(&clk_audio, "nuc900-audio", NULL),
+	DEF_CLKLOOK(&clk_audio, "nuc900-audio-ac97", NULL),
+	DEF_CLKLOOK(&clk_audio, "nuc900-audio-i2s", NULL),
 	DEF_CLKLOOK(&clk_fmi, "nuc900-fmi", NULL),
 	DEF_CLKLOOK(&clk_ms, "nuc900-fmi", "MS"),
 	DEF_CLKLOOK(&clk_sd, "nuc900-fmi", "SD"),
@@ -85,8 +90,9 @@ static struct clk_lookup nuc900_clkregs[] = {
 	DEF_CLKLOOK(&clk_atapi, "nuc900-atapi", NULL),
 	DEF_CLKLOOK(&clk_emc, "nuc900-emc", NULL),
 	DEF_CLKLOOK(&clk_rmii, "nuc900-emc", "RMII"),
-	DEF_CLKLOOK(&clk_usbd, "nuc900-usbd", NULL),
-	DEF_CLKLOOK(&clk_usbh, "nuc900-usbh", NULL),
+	DEF_CLKLOOK(&clk_usbd, "nuc900-usbgadget", NULL),
+	DEF_CLKLOOK(&clk_usbh, "nuc900-ehci", NULL),
+	DEF_CLKLOOK(&clk_usbh, "nuc900-ohci", NULL),
 	DEF_CLKLOOK(&clk_g2d, "nuc900-g2d", NULL),
 	DEF_CLKLOOK(&clk_pwm, "nuc900-pwm", NULL),
 	DEF_CLKLOOK(&clk_ps2, "nuc900-ps2", NULL),
@@ -101,6 +107,8 @@ static struct clk_lookup nuc900_clkregs[] = {
 	DEF_CLKLOOK(&clk_timer2, NULL, "timer2"),
 	DEF_CLKLOOK(&clk_timer3, NULL, "timer3"),
 	DEF_CLKLOOK(&clk_timer4, NULL, "timer4"),
+	DEF_CLKLOOK(&clk_i2c0, "nuc900-i2c-p0", NULL),
+	DEF_CLKLOOK(&clk_i2c1, "nuc900-i2c-p1", NULL),
 };

 /* Initial serial platform data */
-- 
1.7.0.4
