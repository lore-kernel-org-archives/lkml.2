Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2JBQhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2JBQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 17/17] ARM: soc: dependency warnings for errata
Date: Tue,  2 Oct 2012 18:36:56 +0200
Message-Id: <1349195816-2225-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wa98cI5tNEzVAw6h/8haDQyv2pqjcV9usSo89Sx9yY1
 VAbhTVa/+aw2DL2IRfqATigGXkJzTR+LQx8UbBCpN+RTrZ0qbB
 PB9UGx37HIXPgBPHpiiYe6Y55fKYTdwne2qxzTpU3Utgt+99Qy
 417LXhX+hEr6qLk/wScPtqe8AkEXE656h2fH9TQ3QuSiicD3qQ
 qneWBpH8MFVuqXLSH0hWt4fpHG7liZbi/7pAd2o3L8cUBg/Yj/
 hZEI27iwo3yAp7LBrGIyOfsZ974rM0P49CZaIYHHtxcNenSyZg
 v2bYxuxs0j8KEG8x1D4cIrlbfl8WrGdkGJo3n8FxQnlQjHjMki
 oDXG9EE+Plgsqh8x+krChJlWFMDBC7Ch7UoRpSkXCbkcyam6Jr
 dn76CZgvhmqmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PL310_ERRATA_753970 and ARM_ERRATA_764369 symbols only make sense
when the base features for them are enabled, so select them
conditionally in Kconfig to avoid warnings like:

warning: (UX500_SOC_COMMON) selects PL310_ERRATA_753970 which has unmet direct dependencies (CACHE_PL310)
warning: (ARCH_TEGRA_2x_SOC && ARCH_TEGRA_3x_SOC && UX500_SOC_COMMON) selects ARM_ERRATA_764369 which has unmet direct dependencies (CPU_V7 && SMP)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
---
 arch/arm/mach-tegra/Kconfig |    4 ++--
 arch/arm/mach-ux500/Kconfig |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 9077aaa..b5f62ab 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -16,7 +16,7 @@ config ARCH_TEGRA_2x_SOC
 	select ARM_ERRATA_742230
 	select ARM_ERRATA_751472
 	select ARM_ERRATA_754327
-	select ARM_ERRATA_764369
+	select ARM_ERRATA_764369 if SMP
 	select PL310_ERRATA_727915 if CACHE_L2X0
 	select PL310_ERRATA_769419 if CACHE_L2X0
 	select CPU_FREQ_TABLE if CPU_FREQ
@@ -38,7 +38,7 @@ config ARCH_TEGRA_3x_SOC
 	select ARM_ERRATA_743622
 	select ARM_ERRATA_751472
 	select ARM_ERRATA_754322
-	select ARM_ERRATA_764369
+	select ARM_ERRATA_764369 if SMP
 	select PL310_ERRATA_769419 if CACHE_L2X0
 	select CPU_FREQ_TABLE if CPU_FREQ
 	help
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 53d3d46..18755f1 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -5,9 +5,9 @@ config UX500_SOC_COMMON
 	default y
 	select ARM_GIC
 	select HAS_MTU
-	select PL310_ERRATA_753970
+	select PL310_ERRATA_753970 if CACHE_PL310
 	select ARM_ERRATA_754322
-	select ARM_ERRATA_764369
+	select ARM_ERRATA_764369 if SMP
 	select CACHE_L2X0
 	select PINCTRL
 	select PINCTRL_NOMADIK
-- 
1.7.10

