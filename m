Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1KIPwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:52:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KIPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:52:04 -0500
Message-ID: <4EBAA124.6060903@gmail.com>
Date: Wed, 09 Nov 2011 23:49:56 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: NUC900: fix a building WARNING 'Found 1 section mismatch'.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix a WARNING which is the "modpost: Found 1 section
mismatch(es)" for nuc900 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 7a1fa6a..5b0c38a 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -422,7 +422,7 @@ struct platform_device nuc900_device_kpi = {

 /* LCD controller*/

-static struct nuc900fb_display __initdata nuc900_lcd_info[] = {
+static struct nuc900fb_display nuc900_lcd_info[] = {
 	/* Giantplus Technology GPM1040A0 320x240 Color TFT LCD */
 	[0] = {
 		.type		= LCM_DCCS_VA_SRC_RGB565,
@@ -445,7 +445,7 @@ static struct nuc900fb_display __initdata
nuc900_lcd_info[] = {
 	},
 };

-static struct nuc900fb_mach_info nuc900_fb_info __initdata = {
+static struct nuc900fb_mach_info nuc900_fb_info = {
 #if defined(CONFIG_GPM1040A0_320X240)
 	.displays		= &nuc900_lcd_info[0],
 #else
-- 
1.7.0.4
