Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1JAUKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:10:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1JAUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/26] ARM: pxa: allow selecting just one of TREO680/CENTRO
Date: Sat,  1 Oct 2011 22:03:42 +0200
Message-Id: <1317499438-14058-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gl4LFfmNKbF8u8RNXEhg0WPZTan/tKfmfcFCDGLFMy1
 8q3La9JPfAm1SkqKZiDDeCVjMxwdI4sPhbrKlJOrY6XrDDthkG
 0yvgkbeRnifxKmKtA1a52HUvlL2ZScdcZ0xwfZGOfPZEp52ouJ
 n4npUkgKdNp+2SAnVf9hI/hQjQ1Na/fqG3pmbku29ewnurblbg
 qxyEhIGDcOPi7FsAGD9WEVpNH+QtYM64uFDaeSQsawXChpvvKQ
 NZ/EVLfGIKlXBPSjEIgjje8ZDMsptLv8f4dTP+/Oi1EBiWzE6N
 o/z4c4rUvN/rV5S0rUMu6I6xXfE1dHDZ2TDg/u8rEvlwjTZ+r3
 9CWV4kprFKxiLRnvqFuKA8jQouv+rTgUv69Kimy9BgXMy/o0et
 PJ2YxHbIQZB6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two variants of the palmtreo machine, the 680 and the
centro, and Kconfig allows selecting one or both of them.
This changes the board file so that it's actually possible
to build all configurations that are allowed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/palmtreo.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
index bb27d4b..30364b0 100644
--- a/arch/arm/mach-pxa/palmtreo.c
+++ b/arch/arm/mach-pxa/palmtreo.c
@@ -423,6 +423,7 @@ static void __init palmphone_common_init(void)
 	palmtreo_leds_init();
 }
 
+#ifdef CONFIG_MACH_TREO680
 static void __init treo680_init(void)
 {
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(treo680_pin_config));
@@ -430,7 +431,9 @@ static void __init treo680_init(void)
 	palm27x_mmc_init(GPIO_NR_TREO_SD_DETECT_N, GPIO_NR_TREO680_SD_READONLY,
 			GPIO_NR_TREO680_SD_POWER, 0);
 }
+#endif
 
+#ifdef CONFIG_MACH_CENTRO
 static void __init centro_init(void)
 {
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(centro685_pin_config));
@@ -438,7 +441,9 @@ static void __init centro_init(void)
 	palm27x_mmc_init(GPIO_NR_TREO_SD_DETECT_N, -1,
 			GPIO_NR_CENTRO_SD_POWER, 1);
 }
+#endif
 
+#ifdef CONFIG_MACH_TREO680
 MACHINE_START(TREO680, "Palm Treo 680")
 	.boot_params    = 0xa0000100,
 	.map_io         = pxa27x_map_io,
@@ -448,7 +453,9 @@ MACHINE_START(TREO680, "Palm Treo 680")
 	.timer          = &pxa_timer,
 	.init_machine   = treo680_init,
 MACHINE_END
+#endif
 
+#ifdef CONFIG_MACH_CENTRO
 MACHINE_START(CENTRO, "Palm Centro 685")
 	.boot_params    = 0xa0000100,
 	.map_io         = pxa27x_map_io,
@@ -458,3 +465,4 @@ MACHINE_START(CENTRO, "Palm Centro 685")
 	.timer          = &pxa_timer,
 	.init_machine	= centro_init,
 MACHINE_END
+#endif
-- 
1.7.5.4

