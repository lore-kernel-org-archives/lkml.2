Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0KFJJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:09:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56567 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0KFJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=m/UdxN0dsWg38ty2fvnoirzIQvW8SE5cYju8oV5Hpk42ef5ZywfAorXgDEQy0TKAWu
         dO7e98GgQxCTk3S1FcumhS3jUwf5JKrlHllKagcy3IFTkwIO2A2Ssk+vKORFNnBnQniL
         U9FsuM/DCATNlXOY5Q9FLa36G19FqbhMsYreM=
Message-ID: <4CD51A9B.7010806@gmail.com>
Date: Sat, 06 Nov 2010 10:06:35 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: fix compilation warning during compilation
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

During compilation of 2.6.36 for Beagle board, there a are a couple of warnings. This patch fix them.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-2.6.36-orig/arch/arm/plat-omap/include/plat/usb.h	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.36/arch/arm/plat-omap/include/plat/usb.h	2010-11-01 09:44:13.000000000 +0100
@@ -105,7 +105,7 @@ static inline void omap1_usb_init(struct
 #if defined(CONFIG_ARCH_OMAP_OTG) || defined(CONFIG_ARCH_OMAP_OTG_MODULE)
 void omap2_usbfs_init(struct omap_usb_config *pdata);
 #else
-static inline omap2_usbfs_init(struct omap_usb_config *pdata)
+static inline void omap2_usbfs_init(struct omap_usb_config *pdata)
 {
 }
 #endif
--- linux-2.6.36-orig/arch/arm/mach-omap2/mux.c	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.36/arch/arm/mach-omap2/mux.c	2010-11-01 10:21:29.000000000 +0100
@@ -87,7 +87,7 @@ static char *omap_mux_options;
 int __init omap_mux_init_gpio(int gpio, int val)
 {
 	struct omap_mux_entry *e;
-	struct omap_mux *gpio_mux;
+	struct omap_mux *gpio_mux = NULL;
 	u16 old_mode;
 	u16 mux_mode;
 	int found = 0;

