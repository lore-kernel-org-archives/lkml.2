Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0JDNbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:31:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:35822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0JDNbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:31:44 -0400
From: Michal Marek <mmarek@suse.cz>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: Fix Kconfig dependencies
Date: Mon,  4 Oct 2010 15:31:33 +0200
Message-Id: <1286199093-3576-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c/algos/Kconfig makes all the algorithms dependent on
!I2C_HELPER_AUTO, which triggers a Kconfig warning about broken
dependencies when some driver selects one of the algorithms. Make only
the prompts dependent on !I2C_HELPER_AUTO, not the complete symbols.
This moves the entries out of the "I2C Algorithms" submenu, but most
users do not unset I2C_HELPER_AUTO, so they will not see it anyway.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---

Please consider for 2.6.36, as the warning is caused by a kconfig fix
that I'm about to send to Linus for 2.6.36. And it is triggered by a
simple 'make defconfig' in i386/x84_64:

$ make defconfig
*** Default configuration is based on 'x86_64_defconfig'
warning: (IEEE1394_PCILYNX && (PCI || BROKEN) && PCI && IEEE1394 && I2C || SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA && I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP && EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 && I2C && ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C && (ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT && I2C && PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C && ARCH_ACORN || SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_AU0828 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VI
 DEO_V4L2 || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_PLUTO2 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C || DRM && HAS_IOMEM && (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU || FB_DDC && HAS_IOMEM && FB || FB_VIA && HAS_IOMEM && FB && PCI && X86 || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
[...]

---
 drivers/i2c/algos/Kconfig |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index 7b2ce4a..9ced1a0 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -2,16 +2,15 @@
 # I2C algorithm drivers configuration
 #
 
-menu "I2C Algorithms"
-	depends on !I2C_HELPER_AUTO
-
 config I2C_ALGOBIT
-	tristate "I2C bit-banging interfaces"
+	tristate
+	prompt "I2C bit-banging interfaces" if !I2C_HELPER_AUTO
 
 config I2C_ALGOPCF
-	tristate "I2C PCF 8584 interfaces"
+	tristate
+	prompt "I2C PCF 8584 interfaces" if !I2C_HELPER_AUTO
 
 config I2C_ALGOPCA
-	tristate "I2C PCA 9564 interfaces"
+	tristate
+	prompt "I2C PCA 9564 interfaces" if !I2C_HELPER_AUTO
 
-endmenu
-- 
1.7.1

