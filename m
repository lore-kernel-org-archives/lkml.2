Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1JBOuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1JBOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 26/30] ARM: omap: add board autoselection
Date: Sun,  2 Oct 2011 16:45:56 +0200
Message-Id: <1317566760-25681-27-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tr6zSq+wRa5ZpVtRDbq4njRs6v0SRN+Zg6221Fwr7y6
 cXqhDXRqFWOYs8iq6S64sItfkGzdH1gWr9Vrf1JR8PQMjiIl43
 Zds95/OfdyR+KAhIHnWT4DoYqVOyM+xz/UdOSfjZlUrXCdbOE2
 ZhHvUmi1TLljnb66hIx02zntxf9WMzBvQ3gj8xFPiP+E0SAWoV
 fBgyl1XvcGzzlWMCUI4GZkg0mwAMlKq8SBTWV8IZjjroL2lSXq
 SL9rDRbk4sUV+FIJKYReTcSN1L786sG/R1ALx1Ek4zdBuZUWde
 g+buoIm0TU/CvKGGefSzm7LOahTiyjBKGhwY9YslxQb+8zzApy
 8Vad/V88QBcWBtpff6kYdUQJ5I/sYjsrYsPj3TU+tCgM2h4jjY
 B5JfAOtCLPJ3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least one board file needs to be selected to successfully build
a kernel, so this one adds logic to the omap Kconfig file to
pick one default board file when all others are disabled. Since
the available boards depend on the SoC family (omap2/3/4) being
selected first, this adds one default for each family.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 3c9fb89..fd0ab18 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -120,6 +120,45 @@ config MACH_OMAP_GENERIC
 	depends on ARCH_OMAP2
 	default y
 
+config MACH_OMAP_AUTO_BOARD
+	def_bool y
+	depends on !MACH_OMAP2_TUSB6010
+	depends on !MACH_OMAP_H4
+	depends on !MACH_OMAP_APOLLON
+	depends on !MACH_OMAP_APOLLON
+	depends on !MACH_OMAP_2430SDP
+	depends on !MACH_OMAP3_BEAGLE
+	depends on !MACH_DEVKIT8000
+	depends on !MACH_OMAP_LDP
+	depends on !MACH_OMAP3530_LV_SOM
+	depends on !MACH_OMAP3_TORPEDO
+	depends on !MACH_OVERO
+	depends on !MACH_OMAP3EVM
+	depends on !MACH_OMAP3517EVM
+	depends on !MACH_CRANEBOARD
+	depends on !MACH_OMAP3_PANDORA
+	depends on !MACH_OMAP3_TOUCHBOOK
+	depends on !MACH_NOKIA_N8X0
+	depends on !MACH_NOKIA_RM680
+	depends on !MACH_NOKIA_RX51
+	depends on !MACH_OMAP_ZOOM2
+	depends on !MACH_OMAP_ZOOM3
+	depends on !MACH_CM_T35
+	depends on !MACH_CM_T3517
+	depends on !MACH_IGEP0020
+	depends on !MACH_IGEP0030
+	depends on !MACH_SBC3530
+	depends on !MACH_OMAP_3630SDP
+	depends on !MACH_TI8168EVM
+	depends on !MACH_OMAP4_PANDA
+	select MACH_OMAP_GENERIC if ARCH_OMAP2
+	select MACH_OMAP_3430SDP if ARCH_OMAP3 && !ARCH_OMAP2
+	select MACH_OMAP_4430SDP if ARCH_OMAP4 && !ARCH_OMAP3 && !ARCH_OMAP2
+	help
+	  The kernel needs to have support for at least one board
+	  in order to build. If none is selected, default to the
+	  generic board.
+
 config MACH_OMAP2_TUSB6010
 	bool
 	depends on ARCH_OMAP2 && SOC_OMAP2420
-- 
1.7.5.4

