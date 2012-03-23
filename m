Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2CWROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:14:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46393 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab2CWROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:14 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 7/9] omap2plus: ensure that one of omap2/3/4 is selected
Date: Fri, 23 Mar 2012 11:13:54 -0600
Message-Id: <1332522836-29517-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Random configurations can fail if none of the omap families
in mach-omap2 is selected. This patch automatically selects
omap2 if the user has not made any other choice.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 0279e9e..b244e80 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -55,6 +55,16 @@ config ARCH_OMAP4
 	select USB_ARCH_HAS_EHCI
 	select ARM_CPU_SUSPEND if PM
 
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

