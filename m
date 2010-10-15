Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0JOPc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:32:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37485 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0JOPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uoSr02KG5fPeyQ5J5fwj/yNo3Xp02/sHkUfvzBiVCuPz0KQOjCBsVyWq5CA25hhKHh
         Vx+Z2IXLpNDq8gfJIphd1LXnSr1YOBNG9O871iO5KqVNpZe+YINvui9r5Cef42MTYKjl
         UPZOkudvgMug8d/DAK/SiQprDUHTFQlGAM5G8=
Message-ID: <4CB873FB.4@gmail.com>
Date: Fri, 15 Oct 2010 23:32:11 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        yachen@nuvoton.com
Subject: [PATCH] arm/nuc900: delete __initdata for nuc900 lcd structures.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Delete __initdata for nuc900 lcd structures which can arise
some warning as building stage as following:

"
MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
"

so I make this patch to fix it.

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
@@ -445,7 +445,7 @@ static struct nuc900fb_display __initdata nuc900_lcd_info[] = {
  	},
  };

-static struct nuc900fb_mach_info nuc900_fb_info __initdata = {
+static struct nuc900fb_mach_info nuc900_fb_info = {
  #if defined(CONFIG_GPM1040A0_320X240)
  	.displays		= &nuc900_lcd_info[0],
  #else
-- 
1.6.3.3
