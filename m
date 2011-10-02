Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1JBOt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1JBOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/30] ARM: omap4: always build omap_phy_internal
Date: Sun,  2 Oct 2011 16:45:42 +0200
Message-Id: <1317566760-25681-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/mTzhW7AgNXrVniylPaagrC6GYP2Lv1sAJq/GmSvs8J
 MwU9yQ/eg+bksLxBzimZFLiKNShOTUdwHfubTR0frirSUAawFQ
 2j6ymQBJoDkjP4tp+nA1OTqMoUWCmft9tvgO18qRTYrqMNa6SY
 2XocN5ygg/P/iXxffztHimPJp7v1zh4SSBrv4xcKmXFM7/iN1U
 rPCG/LsWUKneQewggkcPcwAHTHys90W8QGshajCRF0KRlMxwgR
 WFFupK5RB7FWtEmo243YnJZWmbdijaY67FQ7yZWr7XVtTGzJS4
 ZjloGYOx8SvO6dMmXpgF4aylHARDja+oCmVQBwCPAi+y/PoTd9
 1DbvW77jHv1mJ2iSLWjgkjruNspTB+4KYlytIi6bHTigQI+5em
 pf3Lgw3W4k5OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions defined in omap_phy_internal.c are requrired on
omap4-only configurations, not just for specific boards.

twl-common.c:(.init.text+0x6b40): undefined reference to `omap4430_phy_init'
twl-common.c:(.init.text+0x6c68): undefined reference to `omap4430_phy_init'
mach-omap2/built-in.o:(.data+0x154e0): undefined reference to `omap4430_phy_init'
mach-omap2/built-in.o:(.data+0x154e4): undefined reference to `omap4430_phy_exit'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Makefile |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index f343365..dc36bd4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -242,12 +242,9 @@ obj-$(CONFIG_MACH_IGEP0020)		+= board-igep0020.o \
 obj-$(CONFIG_MACH_OMAP3_TOUCHBOOK)	+= board-omap3touchbook.o \
 					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o \
-					   hsmmc.o \
-					   omap_phy_internal.o
+					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o \
-					   hsmmc.o \
-					   omap_phy_internal.o
-
+					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o \
 					   omap_phy_internal.o \
 
@@ -275,6 +272,7 @@ obj-y					+= $(smc91x-m) $(smc91x-y)
 smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
 obj-y					+= $(smsc911x-m) $(smsc911x-y)
 obj-$(CONFIG_ARCH_OMAP4)		+= hwspinlock.o
+obj-$(CONFIG_ARCH_OMAP4)		+= omap_phy_internal.o
 
 disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
-- 
1.7.5.4

