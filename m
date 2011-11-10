Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab1KJAJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:09:05 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43550
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933462Ab1KJAI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:58 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: [RFC PATCH 10/17] powerpc/e500: Fix up the last references to CONFIG_PPC_E500MC
Date: Wed,  9 Nov 2011 19:07:08 -0500
Message-Id: <1320883635-17194-11-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the "select PPC_FPU" from PPC_E500MC to the new FSL_E500MC
processor selection, where it belongs.

The only actual difference that this patch introduces is the P5020DS
board (FreeScale e5500 CPU) will not set FSL_E500MC when building in
64-bit mode.

This is OK as all of the existing code that the 64-bit P5020DS needs is
still conditional on CONFIG_E500 or CONFIG_PPC_FPU, which are both set
properly on the P5020DS (PPC_FPU is always enabled on 64-bit).

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/cache.h       |    2 +-
 arch/powerpc/platforms/85xx/Kconfig    |   10 +++++-----
 arch/powerpc/platforms/Kconfig.cputype |    8 ++------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 4b50941..10988a2 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -8,7 +8,7 @@
 #if defined(CONFIG_8xx) || defined(CONFIG_403GCX)
 #define L1_CACHE_SHIFT		4
 #define MAX_COPY_PREFETCH	1
-#elif defined(CONFIG_PPC_E500MC)
+#elif defined(CONFIG_FSL_E500MC)
 #define L1_CACHE_SHIFT		6
 #define MAX_COPY_PREFETCH	4
 #elif defined(CONFIG_PPC32)
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 37f9de7..248f87c 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -173,8 +173,8 @@ config SBC8560
 
 config P2041_RDB
 	bool "Freescale P2041 RDB"
+	depends on FSL_E500MC
 	select DEFAULT_UIMAGE
-	select PPC_E500MC
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select ARCH_REQUIRE_GPIOLIB
@@ -187,8 +187,8 @@ config P2041_RDB
 
 config P3041_DS
 	bool "Freescale P3041 DS"
+	depends on FSL_E500MC
 	select DEFAULT_UIMAGE
-	select PPC_E500MC
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select ARCH_REQUIRE_GPIOLIB
@@ -201,8 +201,8 @@ config P3041_DS
 
 config P3060_QDS
 	bool "Freescale P3060 QDS"
+	depends on FSL_E500MC
 	select DEFAULT_UIMAGE
-	select PPC_E500MC
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select MPC8xxx_GPIO
@@ -214,8 +214,8 @@ config P3060_QDS
 
 config P4080_DS
 	bool "Freescale P4080 DS"
+	depends on FSL_E500MC
 	select DEFAULT_UIMAGE
-	select PPC_E500MC
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select ARCH_REQUIRE_GPIOLIB
@@ -230,9 +230,9 @@ endif # PPC32
 
 config P5020_DS
 	bool "Freescale P5020 DS"
+	depends on FSL_E500MC || PPC_BOOK3E_64
 	select DEFAULT_UIMAGE
 	select E500
-	select PPC_E500MC
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 9770564..fd37bb2 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -38,6 +38,7 @@ config FSL_E500_V1_V2
 config FSL_E500MC
 	bool "Freescale e500mc (also e5500 in 32-bit mode)"
 	select PHYS_64BIT_SUPPORTED
+	select PPC_FPU
 	select E500
 	select PPC_85xx
 
@@ -148,11 +149,6 @@ config E500
 	select PPC_FSL_BOOK3E
 	bool
 
-config PPC_E500MC
-	bool "e500mc Support"
-	select PPC_FPU
-	depends on E500
-
 config PPC_FPU
 	bool
 	default y if PPC64
@@ -280,7 +276,7 @@ config PPC_ICSWX
 
 config SPE
 	bool "SPE Support"
-	depends on FSL_E200 || (E500 && !PPC_E500MC)
+	depends on FSL_E200 || FSL_E500_V1_V2
 	default y
 	---help---
 	  This option enables kernel support for the Signal Processing
-- 
1.7.2.5

