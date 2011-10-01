Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1JATXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1JATWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:22:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/11] ARM: SMP depends on MMU
Date: Sat,  1 Oct 2011 21:21:51 +0200
Message-Id: <1317496920-7764-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:p711gFbgtFq5BKmrRFip0fmbogseZ0brdTBK1yd4U0e
 vLm88YPQqSDsMbIbCzcR7b/LDJNAkYE70W+lARLryHOm8bopCl
 NGRa+s7Bz+U5yG1LsFxAfnoneK+ZLC4CorXbNN0nErWk7sIfYF
 1q0irEBeYetFuECYfwp4W8RrGWp/vKCdJxhmHpkfalRbho4cA5
 sb6JvIGSfQbyXkJlrWS5Z8edA/SODG4CVABc21mO1o04PHxPT2
 JlSVbhZc8dQJUKT9qjTLhtfywstA6++VzgWop2Ru5QjhTXu7Cd
 I1dq5CmLyhtbtCzuwXEpBkfWeuviY7IDvaXxQhh3dNgTd4RYHY
 96HSsvWY/Fq7h/nnP0DWnZ9UFvl+6H0gy54rJhRH0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMP implementation on ARM heavily depends on MMU-only code.
As long as nobody is interested in fixing this, let's disable the
SMP option when building for nommu.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d9..4e1eee0c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1349,6 +1349,7 @@ config SMP
 		 MACH_REALVIEW_PB11MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
 		 ARCH_EXYNOS4 || ARCH_TEGRA || ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || \
 		 ARCH_MSM_SCORPIONMP || ARCH_SHMOBILE
+	depends on MMU
 	select USE_GENERIC_SMP_HELPERS
 	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
 	help
-- 
1.7.5.4

