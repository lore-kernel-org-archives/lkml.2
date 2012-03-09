Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2CIBzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:55:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62949 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab2CIBzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:55:04 -0500
From: mathieu.poirier@linaro.org
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, patches@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: vexpress: select ARM_ERRATA_753970 only when L2 is on
Date: Thu,  8 Mar 2012 18:54:58 -0700
Message-Id: <1331258098-31733-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Kconfig warns about unresolved dependencies in select statements,
and ARM_ERRATA_753970 rightfully depends on CACHE_PL310.
Selecting it only when the cache is enabled gets rid of the
warning with no functional change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/mach-vexpress/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 88c3ba1..0683a15 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -7,7 +7,7 @@ config ARCH_VEXPRESS_CA9X4
 	select ARM_GIC
 	select ARM_ERRATA_720789
 	select ARM_ERRATA_751472
-	select PL310_ERRATA_753970
+	select PL310_ERRATA_753970 if CACHE_PL310
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 
-- 
1.7.5.4

