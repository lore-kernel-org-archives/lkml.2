Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1LMGgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:36:36 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:53661 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1LMGcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:10 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/19] cpuimx25sd: fix Kconfig
Date: Tue, 13 Dec 2011 07:31:35 +0100
Message-Id: <1323757911-25217-3-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in 0d6cfa3a75f5cde5b3ca0dde748fd22625b4f34c I fixed the mach-types
records. We also need to make the name consistent in Kconfig else
the machine_is_eukrea_cpuimx25sd macro fails, and thus audio codec
is not properly initalized.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/Kconfig  |    4 ++--
 arch/arm/mach-imx/Makefile |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index c44aa97..d2c24d5 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -132,7 +132,7 @@ config MACH_MX25_3DS
 	select IMX_HAVE_PLATFORM_MXC_NAND
 	select IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
 
-config MACH_EUKREA_CPUIMX25
+config MACH_EUKREA_CPUIMX25SD
 	bool "Support Eukrea CPUIMX25 Platform"
 	select SOC_IMX25
 	select IMX_HAVE_PLATFORM_FLEXCAN
@@ -148,7 +148,7 @@ config MACH_EUKREA_CPUIMX25
 
 choice
 	prompt "Baseboard"
-	depends on MACH_EUKREA_CPUIMX25
+	depends on MACH_EUKREA_CPUIMX25SD
 	default MACH_EUKREA_MBIMXSD25_BASEBOARD
 
 config MACH_EUKREA_MBIMXSD25_BASEBOARD
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index aba7321..646f643 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_MACH_MX21ADS) += mach-mx21ads.o
 
 # i.MX25 based machines
 obj-$(CONFIG_MACH_MX25_3DS) += mach-mx25_3ds.o
-obj-$(CONFIG_MACH_EUKREA_CPUIMX25) += mach-eukrea_cpuimx25.o
+obj-$(CONFIG_MACH_EUKREA_CPUIMX25SD) += mach-eukrea_cpuimx25.o
 obj-$(CONFIG_MACH_EUKREA_MBIMXSD25_BASEBOARD) += eukrea_mbimxsd25-baseboard.o
 
 # i.MX27 based machines
-- 
1.7.6.4

