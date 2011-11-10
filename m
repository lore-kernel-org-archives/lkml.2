Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1KJAKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:10:31 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43581
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933497Ab1KJAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:09:04 -0500
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
Subject: [RFC PATCH 13/17] powerpc/e500: Add a new CONFIG_FSL_E5500 option for the e5500
Date: Wed,  9 Nov 2011 19:07:11 -0500
Message-Id: <1320883635-17194-14-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of splitting CONFIG_E500 into separate options for e500v1/v2 and
e500mc/e5500, some code only needs to be built when e5500 support is
required.

This adds a new internal-use config option for both 32-bit and 64-bit
builds that enables only the e5500 support code.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/platforms/85xx/Kconfig    |    2 +-
 arch/powerpc/platforms/Kconfig.cputype |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 248f87c..72488d4 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -231,8 +231,8 @@ endif # PPC32
 config P5020_DS
 	bool "Freescale P5020 DS"
 	depends on FSL_E500MC || PPC_BOOK3E_64
+	select FSL_E5500
 	select DEFAULT_UIMAGE
-	select E500
 	select PHYS_64BIT_DT_REQUIRED
 	select SWIOTLB
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index fd37bb2..cff45e3 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -144,6 +144,10 @@ config 8xx
 config PPC_85xx
 	bool
 
+config FSL_E5500
+	bool
+	select E500
+
 config E500
 	select FSL_EMB_PERFMON
 	select PPC_FSL_BOOK3E
-- 
1.7.2.5

