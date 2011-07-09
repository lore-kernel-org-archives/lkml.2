Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1GIV0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:26:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13319 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab1GIVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:25:59 -0400
Date: Sat, 9 Jul 2011 23:16:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-sh@vger.kernel.org, Yusuke Goda <goda.yuske@renesas.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 3/7] SH: static should be at beginning of declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107092312390.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2103632354-1310246182=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2103632354-1310246182=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Make sure that the 'static' keywork is at the beginning of declaration
for arch/sh/*

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/sh/boards/mach-ap325rxa/setup.c |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c |    4 ++--
 arch/sh/boards/mach-kfr2r09/setup.c  |    2 +-
 arch/sh/boards/mach-migor/setup.c    |    2 +-
 arch/sh/boards/mach-se/7724/setup.c  |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 969421f..1dc924b 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -188,7 +188,7 @@ static void ap320_wvga_power_off(void *board_data)
 	__raw_writew(0, FPGA_LCDREG);
 }
 
-const static struct fb_videomode ap325rxa_lcdc_modes[] = {
+static const struct fb_videomode ap325rxa_lcdc_modes[] = {
 	{
 		.name = "LB070WV1",
 		.xres = 800,
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 513cb1a..b24d69d 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -280,7 +280,7 @@ static struct platform_device usbhs_device = {
 };
 
 /* LCDC */
-const static struct fb_videomode ecovec_lcd_modes[] = {
+static const struct fb_videomode ecovec_lcd_modes[] = {
 	{
 		.name		= "Panel",
 		.xres		= 800,
@@ -295,7 +295,7 @@ const static struct fb_videomode ecovec_lcd_modes[] = {
 	},
 };
 
-const static struct fb_videomode ecovec_dvi_modes[] = {
+static const struct fb_videomode ecovec_dvi_modes[] = {
 	{
 		.name		= "DVI",
 		.xres		= 1280,
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index 8b4abbb..f65271a 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -127,7 +127,7 @@ static struct platform_device kfr2r09_sh_keysc_device = {
 	},
 };
 
-const static struct fb_videomode kfr2r09_lcdc_modes[] = {
+static const struct fb_videomode kfr2r09_lcdc_modes[] = {
 	{
 		.name = "TX07D34VM0AAA",
 		.xres = 240,
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 184fde1..2d4c9c8 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -214,7 +214,7 @@ static struct platform_device migor_nand_flash_device = {
 	}
 };
 
-const static struct fb_videomode migor_lcd_modes[] = {
+static const struct fb_videomode migor_lcd_modes[] = {
 	{
 #if defined(CONFIG_SH_MIGOR_RTA_WVGA)
 		.name = "LB070WV1",
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 1235767..d007567 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -145,7 +145,7 @@ static struct platform_device nor_flash_device = {
 };
 
 /* LCDC */
-const static struct fb_videomode lcdc_720p_modes[] = {
+static const struct fb_videomode lcdc_720p_modes[] = {
 	{
 		.name		= "LB070WV1",
 		.sync		= 0, /* hsync and vsync are active low */
@@ -160,7 +160,7 @@ const static struct fb_videomode lcdc_720p_modes[] = {
 	},
 };
 
-const static struct fb_videomode lcdc_vga_modes[] = {
+static const struct fb_videomode lcdc_vga_modes[] = {
 	{
 		.name		= "LB070WV1",
 		.sync		= 0, /* hsync and vsync are active low */
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-2103632354-1310246182=:25516--
