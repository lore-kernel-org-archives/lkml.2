Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab1LFBkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:40:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65148 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:39:59 -0500
Message-ID: <4EDD71C5.1090905@solonet.org.ua>
Date: Tue, 06 Dec 2011 03:37:09 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH resend3] arm: s3c24xx: Add new LCD (W35i) support for Mini2440
 board
References: <4EC588A8.3030907@solonet.org.ua>
In-Reply-To: <4EC588A8.3030907@solonet.org.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new LCD (W35i) support for Mini2440 board

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
---

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c
b/arch/arm/mach-s3c2440/mach-mini2440.c
index fc2dc0b..951eadd 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -167,6 +167,24 @@ static struct s3c2410fb_display mini2440_lcd_cfg[]
__initdata = {
 		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
 				   S3C2410_LCDCON5_HWSWP),
 	},
+	/* mini2440 + 3.5" TFT (LCD-W35i, LQ035Q1DG06 type) + touchscreen*/
+	[3] = {
+		_LCD_DECLARE(
+			/* clock */
+			7,
+			/* xres, margin_right, margin_left, hsync */
+			320, 68, 66, 4,
+			/* yres, margin_top, margin_bottom, vsync */
+			240, 4, 4, 9,
+			/* refresh rate */
+			60),
+		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVDEN |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVCLK |
+				   S3C2410_LCDCON5_HWSWP),
+	},
 };
  /* todo - put into gpio header */
