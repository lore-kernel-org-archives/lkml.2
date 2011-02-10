Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1BJGoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1BJGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:11 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Gary King <gking@nvidia.com>, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/15] ARM: tegra: iomap: Add missing devices, fix use of SZ_8, SZ_64
Date: Wed,  9 Feb 2011 22:43:19 -0800
Message-Id: <1297320204-31882-11-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary King <gking@nvidia.com>

Adds gart, hdmi, avp, host1x, and pwm controllers to mach/iomap.h
There is no SZ_8 or SZ_64, replace them with constants

Signed-off-by: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/iomap.h |   55 ++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/iomap.h b/arch/arm/mach-tegra/include/mach/iomap.h
index 325eca3..26f2363 100644
--- a/arch/arm/mach-tegra/include/mach/iomap.h
+++ b/arch/arm/mach-tegra/include/mach/iomap.h
@@ -26,6 +26,9 @@
 #define TEGRA_IRAM_BASE			0x40000000
 #define TEGRA_IRAM_SIZE			SZ_256K
 
+#define TEGRA_HOST1X_BASE		0x50000000
+#define TEGRA_HOST1X_SIZE		0x24000
+
 #define TEGRA_ARM_PERIF_BASE		0x50040000
 #define TEGRA_ARM_PERIF_SIZE		SZ_8K
 
@@ -35,38 +38,56 @@
 #define TEGRA_ARM_INT_DIST_BASE		0x50041000
 #define TEGRA_ARM_INT_DIST_SIZE		SZ_4K
 
+#define TEGRA_MPE_BASE			0x54040000
+#define TEGRA_MPE_SIZE			SZ_256K
+
+#define TEGRA_VI_BASE			0x54080000
+#define TEGRA_VI_SIZE			SZ_256K
+
+#define TEGRA_ISP_BASE			0x54100000
+#define TEGRA_ISP_SIZE			SZ_256K
+
 #define TEGRA_DISPLAY_BASE		0x54200000
 #define TEGRA_DISPLAY_SIZE		SZ_256K
 
 #define TEGRA_DISPLAY2_BASE		0x54240000
 #define TEGRA_DISPLAY2_SIZE		SZ_256K
 
+#define TEGRA_HDMI_BASE			0x54280000
+#define TEGRA_HDMI_SIZE			SZ_256K
+
+#define TEGRA_GART_BASE			0x58000000
+#define TEGRA_GART_SIZE			SZ_32M
+
+#define TEGRA_RES_SEMA_BASE		0x60001000
+#define TEGRA_RES_SEMA_SIZE		SZ_4K
+
 #define TEGRA_PRIMARY_ICTLR_BASE	0x60004000
-#define TEGRA_PRIMARY_ICTLR_SIZE	SZ_64
+#define TEGRA_PRIMARY_ICTLR_SIZE	64
 
 #define TEGRA_SECONDARY_ICTLR_BASE	0x60004100
-#define TEGRA_SECONDARY_ICTLR_SIZE	SZ_64
+#define TEGRA_SECONDARY_ICTLR_SIZE	64
 
 #define TEGRA_TERTIARY_ICTLR_BASE	0x60004200
-#define TEGRA_TERTIARY_ICTLR_SIZE	SZ_64
+#define TEGRA_TERTIARY_ICTLR_SIZE	64
 
 #define TEGRA_QUATERNARY_ICTLR_BASE	0x60004300
-#define TEGRA_QUATERNARY_ICTLR_SIZE	SZ_64
+#define TEGRA_QUATERNARY_ICTLR_SIZE	64
 
 #define TEGRA_TMR1_BASE			0x60005000
-#define TEGRA_TMR1_SIZE			SZ_8
+#define TEGRA_TMR1_SIZE			8
 
 #define TEGRA_TMR2_BASE			0x60005008
-#define TEGRA_TMR2_SIZE			SZ_8
+#define TEGRA_TMR2_SIZE			8
 
 #define TEGRA_TMRUS_BASE		0x60005010
-#define TEGRA_TMRUS_SIZE		SZ_64
+#define TEGRA_TMRUS_SIZE		64
 
 #define TEGRA_TMR3_BASE			0x60005050
-#define TEGRA_TMR3_SIZE			SZ_8
+#define TEGRA_TMR3_SIZE			8
 
 #define TEGRA_TMR4_BASE			0x60005058
-#define TEGRA_TMR4_SIZE			SZ_8
+#define TEGRA_TMR4_SIZE			8
 
 #define TEGRA_CLK_RESET_BASE		0x60006000
 #define TEGRA_CLK_RESET_SIZE		SZ_4K
@@ -114,10 +135,10 @@
 #define TEGRA_I2S2_SIZE			SZ_256
 
 #define TEGRA_UARTA_BASE		0x70006000
-#define TEGRA_UARTA_SIZE		SZ_64
+#define TEGRA_UARTA_SIZE		64
 
 #define TEGRA_UARTB_BASE		0x70006040
-#define TEGRA_UARTB_SIZE		SZ_64
+#define TEGRA_UARTB_SIZE		64
 
 #define TEGRA_UARTC_BASE		0x70006200
 #define TEGRA_UARTC_SIZE		SZ_256
@@ -140,6 +161,18 @@
 #define TEGRA_PWFM_BASE			0x7000A000
 #define TEGRA_PWFM_SIZE			SZ_256
 
+#define TEGRA_PWFM0_BASE		0x7000A000
+#define TEGRA_PWFM0_SIZE		4
+
+#define TEGRA_PWFM1_BASE		0x7000A010
+#define TEGRA_PWFM1_SIZE		4
+
+#define TEGRA_PWFM2_BASE		0x7000A020
+#define TEGRA_PWFM2_SIZE		4
+
+#define TEGRA_PWFM3_BASE		0x7000A030
+#define TEGRA_PWFM3_SIZE		4
+
 #define TEGRA_MIPI_BASE			0x7000B000
 #define TEGRA_MIPI_SIZE			SZ_256
 
-- 
1.7.3.1

