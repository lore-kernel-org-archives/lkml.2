Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1JBOtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1JBOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 24/30] ARM: omap2+: ensure that one of omap2/3/4 is selected
Date: Sun,  2 Oct 2011 16:45:54 +0200
Message-Id: <1317566760-25681-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:N9jMs5m0PVD7+BmCfDfcPuaFhnHj7M/Uvtapp8IvxQS
 T29fylyE1aCxoVyMoNYypx2N0pnSaPKlj+X0vOcP5zMxV9wHMx
 3btHfx9CiI8E1x7VrGMUGRe7i3JRS+PZ0Wa4B4PVC4C3bfgeGr
 7PydPPmPyAHEuK9cYERHI6u800N2aIqnLuhS0ze6DbAVIlist4
 pClPPCwkKDZ9NPowV5RArul+fA7COgXezxolGevbi9nD2UrpRc
 xa1MV8/xzTSw7zfRTYYxIlKzmTbQCLkFjFAsXWycFfKWq8ScjC
 oAlulww+LY7izUfiTxMzW4GUZTl+oQ/nH/tsOsut79Mc6VJ26J
 1N/uDsHFlgkFdpCOFy8Sym2un89191UPbqCVBCxpEE+NW9tXbq
 4kVyrRvhK5Vzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random configurations can fail if none of the omap families
in mach-omap2 is selected. This patch automatically selects
omap2 if the user has not made any other choice.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 4deeade..3c9fb89 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -51,6 +51,16 @@ config ARCH_OMAP4
 	select PM_OPP if PM
 	select USB_ARCH_HAS_EHCI
 
+config ARCH_OMAP2_AUTO
+	bool
+	depends on !ARCH_OMAP3 && !ARCH_OMAP4
+	select ARCH_OMAP2
+	default y
+	help
+	  At least one of OMAP2/OMAP3/OMAP4 needs to be enabled, this
+	  selects OMAP2 if nothing else gets selected, to avoid non-building
+	  configurations.
+
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
 
-- 
1.7.5.4

